
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SECFC <img src="logo.png" align="right" height="139" />

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![Website](https://img.shields.io/badge/Website-Jianing_Ding-skyblue)](https://jianing-ding.netlify.app/)
[![Website](https://img.shields.io/badge/Website-Ziqian_Xia-red)](https://ziqian-xia.tech/)

<!-- badges: start -->
<!-- badges: end -->

SECFC (Survey-Embedded Carbon Footprint Calculator) is a transparent,
open-source R package designed to assist researchers in environmental
psychology with survey-based carbon footprint estimation.

It provides a modular structure that makes it easy to calculate and
analyze emissions from various domains such as consumption, food,
housing, transport, and pets.

SECFC is particularly suitable for academic studies requiring
reproducibility, transparency, and process-level emissions output.

## Key Features

- Twelve core functions to estimate individual-level carbon footprint
  based on survey data.
- ️ Transparent processing: Choose between total emissions or detailed
  calculation steps.
- Designed with survey data structure in mind.
- Ideal for environmental psychology, behavioral science, and carbon
  impact studies.

## ️ Functions Overview

SECFC contains twelve main functions, divided into two groups:

### ➤ Simple Output Functions

These functions calculate total emissions by domain and append one new
column to the dataset: - `calc_cons_emissions()` – consumption-related
emissions - `calc_food_emissions()` – food-related emissions -
`calc_housing_emissions()` – housing-related emissions -
`calc_pet_emissions()` – pet-related emissions -
`calc_transport_emissions()` – transport-related emissions -
`calc_total_emissions()` – total emissions across all domains

Each function: - Takes a data frame as input - Appends a new column with
calculated emissions - Returns the updated data frame and prints results

### ➤ Process-Level Functions

These functions provide detailed emissions breakdowns, appending
multiple columns with intermediate steps: -
`calc_cons_emissions_process()` - `calc_food_emissions_process()` -
`calc_housing_emissions_process()` - `calc_pet_emissions_process()` -
`calc_transport_emissions_process()` - `calc_total_emissions_process()`

Each function: - Adds multiple columns explaining the step-by-step
calculation - Enhances transparency for research and teaching purposes -
Also returns and prints the final emission result

## Getting Started

Install the package

``` r
# install.packages("remotes")
remotes::install_github("jianing-d/SECFC", subdir = "SECFC")
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
  ~EH_02_ElectricityBil_1, ~EH_03_ElectricityBil_1, ~EH_05_NaturalGasBill_1, ~EH_06_NaturalGasBill_1, ~PETS_4, ~PETS_5,
  ~SD_06_HouseholdSize_17, ~SD_06_HouseholdSize_18, ~SD_06_HouseholdSize_19, ~SD_07_Country, ~SD_08_ZipCode,
  
  "3/20/25 9:43", "3/20/25 9:47", "IP Address", "111.187.123.25", 100, 240, TRUE, "3/20/25 9:47", "R_3lENNCNKNsOdbgd",
  NA, NA, NA, NA, 31.2222, 121.4581, "anonymous", "EN", "Yes, I accept to proceed to the study",
  "7-12 times (About every 1-2 months)", 30, 250, 50, 0, 50, 100, 200, 7, 3, 4, 6, "5-6 days",
  "Gasoline Vehicle", "11-50 km or 6.2-31 miles", "Weekly", "5-10 km or 3.1-6.2 miles", "1-3 flights",
  "1-3 flights", "Monthly", 120, 1440, 50, 600, 1, 1, 2, 1, 0, "United States", 10001
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
cons <- calc_cons_emissions(data)
```

With process details:

``` r
cons_process <- calc_cons_emissions_process(data)
```

#### 🍽 Food Emissions ️

Calculate the carbon footprint from food consumption.

``` r
food <- calc_food_emissions(data)
```

With process details:

``` r
food_process <- calc_food_emissions_process(data)
```

#### 🏠 Housing Emissions

Calculate the carbon footprint from housing energy use.

``` r
housing <- calc_housing_emissions(data)
```

With process details:

``` r
housing_process <- calc_housing_emissions_process(data)
```

#### 🐶 Pet Emissions

Calculate the carbon footprint from pet ownership.

``` r
pet <- calc_pet_emissions(data)
```

With process details:

``` r
pet_process <- calc_pet_emissions_process(data)
```

#### 🚗 Transport Emissions

Calculate the carbon footprint from daily and long-distance
transportation.

``` r
transport <- calc_transport_emissions(data)
```

With process details:

``` r
transport_process <- calc_transport_emissions_process(data)
```

#### 🌍 Total Emissions

Calculate the total carbon footprint across all domains.

``` r
total <- calc_total_emissions(data)
```

With process details:

``` r
total_process <- calc_total_emissions_process(data)
```

### Example Usage

Here’s a simple example of how to use the **SECFC** package in practice:

``` r
# Step 1: Load the package
library(SECFC)

# Step 2: Load your dataset
# Example: use "questionnaire_sample.rds"
df <- readRDS("questionnaire_sample.rds")

# Step 3: Calculate carbon emissions by domain
cons <- calc_cons_emissions(df)       # Adds consumption emissions
food <- calc_food_emissions(df)       # Adds food emissions
housing <- calc_housing_emissions(df)    # Adds housing emissions
pet <- calc_pet_emissions(df)        # Adds pet emissions
transport <- calc_transport_emissions(df)  # Adds transport emissions

# Step 4: Calculate total carbon footprint
total <- calc_total_emissions(df)

# Optional: Use process-level functions to view detailed steps
cons_process <- calc_cons_emissions_process(df)
food_process <- calc_food_emissions_process(df)
housing_process <- calc_housing_emissions_process(df)
pet_process <- calc_pet_emissions_process(df)
transport_process <- calc_transport_emissions_process(df)
total_process <- calc_total_emissions_process(df)
```

### Survey Template

To ensure accurate carbon footprint calculations, your dataset should
follow the Qualtrics-compatible format we provide. Please do not change
variable names unless you update the function internals. Below is a list
of key columns expected by SECFC, along with their corresponding survey
question descriptions:

| Variable Name | Description |
|----|----|
| Q39 | Consent and agreement to participate |
| CL_01_ClothingPurcha | Frequency of clothing purchases |
| CL_03_MonthlyEx_9 | Monthly spending on food delivery (USD) |
| CL_03_MonthlyEx_10 | Monthly spending on dining out (USD) |
| CL_03_MonthlyEx_11 | Monthly spending on hotel stays (USD) |
| CL_03_MonthlyEx_12 | Monthly spending on tobacco (USD) |
| CL_03_MonthlyEx_13 | Monthly spending on alcohol and beverages (USD) |
| CL_03_MonthlyEx_14 | Monthly spending on entertainment (USD) |
| CL_03_MonthlyEx_15 | Monthly spending on healthcare (USD) |
| F_01_DietaryHabits_5 | Weekly frequency of meat-based meals (0–14) |
| F_01_DietaryHabits_6 | Weekly frequency of vegan meals (0–14) |
| F_01_DietaryHabits_7 | Weekly frequency of vegetarian meals (0–14) |
| F_01_DietaryHabits_4 | Weekly frequency of dairy meals (0–14) |
| T_01_CarUsage | Frequency of car use (e.g., “5-6 days”) |
| T_02_CarType | Type of car (e.g., Gasoline, EV) |
| T_03_CarDistance | Average car distance on driving days |
| T_04_PublicTransport | Frequency of public transport use |
| T_05_PublicTransport | Commute distance using public transport |
| T_06_AirTravelLong | Long-distance flights per year |
| T_07_AirTravelShort | Short-distance flights per year |
| T_08_LongDistanceTra | Frequency of long-distance transport use (rail, intercity bus) |
| EH_02_ElectricityBil_1 | Monthly electricity bill (USD) |
| EH_03_ElectricityBil_1 | Annual electricity bill (USD) |
| EH_05_NaturalGasBill_1 | Monthly natural gas bill (USD) |
| EH_06_NaturalGasBill_1 | Annual natural gas bill (USD) |
| PETS_4 | Number of cats owned |
| PETS_5 | Number of dogs owned |
| SD_06_HouseholdSize_17 | Number of adults in household |
| SD_06_HouseholdSize_18 | Number of children in household |
| SD_06_HouseholdSize_19 | Number of seniors in household |
| SD_07_Country | Country of residence |
| SD_08_ZipCode | U.S. Zip code (for regional analysis) |

✅ Note The following columns are automatically generated when you
export responses from Qualtrics: ~StartDate, ~EndDate, ~Status,
~IPAddress, ~Progress, ~`Duration (in seconds)`, ~Finished,
~RecordedDate, ~ResponseId,  
~RecipientLastName, ~RecipientFirstName, ~RecipientEmail,
~ExternalReference, ~LocationLatitude, ~LocationLongitude,  
~DistributionChannel, ~UserLanguage

## 📫 Contact

For questions, bug reports, or suggestions, please reach out to:

**Jianing Ding**

<jianing.research@gmail.com>

Tongji University

school
