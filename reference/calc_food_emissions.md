# Calculate Food-Based Emissions using internal dataset

This function computes food-based emissions by converting food intake
data into estimated carbon emissions.

## Usage

``` r
calc_food_emissions(df, milk_price_rmb_per_l = 10, serving_volume_l = 0.5)
```

## Arguments

- df:

  A data frame containing the food consumption data.

- milk_price_rmb_per_l:

  numeric. Milk price per litre (RMB).

- serving_volume_l:

  numeric. Serving volume in litres.

## Value

A data frame with a new column `FoodEmissions` representing total food
emissions.
