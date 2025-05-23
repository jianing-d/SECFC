
# Create a built-in dataset for food emission factors
food_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States",
              "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts",
                 "MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts",
                 "MeatMeals", "VeganMeals", "VegetarianMeals", "DairyProducts"),
  Value = c(3.07, 0.25, 0.68, 1542.3562,  
            NA, NA, NA, NA,
            NA, NA, NA, NA)
)

# Save as an R dataset inside the package
usethis::use_data(food_emission_factors, overwrite = TRUE)
library(dplyr)
library(tidyverse)

#' Get country-specific food emission factors from the built-in dataset
#'
#' Fetches food emission factors from the dataset stored in the package.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A named list of food emission factors.
get_food_emission_factors <- function(country) {
  
  # Filter the dataset for the given country
  factors <- food_emission_factors %>%
    filter(Country == country) %>%
    select(FactorName, Value)

  # Convert the dataset into a named list
  if (nrow(factors) > 0) {
    emission_list <- setNames(factors$Value, factors$FactorName)
  } else {
    # Return NA for all factors if the country is not found
    emission_list <- list(
      "MeatMeals" = NA,  
      "VeganMeals" = NA,  
      "VegetarianMeals" = NA,  
      "DairyProducts" = NA  
    )
  }

  return(emission_list)
}

#' Calculate Food-Based Emissions using internal dataset
#'
#' This function computes food-based emissions by converting food intake data into estimated carbon emissions.
#'
#' @param df A data frame containing the food consumption data.
#' @return A data frame with a new column `FoodEmissions` representing total food emissions.
#' @export
calc_food_emissions <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_food")
  # Get country-specific food emission factors from the dataset
  emission_factors_food <- get_food_emission_factors(unique(df$SD_07_Country))
  
  # Convert food intake columns to numeric and replace NA values with 0
  df_food <- df %>%
    mutate(
      F_01_DietaryHabits_5 = as.numeric(F_01_DietaryHabits_5),
      F_01_DietaryHabits_6 = as.numeric(F_01_DietaryHabits_6),
      F_01_DietaryHabits_7 = as.numeric(F_01_DietaryHabits_7),
      F_01_DietaryHabits_4 = as.numeric(F_01_DietaryHabits_4)
    ) %>%
    replace(is.na(.), 0)
 
  serving_volume_l    <- 0.5          # average dairy product per meal in liters
  serving_volume_m3   <- serving_volume_l / 1000  
  
  # Calculate emissions for each food category
  df_food <- df_food %>%
    mutate(
      MeatEmissions = F_01_DietaryHabits_5 * 52 * emission_factors_food[["MeatMeals"]],
      VeganEmissions = F_01_DietaryHabits_6 * 52 * emission_factors_food[["VeganMeals"]],
      VegetarianEmissions = F_01_DietaryHabits_7 * 52 * emission_factors_food[["VegetarianMeals"]],
      DairyEmissions = F_01_DietaryHabits_4 * 52 * serving_volume_m3 * emission_factors_food[["DairyProducts"]],    #1m3=1000L
      
      # Total food emissions
      FoodEmissions = rowSums(cbind(MeatEmissions, VeganEmissions, VegetarianEmissions, DairyEmissions), na.rm = TRUE)
    )
  
    df_food <- df_food %>% 
    select(-MeatEmissions,-VeganEmissions,-VegetarianEmissions,-DairyEmissions)
    
    # assign new df_food to the user’s workspace
    assign(new_name, df_food, envir = parent.frame())
    message(
      paste0(
        "✅ A new data frame '", new_name,
        "' is now available in your R environment."
      )
    )
    
    
  
  return(df_food)
}

