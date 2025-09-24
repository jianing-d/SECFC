
#' Get country-specific pet emission factors
#'
#' Returns a list of pet emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @param country A character string representing the country.
#' @return A list of pet emission factors.
get_pet_emission_factors <- function(country) {
  
  # Ensure dataset exists
  if (!exists("pet_emission_factors")) stop("Error: pet_emission_factors dataset not found.")
  # tolerate vectors: pick first non-NA value
  if (length(country) > 1) {
    country <- country[!is.na(country)]
    country <- if (length(country)) country[[1]] else NA_character_
  }
  # normalize a few variants to "China"
  norm <- function(x) {
    x <- trimws(x)
    if (is.na(x)) return(x)
    x <- gsub("^PRC$|^CN$|^China \\(Mainland\\)$|^Mainland China$", "China", x, ignore.case = TRUE)
    x
  }
  country <- norm(country)
  
  # Filter dataset for the given country
  factors <- pet_emission_factors %>% filter(Country == country)
  
  # fallback to "Other" if no exact match
  if (nrow(factors) == 0) {
    factors <- pet_emission_factors %>% filter(Country == "Other")
    if (nrow(factors) == 0) return(list(Dog = NA_real_, Cat = NA_real_))
  }
  list(
    Dog = as.numeric(factors$Dog[[1]]),
    Cat = as.numeric(factors$Cat[[1]])
  )
}

#' Calculate Pet-Related Carbon Emissions with Process Data
#'
#' This function computes pet-related carbon emissions and retains process calculation result data.
#'
#' @param df A data frame containing pet ownership data.
#' @return A data frame with a new column `PetEmissions` representing total pet-related emissions and additional process calculation results.
#' @export
calc_pet_emissions_process <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_pet_process")
  
  # Get country-specific pet emission factors
  emission_factors_pets <- get_pet_emission_factors(unique(df$SD_07_Country))
  
  # Convert pet ownership columns to numeric and handle missing values
  df_pet_process <- df %>%
    mutate(
      PETS_4 = as.numeric(PETS_4),
      PETS_5 = as.numeric(PETS_5),
      PETS_4 = replace_na(PETS_4, 0),
      PETS_5 = replace_na(PETS_5, 0)
    )
  
  # Calculate pet emissions
  df_pet_process <- df_pet_process %>%
    mutate(
      PetEmissions_Cat = PETS_4 * emission_factors_pets$Cat,
      PetEmissions_Dog = PETS_5 * emission_factors_pets$Dog,
      PetEmissions = PetEmissions_Cat + PetEmissions_Dog
    )
  
  
  # assign new df_pet_process to the user's workspace
  assign(new_name, df_pet_process, envir = parent.frame())
  message(
    paste0(
      "\u2705 A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  return(df_pet_process)
}

