
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SECFC <img src="source-files/logo.png" align="right" height="139"/>

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

## Shiny APP

<div style="text-align: center; background-color: #f5f5f5; padding: 20px; border-radius: 8px; border: 1px solid #ddd; margin: 20px auto; max-width: 500px;">

<h2 style="color: #2C3E50; margin-bottom: 10px;">
Shiny App Available
</h2>
<p>
<a href="https://ziqianxia.shinyapps.io/secfc/" target="_blank" style="font-size: 18px; color: #4A6D8C; text-decoration: none; font-weight: bold;">
https://ziqianxia.shinyapps.io/secfc/ </a>
</p>

</div>

## Key Features

- Twelve core functions to estimate individual-level carbon footprint
  based on survey data.
- ️ Transparent processing: Choose between total emissions or detailed
  calculation steps.
- Designed with survey data structure in mind.
- Ideal for environmental psychology, behavioral science, and carbon
  impact studies.

<img src="https://github.com/jianing-d/SECFC/blob/main/source-files/flowchart.png?raw=true" align="right" />

## ️ Functions Overview

SECFC contains twelve main functions, divided into two groups:

### ➤ Simple Output Functions

These functions calculate total emissions by domain and append one new
column to the dataset: - `calc_cons_emissions()`: consumption-related
emissions - `calc_food_emissions()`: food-related emissions -
`calc_housing_emissions()`: housing-related emissions -
`calc_pet_emissions()`: pet-related emissions -
`calc_transport_emissions()`: transport-related emissions -
`calc_total_emissions()`: total emissions across all domains

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

## 📫 Contact

For questions, bug reports, or suggestions, please reach out to:

**Jianing Ding**

<jianing.research@gmail.com>

Tongji University

**Ziqian Xia**

<ziqianx@stanford.edu>

Stanford University

**Nathaniel Geiger**

<geigern@umich.edu>

University of Michigan
