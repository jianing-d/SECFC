
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
      WaterCFC   = 26.5,
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



#' Calculate Housing-Related Carbon Emissions with Process Data
#'
#' This function computes housing-related carbon emissions and retains process calculation result data.
#'
#' @param df A data frame containing housing-related data.
#' @return A data frame with a new column `HousingEmissions` representing total housing-related emissions and additional process calculation results.
#' @export
calc_housing_emissions_process <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_housing_process")
  # Ensure built-in datasets are available
  if (!exists("zip_data")) stop("Error: zip_data dataset not found.")
  
  # Get country-specific housing emission factors
  emission_factors_housing <- get_housing_emission_factors(unique(df$SD_07_Country))
  
  # Ensure ZIP code exists and is numeric
  df_housing_process <- df %>%
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
  df_housing_process <- df_housing_process %>%
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
  df_housing_process <- df_housing_process %>%
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
  df_housing_process <- df_housing_process %>%
    mutate(
      electricity_price = as.numeric(electricity_prices$price[match(state, electricity_prices$state)]),
      electricity_usage_kWh = ifelse(electricity_price > 0,
                                     (EH_02_ElectricityBil_1 * 100) / electricity_price,
                                     0),
      natural_gas_usage_m3 = EH_05_NaturalGasBill_1 / 0.353147, # Assuming $0.353147 per 1.0 m3 for simplicity
      
      ElectricityEmissions = electricity_usage_kWh * 12 * electricity_emission_factor,
      NaturalGasEmissions = natural_gas_usage_m3 * 12 * emission_factors_housing$NaturalGas,
      WaterEmissions = emission_factors_housing$WaterCFC,
      
      # Total housing emissions
      HousingEmissions = ElectricityEmissions + NaturalGasEmissions + WaterEmissions
    )
  

  # assign new df_housing_process to the user’s workspace
  assign(new_name, df_housing_process, envir = parent.frame())
  message(
    paste0(
      "✅ A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  
  return(df_housing_process)
}

