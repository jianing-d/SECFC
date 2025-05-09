% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_transport_emissions_process.R
\name{calc_transport_emissions_process}
\alias{calc_transport_emissions_process}
\title{Calculate Transport-Related Carbon Emissions with Process Data}
\usage{
calc_transport_emissions_process(df)
}
\arguments{
\item{df}{A data frame containing transportation-related survey data.}
}
\value{
A data frame with a new column \code{TransportEmissions} representing total
transport emissions and additional process-calculation columns.
}
\description{
Computes transport-related carbon emissions and retains intermediate calculations.
}
