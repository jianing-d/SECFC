
# Create a built-in dataset for housing emission factors
housing_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States", "United States", "United States","United States", "United States", "United States", "United States",
              "China", "China", "China", "China", "China","China", "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("WaterCFC", "NaturalGas", "Electricity_US_ASCC", "Electricity_US_HICC", "Electricity_US_MRO", "Electricity_US_NPCC","Electricity_US_RFC", "Electricity_US_SERC", "Electricity_TRE", "Electricity_WECC",
                 "WaterCFC", "NaturalGas", "Electricity_中国南方电网","Electricity_华东电网公司","Electricity_华北电网公司","Electricity_中国东北电网","Electricity_西北电网","Electricity_西南电网","Electricity_华中电网","Electricity_Hong Kong",
                 "WaterCFC", "NaturalGas", "Electricity_EU_Group1", "Electricity_EU_Group2", "Electricity_EU_Group3"),
  Value = c(0.84, 2.49801121, 0.608418285, 0.823151786, 0.543851789, 0.273336294, 0.5399024,0.532591155,0.461607295,0.376463424,
            0.801548088, 5.676877175, 0.606058558,0.784460835,1.052715703,1.23154963,0.875964414,0.364927425,0.870897537,0.867604857,  
            NA, NA, NA, NA, NA)
)

# Save as an internal dataset inside the package
usethis::use_data_raw("housing_emission_factors", open = FALSE)
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

# Create the cn_admin_data dataset (China admin code → province, grid, price RMB/kWh)
cn_admin_data <- tibble::tibble(
  AdminCode = c(110000,120000,130000,140000,150000,210000,220000,230000,310000,320000,330000,340000,350000,360000,370000,410000,420000,430000,440000,450000,460000,500000,510000,520000,530000,540000,610000,620000,630000,640000,650000,810000,820000),
  Province  = c("北京市","天津市","河北省","山西省","内蒙古自治区","辽宁省","吉林省","黑龙江省","上海市","江苏省","浙江省","安徽省","福建省","江西省","山东省","河南省","湖北省","湖南省","广东省","广西壮族自治区","海南省","重庆市","四川省","贵州省","云南省","西藏自治区","陕西省","甘肃省","青海省","宁夏回族自治区","新疆维吾尔自治区","香港特别行政区","澳门特别行政区"),
  GridName  = c("Electricity_华北电网公司","Electricity_华北电网公司","Electricity_华北电网公司","Electricity_华北电网公司","Electricity_华北电网公司",
                "Electricity_中国东北电网","Electricity_中国东北电网","Electricity_中国东北电网",
                "Electricity_华东电网公司","Electricity_华东电网公司","Electricity_华东电网公司","Electricity_华东电网公司","Electricity_华东电网公司",
                "Electricity_华中电网","Electricity_华北电网公司","Electricity_华中电网","Electricity_华中电网","Electricity_华中电网",
                "Electricity_中国南方电网","Electricity_中国南方电网","Electricity_中国南方电网",
                "Electricity_西南电网","Electricity_西南电网","Electricity_中国南方电网","Electricity_中国南方电网","Electricity_西南电网",
                "Electricity_西北电网","Electricity_西北电网","Electricity_西北电网","Electricity_西北电网","Electricity_西北电网",
                "Electricity_Hong Kong","Electricity_中国南方电网"),
  ElecPrice_RMB_per_kWh = c(0.4883,0.49,0.52,0.477,0.415,0.5,0.525,0.51,0.617,0.5283,0.538,0.5653,0.4983,0.6,0.5469,0.56,0.558,0.588,0.589,0.5283,0.6083,0.52,0.5224,0.4556,0.36,0.49,0.4983,0.51,0.3771,0.4486,0.49,1.424,1.167)
)

# Save it as an internal dataset inside the package
usethis::use_data_raw("cn_admin_data", open = FALSE)
usethis::use_data(cn_admin_data, overwrite = TRUE)

library(dplyr)
library(tidyverse)

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
#' @importFrom tidyr replace_na
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
        `Electricity_中国南方电网` = get_elec("Electricity_中国南方电网"),
        `Electricity_华东电网公司` = get_elec("Electricity_华东电网公司"),
        `Electricity_华北电网公司` = get_elec("Electricity_华北电网公司"),
        `Electricity_中国东北电网` = get_elec("Electricity_中国东北电网"),
        `Electricity_西北电网`     = get_elec("Electricity_西北电网"),
        `Electricity_西南电网`     = get_elec("Electricity_西南电网"),
        `Electricity_华中电网`     = get_elec("Electricity_华中电网"),
        `Electricity_Hong Kong`   = get_elec("Electricity_Hong Kong")
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
  
  if (!exists("zip_data")) stop("Error: zip_data dataset not found.")
  if (!exists("cn_admin_data")) {
    # Not mandatory to always have China data, but required if there are rows for China
    has_cn <- any(df$SD_07_Country %in% c("China","中国"), na.rm = TRUE)
    if (has_cn) stop("Error: cn_admin_data dataset not found.")
  }
  
  # Pre-fetch emission factors for the two countries (to avoid repeated row-wise lookups)
  factors_us <- get_housing_emission_factors("United States")
  factors_cn <- get_housing_emission_factors("China")
  
  # US helper: ZIP → State → Region
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
  
  # US state electricity price table
  electricity_prices <- data.frame(
    state = c("AL","AK","AZ","AR","CA","CO","CT","DC","DE","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"),
    price = c(12.41,22.54,13.16,9.99,19.90,12.28,21.62,13.21,12.05,11.37,12.26,32.76,10.58,12.56,12.02,13.81,11.56,10.56,9.37,16.16,13.92,21.11,16.07,14.09,11.55,13.23,11.85,11.31,11.67,19.63,15.64,13.37,19.30,11.24,12.07,12.64,10.72,11.02,14.38,18.64,12.91,12.39,10.79,11.36,10.63,18.50,12.40,9.79,11.57,14.28,12.30)
  )
  
  # Pre-cleaning
  df_housing <- df %>%
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
  
  # For China rows, add provincial electricity price/power grid company
  if (exists("cn_admin_data")) {
    df_housing <- df_housing %>%
      left_join(cn_admin_data, by = c("SD_09_AdminCode" = "AdminCode"))
  }
  
  # Row-wise calculation: assign process by country
  df_housing <- df_housing %>%
    rowwise() %>%
    mutate(
      # -- Household size -- 
      HouseholdSize = SD_06_HouseholdSize_17 + SD_06_HouseholdSize_18 + SD_06_HouseholdSize_19,
      HouseholdSize = ifelse(HouseholdSize == 0, 1, HouseholdSize),
      
      # -- US path: ZIP → State/Region/Electricity factor; infer electricity usage from bills and state electricity price -- 
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
      # Natural gas/tap water (US) simplified: Price → Usage (m³), then multiply by factor (kgCO2/m³)
      natural_gas_usage_m3_us = ifelse(SD_07_Country == "United States", EH_05_NaturalGasBill_1 / 0.353147, 0),
      price_per_m3_us         = ifelse(SD_07_Country == "United States", 6.64 / (1000 * 0.00378541), NA_real_),
      water_m3_month_us       = ifelse(SD_07_Country == "United States" & !is.na(price_per_m3_us) & price_per_m3_us > 0,
                                       EH_07_WaterBill / price_per_m3_us, 0),
      
      # -- China path: Provincial electricity price (RMB/kWh) directly infers usage; water/gas use “per RMB emission factor” -- 
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
      
      # -- Electricity emissions by country -- 
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
      
      # -- Tap water emissions by country -- 
      WaterEmissions = dplyr::case_when(
        SD_07_Country == "United States" ~ water_m3_month_us * 12 * factors_us$WaterCFC,
        SD_07_Country == "China"         ~ EH_07_WaterBill  * 12 * factors_cn$WaterCFC,            # Unit: kgCO2e_per_RMB
        TRUE ~ NA_real_
      ),
      
      HousingEmissions_household = rowSums(cbind(ElectricityEmissions, NaturalGasEmissions, WaterEmissions), na.rm = TRUE),
      HousingEmissions = HousingEmissions_household / HouseholdSize
    ) %>% 
    ungroup()
  
  # Clean up intermediate columns
  drop_cols <- intersect(
    names(df_housing),
    c("HouseholdSize",
      # us
      "state_us","region_us","elec_price_us_cents","elec_factor_us",
      "electricity_usage_kWh_us","natural_gas_usage_m3_us","price_per_m3_us","water_m3_month_us",
      # china
      "Province","GridName","ElecPrice_RMB_per_kWh","elec_price_cn_rmb","electricity_usage_kWh_cn","elec_factor_cn",
      "HousingEmissions_household")
  )
  df_housing <- df_housing %>% select(-all_of(drop_cols))
  
  assign(new_name, df_housing, envir = parent.frame())
  message(paste0("\u2705 A new data frame '", new_name, "' is now available in your R environment."))
  return(df_housing)
}
