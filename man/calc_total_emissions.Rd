% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_total_emissions.R
\name{calc_total_emissions}
\alias{calc_total_emissions}
\title{Calculate Total Emissions}
\usage{
calc_total_emissions(df)
}
\arguments{
\item{df}{A data frame containing emissions data from various components.}
}
\value{
A data frame with a new column \code{TotalEmissions} representing the aggregated total emissions.
}
\description{
This function computes total carbon emissions by aggregating transportation, pet, housing (per capita), food, and consumption-based emissions.
}
