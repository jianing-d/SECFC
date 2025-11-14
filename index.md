# SECFC

![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)[![Website](https://img.shields.io/badge/Website-Jianing_Ding-skyblue)](https://jianing-ding.netlify.app/)
[![Website](https://img.shields.io/badge/Website-Ziqian_Xia-red)](https://ziqian-xia.tech/)

SECFC (Survey-Embedded Carbon Footprint Calculator) is a transparent,
open-source R package designed to assist researchers in environmental
psychology with survey-based carbon footprint estimation.

It provides a modular structure that makes it easy to calculate and
analyze emissions from various domains such as consumption, food,
housing, transport, and pets.

SECFC is particularly suitable for academic studies requiring
reproducibility, transparency, and process-level emissions output.

![](https://github.com/jianing-d/SECFC/blob/main/source-files/image0503.png?raw=true)

## Shiny APP

## Shiny App Available

[https://ziqianxia.shinyapps.io/secfc/](https://ziqianxia.shinyapps.io/secfc/)

## Key Features

- Twelve core functions to estimate individual-level carbon footprint
  based on survey data.
- ️ Transparent processing: Choose between total emissions or detailed
  calculation steps.
- Designed with survey data structure in mind.
- Ideal for environmental psychology, behavioral science, and carbon
  impact studies.

![](https://github.com/jianing-d/SECFC/blob/main/source-files/flowchart.png?raw=true)

## ️ Functions Overview

SECFC contains twelve main functions, divided into two groups:

### ➤ Simple Output Functions

These functions calculate total emissions by domain and produce a new
data frame in your R environment named by appending a suffix to the
input object’s name:

- [`calc_cons_emissions()`](reference/calc_cons_emissions.md):
  consumption-related emissions
- [`calc_food_emissions()`](reference/calc_food_emissions.md):
  food-related emissions
- [`calc_housing_emissions()`](reference/calc_housing_emissions.md):
  housing-related emissions
- [`calc_pet_emissions()`](reference/calc_pet_emissions.md): pet-related
  emissions
- [`calc_transport_emissions()`](reference/calc_transport_emissions.md):
  transport-related emissions
- [`calc_total_emissions()`](reference/calc_total_emissions.md): total
  emissions across all domains

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

- [`calc_cons_emissions_process()`](reference/calc_cons_emissions_process.md)
- [`calc_food_emissions_process()`](reference/calc_food_emissions_process.md)
- [`calc_housing_emissions_process()`](reference/calc_housing_emissions_process.md)
- [`calc_pet_emissions_process()`](reference/calc_pet_emissions_process.md)
- [`calc_transport_emissions_process()`](reference/calc_transport_emissions_process.md)
- [`calc_total_emissions_process()`](reference/calc_total_emissions_process.md)

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

**Jianing Ding**  
<jianing.research@gmail.com>  
Tongji University  
  

**Ka Leung Lam**  
<kaleung.lam@dukekunshan.edu.cn>  
Duke Kunshan University  
  

**Nathaniel Geiger**  
<geigern@umich.edu>  
University of Michigan

**Ziqian Xia**  
<ziqianx@stanford.edu>  
Stanford University  
  

**Jinliang Xie**  
<jinliang.research@gmail.com>  
Tsinghua University
