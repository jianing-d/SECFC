# Questionnaire Example Data

A small, realistic demo dataset with responses from a global
lifestyle/footprint questionnaire. It’s intended for testing the SECFC
calculator and mirrors typical variables you might collect:
transportation, energy, diet, clothing, and sociodemographics.

## Usage

``` r
questionnaire_example
```

## Format

A tibble with 50 rows and 36 variables:

- RecordedDate:

  chr; timestamp when the response was recorded, format "dd/mm/yyyy
  HH:MM".

- T_01_CarUsage:

  dbl; self-reported car use intensity or frequency (numeric scale).

- T_02_CarType:

  chr; car type category (e.g., "Hybrid Vehicle", "Diesel Vehicle").

- T_03_CarDistance:

  dbl; relative distance travelled by car (numeric scale).

- T_04_PublicTransport:

  dbl; public transport use (primary measure; numeric scale).

- T_05_PublicTransport:

  dbl; public transport use (secondary measure; numeric scale).

- T_06_AirTravelLong:

  dbl; long-haul air travel frequency/intensity (numeric scale).

- T_07_AirTravelShort:

  chr; short-haul air travel category (e.g., "4-6 flights").

- T_08_LongDistanceTra:

  dbl; other long-distance travel activity (numeric scale).

- PETS_4:

  dbl; pet-related count/score (e.g., number of pets).

- PETS_5:

  dbl; additional pet-related measure.

- `E1_Electricity Usage`:

  dbl; self-reported household electricity usage level (numeric scale).

- EH_02_ElectricityBil_1:

  dbl; monthly electricity bill (first/primary entry), in local currency
  units.

- EH_05_NaturalGasBill_1:

  dbl; monthly natural gas bill (first/primary entry), in local currency
  units.

- EH_07_WaterBill:

  dbl; monthly water bill, in local currency units.

- F_01_DietaryHabits_5:

  dbl; dietary habit indicator (numeric frequency/score).

- F_01_DietaryHabits_6:

  dbl; dietary habit indicator (numeric frequency/score).

- F_01_DietaryHabits_7:

  dbl; dietary habit indicator (numeric frequency/score).

- F_01_DietaryHabits_4:

  dbl; dietary habit indicator (numeric frequency/score).

- CL_01_ClothingPurcha:

  dbl; clothing purchase frequency/quantity (numeric scale).

- CL_03_MonthlyEx_9:

  dbl; clothing monthly expenditure (bucket 9), currency units.

- CL_03_MonthlyEx_10:

  dbl; clothing monthly expenditure (bucket 10), currency units.

- CL_03_MonthlyEx_11:

  dbl; clothing monthly expenditure (bucket 11), currency units.

- CL_03_MonthlyEx_12:

  dbl; clothing monthly expenditure (bucket 12), currency units.

- CL_03_MonthlyEx_13:

  dbl; clothing monthly expenditure (bucket 13), currency units.

- CL_03_MonthlyEx_14:

  dbl; clothing monthly expenditure (bucket 14), currency units.

- CL_03_MonthlyEx_15:

  dbl; clothing monthly expenditure (bucket 15), currency units.

- SD_06_HouseholdSize_17:

  dbl; household size component (e.g., adults).

- SD_06_HouseholdSize_18:

  dbl; household size component (e.g., teens).

- SD_06_HouseholdSize_19:

  dbl; household size component (e.g., children/others).

- SD_07_Country:

  chr; respondent country.

- SD_08_ZipCode:

  chr; postal/zip code (character; may include leading zeros or be
  missing).

- EH_03_ElectricityBil_1:

  dbl; derived/period electricity bill total (e.g., annualized),
  currency units.

- EH_06_NaturalGasBill_1:

  dbl; derived/period natural gas bill total (e.g., annualized),
  currency units.

- income:

  dbl; household or personal income (numeric, currency units).

- SD_09_AdminCode:

  chr; administrative code (e.g., province/prefecture code).

## Source

Demo data generated for use with the SECFC calculator; reflects typical
global survey responses.
