#' China admin code → province, grid, and electricity price
#'
#' Provincial/municipal administrative codes mapped to province name, grid operator label,
#' and residential electricity price (RMB per kWh, tax included).
#'
#' @format A tibble/data frame with N rows and 4 variables:
#' \describe{
#'   \item{AdminCode}{integer. GB/T admin code at provincial level.}
#'   \item{Province}{character. Province/autonomous region/municipality name.}
#'   \item{GridName}{character. Grid operator label used to select emission factors.}
#'   \item{ElecPrice_RMB_per_kWh}{numeric. Electricity price (RMB/kWh, VAT included).}
#' }
#' @examples
#' head(cn_admin_data)
"cn_admin_data"
