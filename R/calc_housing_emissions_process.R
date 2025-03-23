
.onLoad <- function(libname, pkgname) {
  # Load package data into the global environment
  data_env <- globalenv()
  utils::data("zip_data", package = pkgname, envir = data_env)
  utils::data("housing_emission_factors", package = pkgname, envir = data_env)
}

#' Get country-specific housing emission factors from dataset
#'
#' Returns a list of housing emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A list of housing emission factors.
get_housing_emission_factors <- function(country) {
  # Ensure dataset is available
  if (!exists("housing_emission_factors", where = globalenv())) {
    stop("Error: housing_emission_factors dataset not found.")
  }
  
  # Filter dataset for the selected country
  factors <- housing_emission_factors %>% filter(Country == country)
  
  # Set default values to prevent NULLs
  default_values <- list(
    "WaterCFC" = 26.5,
    "NaturalGas" = 0.055,
    "Electricity" = list(
      "Average" = 0.513,
      "Texas" = 0.641855,
      "Western" = 0.461226,
      "Eastern" = 0.572386
    )
  )
  
  # Ensure values exist, otherwise, use defaults
  return(list(
    "WaterCFC" = ifelse(any(factors$FactorName == "WaterCFC"), factors$Value[factors$FactorName == "WaterCFC"], default_values$WaterCFC),
    "NaturalGas" = ifelse(any(factors$FactorName == "NaturalGas"), factors$Value[factors$FactorName == "NaturalGas"], default_values$NaturalGas),
    "Electricity" = list(
      "Average" = ifelse(any(factors$FactorName == "Electricity_Average"), factors$Value[factors$FactorName == "Electricity_Average"], default_values$Electricity$Average),
      "Texas" = ifelse(any(factors$FactorName == "Electricity_Texas"), factors$Value[factors$FactorName == "Electricity_Texas"], default_values$Electricity$Texas),
      "Western" = ifelse(any(factors$FactorName == "Electricity_Western"), factors$Value[factors$FactorName == "Electricity_Western"], default_values$Electricity$Western),
      "Eastern" = ifelse(any(factors$FactorName == "Electricity_Eastern"), factors$Value[factors$FactorName == "Electricity_Eastern"], default_values$Electricity$Eastern)
    )
  ))
}


#' Calculate Housing-Related Carbon Emissions with Process Data
#'
#' This function computes housing-related carbon emissions and retains process calculation result data.
#'
#' @param df A data frame containing housing-related data.
#' @return A data frame with a new column `HousingEmissions` representing total housing-related emissions and additional process calculation results.
#' @export
calc_housing_emissions_process <- function(df) {
  
  # Ensure built-in datasets are available
  if (!exists("zip_data")) stop("Error: zip_data dataset not found.")
  
  # Get country-specific housing emission factors
  emission_factors_housing <- get_housing_emission_factors(unique(df$SD_07_Country))
  
  # Ensure ZIP code exists and is numeric
  df <- df %>%
    mutate(SD_08_ZipCode = as.numeric(SD_08_ZipCode))
  
  # Define function to classify state based on ZIP code
  classify_state <- function(zip_code) {
    matched_state <- zip_data %>%
      filter(zip_code >= Zip_Min & zip_code <= Zip_Max) %>%
      pull(ST)
    
    if (length(matched_state) == 1) {
      return(matched_state)
    } else {
      return(NA)  # Return NA if no match or multiple matches found
    }
  }
  
  # Define function to classify region based on state
  classify_zip_code <- function(zip_code) {
    state <- classify_state(zip_code)
    
    west_states <- c("WA", "OR", "CA", "ID", "NV", "UT", "AZ", "MT", "WY", "CO", "NM", "HI", "AK")
    east_states <- c("ME", "NH", "MA", "RI", "CT", "NY", "NJ", "DE", "MD", "VA", "NC", "SC", "GA", "FL", "VT", "PA", "WV", "OH", "MI")
    
    if (!is.na(state)) {
      if (state %in% west_states) {
        return("West")
      } else if (state %in% east_states) {
        return("East")
      } else if (state == "TX") {
        return("Texas")
      } else {
        return("Other")
      }
    } else {
      return(NA)
    }
  }
  
  # Classify state, region, and select appropriate electricity emission factor
  df <- df %>%
    rowwise() %>%
    mutate(
      state = classify_state(SD_08_ZipCode),
      region = classify_zip_code(SD_08_ZipCode),
      electricity_emission_factor = case_when(
        region == "Texas" ~ emission_factors_housing$Electricity$Texas,
        region == "West" ~ emission_factors_housing$Electricity$Western,
        region == "East" ~ emission_factors_housing$Electricity$Eastern,
        TRUE ~ emission_factors_housing$Electricity$Average
      )
    ) %>%
    ungroup()
  
  # Handle missing values for energy bills
  df <- df %>%
    mutate(
      EH_02_ElectricityBil_1 = as.numeric(EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = as.numeric(EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = as.numeric(EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1= as.numeric(EH_06_NaturalGasBill_1),
      
      EH_02_ElectricityBil_1 = ifelse(is.na(EH_02_ElectricityBil_1), 0, EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = ifelse(is.na(EH_03_ElectricityBil_1), 0, EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = ifelse(is.na(EH_05_NaturalGasBill_1), 0, EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1= ifelse(is.na(EH_06_NaturalGasBill_1), 0, EH_06_NaturalGasBill_1)
    )
  
  # Calculate annual emissions using specific user-selected values
  df <- df %>%
    mutate(
      electricity_usage_kWh = ifelse(electricity_emission_factor > 0, 
                                     (EH_02_ElectricityBil_1 * 100) / electricity_emission_factor, 
                                     0),
      natural_gas_usage_cubic_feet = EH_05_NaturalGasBill_1 / 15.2,
      
      ElectricityEmissions = electricity_usage_kWh * 12 * electricity_emission_factor,
      NaturalGasEmissions = natural_gas_usage_cubic_feet * 12 * emission_factors_housing$NaturalGas,
      WaterEmissions = emission_factors_housing$WaterCFC,
      
      # Total housing emissions
      HousingEmissions = ElectricityEmissions + NaturalGasEmissions + WaterEmissions
    )
  
  
  # Notify user and print results
  message("New column `HousingEmissions` representing total housing emissions has been added to the dataset.")
  message("Process calculation result data have been added.")
  
  print(df$HousingEmissions)
  
  return(df)
}

