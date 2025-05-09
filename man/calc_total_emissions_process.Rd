% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_total_emissions_process.R
\name{calc_total_emissions_process}
\alias{calc_total_emissions_process}
\title{Calculate Total Carbon Emissions with Process Data}
\usage{
calc_total_emissions_process(df)
}
\arguments{
\item{df}{A data frame containing emissions data from various components.}
}
\value{
A data frame with a new column \code{TotalEmissions} representing total emissions and additional process calculation results.
}
\description{
This function computes total carbon emissions by aggregating transportation, pet, housing (per capita), food, and consumption-based emissions.
}
