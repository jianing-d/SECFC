
# Create a built-in dataset for emission factors
cons_emission_factors <- tibble::tibble(
  Country = c("United States", "United States", "United States", "United States", "United States", 
              "United States", "United States", "United States", "United States",
              "China", "China", "China", "China", "China", "China", "China", "China", "China",
              "European Union", "European Union", "European Union", "European Union", 
              "European Union", "European Union", "European Union", "European Union", "European Union"),
  FactorName = c("FoodDelivery", "DiningOut", "HotelStays", "TobaccoProducts", 
                 "AlcoholDrinks", "Entertainment", "Healthcare", "Clothing",
                 "Other",
                 "FoodDelivery", "DiningOut", "HotelStays", "TobaccoProducts", 
                 "AlcoholDrinks", "Entertainment", "Healthcare", "Clothing",
                 "Other",
                 "FoodDelivery", "DiningOut", "HotelStays", "TobaccoProducts", 
                 "AlcoholDrinks", "Entertainment", "Healthcare", "Clothing",
                 "Other"),
  Value = c(
    # United States (your existing numbers)
    0.349757961, 0.198559285, 0.16119859, 0.14516377, 
    0.450885975, 0.150237261, 0.066070988, 0.15783379, NA, 
    # China (FILLED from your table; units: kgCO2e per RMB of spend)
    0.116295,      # FoodDelivery - 2020 CEEIO (courier 60%, platform 30%, post 10%)
    0.075204156,   # DiningOut     - Eating and drinking places
    0.258339174,   # HotelStays    - Hotels
    0.10581416,    # TobaccoProducts - Tobacco products
    0.320292349,   # AlcoholDrinks - Wines, spirits and liquors
    0.539357798,   # Entertainment  - Avg: Culture & arts, Sports, Recreational services
    0.055779549,   # Healthcare     - Health services
    0.14930049,    # Clothing       - Wearing apparel
    NA,
    # European Union (placeholders; still NA)
    NA, NA, NA, NA, NA, NA, NA, NA, NA)
)

# Save as an R dataset
usethis::use_data(cons_emission_factors, overwrite = TRUE)



#' Get country-specific emission factors from the built-in dataset
#'
#' Fetches consumption emission factors from the dataset stored in the package.
#'
#' @importFrom dplyr filter mutate select case_when rowwise ungroup pull across left_join all_of
#' @importFrom tidyr replace_na pivot_wider
#' @importFrom stats setNames
#' @importFrom magrittr "%>%"
#' @importFrom purrr map map_df
#' @importFrom tibble tibble
#' @importFrom rlang .data
#' @param country A character string representing the country.
#' @return A named list of consumption emission factors.
get_cons_emission_factors <- function(country) {
  # Be robust to vectors; pick the first non-NA unique value
  if (length(country) > 1) {
    country <- country[!is.na(country)]
    country <- if (length(country)) country[[1]] else NA_character_
  }
  # Filter the dataset for the given country
  factors <- cons_emission_factors %>%
    filter(Country == country) %>%
    select(FactorName, Value)
  
  # Convert the dataset into a named list
  if (nrow(factors) > 0) {
    emission_list <- setNames(factors$Value, factors$FactorName)
  } else {
    # Return NA for all factors if the country is not found
    emission_list <- list(
      "FoodDelivery" = NA,  
      "DiningOut" = NA,  
      "HotelStays" = NA,  
      "TobaccoProducts" = NA,  
      "AlcoholDrinks" = NA,  
      "Entertainment" = NA,  
      "Healthcare" = NA,  
      "Clothing" = NA  
    )
  }
  
  return(emission_list)
}

#' Calculate Consumption-Based Emissions using internal dataset
#'
#' This function computes consumption-based emissions by converting expenditure data into estimated carbon emissions.
#'
#' @param df A data frame containing the consumption data.
#' @return A data frame with a new column `ConsEmissions` representing total consumption emissions.
#' @export
calc_cons_emissions <- function(df) {
  original_name <- deparse(substitute(df))
  new_name      <- paste0(original_name, "_cons")
  # Get country-specific emission factors from the dataset
  emission_factors_cons <- get_cons_emission_factors(unique(df$SD_07_Country))
  
  # Quick guardrail: warn if any required factor is NA
  needed_keys <- c("FoodDelivery","DiningOut","HotelStays","TobaccoProducts",
                   "AlcoholDrinks","Entertainment","Healthcare","Clothing")
  if (any(is.na(unlist(emission_factors_cons[needed_keys])))) {
    warning("Some consumption emission factors are NA for country = ",
            paste(unique(df$SD_07_Country), collapse = ", "),
            ". Check 'cons_emission_factors'.")
  }
  
  # Ensure expenditure columns are numeric
  df_cons <- df %>%
    mutate(
      CL_03_MonthlyEx_9 = as.numeric(CL_03_MonthlyEx_9),
      CL_03_MonthlyEx_10 = as.numeric(CL_03_MonthlyEx_10),
      CL_03_MonthlyEx_11 = as.numeric(CL_03_MonthlyEx_11),
      CL_03_MonthlyEx_12 = as.numeric(CL_03_MonthlyEx_12),
      CL_03_MonthlyEx_13 = as.numeric(CL_03_MonthlyEx_13),
      CL_03_MonthlyEx_14 = as.numeric(CL_03_MonthlyEx_14),
      CL_03_MonthlyEx_15 = as.numeric(CL_03_MonthlyEx_15)
    )
  
  # Assign estimated clothing spending based on categorical responses
  clothing_spending_map <- c(
    "More than 12 times (At least once a month)" = 600,
    "7-12 times (About every 1-2 months)" = 420,
    "4-6 times (About every 2-3 months)" = 300,
    "1-3 times (Less than every 3 months)" = 120,
    "Rarely" = 60
  )
  
  df_cons <- df_cons %>%
    mutate(
      annual_clothing_spending = clothing_spending_map[as.character(CL_01_ClothingPurcha)],
      annual_clothing_spending = ifelse(is.na(annual_clothing_spending), 0, annual_clothing_spending),
      
      ClothingEm = annual_clothing_spending * emission_factors_cons[["Clothing"]]
    )
  
  # Calculate annual emissions for each category
  df_cons <- df_cons %>%
    mutate(
      FoodDeliveryEm = CL_03_MonthlyEx_9 * 12 * emission_factors_cons[["FoodDelivery"]],
      DiningOutEm = CL_03_MonthlyEx_10 * 12 * emission_factors_cons[["DiningOut"]],
      HotelStaysEm = CL_03_MonthlyEx_11 * 12 * emission_factors_cons[["HotelStays"]],
      TobaccoEm = CL_03_MonthlyEx_12 * 12 * emission_factors_cons[["TobaccoProducts"]],
      AlcoholEm = CL_03_MonthlyEx_13 * 12 * emission_factors_cons[["AlcoholDrinks"]],
      EntertainmentEm = CL_03_MonthlyEx_14 * 12 * emission_factors_cons[["Entertainment"]],
      HealthcareEm = CL_03_MonthlyEx_15 * 12 * emission_factors_cons[["Healthcare"]]
    )
  
  # Compute total consumption emissions
  df_cons <- df_cons %>%
    mutate(
      ConsEmissions = rowSums(cbind(
        FoodDeliveryEm, DiningOutEm, HotelStaysEm,
        TobaccoEm, AlcoholEm, EntertainmentEm,
        HealthcareEm, ClothingEm
      ), na.rm = TRUE)
    )
  
  df_cons <- df_cons %>% 
    mutate(
      annual_clothing_spending = as.numeric(annual_clothing_spending),
      ClothingEm = as.numeric(ClothingEm),
      ConsEmissions = as.numeric(ConsEmissions)
    )
  
  df_cons <- df_cons %>% 
    select(-annual_clothing_spending,-ClothingEm,-FoodDeliveryEm,-DiningOutEm,-HotelStaysEm,-TobaccoEm,-AlcoholEm,-EntertainmentEm,-HealthcareEm)
  
  
  # assign new df_cons to the user's workspace
  assign(new_name, df_cons, envir = parent.frame())
  message(
    paste0(
      "\u2705 A new data frame '", new_name,
      "' is now available in your R environment."
    )
  )
  
  
  return(df_cons)
}


