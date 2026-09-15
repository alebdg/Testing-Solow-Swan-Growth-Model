# Econometrics Group Project — Testing the Solow-Swan Growth Model

This project tests the **Solow-Swan economic growth model** using cross-country data from the World Bank, comparing its explanatory power for **OECD countries** and **developing countries**.

## Project Overview

The analysis investigates how two core variables from the Solow-Swan framework:

- **Domestic savings**
- **Population growth**

are associated with **GDP per capita**.

The model is first estimated separately for OECD and developing countries. The analysis is then extended by adding **net migration** as an additional explanatory variable to evaluate whether migration improves the model's ability to explain differences in GDP per capita.

## Data

All data were collected from the **World Bank Open Data** platform and cover the period **1961–2022**.

Main variables:

- **GDP per capita (constant 2015 US$)** — dependent variable
- **Gross domestic savings (% of GDP)**
- **Population growth (annual %)**
- **Net migration**

To improve data quality, aggregate country groups were removed and countries were divided into OECD and developing-country samples. A restricted subset of developing countries with complete observations over the full period was also created.

## Methodology

The project uses **Ordinary Least Squares (OLS)** regressions.

Variables were transformed into logarithms, allowing the estimated coefficients to be interpreted approximately as **elasticities**.

The analysis was carried out in three stages:

1. Estimate the Solow-Swan model for OECD countries.
2. Estimate the same model for developing countries, including a restricted sample with more complete data.
3. Extend the best-performing developing-country specification by adding **net migration**.

Model diagnostics included:

- **Ramsey RESET test** — functional-form specification
- **Breusch-Pagan test** — heteroskedasticity
- **Durbin-Watson test** — serial correlation
- **Jarque-Bera test** — normality of residuals

## Main Results

The baseline Solow-Swan model performs relatively poorly for OECD countries, with an R² of around **0.21**.

The model performs substantially better for developing countries. For the restricted developing-country sample, the R² exceeds **0.90**.

In that specification:

- A **1% increase in savings** is associated with approximately a **0.6% increase in GDP per capita**.
- A **1% increase in population growth** is associated with approximately a **1.12% decrease in GDP per capita**.

Adding **net migration** further improves the model:

- R² increases to approximately **0.93**
- Adjusted R² also increases
- Net migration shows a positive relationship with GDP per capita

The graphical comparison between actual and predicted GDP per capita also suggests that the migration-extended specification improves the fit, particularly for observations between roughly 1970 and 1990.

## Key Takeaway

The results suggest that the Solow-Swan model explains GDP per capita much better for developing countries than for OECD economies in this dataset. Extending the model with migration provides additional explanatory power and highlights the potential role of labor mobility in economic development.

## Authors

- Pietro Cartapani
- Alessandro Pagan
- Francesco Lamesso
