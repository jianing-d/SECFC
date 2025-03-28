# Generated from create-SECFC.Rmd: do not edit by hand

#' Get country-specific total emission factors
#'
#' Returns a list of total emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A list of total emission factors.
get_total_emission_factors <- function(country) {
  if (country == "United States") {
    return(list(
      "Transport" = 1,  # Placeholder (1 means no modification)
      "Pet" = 1,
      "Housing" = 1,
      "Food" = 1,
      "Consumption" = 1
    ))
  } else if (country == "China") {
    return(list(
      "Transport" = NA,  # Placeholder for China
      "Pet" = NA,
      "Housing" = NA,
      "Food" = NA,
      "Consumption" = NA
    ))
  } else if (country == "European Union") {
    return(list(
      "Transport" = NA,  # Placeholder for EU
      "Pet" = NA,
      "Housing" = NA,
      "Food" = NA,
      "Consumption" = NA
    ))
  } else {
    return(list(
      "Transport" = NA,
      "Pet" = NA,
      "Housing" = NA,
      "Food" = NA,
      "Consumption" = NA
    ))
  }
}

#' Calculate Total Carbon Emissions with Process Data
#'
#' This function computes total carbon emissions by aggregating transportation, pet, housing (per capita), food, and consumption-based emissions.
#'
#' @param df A data frame containing emissions data from various components.
#' @return A data frame with a new column `TotalEmissions` representing total emissions and additional process calculation results.
#'
calc_total_emissions_process <- function(df) {
  df <- calc_cons_emissions_process(df)
  df <- calc_food_emissions_process(df)
  df <- calc_housing_emissions_process(df)
  df <- calc_pet_emissions_process(df)
  df <- calc_transport_emissions_process(df)
  # Get country-specific emission factors
  emission_factors_total <- get_total_emission_factors(unique(df$SD_07_Country))
  
  # Convert household size columns to numeric and handle NA values
  df <- df %>%
    mutate(
      SD_06_HouseholdSize_17 = as.numeric(SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = as.numeric(SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = as.numeric(SD_06_HouseholdSize_19),
      SD_06_HouseholdSize_17 = ifelse(is.na(SD_06_HouseholdSize_17), 0, SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = ifelse(is.na(SD_06_HouseholdSize_18), 0, SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = ifelse(is.na(SD_06_HouseholdSize_19), 0, SD_06_HouseholdSize_19)
    )
  
  # Calculate total household size (minimum 1 to prevent division by zero)
  df <- df %>%
    mutate(
      HouseholdSize = SD_06_HouseholdSize_17 + SD_06_HouseholdSize_18 + SD_06_HouseholdSize_19,
      HouseholdSize = ifelse(HouseholdSize == 0, 1, HouseholdSize)
    )
  
  # Adjust housing emissions per capita
  df <- df %>%
    mutate(
      HousingEmissionsPerCapita = HousingEmissions / HouseholdSize
    )
  
  # Ensure all emission components exist and replace NA values
  df <- df %>%
    mutate(
      TransportEmissions = ifelse(is.na(TransportEmissions), 0, TransportEmissions) * emission_factors_total$Transport,
      PetEmissions = ifelse(is.na(PetEmissions), 0, PetEmissions) * emission_factors_total$Pet,
      HousingEmissionsPerCapita = ifelse(is.na(HousingEmissionsPerCapita), 0, HousingEmissionsPerCapita) * emission_factors_total$Housing,
      FoodEmissions = ifelse(is.na(FoodEmissions), 0, FoodEmissions) * emission_factors_total$Food,
      ConsEmissions = ifelse(is.na(ConsEmissions), 0, ConsEmissions) * emission_factors_total$Consumption
    )
  
  # Calculate total emissions
  df <- df %>%
    mutate(
      TotalEmissions = TransportEmissions + PetEmissions + HousingEmissionsPerCapita +
        FoodEmissions + ConsEmissions
    )
  
  df <- df %>% 
    mutate(
      TotalEmissions = as.numeric(TotalEmissions)
    )

  
  #Notify user and print results
  message("All individual emission calculations have been completed.")
  message("New column `TotalEmissions` representing total carbon footprint has been added to the dataset.")
  message("Process calculation result data have been added.")
  
  print(df$TotalEmissions) 
  
  return(df)
}
