
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

#' Calculate Total Emissions
#'
#' This function computes total carbon emissions by aggregating transportation, pet, housing (per capita), food, and consumption-based emissions.
#'
#' @param df A data frame containing emissions data from various components.
#' @return A data frame with a new column `TotalEmissions` representing the aggregated total emissions.
#' @export
calc_total_emissions <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_total")
  
  df_total <- df
  df_total <- suppressMessages(calc_cons_emissions(df_total))
  df_total <- suppressMessages(calc_food_emissions(df_total))
  df_total <- suppressMessages(calc_housing_emissions(df_total))
  df_total <- suppressMessages(calc_pet_emissions(df_total))
  df_total <- suppressMessages(calc_transport_emissions(df_total))
  # Get country-specific emission factors
  emission_factors_total <- get_total_emission_factors(unique(df_total$SD_07_Country))
  

  
  # Ensure all emission components exist and replace NA values
  df_total <- df_total %>%
    mutate(
      TransportEmissions = ifelse(is.na(TransportEmissions), 0, TransportEmissions) * emission_factors_total$Transport,
      PetEmissions = ifelse(is.na(PetEmissions), 0, PetEmissions) * emission_factors_total$Pet,
      HousingEmissions = ifelse(is.na(HousingEmissions), 0, HousingEmissions) * emission_factors_total$Housing,
      FoodEmissions = ifelse(is.na(FoodEmissions), 0, FoodEmissions) * emission_factors_total$Food,
      ConsEmissions = ifelse(is.na(ConsEmissions), 0, ConsEmissions) * emission_factors_total$Consumption
    )
  
  # Calculate total emissions
  df_total <- df_total %>%
    mutate(
      TotalEmissions = TransportEmissions + PetEmissions + HousingEmissions +
        FoodEmissions + ConsEmissions
    )
    
  df_total <- df_total %>% 
  mutate(
  TotalEmissions = as.numeric(TotalEmissions)
  )
  

   # assign new df_total to the user’s workspace
   assign(new_name, df_total, envir = parent.frame())
   message(
     paste0(
       "✅ A new data frame '", new_name,
       "' is now available in your R environment."
     )
   )
   
  
  return(df_total)
}

