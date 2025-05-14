
# Create a built-in dataset for housing emission factors
housing_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States", "United States", "United States","United States", "United States", "United States", "United States",
              "China", "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("WaterCFC", "NaturalGas", "Electricity_US_ASCC", "Electricity_US_HICC", "Electricity_US_MRO", "Electricity_US_NPCC","Electricity_US_RFC", "Electricity_US_SERC", "Electricity_TRE", "Electricity_WECC",
                 "WaterCFC", "NaturalGas", "Electricity_China_Group1", "Electricity_China_Group2", "Electricity_China_Group3",
                 "WaterCFC", "NaturalGas", "Electricity_EU_Group1", "Electricity_EU_Group2", "Electricity_EU_Group3"),
  Value = c(0.84, 0.573511218, 0.608418285, 0.823151786, 0.543851789, 0.273336294, 0.5399024,0.532591155,0.461607295,0.376463424,
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
  # Normalize empty/missing to "United States"
  lookup_country <- if (is.na(country) || country == "") "United States" else country
  
  # United States: use existing dataset + defaults
  if (lookup_country == "United States") {
    if (!exists("housing_emission_factors", where = globalenv())) {
      stop("Error: housing_emission_factors dataset not found.")
    }
    factors <- housing_emission_factors %>% filter(Country == "United States")
    
    defaults <- list(
      WaterCFC   = 0.84,
      NaturalGas = 0.573511218,
      Electricity = list(
        US_ASCC = 0.608418285, US_HICC = 0.823151786,
        US_MRO  = 0.543851789, US_NPCC = 0.273336294,
        US_RFC  = 0.5399024,   US_SERC = 0.532591155,
        US_TRE  = 0.461607295, US_WECC = 0.376463424
      )
    )
    
    return(list(
      WaterCFC   = ifelse(any(factors$FactorName=="WaterCFC"),
                          factors$Value[factors$FactorName=="WaterCFC"],
                          defaults$WaterCFC),
      NaturalGas = ifelse(any(factors$FactorName=="NaturalGas"),
                          factors$Value[factors$FactorName=="NaturalGas"],
                          defaults$NaturalGas),
      Electricity = list(
        US_ASCC = ifelse(any(factors$FactorName=="Electricity_US_ASCC"),
                         factors$Value[factors$FactorName=="Electricity_US_ASCC"],
                         defaults$Electricity$US_ASCC),
        US_HICC = ifelse(any(factors$FactorName=="Electricity_US_HICC"),
                         factors$Value[factors$FactorName=="Electricity_US_HICC"],
                         defaults$Electricity$US_HICC),
        US_MRO  = ifelse(any(factors$FactorName=="Electricity_US_MRO"),
                         factors$Value[factors$FactorName=="Electricity_US_MRO"],
                         defaults$Electricity$US_MRO),
        US_NPCC = ifelse(any(factors$FactorName=="Electricity_US_NPCC"),
                         factors$Value[factors$FactorName=="Electricity_US_NPCC"],
                         defaults$Electricity$US_NPCC),
        US_RFC  = ifelse(any(factors$FactorName=="Electricity_US_RFC"),
                         factors$Value[factors$FactorName=="Electricity_US_RFC"],
                         defaults$Electricity$US_RFC),
        US_SERC = ifelse(any(factors$FactorName=="Electricity_US_SERC"),
                         factors$Value[factors$FactorName=="Electricity_US_SERC"],
                         defaults$Electricity$US_SERC),
        US_TRE  = ifelse(any(factors$FactorName=="Electricity_US_TRE"),
                         factors$Value[factors$FactorName=="Electricity_US_TRE"],
                         defaults$Electricity$US_TRE),
        US_WECC = ifelse(any(factors$FactorName=="Electricity_US_WECC"),
                         factors$Value[factors$FactorName=="Electricity_US_WECC"],
                         defaults$Electricity$US_WECC)
      )
    ))
  }
  
  # China: all NA, but keep structure
  if (lookup_country == "China") {
    return(list(
      WaterCFC   = NA,
      NaturalGas = NA,
      Electricity = list(
        Electricity_China_Group1 = NA,
        Electricity_China_Group2 = NA,
        Electricity_China_Group3 = NA
      )
    ))
  }
  
  # European Union: all NA, but keep structure
  if (lookup_country == "European Union") {
    return(list(
      WaterCFC   = NA,
      NaturalGas = NA,
      Electricity = list(
        Electricity_EU_Group1 = NA,
        Electricity_EU_Group2 = NA,
        Electricity_EU_Group3 = NA
      )
    ))
  }
  
  # Other (not US, China, EU): everything NA
  return(list(
    WaterCFC   = NA,
    NaturalGas = NA,
    Electricity = NA
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
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_housing")
  # Ensure built-in datasets are available
  if (!exists("zip_data")) stop("Error: zip_data dataset not found.")
  
  # Get country-specific housing emission factors
  emission_factors_housing <- get_housing_emission_factors(unique(df$SD_07_Country))
  
  # Ensure ZIP code exists and is numeric
  df_housing <- df %>%
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
    
    US_ASCC <- c("AK")
    US_HICC <- c("HI")
    US_MRO  <- c("IA","IL","KS","MI","MN","MO","MT","ND","NE","SD","WI")
    US_NPCC <- c("CT","MA","ME","NH","NY","RI","VT")
    US_RFC  <- c("DC","DE","IN","MD","NJ","OH","PA","VA","WV")
    US_SERC <- c("AL","AR","FL","GA","KY","LA","MS","NC","OK","SC","TN")
    US_TRE  <- c("TX")
    US_WECC <- c("AZ","CA","CO","ID","NM","NV","OR","UT","WA","WY")
    
    
    if (is.na(state)) {
      return(NA)
    }
    if      (state %in% US_ASCC) return("US_ASCC")
    else if (state %in% US_HICC) return("US_HICC")
    else if (state %in% US_MRO)  return("US_MRO")
    else if (state %in% US_NPCC) return("US_NPCC")
    else if (state %in% US_RFC)  return("US_RFC")
    else if (state %in% US_SERC) return("US_SERC")
    else if (state %in% US_TRE)  return("US_TRE")
    else if (state %in% US_WECC) return("US_WECC")
    # catch‑all
    return(NA)
  }
  
  # Classify state, region, and select appropriate electricity emission factor
  df_housing <- df_housing %>%
    rowwise() %>%
    mutate(
      state = classify_state(SD_08_ZipCode),
      region = classify_zip_code(SD_08_ZipCode),
      electricity_emission_factor = case_when(
        region == "US_ASCC" ~ emission_factors_housing$Electricity$US_ASCC,
        region == "US_HICC" ~ emission_factors_housing$Electricity$US_HICC,
        region == "US_MRO" ~ emission_factors_housing$Electricity$US_MRO,
        region == "US_NPCC" ~ emission_factors_housing$Electricity$US_NPCC,
        region == "US_RFC" ~ emission_factors_housing$Electricity$US_RFC,
        region == "US_SERC" ~ emission_factors_housing$Electricity$US_SERC,
        region == "US_TRE" ~ emission_factors_housing$Electricity$US_TRE,
        region == "US_WECC" ~ emission_factors_housing$Electricity$US_WECC
      )
    ) %>%
    ungroup()
  
  # Handle missing values for energy bills
  df_housing <- df_housing %>%
    mutate(
      EH_02_ElectricityBil_1 = as.numeric(EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = as.numeric(EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = as.numeric(EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1= as.numeric(EH_06_NaturalGasBill_1),
      EH_07_WaterBill = as.numeric(EH_07_WaterBill),
      SD_06_HouseholdSize_17 = as.numeric(SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = as.numeric(SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = as.numeric(SD_06_HouseholdSize_19),
      
      EH_02_ElectricityBil_1 = ifelse(is.na(EH_02_ElectricityBil_1), 0, EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = ifelse(is.na(EH_03_ElectricityBil_1), 0, EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = ifelse(is.na(EH_05_NaturalGasBill_1), 0, EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1= ifelse(is.na(EH_06_NaturalGasBill_1), 0, EH_06_NaturalGasBill_1),
      EH_07_WaterBill = ifelse(is.na(EH_07_WaterBill), 0, EH_07_WaterBill),
      SD_06_HouseholdSize_17 = ifelse(is.na(SD_06_HouseholdSize_17), 0, SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = ifelse(is.na(SD_06_HouseholdSize_18), 0, SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = ifelse(is.na(SD_06_HouseholdSize_19), 0, SD_06_HouseholdSize_19)
    )
  
  # Define electricity prices by state (in cents per kWh)
  electricity_prices <- data.frame(
    state = c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DC", "DE", "FL", 
              "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", 
              "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", 
              "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", 
              "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", 
              "WY"),
    price = c(12.41, 22.54, 13.16, 9.99, 19.90, 12.28, 21.62, 13.21, 12.05, 11.37, 
              12.26, 32.76, 10.58, 12.56, 12.02, 13.81, 11.56, 10.56, 9.37, 16.16, 
              13.92, 21.11, 16.07, 14.09, 11.55, 13.23, 11.85, 11.31, 11.67, 19.63, 
              15.64, 13.37, 19.30, 11.24, 12.07, 12.64, 10.72, 11.02, 14.38, 18.64, 
              12.91, 12.39, 10.79, 11.36, 10.63, 18.50, 12.40, 9.79, 11.57, 14.28, 
              12.30)
  )
  # Calculate annual emissions using specific user-selected values
  df_housing <- df_housing %>%
    mutate(
      electricity_price = as.numeric(electricity_prices$price[match(state, electricity_prices$state)]),
      electricity_usage_kWh = ifelse(electricity_price > 0,
                                     (EH_02_ElectricityBil_1 * 100) / electricity_price,
                                     0),
      natural_gas_usage_m3 = EH_05_NaturalGasBill_1 / 0.353147, # Assuming $0.353147 per 1.0 m3 for simplicity
      # 1) USD per m³ of water
      price_per_m3 = 6.64 / (1000 * 0.00378541),
      
      # 2) m³ used per month
      water_m3_month = ifelse(price_per_m3 > 0,
                              EH_07_WaterBill / price_per_m3,
                              0),
      HouseholdSize = SD_06_HouseholdSize_17 + SD_06_HouseholdSize_18 + SD_06_HouseholdSize_19,
      HouseholdSize = ifelse(HouseholdSize == 0, 1, HouseholdSize),
      ElectricityEmissions = electricity_usage_kWh * 12 * electricity_emission_factor,
      NaturalGasEmissions = natural_gas_usage_m3 * 12 * emission_factors_housing$NaturalGas,
      WaterEmissions = water_m3_month * emission_factors_housing$WaterCFC*12,
      
      # Total housing emissions
      HousingEmissions_household = ElectricityEmissions + NaturalGasEmissions + WaterEmissions,
      HousingEmissions=HousingEmissions_household/HouseholdSize
    )
  
  df_housing <- df_housing %>% 
    select(-state,-region,-electricity_emission_factor,-electricity_usage_kWh,-price_per_m3,-natural_gas_usage_m3,-water_m3_month,-HouseholdSize,-ElectricityEmissions,-NaturalGasEmissions,-WaterEmissions,-electricity_price,-HousingEmissions_household)
  
  # assign new df_housing to the user’s workspace
  assign(new_name, df_housing, envir = parent.frame())
  message(
    paste0(
      "✅ A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  
  return(df_housing)
}

