
#' Get country-specific total emission factors
#'
#' Returns a list of total emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na pivot_wider
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
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
      "Transport" = 1,  # Placeholder for China
      "Pet" = 1,
      "Housing" = 1,
      "Food" = 1,
      "Consumption" = 1
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
  
  # Key modification: Retrieve and apply total emission factors row by row based on SD_07_Country
  df_total <- df_total %>%
    dplyr::rowwise() %>%
    dplyr::mutate(
      .f_total = list(get_total_emission_factors(SD_07_Country)),
      TotalFactor_Transport   = .f_total$Transport,
      TotalFactor_Pet         = .f_total$Pet,
      TotalFactor_Housing     = .f_total$Housing,
      TotalFactor_Food        = .f_total$Food,
      TotalFactor_Consumption = .f_total$Consumption
    ) %>%
    dplyr::ungroup()
  
  # Ensure all emission components exist and replace NA values, then multiply by the row-specific factors
  df_total <- df_total %>%
    dplyr::mutate(
      TransportEmissions = ifelse(is.na(TransportEmissions), 0, TransportEmissions) * TotalFactor_Transport,
      PetEmissions       = ifelse(is.na(PetEmissions),       0, PetEmissions)       * TotalFactor_Pet,
      HousingEmissions   = ifelse(is.na(HousingEmissions),   0, HousingEmissions)   * TotalFactor_Housing,
      FoodEmissions      = ifelse(is.na(FoodEmissions),      0, FoodEmissions)      * TotalFactor_Food,
      ConsEmissions      = ifelse(is.na(ConsEmissions),      0, ConsEmissions)      * TotalFactor_Consumption
    )
  
  # Calculate total emissions
  df_total <- df_total %>%
    dplyr::mutate(
      TotalEmissions = TransportEmissions + PetEmissions + HousingEmissions +
        FoodEmissions + ConsEmissions,
      TotalEmissions = as.numeric(TotalEmissions)
    )
  
  # Clean up temporary factor columns
  df_total <- df_total %>%
    dplyr::select(-dplyr::any_of(c(".f_total",
                                   "TotalFactor_Transport","TotalFactor_Pet",
                                   "TotalFactor_Housing","TotalFactor_Food",
                                   "TotalFactor_Consumption")))
  
  # assign new df_total to the user's workspace
  assign(new_name, df_total, envir = parent.frame())
  message(paste0("\u2705 A new data frame '", new_name, "' is now available in your R environment."))
  return(df_total)
}
