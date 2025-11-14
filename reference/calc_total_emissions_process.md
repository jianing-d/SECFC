# Calculate Total Carbon Emissions with Process Data

This function computes total carbon emissions by aggregating
transportation, pet, housing (per capita), food, and consumption-based
emissions.

## Usage

``` r
calc_total_emissions_process(df)
```

## Arguments

- df:

  A data frame containing emissions data from various components.

## Value

A data frame with a new column `TotalEmissions` representing total
emissions and additional process calculation results.
