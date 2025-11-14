# China admin code → province, grid, and electricity price

Provincial/municipal administrative codes mapped to province name, grid
operator label, and residential electricity price (RMB per kWh, tax
included).

## Usage

``` r
cn_admin_data
```

## Format

A tibble/data frame with N rows and 4 variables:

- AdminCode:

  integer. GB/T admin code at provincial level.

- Province:

  character. Province/autonomous region/municipality name.

- GridName:

  character. Grid operator label used to select emission factors.

- ElecPrice_RMB_per_kWh:

  numeric. Electricity price (RMB/kWh, VAT included).

## Examples

``` r
head(cn_admin_data)
#> # A tibble: 6 × 4
#>   AdminCode Province     GridName           ElecPrice_RMB_per_kWh
#>       <dbl> <chr>        <chr>                              <dbl>
#> 1    110000 北京市       Electricity_北京                   0.488
#> 2    120000 天津市       Electricity_天津                   0.49 
#> 3    130000 河北省       Electricity_河北                   0.52 
#> 4    140000 山西省       Electricity_山西                   0.477
#> 5    150000 内蒙古自治区 Electricity_内蒙古                 0.415
#> 6    210000 辽宁省       Electricity_辽宁                   0.5  
```
