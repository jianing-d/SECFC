
# Create the built-in dataset for pet emission factors
pet_emission_factors <- tibble::tibble(
  Country = c("United States", "China", "European Union", "Other"),
  Dog = c(770, 770, NA, NA),  # kg CO2 per dog per year
  Cat = c(335, 335, NA, NA)   # kg CO2 per cat per year
)

# Save as internal data 
if (interactive()) {
usethis::use_data(pet_emission_factors, overwrite = TRUE)
}
  
#' Get country-specific pet emission factors
#'
#' Returns a list of pet emission factors based on the country.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na pivot_wider
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
  
  # If no match, return NA values
  if (nrow(factors) == 0) {
    factors <- pet_emission_factors %>% filter(Country == "Other")
    if (nrow(factors) == 0) return(list(Dog = NA_real_, Cat = NA_real_))
  }
  list(
    Dog = as.numeric(factors$Dog[[1]]),
    Cat = as.numeric(factors$Cat[[1]])
  )
}

#' Calculate Pet Emissions
#'
#' This function computes pet-related emissions based on the number of cats and dogs owned.
#'
#' @param df A data frame containing pet ownership data.
#' @return A data frame with a new column `PetEmissions` representing total pet emissions.
#' @export
calc_pet_emissions <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_pet")
  # Get country-specific pet emission factors
  emission_factors_pets <- get_pet_emission_factors(unique(df$SD_07_Country))
  
  # Convert pet ownership columns to numeric and handle missing values
  df_pet <- df %>%
    mutate(
      PETS_4 = as.numeric(PETS_4),
      PETS_5 = as.numeric(PETS_5),
      PETS_4 = replace_na(PETS_4, 0),
      PETS_5 = replace_na(PETS_5, 0)
    )
  
  # Calculate pet emissions
  df_pet <- df_pet %>%
    mutate(
      PetEmissions_Cat = PETS_4 * emission_factors_pets$Cat,
      PetEmissions_Dog = PETS_5 * emission_factors_pets$Dog,
      PetEmissions = PetEmissions_Cat + PetEmissions_Dog
    )
  
  df_pet <- df_pet %>% 
    select(-PetEmissions_Cat,-PetEmissions_Dog)
  
  # assign new df_pet to the user's workspace
  assign(new_name, df_pet, envir = parent.frame())
  message(
    paste0(
      "\u2705 A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  return(df_pet)
}


