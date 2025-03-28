
# Create the built-in dataset for transport emission factors
transport_emission_factors <- tibble::tibble(
  Country = c("United States", "China", "European Union", "Other"),
  Gasoline_Vehicles = c(0.14748, NA, NA, NA),
  Diesel_Vehicles = c(0.16327, NA, NA, NA),
  Electric_Vehicles = c(0.0, NA, NA, NA),  # Assumed zero
  Hybrid_Vehicles = c(0.07374, NA, NA, NA),  # Half of gasoline
  Natural_Gas_Vehicles = c(0.1279, NA, NA, NA),
  Public_Transport = c(0.018949, NA, NA, NA),
  Flights = c(1.05285, NA, NA, NA),  # kg CO2 per km
  Long_Distance_Train = c(0.039489129, NA, NA, NA)  # kg CO2 per km
)

# Save the dataset as internal data
usethis::use_data(transport_emission_factors, overwrite = TRUE)
library(dplyr)
library(tidyverse)
#' Get country-specific transport emission factors
#'
#' Returns a list of transport emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A list of transport emission factors.
get_transport_emission_factors <- function(country) {
  
  # Ensure the built-in dataset exists
  if (!exists("transport_emission_factors")) {
    stop("Error: transport_emission_factors dataset not found.")
  }
  
  # Filter the dataset for the given country
  factors <- transport_emission_factors %>% filter(Country == country)
  
  # If no match, return NA values
  if (nrow(factors) == 0) {
    return(list(
      "Gasoline Vehicles" = NA,
      "Diesel Vehicles" = NA,
      "Electric Vehicles" = NA,
      "Hybrid Vehicles" = NA,
      "Natural Gas Vehicles" = NA,
      "Public Transport" = NA,
      "Flights" = NA,
      "Long Distance Train" = NA
    ))
  }
  
  # Convert row data to a list (excluding country column)
  return(as.list(factors[-1]))
}

#' Calculate Transport Emissions
#'
#' This function computes transportation emissions by converting survey responses into estimated annual carbon emissions.
#'
#' @param df A data frame containing transportation-related survey data.
#' @return A data frame with a new column `TransportEmissions` representing total transport emissions.
#' @export
calc_transport_emissions <- function(df) {
  
  # Get country-specific transport emission factors
  emission_factors_transport <- get_transport_emission_factors(unique(df$SD_07_Country))
  
  # Ensure emission factors are not NULL or empty
  emission_factors_transport <- lapply(emission_factors_transport, function(x) ifelse(is.na(x) | length(x) == 0, 0, x))

  # Define mappings for categorical values
  car_usage_map <- c(
    "0 days (I do not use a car)" = 0,
    "1-2 days" = 1.5,
    "3-4 days" = 3.5,
    "5-6 days" = 5.5,
    "Everyday" = 7
  )
  
  car_distance_map <- c(
    "0-5 km or 0-3.1 miles" = 5,
    "5-10 km or 3.1-6.2 miles" = 10,
    "11-50 km or 6.2-31 miles" = 30.5,
    "More than 50 km or 31 miles" = 51
  )
  
  public_transport_freq_map <- c(
    "Daily" = 1,
    "Weekly" = 1/7,
    "Monthly" = 1/30,
    "Rarely" = 1/90,
    "Never" = 0
  )
  
  public_transport_distance_map <- c(
    "0-5 km or 0-3.1 miles" = 5,
    "5-10 km or 3.1-6.2 miles" = 10,
    "11-50 km or 6.2-31 miles" = 30.5,
    "More than 50 km or 31 miles" = 51
  )
  
  flight_freq_map <- c(
    "None" = 0,
    "1-3 flights" = 2.5,
    "4-6 flights" = 5,
    "7-10 flights" = 8,
    "More than 10 flights" = 12
  )
  
  long_distance_transport_map <- c(
    "Daily" = 1,
    "Weekly" = 1/7,
    "Monthly" = 1/30,
    "Rarely" = 1/90,
    "Never" = 0
  )
  
  # Map categorical values to numeric
  df <- df %>%
    mutate(
      T_01_CarUsage = car_usage_map[T_01_CarUsage],
      T_03_CarDistance = car_distance_map[T_03_CarDistance],
      T_04_PublicTransport_usage = sapply(T_04_PublicTransport, function(x) public_transport_freq_map[[x]]),
      T_05_PublicTransport = public_transport_distance_map[T_05_PublicTransport],
      T_06_AirTravelLong = flight_freq_map[T_06_AirTravelLong],
      T_07_AirTravelShort = flight_freq_map[T_07_AirTravelShort],
      T_08_LongDistanceTra = long_distance_transport_map[T_08_LongDistanceTra]
    )
  
  # Assign correct emission factors for car types
  df <- df %>%
    mutate(
      car_emission_factor = case_when(
        T_02_CarType == "Gasoline Vehicle" ~ emission_factors_transport$Gasoline_Vehicles,
        T_02_CarType == "Diesel Vehicle" ~ emission_factors_transport$Diesel_Vehicles,
        T_02_CarType == "Hybrid Vehicle" ~ emission_factors_transport$Hybrid_Vehicles,
        T_02_CarType == "Electric Vehicle" ~ emission_factors_transport$Electric_Vehicles,
        T_02_CarType == "Natural Gas Vehicle" ~ emission_factors_transport$Natural_Gas_Vehicles,
        TRUE ~ 0
      )
    )
  
  # Handle missing values in user inputs
  df <- df %>%
    mutate(
      T_01_CarUsage = ifelse(is.na(T_01_CarUsage), 0, T_01_CarUsage),
      T_03_CarDistance = ifelse(is.na(T_03_CarDistance), 0, T_03_CarDistance),
      T_04_PublicTransport_usage = ifelse(is.na(T_04_PublicTransport_usage), 0, T_04_PublicTransport_usage),
      T_05_PublicTransport = ifelse(is.na(T_05_PublicTransport), 0, T_05_PublicTransport),
      T_06_AirTravelLong = ifelse(is.na(T_06_AirTravelLong), 0, T_06_AirTravelLong),
      T_07_AirTravelShort = ifelse(is.na(T_07_AirTravelShort), 0, T_07_AirTravelShort),
      T_08_LongDistanceTra = ifelse(is.na(T_08_LongDistanceTra), 0, T_08_LongDistanceTra)
    )
  
  # Calculate weekly travel distances
  df <- df %>%
    mutate(
      WeeklyCarDistance = T_01_CarUsage * T_03_CarDistance,
      WeeklyPublicTransportDistance = T_05_PublicTransport,
      public_transport_usage_factor = T_04_PublicTransport_usage
    )
    
  df <- df %>% 
    mutate(WeeklyCarDistance = as.numeric(WeeklyCarDistance),
  WeeklyPublicTransportDistance = as.numeric(WeeklyPublicTransportDistance))
  
  # Ensure emission factors are correctly assigned and avoid size 0 error
  public_transport_factor <- ifelse(length(emission_factors_transport$Public_Transport) > 0,
                                    emission_factors_transport$Public_Transport, 0)
  
  flights_factor <- ifelse(length(emission_factors_transport$Flights) > 0,
                           emission_factors_transport$Flights, 0)

  train_factor <- ifelse(length(emission_factors_transport$Long_Distance_Train) > 0,
                         emission_factors_transport$Long_Distance_Train, 0)

  # Calculate annual emissions
  df <- df %>%
    mutate(
      CarEmissions = WeeklyCarDistance * car_emission_factor * 52,
      PublicTransportEmissions = WeeklyPublicTransportDistance * public_transport_factor * 52 * public_transport_usage_factor,
      AirTravelLongEmissions = T_06_AirTravelLong * 1609 * flights_factor,
      AirTravelShortEmissions = T_07_AirTravelShort * 804.5 * flights_factor,
      TrainEmissions = T_08_LongDistanceTra * 100 * 365 * train_factor,
      TransportEmissions = CarEmissions + PublicTransportEmissions + AirTravelLongEmissions + AirTravelShortEmissions + TrainEmissions
    )
  
df <- df %>% 
  mutate(    
  CarEmissions = as.numeric(CarEmissions),
    PublicTransportEmissions = as.numeric(PublicTransportEmissions),
    AirTravelLongEmissions = as.numeric(AirTravelLongEmissions),
    AirTravelShortEmissions = as.numeric(AirTravelShortEmissions),
    TrainEmissions = as.numeric(TrainEmissions),
    TransportEmissions = as.numeric(TransportEmissions))
    
    df <- df %>% 
  select(-car_emission_factor,-WeeklyCarDistance,-WeeklyPublicTransportDistance,-CarEmissions,-PublicTransportEmissions,-AirTravelLongEmissions,-AirTravelShortEmissions,-TrainEmissions)
  
  # Notify user and print results
  message("New column `TransportEmissions` representing total transport-related emissions has been added to the dataset.")


  print(df$TransportEmissions)
  
  return(df)
}

