
# Create a built-in dataset for housing emission factors
housing_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States", "United States", "United States",
              "China", "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("WaterCFC", "NaturalGas", "Electricity_Average", "Electricity_Texas", "Electricity_Western", "Electricity_Eastern",
                 "WaterCFC", "NaturalGas", "Electricity_Group1", "Electricity_Group2", "Electricity_Group3",
                 "WaterCFC", "NaturalGas", "Electricity_Group1", "Electricity_Group2", "Electricity_Group3"),
  Value = c(26.5, 0.055, 0.513, 0.641855, 0.461226, 0.572386,  
            NA, NA, NA, NA, NA,  
            NA, NA, NA, NA, NA)
)

# Save as an internal dataset inside the package
usethis::use_data(housing_emission_factors, overwrite = TRUE)

# Load required package
library(tibble)
library(dplyr)
library(tidyverse)

# Create the zip_data dataset
zip_data <- tibble::tibble(
  ID = c(6,5,69,8,7,9,10,11,73,13,74,63,12,14,15,65,16,20,66,17,18,19,21,22,68,23,26,58,77,78,25,24,27,28,57,29,59,31,38,39,67,32,34,35,36,33,60,37,40,70,41,42,43,44,45,46,47,48,49,71,72,61,50,64,75,76,52,51,62,53,55,54,56),
  State_Name = c("Alaska", "Alabama", "Arkansas", "Arkansas (Texarkana)", "Arizona", "California", "Colorado", "Connecticut", "Connecticut", "Dist of Columbia", "Dist of Columbia", "Dist of Columbia", "Delaware", "Florida", "Georgia", "Georga (Atlanta)", "Hawaii", "Iowa", "Iowa (OMAHA)", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Louisiana", "Massachusetts", "Massachusetts (Andover)", "Maryland", "Maryland", "Maryland", "Maine", "Michigan", "Minnesota", "kc96 DataMO", "Mississippi", "Mississippi(Warren)", "Montana", "North Carolina", "North Dakota", "Nebraska", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York (Fishers Is)", "New York", "Ohio", "Oklahoma", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas (Austin)", "Texas", "Texas", "Texas (El Paso)", "Utah", "Virginia", "Virginia", "Virginia", "Virginia", "Vermont", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"),
  ST = c("AK","AL","AR","AR","AZ","CA","CO","CT","CT","DC","DC","DC","DE","FL","GA","GA","HI","IA","IA","ID","IL","IN","KS","KY","LA","LA","MA","MA","MD","MD","MD","ME","MI","MN","MO","MS","MS","MT","NC","ND","NE","NE","NH","NJ","NM","NV","NY","NY","OH","OK","OK","OR","PA","PR","RI","SC","SD","TN","TX","TX","TX","TX","UT","VA","VA","VA","VA","VT","VT","WA","WI","WV","WY"),
  Zip_Min = c(99501,35004,71601,75502,85001,90001,80001,6001,6401,20001,20042,20799,19701,32004,30001,39901,96701,50001,68119,83201,60001,46001,66002,40003,70001,71234,1001,5501,20331,20335,20812,3901,48001,55001,63001,38601,71233,59001,27006,58001,68001,68122,3031,7001,87001,88901,6390,10001,43001,73001,73401,97001,15001,0,2801,29001,57001,37010,73301,75001,75503,88510,84001,20040,20040,20042,22001,5001,5601,98001,53001,24701,82001),
  Zip_Max = c(99950,36925,72959,75502,86556,96162,81658,6389,6928,20039,20599,20799,19980,34997,31999,39901,96898,52809,68120,83876,62999,47997,67954,42788,71232,71497,2791,5544,20331,20797,21930,4992,49971,56763,65899,39776,71233,59937,28909,58856,68118,69367,3897,8989,88441,89883,6390,14975,45999,73199,74966,97920,19640,0,2940,29948,57799,38589,73301,75501,79999,88589,84784,20041,20167,20042,24658,5495,5907,99403,54990,26886,83128)
)

# Save it as an internal dataset inside the package
usethis::use_data(zip_data, overwrite = TRUE)

library(dplyr)
library(tidyverse)

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


#' Calculate Housing Emissions
#'
#' Computes housing emissions by converting energy and utility expenditure data into estimated annual carbon emissions.
#'
#' @param df A data frame containing housing-related data.
#' @return A data frame with a new column `HousingEmissions` representing total housing emissions.
#' @export
calc_housing_emissions <- function(df) {
  
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
  
    df <- df %>% 
    select(-state,-region,-electricity_emission_factor,-electricity_usage_kWh,-natural_gas_usage_cubic_feet,-ElectricityEmissions,-NaturalGasEmissions,-WaterEmissions)
    
    # Notify user and print results
  message("New column `HousingEmissions` representing total housing emissions has been added to the dataset.")


  print(df$HousingEmissions)
  
  return(df)
}

