# Calculate Food-Related Carbon Emissions with Process Data

This function computes food-based emissions and retains process
calculation result data.

## Usage

``` r
calc_food_emissions_process(
  df,
  milk_price_rmb_per_l = 10,
  serving_volume_l = 0.5
)
```

## Arguments

- df:

  A data frame containing the food consumption data.

- milk_price_rmb_per_l:

  numeric. Milk price per litre (RMB).

- serving_volume_l:

  numeric. Serving volume in litres.

## Value

A data frame with a new column `FoodEmissions` representing total
food-related emissions and additional process calculation results.
