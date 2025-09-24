
# Create a built-in dataset for food emission factors
food_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States",
              "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts",
                 "MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts",
                 "MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts"),
  Value = c(
    # United States
    3.07, 0.25, 0.68, 1542.3562,  # Dairy: kg CO2e per m^3
    # China
    3.07, 0.25, 0.68, 0.740150193, # Dairy: kg CO2e per RMB (CEEIO 2020)
    # EU
    NA, NA, NA, NA),
  Unit       = c(
    # United States
    rep("kg_per_meal", 3), "kg_per_m3",
    # China
    rep("kg_per_meal", 3), "kg_per_RMB",
    # EU
    rep(NA_character_, 4)
  )
)

# Save as an R dataset inside the package
usethis::use_data(food_emission_factors, overwrite = TRUE)
library(dplyr)
library(tidyverse)

#' Get country-specific food emission factors from the built-in dataset
#'
#' Fetches food emission factors from the dataset stored in the package.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @param country A character string representing the country.
#' @return A named list of food emission factors.
get_food_emission_factors <- function(country) {
  # tolerate vectors / NAs
  if (length(country) > 1) {
    country <- country[!is.na(country)]
    country <- if (length(country)) country[[1]] else NA_character_
  }
  norm_country <- function(x) {
    x <- trimws(x)
    if (is.na(x)) return(x)
    x <- gsub("^PRC$|^CN$|^China \\(Mainland\\)$|^Mainland China$", "China", x, ignore.case = TRUE)
    x
  }
  country <- norm_country(country)
  
  # Filter the dataset for the given country
  factors <- food_emission_factors %>%
    filter(Country == country) %>%
    select(FactorName, Value, Unit)
  
  if (nrow(factors) == 0) {
    return(list(
      MeatMeals        = NA_real_,
      VeganMeals       = NA_real_,
      VegetarianMeals  = NA_real_,
      DairyProducts    = NA_real_,
      .units           = c(MeatMeals="kg_per_meal", VeganMeals="kg_per_meal",
                           VegetarianMeals="kg_per_meal", DairyProducts=NA_character_)
    ))
  }
  out <- as.list(factors$Value)
  names(out) <- factors$FactorName
  
  # also return units (for dairy branching)
  out$.units <- setNames(factors$Unit, factors$FactorName)
  out
}

#' Calculate Food-Based Emissions using internal dataset
#'
#' This function computes food-based emissions by converting food intake data into estimated carbon emissions.
#'
#' @param df A data frame containing the food consumption data.
#' @param milk_price_rmb_per_l numeric. Milk price per litre (RMB).
#' @param serving_volume_l numeric. Serving volume in litres.
#' @return A data frame with a new column `FoodEmissions` representing total food emissions.
#' @export
calc_food_emissions <- function(df,
                                milk_price_rmb_per_l = 10,  # <- default; adjust if needed
                                serving_volume_l = 0.5) {   # dairy per meal (liters)
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_food")
  
  
  # country factors
  country_val <- unique(df$SD_07_Country)
  ef <- get_food_emission_factors(country_val)
  units_vec <- ef$.units
  
  # Convert food intake columns to numeric and replace NA values with 0
  df_food <- df %>%
    mutate(
      F_01_DietaryHabits_5 = as.numeric(F_01_DietaryHabits_5),
      F_01_DietaryHabits_6 = as.numeric(F_01_DietaryHabits_6),
      F_01_DietaryHabits_7 = as.numeric(F_01_DietaryHabits_7),
      F_01_DietaryHabits_4 = as.numeric(F_01_DietaryHabits_4)
    ) %>%
    mutate(
      across(c(F_01_DietaryHabits_5,F_01_DietaryHabits_6,
               F_01_DietaryHabits_7,F_01_DietaryHabits_4),
             ~replace_na(., 0))
    )
  
  # Per-meal factors (all countries)
  df_food <- df_food %>%
    mutate(
      MeatEmissions       = F_01_DietaryHabits_5 * 52 * ef[["MeatMeals"]],
      VeganEmissions      = F_01_DietaryHabits_6 * 52 * ef[["VeganMeals"]],
      VegetarianEmissions = F_01_DietaryHabits_7 * 52 * ef[["VegetarianMeals"]]
    )
  
  
  # dairy: branch by country/unit
  serving_volume_m3 <- serving_volume_l / 1000
  is_china <- FALSE
  if (length(country_val)) {
    cv <- country_val[!is.na(country_val)]
    is_china <- length(cv) > 0 && tolower(cv[1]) %in% c("china","prc","cn","mainland china","china (mainland)")
  }
  
  if (is_china && identical(units_vec[["DairyProducts"]], "kg_per_RMB")) {
    # Convert per-RMB factor using price and serving volume:
    # weekly_freq * 52 * (serving_liters * RMB_per_liter) * (kg/RMB)
    per_meal_rmb <- serving_volume_l * milk_price_rmb_per_l
    df_food <- df_food %>%
      mutate(
        DairyEmissions = F_01_DietaryHabits_4 * 52 * per_meal_rmb * ef[["DairyProducts"]]
      )
  } else {
    # Non-China: per-m^3 factor (your original approach)
    df_food <- df_food %>%
      mutate(
        DairyEmissions = F_01_DietaryHabits_4 * 52 * serving_volume_m3 * ef[["DairyProducts"]]
      )
  }
  
  # total + cleanup
  df_food <- df_food %>%
    mutate(
      FoodEmissions = rowSums(
        cbind(MeatEmissions, VeganEmissions, VegetarianEmissions, DairyEmissions),
        na.rm = TRUE
      )
    ) %>%
    select(-MeatEmissions, -VeganEmissions, -VegetarianEmissions, -DairyEmissions)
  
  assign(new_name, df_food, envir = parent.frame())
  message("\u2705 A new data frame '", new_name, "' is now available in your R environment.")
  df_food
}