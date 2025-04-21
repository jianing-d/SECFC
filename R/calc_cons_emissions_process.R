
library(dplyr)
library(tidyverse)

#' Get country-specific emission factors from the built-in dataset
#'
#' Fetches consumption emission factors from the dataset stored in the package.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A named list of consumption emission factors.
get_cons_emission_factors <- function(country) {
  
  # Filter the dataset for the given country
  factors <- cons_emission_factors %>%
    filter(Country == country) %>%
    select(FactorName, Value)
  
  # Convert the dataset into a named list
  if (nrow(factors) > 0) {
    emission_list <- setNames(factors$Value, factors$FactorName)
  } else {
    # Return NA for all factors if the country is not found
    emission_list <- list(
      "FoodDelivery" = NA,  
      "DiningOut" = NA,  
      "HotelStays" = NA,  
      "TobaccoProducts" = NA,  
      "AlcoholDrinks" = NA,  
      "Entertainment" = NA,  
      "Healthcare" = NA,  
      "Clothing" = NA  
    )
  }
  
  return(emission_list)
}

#' Calculate Consumption-Based Emissions with Process Data
#'
#' This function computes consumption-based emissions and retains process calculation result data.
#'
#' @param df A data frame containing the consumption data.
#' @return A data frame with a new column `ConsEmissions` representing total consumption emissions and additional process calculation results.
#' @export
calc_cons_emissions_process <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_cons_process")
  # Get country-specific emission factors from the dataset
  emission_factors_cons <- get_cons_emission_factors(unique(df$SD_07_Country))
  
  # Ensure expenditure columns are numeric
  df_cons_process <- df %>%
    mutate(
      CL_03_MonthlyEx_9 = as.numeric(CL_03_MonthlyEx_9),
      CL_03_MonthlyEx_10 = as.numeric(CL_03_MonthlyEx_10),
      CL_03_MonthlyEx_11 = as.numeric(CL_03_MonthlyEx_11),
      CL_03_MonthlyEx_12 = as.numeric(CL_03_MonthlyEx_12),
      CL_03_MonthlyEx_13 = as.numeric(CL_03_MonthlyEx_13),
      CL_03_MonthlyEx_14 = as.numeric(CL_03_MonthlyEx_14),
      CL_03_MonthlyEx_15 = as.numeric(CL_03_MonthlyEx_15)
    )
  
  # Assign estimated clothing spending based on categorical responses
  clothing_spending_map <- c(
    "More than 12 times (At least once a month)" = 600,
    "7-12 times (About every 1-2 months)" = 420,
    "4-6 times (About every 2-3 months)" = 300,
    "1-3 times (Less than every 3 months)" = 120,
    "Rarely" = 60
  )
  
  df_cons_process <- df_cons_process %>%
    mutate(
      annual_clothing_spending = clothing_spending_map[CL_01_ClothingPurcha],
      annual_clothing_spending = ifelse(is.na(annual_clothing_spending), 0, annual_clothing_spending),
      
      ClothingEm = annual_clothing_spending * emission_factors_cons[["Clothing"]]
    )
  
  # Calculate annual emissions for each category
  df_cons_process <- df_cons_process %>%
    mutate(
      FoodDeliveryEm = CL_03_MonthlyEx_9 * 12 * emission_factors_cons[["FoodDelivery"]],
      DiningOutEm = CL_03_MonthlyEx_10 * 12 * emission_factors_cons[["DiningOut"]],
      HotelStaysEm = CL_03_MonthlyEx_11 * 12 * emission_factors_cons[["HotelStays"]],
      TobaccoEm = CL_03_MonthlyEx_12 * 12 * emission_factors_cons[["TobaccoProducts"]],
      AlcoholEm = CL_03_MonthlyEx_13 * 12 * emission_factors_cons[["AlcoholDrinks"]],
      EntertainmentEm = CL_03_MonthlyEx_14 * 12 * emission_factors_cons[["Entertainment"]],
      HealthcareEm = CL_03_MonthlyEx_15 * 12 * emission_factors_cons[["Healthcare"]]
    )
  
  # Compute total consumption emissions
  df_cons_process <- df_cons_process %>%
    mutate(
      ConsEmissions = rowSums(cbind(
        FoodDeliveryEm, DiningOutEm, HotelStaysEm,
        TobaccoEm, AlcoholEm, EntertainmentEm,
        HealthcareEm, ClothingEm
      ), na.rm = TRUE)
    )
  
  df_cons_process <- df_cons_process %>% 
    mutate(
      annual_clothing_spending = as.numeric(annual_clothing_spending),
      ClothingEm = as.numeric(ClothingEm),
      ConsEmissions = as.numeric(ConsEmissions)
    )
  
  # assign new df_cons_process to the user’s workspace
  assign(new_name, df_cons_process, envir = parent.frame())
  message("Created new data frame: ", new_name)
  
  return(df_cons_process)
}

