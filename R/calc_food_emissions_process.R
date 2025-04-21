
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

#' Calculate Food-Related Carbon Emissions with Process Data
#'
#' This function computes food-based emissions and retains process calculation result data.
#'
#' @param df A data frame containing the food consumption data.
#' @return A data frame with a new column `FoodEmissions` representing total food-related emissions and additional process calculation results.
#' @export
calc_food_emissions_process <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_food_process")
  
  # Get country-specific food emission factors from the dataset
  emission_factors_food <- get_food_emission_factors(unique(df$SD_07_Country))
  
  # Convert food intake columns to numeric and replace NA values with 0
  df_food_process <- df %>%
    mutate(
      F_01_DietaryHabits_5 = as.numeric(F_01_DietaryHabits_5),
      F_01_DietaryHabits_6 = as.numeric(F_01_DietaryHabits_6),
      F_01_DietaryHabits_7 = as.numeric(F_01_DietaryHabits_7),
      F_01_DietaryHabits_4 = as.numeric(F_01_DietaryHabits_4)
    ) %>%
    replace(is.na(.), 0)
  
  # Calculate emissions for each food category
  df_food_process <- df_food_process %>%
    mutate(
      MeatEmissions = F_01_DietaryHabits_5 * 52 * emission_factors_food[["MeatMeals"]],
      VeganEmissions = F_01_DietaryHabits_6 * 52 * emission_factors_food[["VeganMeals"]],
      VegetarianEmissions = F_01_DietaryHabits_7 * 52 * emission_factors_food[["VegetarianMeals"]],
      DairyEmissions = F_01_DietaryHabits_4 * 52 * emission_factors_food[["DairyProducts"]],
      
      # Total food emissions
      FoodEmissions = rowSums(cbind(MeatEmissions, VeganEmissions, VegetarianEmissions, DairyEmissions), na.rm = TRUE)
    )
  
  
  
  # assign new df_food_process to the user’s workspace
  assign(new_name, df_food_process, envir = parent.frame())
  message("Created new data frame: ", new_name)
  
  return(df_food_process)
}

