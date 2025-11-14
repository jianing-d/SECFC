# Calculate Total Emissions

This function computes total carbon emissions by aggregating
transportation, pet, housing (per capita), food, and consumption-based
emissions.

## Usage

``` r
calc_total_emissions(df)
```

## Arguments

- df:

  A data frame containing emissions data from various components.

## Value

A data frame with a new column `TotalEmissions` representing the
aggregated total emissions.
