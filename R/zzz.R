
.onLoad <- function(libname, pkgname) {
  required_packages <- c("dplyr", "tidyr", "tibble", "purrr", "magrittr")

  for (pkg in required_packages) {
    if (!requireNamespace(pkg, quietly = TRUE)) {
       warning(paste("Package", pkg, "is required but not installed. Please install it."))
    }
  }
}

.onLoad <- function(libname, pkgname) {
  utils::globalVariables(c(
    # General variables
    "Zip_Min", "Zip_Max", "ST", "SD_08_ZipCode", "WeeklyCarDistance", 
    "electricity_emission_factor", "natural_gas_usage_cubic_feet", 
    "electricity_usage_kWh", "CarEmissions", "PublicTransportEmissions",
    "AirTravelLongEmissions", "AirTravelShortEmissions", "TrainEmissions", 
    "PetEmissions", "PetEmissions_Cat", "PetEmissions_Dog", "HousingEmissions", 
    "FoodEmissions", "ConsEmissions", "WaterEmissions", "HouseholdSize",
    
    # Consumption Emissions
    "CL_03_MonthlyEx_9", "CL_03_MonthlyEx_10", "CL_03_MonthlyEx_11", 
    "CL_03_MonthlyEx_12", "CL_03_MonthlyEx_13", "CL_03_MonthlyEx_14", 
    "CL_03_MonthlyEx_15", "CL_01_ClothingPurcha", "annual_clothing_spending", 
    "FoodDeliveryEm", "DiningOutEm", "HotelStaysEm", "TobaccoEm", 
    "AlcoholEm", "EntertainmentEm", "HealthcareEm", "ClothingEm",
    
    # Food Emissions
    "F_01_DietaryHabits_4", "F_01_DietaryHabits_5", "F_01_DietaryHabits_6", 
    "F_01_DietaryHabits_7", ".", "MeatEmissions", "VeganEmissions", 
    "VegetarianEmissions", "DairyEmissions",
    
    # Housing Emissions
    "EH_02_ElectricityBil_1", "EH_03_ElectricityBil_1", 
    "EH_05_NaturalGasBill_1", "EH_06_NaturalGasBill_1", "EH_07_WaterBill",
    "ElectricityEmissions", "NaturalGasEmissions","WaterEmissions",
    
    # Pet Emissions
    "PETS_4", "PETS_5",
    
    # Total Emissions
    "SD_06_HouseholdSize_17", "SD_06_HouseholdSize_18", "SD_06_HouseholdSize_19",
    "TransportEmissions", "HousingEmissionsPerCapita","TotalEmissions","electricity_price",
    
    # Transport Emissions
    "T_01_CarUsage", "T_03_CarDistance", "T_04_PublicTransport", 
    "T_05_PublicTransport", "T_06_AirTravelLong", "T_07_AirTravelShort", 
    "T_08_LongDistanceTra", "car_emission_factor", "WeeklyPublicTransportDistance","T_04_PublicTransport_usage","public_transport_usage_factor",
    
    # Emission Factor Functions
    "Country", "FactorName", "Value", "pull","state","region"
  ))
}


