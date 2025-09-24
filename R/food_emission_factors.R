
#' Food Emission Factors Dataset
#'
#' This dataset contains food-related emission factors based on country-specific data.
#'
#' @docType data
#' @name food_emission_factors
#' @usage data(food_emission_factors)
#' @keywords datasets
#' @format A data frame with columns:
#' \describe{
#'   \item{Country}{Country name}
#'   \item{FactorName}{Type of food emission factor (e.g., Dairy, Meat, Vegan, Vegetarian)}
#'   \item{Unit}{character}  # e.g., "kg CO2e / kg"
#'   \item{Value}{Emission value for the given factor}
#' }
'food_emission_factors'

