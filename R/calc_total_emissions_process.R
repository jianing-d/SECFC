
#' Get country-specific total emission factors
#'
#' Returns a list of total emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @param country A character string representing the country.
#' @return A list of total emission factors.
get_total_emission_factors <- function(country) {
  # Normalize country names
  norm <- function(x) {
    if (is.na(x) || x == "") return(NA_character_)
    xl <- tolower(trimws(as.character(x)))
    dplyr::case_when(
      xl %in% c("united states", "united states of america", "us", "usa") ~ "United States",
      xl %in% c("china", "中国") ~ "China",
      xl %in% c("european union", "eu", "欧盟") ~ "European Union",
      TRUE ~ x
    )
  }
  country <- norm(country)
  
  if (identical(country, "United States")) {
    return(list(
      "Transport" = 1,  # Placeholder (1 means no modification)
      "Pet" = 1,
      "Housing" = 1,
      "Food" = 1,
      "Consumption" = 1
    ))
  } else if (identical(country, "China")) {
    return(list(
      "Transport" = 1,  # Placeholder (can be replaced with Chinese-specific scaling later)
      "Pet" = 1,
      "Housing" = 1,
      "Food" = 1,
      "Consumption" = 1
    ))
  } else if (identical(country, "European Union")) {
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

#' Calculate Total Carbon Emissions with Process Data
#'
#' This function computes total carbon emissions by aggregating transportation, pet, housing (per capita), food, and consumption-based emissions.
#'
#' @param df A data frame containing emissions data from various components.
#' @return A data frame with a new column `TotalEmissions` representing total emissions and additional process calculation results.
#' @export
calc_total_emissions_process <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_total_process")
  
  df_total_process <- df
  df_total_process <- suppressMessages(calc_cons_emissions_process(df_total_process))
  df_total_process <- suppressMessages(calc_food_emissions_process(df_total_process))
  df_total_process <- suppressMessages(calc_housing_emissions_process(df_total_process))
  df_total_process <- suppressMessages(calc_pet_emissions_process(df_total_process))
  df_total_process <- suppressMessages(calc_transport_emissions_process(df_total_process))
  
  # Apply emission factors row by row (handles mixed-country datasets)
  df_total_process <- df_total_process %>%
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
  
  # Ensure components exist, replace NA with 0, apply country-specific factors
  df_total_process <- df_total_process %>%
    dplyr::mutate(
      TransportEmissions = ifelse(is.na(TransportEmissions), 0, TransportEmissions) * TotalFactor_Transport,
      PetEmissions       = ifelse(is.na(PetEmissions),       0, PetEmissions)       * TotalFactor_Pet,
      HousingEmissions   = ifelse(is.na(HousingEmissions),   0, HousingEmissions)   * TotalFactor_Housing,
      FoodEmissions      = ifelse(is.na(FoodEmissions),      0, FoodEmissions)      * TotalFactor_Food,
      ConsEmissions      = ifelse(is.na(ConsEmissions),      0, ConsEmissions)      * TotalFactor_Consumption
    )
  
  # Aggregate total emissions
  df_total_process <- df_total_process %>%
    dplyr::mutate(
      TotalEmissions = as.numeric(TransportEmissions + PetEmissions +
                                    HousingEmissions + FoodEmissions +
                                    ConsEmissions)
    )
  
  # Drop temporary factor columns
  df_total_process <- df_total_process %>%
    dplyr::select(-dplyr::any_of(c(".f_total",
                                   "TotalFactor_Transport","TotalFactor_Pet",
                                   "TotalFactor_Housing","TotalFactor_Food",
                                   "TotalFactor_Consumption")))
  
  # Save result in user workspace
  assign(new_name, df_total_process, envir = parent.frame())
  message(paste0("\u2705 A new data frame '", new_name, "' is now available in your R environment."))
  
  return(df_total_process)
}