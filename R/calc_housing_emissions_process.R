
.onLoad <- function(libname, pkgname) {
  data_env <- globalenv()
  utils::data("zip_data", package = pkgname, envir = data_env)
  utils::data("housing_emission_factors", package = pkgname, envir = data_env)
  utils::data("cn_admin_data", package = pkgname, envir = data_env)   # <- NEW
}


#' Get country-specific housing emission factors from dataset
#'
#' Returns a list of housing emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na pivot_wider
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
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
      NaturalGas = 2.49801121,
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
  
  # China: return actual values and group by power grid company
  if (lookup_country == "China") {
    if (!exists("housing_emission_factors", where = globalenv())) {
      stop("Error: housing_emission_factors dataset not found.")
    }
    factors_cn <- housing_emission_factors %>% filter(Country == "China")
    
    # Extract water/natural gas (unit: kgCO2e per RMB)
    water_v   <- factors_cn %>% filter(FactorName == "WaterCFC") %>% pull(Value) %>% {if(length(.)==0) NA_real_ else .}
    gas_v     <- factors_cn %>% filter(FactorName == "NaturalGas") %>% pull(Value) %>% {if(length(.)==0) NA_real_ else .}
    
    # Electricity (unit: kg CO2-eq / kWh), values retrieved by power grid company name
    get_elec <- function(name) {
      v <- factors_cn %>% filter(FactorName == name) %>% pull(Value)
      if (length(v) == 0) NA_real_ else v
    }
    
    return(list(
      WaterCFC   = water_v,
      NaturalGas = gas_v,
      Electricity = list(
        `Electricity_北京`     = get_elec("Electricity_北京"),
        `Electricity_天津`     = get_elec("Electricity_天津"),
        `Electricity_河北`     = get_elec("Electricity_河北"),
        `Electricity_山西`     = get_elec("Electricity_山西"),
        `Electricity_内蒙古`   = get_elec("Electricity_内蒙古"),
        `Electricity_辽宁`     = get_elec("Electricity_辽宁"),
        `Electricity_吉林`     = get_elec("Electricity_吉林"),
        `Electricity_黑龙江`   = get_elec("Electricity_黑龙江"),
        `Electricity_上海`     = get_elec("Electricity_上海"),
        `Electricity_江苏`     = get_elec("Electricity_江苏"),
        `Electricity_浙江`     = get_elec("Electricity_浙江"),
        `Electricity_安徽`     = get_elec("Electricity_安徽"),
        `Electricity_福建`     = get_elec("Electricity_福建"),
        `Electricity_江西`     = get_elec("Electricity_江西"),
        `Electricity_山东`     = get_elec("Electricity_山东"),
        `Electricity_河南`     = get_elec("Electricity_河南"),
        `Electricity_湖北`     = get_elec("Electricity_湖北"),
        `Electricity_湖南`     = get_elec("Electricity_湖南"),
        `Electricity_广东`     = get_elec("Electricity_广东"),
        `Electricity_广西`     = get_elec("Electricity_广西"),
        `Electricity_海南`     = get_elec("Electricity_海南"),
        `Electricity_重庆`     = get_elec("Electricity_重庆"),
        `Electricity_四川`     = get_elec("Electricity_四川"),
        `Electricity_贵州`     = get_elec("Electricity_贵州"),
        `Electricity_云南`     = get_elec("Electricity_云南"),
        `Electricity_西藏`     = get_elec("Electricity_西藏"),
        `Electricity_陕西`     = get_elec("Electricity_陕西"),
        `Electricity_甘肃`     = get_elec("Electricity_甘肃"),
        `Electricity_青海`     = get_elec("Electricity_青海"),
        `Electricity_宁夏`     = get_elec("Electricity_宁夏"),
        `Electricity_新疆`     = get_elec("Electricity_新疆")
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
  if (!exists("cn_admin_data")) {
    has_cn <- any(df$SD_07_Country %in% c("China","中国"), na.rm = TRUE)
    if (has_cn) stop("Error: cn_admin_data dataset not found.")
  }
  # Get country-specific housing emission factors
  factors_us <- get_housing_emission_factors("United States")
  factors_cn <- get_housing_emission_factors("China")
  
  # Define function to classify state based on ZIP code
  classify_state <- function(zip_code) {
    if (is.na(zip_code)) return(NA_character_)
    st <- zip_data %>% filter(zip_code >= Zip_Min & zip_code <= Zip_Max) %>% pull(ST)
    if (length(st) == 1) st else NA_character_
  }
  classify_zip_code <- function(zip_code) {
    state <- classify_state(zip_code)
    US_ASCC <- c("AK"); US_HICC <- c("HI")
    US_MRO  <- c("IA","IL","KS","MI","MN","MO","MT","ND","NE","SD","WI")
    US_NPCC <- c("CT","MA","ME","NH","NY","RI","VT")
    US_RFC  <- c("DC","DE","IN","MD","NJ","OH","PA","VA","WV")
    US_SERC <- c("AL","AR","FL","GA","KY","LA","MS","NC","OK","SC","TN")
    US_TRE  <- c("TX")
    US_WECC <- c("AZ","CA","CO","ID","NM","NV","OR","UT","WA","WY")
    if (is.na(state)) return(NA_character_)
    if      (state %in% US_ASCC) "US_ASCC"
    else if (state %in% US_HICC) "US_HICC"
    else if (state %in% US_MRO)  "US_MRO"
    else if (state %in% US_NPCC) "US_NPCC"
    else if (state %in% US_RFC)  "US_RFC"
    else if (state %in% US_SERC) "US_SERC"
    else if (state %in% US_TRE)  "US_TRE"
    else if (state %in% US_WECC) "US_WECC"
    else NA_character_
  }
  
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
  
  
  
  # Classify state, region, and select appropriate electricity emission factor
  df_housing_process <- df %>%
    mutate(
      SD_08_ZipCode   = suppressWarnings(as.numeric(SD_08_ZipCode)),
      SD_09_AdminCode = suppressWarnings(as.numeric(SD_09_AdminCode)),
      EH_02_ElectricityBil_1 = as.numeric(EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = as.numeric(EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = as.numeric(EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1 = as.numeric(EH_06_NaturalGasBill_1),
      EH_07_WaterBill        = as.numeric(EH_07_WaterBill),
      SD_06_HouseholdSize_17 = as.numeric(SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = as.numeric(SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = as.numeric(SD_06_HouseholdSize_19),
      EH_02_ElectricityBil_1 = ifelse(is.na(EH_02_ElectricityBil_1), 0, EH_02_ElectricityBil_1),
      EH_03_ElectricityBil_1 = ifelse(is.na(EH_03_ElectricityBil_1), 0, EH_03_ElectricityBil_1),
      EH_05_NaturalGasBill_1 = ifelse(is.na(EH_05_NaturalGasBill_1), 0, EH_05_NaturalGasBill_1),
      EH_06_NaturalGasBill_1 = ifelse(is.na(EH_06_NaturalGasBill_1), 0, EH_06_NaturalGasBill_1),
      EH_07_WaterBill        = ifelse(is.na(EH_07_WaterBill),        0, EH_07_WaterBill),
      SD_06_HouseholdSize_17 = ifelse(is.na(SD_06_HouseholdSize_17), 0, SD_06_HouseholdSize_17),
      SD_06_HouseholdSize_18 = ifelse(is.na(SD_06_HouseholdSize_18), 0, SD_06_HouseholdSize_18),
      SD_06_HouseholdSize_19 = ifelse(is.na(SD_06_HouseholdSize_19), 0, SD_06_HouseholdSize_19)
    )
  
  # Subsidy to China Bank and provincial electricity price/grid companies
  if (exists("cn_admin_data")) {
    df_housing_process <- df_housing_process %>%
      left_join(cn_admin_data, by = c("SD_09_AdminCode" = "AdminCode"))
  }
  
  # Calculate annual emissions using specific user-selected values
  df_housing_process <- df_housing_process %>%
    rowwise() %>%
    mutate(
      HouseholdSize = SD_06_HouseholdSize_17 + SD_06_HouseholdSize_18 + SD_06_HouseholdSize_19,
      HouseholdSize = ifelse(HouseholdSize == 0, 1, HouseholdSize),
      
      #US path: ZIP → state/region/electricity factor; reverse-calculate electricity consumption from bills and state electricity prices.
      state_us  = ifelse(SD_07_Country == "United States", classify_state(SD_08_ZipCode), NA_character_),
      region_us = ifelse(SD_07_Country == "United States", classify_zip_code(SD_08_ZipCode), NA_character_),
      elec_price_us_cents = ifelse(SD_07_Country == "United States",
                                   as.numeric(electricity_prices$price[match(state_us, electricity_prices$state)]),
                                   NA_real_),
      elec_factor_us = ifelse(SD_07_Country == "United States",
                              dplyr::case_when(
                                region_us == "US_ASCC" ~ factors_us$Electricity$US_ASCC,
                                region_us == "US_HICC" ~ factors_us$Electricity$US_HICC,
                                region_us == "US_MRO"  ~ factors_us$Electricity$US_MRO,
                                region_us == "US_NPCC" ~ factors_us$Electricity$US_NPCC,
                                region_us == "US_RFC"  ~ factors_us$Electricity$US_RFC,
                                region_us == "US_SERC" ~ factors_us$Electricity$US_SERC,
                                region_us == "US_TRE"  ~ factors_us$Electricity$US_TRE,
                                region_us == "US_WECC" ~ factors_us$Electricity$US_WECC,
                                TRUE ~ NA_real_
                              ),
                              NA_real_),
      electricity_usage_kWh_us = ifelse(SD_07_Country == "United States" &
                                          !is.na(elec_price_us_cents) & elec_price_us_cents > 0,
                                        (EH_02_ElectricityBil_1 * 100) / elec_price_us_cents, 0),
      #Natural gas/tap water (USA) is simplified as follows: price → usage (m³), then multiply by a factor (kgCO2/m³)
      natural_gas_usage_m3_us = ifelse(SD_07_Country == "United States", EH_05_NaturalGasBill_1 / 0.353147, 0),
      price_per_m3_us         = ifelse(SD_07_Country == "United States", 6.64 / (1000 * 0.00378541), NA_real_),
      water_m3_month_us       = ifelse(SD_07_Country == "United States" & !is.na(price_per_m3_us) & price_per_m3_us > 0,
                                       EH_07_WaterBill / price_per_m3_us, 0),
      
      #China's path: Provincial electricity prices (RMB/kWh) directly infer electricity consumption; water/gas are calculated using the "emission factor per RMB"
      elec_price_cn_rmb = ifelse(SD_07_Country == "China", ElecPrice_RMB_per_kWh, NA_real_),
      electricity_usage_kWh_cn = ifelse(SD_07_Country == "China" &
                                          !is.na(elec_price_cn_rmb) & elec_price_cn_rmb > 0,
                                        EH_02_ElectricityBil_1 / elec_price_cn_rmb, 0),
      elec_factor_cn = ifelse(SD_07_Country == "China" & !is.null(factors_cn$Electricity),
                              {
                                nm <- as.character(GridName)
                                if (!is.na(nm) && nm %in% names(factors_cn$Electricity)) {
                                  as.numeric(factors_cn$Electricity[[nm]])
                                } else NA_real_
                              }, NA_real_),
      #  Electricity emissions by country
      ElectricityEmissions = dplyr::case_when(
        SD_07_Country == "United States" ~ electricity_usage_kWh_us * 12 * elec_factor_us,
        SD_07_Country == "China"         ~ electricity_usage_kWh_cn * 12 * elec_factor_cn,
        TRUE ~ NA_real_
      ),
      
      # -- Natural gas emissions by country --
      NaturalGasEmissions = dplyr::case_when(
        SD_07_Country == "United States" ~ natural_gas_usage_m3_us * 12 * factors_us$NaturalGas,
        SD_07_Country == "China"         ~ EH_05_NaturalGasBill_1   * 12 * factors_cn$NaturalGas,  # Unit: kgCO2e_per_RMB
        TRUE ~ NA_real_
      ),
      
      # -- Tap water discharge by country --
      WaterEmissions = dplyr::case_when(
        SD_07_Country == "United States" ~ water_m3_month_us * 12 * factors_us$WaterCFC,
        SD_07_Country == "China"         ~ EH_07_WaterBill  * 12 * factors_cn$WaterCFC,            # Unit: kgCO2e_per_RMB
        TRUE ~ NA_real_
      ),
      
      HousingEmissions_household = rowSums(cbind(ElectricityEmissions, NaturalGasEmissions, WaterEmissions), na.rm = TRUE),
      HousingEmissions = HousingEmissions_household / HouseholdSize
    ) %>% 
    ungroup()
  
  
  
  
  
  # assign new df_housing_process to the user's workspace
  assign(new_name, df_housing_process, envir = parent.frame())
  message(
    paste0(
      "\u2705 A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  
  return(df_housing_process)
}

