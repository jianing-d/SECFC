
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

<img
  src="https://github.com/jianing-d/SECFC/blob/main/source-files/image0503.png?raw=true"
  style="display: block; margin: 0 auto; width: 50%; height: auto;"
/>

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

These functions calculate total emissions by domain and produce a new
data frame in your R environment named by appending a suffix to the
input object’s name:

- `calc_cons_emissions()`: consumption-related emissions
- `calc_food_emissions()`: food-related emissions
- `calc_housing_emissions()`: housing-related emissions
- `calc_pet_emissions()`: pet-related emissions
- `calc_transport_emissions()`: transport-related emissions
- `calc_total_emissions()`: total emissions across all domains

Each function:

1.  Accepts a data frame (e.g. data) as input.
2.  Computes the specified emissions.
3.  Assigns the result to a new object in your workspace
    (e.g. data_cons, data_food, etc.).
4.  Prints a confirmation message, for example: When you call the
    function calc_cons_emissions(data), it will print: ✅ A new data
    frame ‘data_cons’ is now available in your R environment.

### ➤ Process-Level Functions

These functions provide detailed emissions breakdowns, producing a new
data frame in your R environment by appending a suffix to the input
name:

- `calc_cons_emissions_process()`
- `calc_food_emissions_process()`
- `calc_housing_emissions_process()`
- `calc_pet_emissions_process()`
- `calc_transport_emissions_process()`
- `calc_total_emissions_process()`

Each function:

1.  Takes a data frame as input.
2.  Appends multiple columns showing intermediate calculation steps.
3.  Returns the detailed data frame.
4.  Prints a confirmation message.

### Example Usage

Here’s a simple example of how to use the **SECFC** package in practice:

``` r
# Step 1: Load the package
library(SECFC)

# Step 2: Load your dataset
# Example: use "questionnaire_sample.rds"
df <- readRDS("questionnaire_sample.rds")

# Step 3: Calculate carbon emissions by domain
calc_cons_emissions(df)       # Calculates consumption emissions
calc_food_emissions(df)       # Calculates food emissions
calc_housing_emissions(df)    # Calculates housing emissions
calc_pet_emissions(df)        # Calculates pet emissions
calc_transport_emissions(df)  # Calculates transport emissions

# Step 4: Calculate total carbon footprint
calc_total_emissions(df)

# Optional: Use process-level functions to view detailed steps
calc_cons_emissions_process(df)
calc_food_emissions_process(df)
calc_housing_emissions_process(df)
calc_pet_emissions_process(df)
calc_transport_emissions_process(df)
calc_total_emissions_process(df)
```

## 📫 Contact

For questions, bug reports, or suggestions, please reach out to:

<div style="display: flex; justify-content: space-between;">

<div style="flex: 1; padding-right: 15px;">

**Jianing Ding**<br> <jianing.research@gmail.com><br> Tongji
University<br><br>

**Ka Leung Lam**<br> <kaleung.lam@dukekunshan.edu.cn><br> Duke Kunshan
University<br><br>

**Nathaniel Geiger**<br> <geigern@umich.edu><br> University of Michigan

</div>

<div style="flex: 1; padding-left: 15px;">

**Ziqian Xia**<br> <ziqianx@stanford.edu><br> Stanford
University<br><br>

**Jinliang Xie**<br> <jinliang.research@gmail.com><br> Tsinghua
University

</div>

</div>
