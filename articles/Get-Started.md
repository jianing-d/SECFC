# Get Started

## Getting Started

Install the package

``` r
#install.packages("remotes")
remotes::install_github("jianing-d/SECFC")
```

## How to Use SECFC

Follow these steps to calculate survey-based carbon footprints using
SECFC.

### Step 1: Load the Package

After installation, load the package with:

``` r
library(SECFC)
```

### Step 2: Import Your Survey Dataset

Make sure your dataset is in a data frame or tibble format. If you’re
using the Qualtrics template we provided, ensure that variable names
match exactly. Here is an example of the expected data structure:

``` r
library(tibble)

data <- tribble(
  ~StartDate, ~EndDate, ~Status, ~IPAddress, ~Progress, ~`Duration (in seconds)`, ~Finished, ~RecordedDate, ~ResponseId,
  ~RecipientLastName, ~RecipientFirstName, ~RecipientEmail, ~ExternalReference, ~LocationLatitude, ~LocationLongitude,
  ~DistributionChannel, ~UserLanguage, ~Q39, ~CL_01_ClothingPurcha, ~CL_03_MonthlyEx_9, ~CL_03_MonthlyEx_10, ~CL_03_MonthlyEx_11,
  ~CL_03_MonthlyEx_12, ~CL_03_MonthlyEx_13, ~CL_03_MonthlyEx_14, ~CL_03_MonthlyEx_15, ~F_01_DietaryHabits_5,
  ~F_01_DietaryHabits_6, ~F_01_DietaryHabits_7, ~F_01_DietaryHabits_4, ~T_01_CarUsage, ~T_02_CarType, ~T_03_CarDistance,
  ~T_04_PublicTransport, ~T_05_PublicTransport, ~T_06_AirTravelLong, ~T_07_AirTravelShort, ~T_08_LongDistanceTra,
  ~EH_02_ElectricityBil_1, ~EH_03_ElectricityBil_1, ~EH_05_NaturalGasBill_1, ~EH_06_NaturalGasBill_1, ~EH_07_WaterBill, ~PETS_4, ~PETS_5,
  ~SD_06_HouseholdSize_17, ~SD_06_HouseholdSize_18, ~SD_06_HouseholdSize_19, ~SD_07_Country, ~SD_08_ZipCode, ~SD_09_AdminCode,
  
  "3/20/25 9:43", "3/20/25 9:47", "IP Address", "111.187.123.25", 100, 240, TRUE, "3/20/25 9:47", "R_3lENNCNKNsOdbgd",
  NA, NA, NA, NA, 31.2222, 121.4581, "anonymous", "EN", "Yes, I accept to proceed to the study",
  "7-12 times (About every 1-2 months)", 30, 250, 50, 0, 50, 100, 200, 7, 3, 4, 6, "5-6 days",
  "Gasoline Vehicle", "11-50 km or 6.2-31 miles", "Weekly", "5-10 km or 3.1-6.2 miles", "1-3 flights",
  "1-3 flights", "Monthly", 120, 1440, 50, 600, 150, 1, 1, 2, 1, 0, "United States", 10001, NA
)
```

✅ Note The following columns are automatically generated when you
export responses from Qualtrics: ~StartDate, ~EndDate, ~Status,
~IPAddress, ~Progress, ~`Duration (in seconds)`, ~Finished,
~RecordedDate, ~ResponseId,  
~RecipientLastName, ~RecipientFirstName, ~RecipientEmail,
~ExternalReference, ~LocationLatitude, ~LocationLongitude,  
~DistributionChannel, ~UserLanguage

### Step 3: Run Emission Calculations

Now you’re ready to calculate emissions. Choose the functions depending
on whether you want only the calculation results or also the process
data.

#### 🛒Consumption Emissions

Calculate the carbon footprint from general consumption.

``` r
calc_cons_emissions(data)
#> ✅ A new data frame 'data_cons' is now available in your R environment.
#> # A tibble: 1 × 52
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 45 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_cons_emissions_process(data)
#> ✅ A new data frame 'data_cons_process' is now available in your R environment.
#> # A tibble: 1 × 61
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 54 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

#### 🍽 Food Emissions ️

Calculate the carbon footprint from food consumption.

``` r
calc_food_emissions(data)
#> ✅ A new data frame 'data_food' is now available in your R environment.
#> # A tibble: 1 × 52
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 45 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_food_emissions_process(data)
#> ✅ A new data frame 'data_food_process' is now available in your R environment.
#> # A tibble: 1 × 56
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 49 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

#### 🏠 Housing Emissions

Calculate the carbon footprint from housing energy use.

``` r
calc_housing_emissions(data)
#> ✅ A new data frame 'data_housing' is now available in your R environment.
#> # A tibble: 1 × 55
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 48 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_housing_emissions_process(data)
#> ✅ A new data frame 'data_housing_process' is now available in your R environment.
#> # A tibble: 1 × 71
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 64 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

#### 🐶 Pet Emissions

Calculate the carbon footprint from pet ownership.

``` r
calc_pet_emissions(data)
#> ✅ A new data frame 'data_pet' is now available in your R environment.
#> # A tibble: 1 × 52
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 45 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_pet_emissions_process(data)
#> ✅ A new data frame 'data_pet_process' is now available in your R environment.
#> # A tibble: 1 × 54
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 47 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

#### 🚗 Transport Emissions

Calculate the carbon footprint from daily and long-distance
transportation.

``` r
calc_transport_emissions(data)
#> ✅ A new data frame 'data_transport' is now available in your R environment.
#> # A tibble: 1 × 52
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 45 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_transport_emissions_process(data)
#> ✅ A new data frame 'data_transport_process' is now available in your R environment.
#> # A tibble: 1 × 62
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 55 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

#### 🌍 Total Emissions

Calculate the total carbon footprint across all domains.

``` r
calc_total_emissions(data)
#> ✅ A new data frame 'data_total' is now available in your R environment.
#> # A tibble: 1 × 60
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 53 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

With process details:

``` r
calc_total_emissions_process(data)
#> ✅ A new data frame 'data_total_process' is now available in your R environment.
#> # A tibble: 1 × 101
#>   StartDate    EndDate Status IPAddress Progress Duration (in seconds…¹ Finished
#>   <chr>        <chr>   <chr>  <chr>        <dbl>                  <dbl> <lgl>   
#> 1 3/20/25 9:43 3/20/2… IP Ad… 111.187.…      100                    240 TRUE    
#> # ℹ abbreviated name: ¹​`Duration (in seconds)`
#> # ℹ 94 more variables: RecordedDate <chr>, ResponseId <chr>,
#> #   RecipientLastName <lgl>, RecipientFirstName <lgl>, RecipientEmail <lgl>,
#> #   ExternalReference <lgl>, LocationLatitude <dbl>, LocationLongitude <dbl>,
#> #   DistributionChannel <chr>, UserLanguage <chr>, Q39 <chr>,
#> #   CL_01_ClothingPurcha <chr>, CL_03_MonthlyEx_9 <dbl>,
#> #   CL_03_MonthlyEx_10 <dbl>, CL_03_MonthlyEx_11 <dbl>, …
```

✅ Note The following columns are automatically generated when you
export responses from Qualtrics: ~StartDate, ~EndDate, ~Status,
~IPAddress, ~Progress, ~`Duration (in seconds)`, ~Finished,
~RecordedDate, ~ResponseId,  
~RecipientLastName, ~RecipientFirstName, ~RecipientEmail,
~ExternalReference, ~LocationLatitude, ~LocationLongitude,  
~DistributionChannel, ~UserLanguage
