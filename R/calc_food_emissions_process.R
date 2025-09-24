

#' Get country-specific food emission factors from the built-in dataset
#'
#' Fetches food emission factors from the dataset stored in the package.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na pivot_wider
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @param country A character string representing the country.
#' @return A named list of food emission factors.
get_food_emission_factors <- function(country) {
  # tolerate vectors/NA
  if (length(country) > 1) {
    country <- country[!is.na(country)]
    country <- if (length(country)) country[[1]] else NA_character_
  }
  norm <- function(x) {
    x <- trimws(x)
    if (is.na(x)) return(x)
    gsub("^PRC$|^CN$|^China \\(Mainland\\)$|^Mainland China$", "China", x, ignore.case = TRUE)
  }
  country <- norm(country)
  
  # Filter the dataset for the given country
  factors <- food_emission_factors %>%
    filter(Country == country) %>%
    select(FactorName, Value, Unit)
  
  # Convert the dataset into a named list
  
  if (nrow(factors) == 0) {
    return(list(
      MeatMeals = NA_real_, VeganMeals = NA_real_,
      VegetarianMeals = NA_real_, DairyProducts = NA_real_,
      .units = c(MeatMeals="kg_per_meal", VeganMeals="kg_per_meal",
                 VegetarianMeals="kg_per_meal", DairyProducts=NA_character_)
    ))
  }
  
  out <- as.list(factors$Value)
  names(out) <- factors$FactorName
  out$.units <- setNames(factors$Unit, factors$FactorName)
  out
}

#' Calculate Food-Related Carbon Emissions with Process Data
#'
#' This function computes food-based emissions and retains process calculation result data.
#'
#' @param df A data frame containing the food consumption data.
#' @param milk_price_rmb_per_l numeric. Milk price per litre (RMB).
#' @param serving_volume_l numeric. Serving volume in litres.
#' @return A data frame with a new column `FoodEmissions` representing total food-related emissions and additional process calculation results.
#' @export
calc_food_emissions_process <- function(df,
                                        milk_price_rmb_per_l = 10,  # <- default; adjust if needed
                                        serving_volume_l = 0.5) {   # dairy per meal (liters)
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_food_process")
  
  # country factors
  country_val <- unique(df$SD_07_Country)
  ef <- get_food_emission_factors(country_val)
  units_vec <- ef$.units
  
  # Convert food intake columns to numeric and replace NA values with 0
  df_food_process <- df %>%
    mutate(
      F_01_DietaryHabits_5 = as.numeric(F_01_DietaryHabits_5),
      F_01_DietaryHabits_6 = as.numeric(F_01_DietaryHabits_6),
      F_01_DietaryHabits_7 = as.numeric(F_01_DietaryHabits_7),
      F_01_DietaryHabits_4 = as.numeric(F_01_DietaryHabits_4)
    ) %>%
    mutate(across(c(F_01_DietaryHabits_5, F_01_DietaryHabits_6,
                    F_01_DietaryHabits_7, F_01_DietaryHabits_4),
                  ~replace_na(., 0)))
  
  # meals-based categories (all countries)
  df_food_process <- df_food_process %>%
    mutate(
      MeatEmissions       = F_01_DietaryHabits_5 * 52 * ef[["MeatMeals"]],
      VeganEmissions      = F_01_DietaryHabits_6 * 52 * ef[["VeganMeals"]],
      VegetarianEmissions = F_01_DietaryHabits_7 * 52 * ef[["VegetarianMeals"]]
    )
  
  
  # dairy: branch by country/unit
  serving_volume_m3   <- serving_volume_l / 1000 
  is_china <- FALSE
  if (length(country_val)) {
    cv <- country_val[!is.na(country_val)]
    is_china <- length(cv) > 0 && tolower(cv[1]) %in% c("china","prc","cn","mainland china","china (mainland)")
  }
  
  if (is_china && identical(units_vec[["DairyProducts"]], "kg_per_RMB")) {
    # Convert per-RMB factor using price and serving volume:
    # weekly_freq * 52 * (serving_liters * RMB_per_liter) * (kg/RMB)
    per_meal_rmb <- serving_volume_l * milk_price_rmb_per_l
    
    # Calculate emissions for each food category
    df_food_process <- df_food_process %>%
      mutate(
        DairyEmissions = F_01_DietaryHabits_4 * 52 * per_meal_rmb * ef[["DairyProducts"]]
      )
  } else {
    # Non-China: per-m^3 factor (your original approach)
    df_food_process <- df_food_process %>%
      mutate(
        DairyEmissions = F_01_DietaryHabits_4 * 52 * serving_volume_m3 * ef[["DairyProducts"]]
      )
  }
  
  # total + cleanup
  df_food_process <- df_food_process %>%
    mutate(
      FoodEmissions = rowSums(
        cbind(MeatEmissions, VeganEmissions, VegetarianEmissions, DairyEmissions),
        na.rm = TRUE
      )
    ) 
  
  # assign new df_food_process to the user's workspace
  assign(new_name, df_food_process, envir = parent.frame())
  message(
    paste0(
      "\u2705 A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  return(df_food_process)
}

