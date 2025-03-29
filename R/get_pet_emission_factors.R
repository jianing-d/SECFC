# Generated from create-SECFC.Rmd: do not edit by hand

#' Get country-specific pet emission factors
#'
#' Returns a list of pet emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @param country A character string representing the country.
#' @return A list of pet emission factors.
get_pet_emission_factors <- function(country) {
  
  # Ensure dataset exists
  if (!exists("pet_emission_factors")) stop("Error: pet_emission_factors dataset not found.")
  
  # Filter dataset for the given country
  factors <- pet_emission_factors %>% filter(Country == country)
  
  # If no match, return NA values
  if (nrow(factors) == 0) {
    return(list("Dog" = NA, "Cat" = NA))
  }
  
  # Return as a list
  return(list("Dog" = factors$Dog, "Cat" = factors$Cat))
}

#' Calculate Pet-Related Carbon Emissions with Process Data
#'
#' This function computes pet-related carbon emissions and retains process calculation result data.
#'
#' @param df A data frame containing pet ownership data.
#' @return A data frame with a new column `PetEmissions` representing total pet-related emissions and additional process calculation results.
#' 
calc_pet_emissions_process <- function(df) {
  
  # Get country-specific pet emission factors
  emission_factors_pets <- get_pet_emission_factors(unique(df$SD_07_Country))
  
  # Convert pet ownership columns to numeric and handle missing values
  df <- df %>%
    mutate(
      PETS_4 = as.numeric(PETS_4),
      PETS_5 = as.numeric(PETS_5),
      PETS_4 = replace_na(PETS_4, 0),
      PETS_5 = replace_na(PETS_5, 0)
    )
  
  # Calculate pet emissions
  df <- df %>%
    mutate(
      PetEmissions_Cat = PETS_4 * emission_factors_pets$Cat,
      PetEmissions_Dog = PETS_5 * emission_factors_pets$Dog,
      PetEmissions = PetEmissions_Cat + PetEmissions_Dog
    )
  
  
  # Notify user and print results
  message("New column `PetEmissions` representing total pet-related emissions has been added to the dataset.")
  message("Process calculation result data have been added.")
  
  print(df$PetEmissions)
  
  return(df)
}

