# Project realized by:
# Pietro Cartapani - 3222871
# Alessandro Pagan - 3195343
# Francesco Lamesso - 3217965


# The following libraries are included:
# data.table - for the fast and easy aggregation of large data;
# readxl - to import excel files into R and treat them as normal R databases;
# stargazer - to create visually pleasant regression tables;
# lmtest - to run diagnostic checking in linear regression models;
# tseries - to run time series analysis.

library(data.table)
library(readxl)
library(stargazer)
library(lmtest)
library(tseries)
library(ggplot2)

# Selection of the appropriate file for the variable GDP_per_capita and
# transformation of the variables into an R-readable format

file_path_gdp <- file.choose()
GDP_per_capita <- read_excel(file_path_gdp)

# Repetition of the same process as above for the following variables:
# - pop_growth
# - saving_rate
# - net_migration

file_path_pop <- file.choose()
pop_growth <- read_excel(file_path_pop)

file_path_s <- file.choose()
saving_rate <- read_excel(file_path_s)

file_path_m <- file.choose()
net_migration <- read_excel(file_path_m)

# Transformation of the data into the data.table format

setDT(GDP_per_capita)
setDT(saving_rate)
setDT(pop_growth)
setDT(net_migration)

# Conversion from wide to long format using the command melt()

melted_savings <-
  melt(
    saving_rate,
    id.vars = c(
      "Country Name",
      "Country Code",
      "Indicator Name",
      "Indicator Code"
    ),
    variable.name = "Year",
    value.name = "Saving"
  )

melted_growth <-
  melt(
    pop_growth,
    id.vars = c(
      "Country Name",
      "Country Code",
      "Indicator Name",
      "Indicator Code"
    ),
    variable.name = "Year",
    value.name = "Growth"
  )

melted_GDPpc <-
  melt(
    GDP_per_capita,
    id.vars = c(
      "Country Name",
      "Country Code",
      "Indicator Name",
      "Indicator Code"
    ),
    variable.name = "Year",
    value.name = "GDPpc"
  )

melted_migration <-
  melt(
    net_migration,
    id.vars = c(
      "Country Name",
      "Country Code",
      "Indicator Name",
      "Indicator Code"
    ),
    variable.name = "Year",
    value.name = "Net_migration"
  )

# Creation of list for OECD countries

OECD_countries <-
  c(
    "Austria",
    "Belgium",
    "Canada",
    "Denmark",
    "France",
    "West Germany",
    "Greece",
    "Iceland",
    "Ireland",
    "Italy",
    "Luxembourg",
    "Netherlands",
    "Norway",
    "Portugal",
    "Spain",
    "Sweden",
    "Switzerland",
    "Turkey",
    "United Kingdom",
    "United States",
    "Japan",
    "Finland",
    "Australia",
    "New Zealand"
  )

# Creation of list for developing countries (all developing countries,
# according to the Wikipedia definition)

dev_countries <- c(
  "Albania",
  "Algeria",
  "Angola",
  "Argentina",
  "Armenia",
  "Azerbaijan",
  "The Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belize",
  "Benin",
  "Bhutan",
  "Bolivia",
  "Botswana",
  "Brazil",
  "Bulgaria",
  "Burkina Faso",
  "Cameroon",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Republic of Congo",
  "Costa Rica",
  "Côte d'Ivoire",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Eswatini",
  "Fiji",
  "Gabon",
  "The Gambia",
  "Georgia",
  "Ghana",
  "Guatemala",
  "Guinea",
  "Honduras",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Kenya",
  "Libya",
  "Madagascar",
  "Malaysia",
  "Mali",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Mongolia",
  "Morocco",
  "Namibia",
  "Nepal",
  "Niger",
  "North Macedonia",
  "Oman",
  "Pakistan",
  "Paraguay",
  "Peru",
  "Philippines",
  "Romania",
  "Russia",
  "Rwanda",
  "Saudi Arabia",
  "Senegal",
  "Seychelles",
  "Sierra Leone",
  "South Africa",
  "Sudan",
  "Tanzania",
  "Thailand",
  "Togo",
  "Tunisia",
  "Türkiye",
  "Uganda",
  "Ukraine",
  "Uruguay",
  "Uzbekistan",
  "Vanuatu",
  "Yemen",
  "Zimbabwe"
)

# Creation of list for developing countries that present complete and accurate data

dev_countries_best = c(
  "Algeria",
  "Argentina",
  "Bolivia",
  "Brazil",
  "Bangladesh",
  "Chile",
  "China",
  "Colombia",
  "Costa Rica",
  "Côte d'Ivoire",
  "Domenican Republic",
  "Ecuador",
  "Egypt",
  "Ghana",
  "Honduras",
  "India",
  "Indonesia",
  "Iran",
  "Kenya",
  "Malaysia",
  "Mexico",
  "Morocco",
  "Niger",
  "Pakistan",
  "Peru",
  "Senegal",
  "South Africa",
  "Sudan",
  "Thailand",
  "Togo",
  "Türkiye",
  "Uruguay",
  "Zimbabwe"
)


# Filtering of the melted datasets to extract the values of:
# - saving
# - growth
# - gdp per capita
# of OECD countries only

savings_OECD <-
  melted_savings[melted_savings$"Country Name" %in% OECD_countries, ]
growth_OECD <-
  melted_growth[melted_growth$"Country Name" %in% OECD_countries, ]
GDPpc_OECD <-
  melted_GDPpc[melted_GDPpc$"Country Name" %in% OECD_countries, ]

# Repeating the process above for developing countries

savings_dev <-
  melted_savings[melted_savings$"Country Name" %in% dev_countries, ]
growth_dev <-
  melted_growth[melted_growth$"Country Name" %in% dev_countries, ]
GDPpc_dev <-
  melted_GDPpc[melted_GDPpc$"Country Name" %in% dev_countries, ]

# Repeating the process above for developing countries that present complete and accurate data

savings_dev_best <-
  melted_savings[melted_savings$"Country Name" %in% dev_countries_best, ]
growth_dev_best <-
  melted_growth[melted_growth$"Country Name" %in% dev_countries_best, ]
GDPpc_dev_best <-
  melted_GDPpc[melted_GDPpc$"Country Name" %in% dev_countries_best, ]
net_migration_dev_best <-
  melted_migration[melted_migration$"Country Name" %in% dev_countries_best, ]


# Calculate the average of saving, growth and GDP per capita for each year for OECD countries

avg_savings_OECD <-
  savings_OECD[, .(avg_savings_OECD = mean(Saving, na.rm = TRUE)), by = Year]
avg_growth_OECD <-
  growth_OECD[, .(avg_growth_OECD = mean(Growth, na.rm = TRUE)), by = Year]
avg_GDPpc_OECD <-
  GDPpc_OECD[, .(avg_GDPpc_OCED = mean(GDPpc, na.rm = TRUE)), by = Year]

# Calculate the average of saving, growth and GDP per capita for each year for developing countries

avg_savings_dev <-
  savings_dev[, .(avg_savings_dev = mean(Saving, na.rm = TRUE)), by = Year]
avg_growth_dev <-
  growth_dev[, .(avg_growth_dev = mean(Growth, na.rm = TRUE)), by = Year]
avg_GDPpc_dev <-
  GDPpc_dev[, .(avg_GDPpc_dev = mean(GDPpc, na.rm = TRUE)), by = Year]

# Calculate the average of saving, growth and GDP per capita for developing countries that present complete and accurate data

avg_savings_dev_best <-
  savings_dev_best[, .(avg_savings_dev_best = mean(Saving, na.rm = TRUE)), by = Year]
avg_growth_dev_best <-
  growth_dev_best[, .(avg_growth_dev_best = mean(Growth, na.rm = TRUE)), by = Year]
avg_GDPpc_dev_best <-
  GDPpc_dev_best[, .(avg_GDPpc_dev_best = mean(GDPpc, na.rm = TRUE)), by = Year]
avg_net_migration_dev_best <-
  net_migration_dev_best[, .(avg_net_migration_dev_best = mean(Net_migration, na.rm = TRUE)), by = Year]

# During our analysis, the adoption of logarithmic transformations for variables was deemed necessary.
# In light of this, we came up with a peculiar approach to handle the net migration variable.
# Net migration can take up negative values, thus computing the logarithm straight forward is not possible
# We thus performed the computation of the logarithm of the absolute value of the net migration, while retaining the original sign of the "net-migration" value.
# i.e.: if net migration was -2000 we the new value would be: -log(abs(-2000))
# This method ensures the preservation of the substantive interpretation of the data, as
# the transformed values accurately reflect the magnitude and direction of change experienced by each country.

avg_net_migration_dev_best$avg_net_migration_dev_best <-
  sapply(avg_net_migration_dev_best$avg_net_migration_dev_best, function(val) {
    sign_val <- sign(val)
    if (sign_val == 1) {
      return(log(abs(val), base = 10))
    } else {
      return(-log(abs(val), base = 10))
    }
  })

# Merge the complete set of data by "Year", the process will be performed for the 3 categories of countries

merged_OECD <-
  merge(avg_GDPpc_OECD,
        avg_growth_OECD,
        by = "Year",
        all = TRUE)
merged_OECD <-
  merge(merged_OECD, avg_savings_OECD, by = "Year", all = TRUE)

merged_dev <-
  merge(avg_GDPpc_dev, avg_growth_dev, by = "Year", all = TRUE)
merged_dev <-
  merge(merged_dev, avg_savings_dev, by = "Year", all = TRUE)

merged_dev_best <-
  merge(avg_GDPpc_dev_best,
        avg_growth_dev_best,
        by = "Year",
        all = TRUE)
merged_dev_best <-
  merge(merged_dev_best,
        avg_savings_dev_best,
        by = "Year",
        all = TRUE)

merged_dev_best_mig <-
  merge(merged_dev_best,
        avg_net_migration_dev_best,
        by = "Year",
        all = TRUE)

# Filter of the previously obtained data for the years we are interested in

merged_OECD$Year <- as.numeric(as.character(merged_OECD$Year))
merged_dev$Year <- as.numeric(as.character(merged_dev$Year))
merged_dev_best$Year <-
  as.numeric(as.character(merged_dev_best$Year))
merged_dev_best_mig$Year <-
  as.numeric(as.character(merged_dev_best_mig$Year))

final_OECD <- merged_OECD[merged_OECD$Year >= 1961,]
final_dev <- merged_dev[merged_dev$Year >= 1961, ]
final_dev_best <- merged_dev_best[merged_dev_best$Year >= 1961, ]
final_dev_best_mig <-
  merged_dev_best_mig[merged_dev_best_mig$Year >= 1961, ]

# Computation of the regressions

reg_OECD = lm(data = final_OECD,
              log(avg_GDPpc_OCED) ~ log(avg_savings_OECD) + log(avg_growth_OECD))
reg_dev = lm(data = final_dev,
             log(avg_GDPpc_dev) ~ log(avg_savings_dev) + log(avg_growth_dev))
reg_dev_best = lm(
  data = final_dev_best,
  log(avg_GDPpc_dev_best) ~ log(avg_savings_dev_best) + log(avg_growth_dev_best)
)
reg_dev_best_mig = lm(
  data = final_dev_best_mig,
  log(avg_GDPpc_dev_best) ~ log(avg_savings_dev_best) + log(avg_growth_dev_best) + avg_net_migration_dev_best
)

# Display of the previously obtained  results

summary(reg_OECD)
summary(reg_dev)
summary(reg_dev_best)
summary(reg_dev_best_mig)

# Creation of Latex tables containing the regression results using the stargazer library

stargazer(
  reg_dev_best_mig,
  title = "Results with Migration",
  align = TRUE,
  dep.var.labels = c("GDPpc-dev-best-migration"),
  covariate.labels = c(
    "savings-dev-best",
    "growth-dev-best",
    "net_migration-dev-best"
  )
)

stargazer(
  reg_OECD,
  reg_dev,
  reg_dev_best,
  title = "Results",
  align = TRUE,
  dep.var.labels = c("GDPpc-OECD", "GDPpc-dev", "GDPpc-dev-best"),
  covariate.labels = c(
    "savings-OECD",
    "growth-OECD",
    "savings-dev",
    "growth-dev",
    "savings-dev-best",
    "growth-dev-best"
  ),
  digits = 5
)

# Visual inspection for no multicollinearity between variables


ggplot(final_OECD, aes(x = Year)) +
  #geom_point(aes(y = log(avg_GDPpc_OECD)), color = "red") +
  geom_point(aes(y = log(avg_growth_OECD)), color = "black") +
  geom_point(aes(y = log(avg_savings_OECD)), color = "green") +
  scale_x_continuous(breaks = seq(1961, 2022, by = 10))

ggplot(final_dev_best_mig, aes(x = Year)) +
  #geom_point(aes(y = log(avg_GDPpc_dev_best)), color = "red") +
  geom_point(aes(y = log(avg_growth_dev_best)), color = "black") +
  geom_point(aes(y = log(avg_savings_dev_best)), color = "green") +
  geom_point(aes(y = avg_net_migration_dev_best), color = "blue") +
  scale_x_continuous(breaks = seq(1961, 2022, by = 10))

# conduction of Ramsey tests

reg_OECD_RESET <-
  resettest(reg_OECD, type = "fitted", power = c(2:3))
reg_OECD_RESET

reg_dev_RESET <- resettest(reg_dev, type = "fitted", power = c(2:3))
reg_dev_RESET

reg_dev_best_RESET <-
  resettest(reg_dev_best, type = "fitted", power = c(2:3))
reg_dev_best_RESET

reg_dev_best_mig_RESET <-
  resettest(reg_dev_best_mig, type = "fitted", power = c(2:3))
reg_dev_best_mig_RESET

# informally testing for homoscedasticity

plot(reg_OECD$residuals)

plot(reg_dev$residuals)

plot(reg_dev_best$residuals)

plot(reg_dev_best_mig$residuals)

# conduction of Breusch-Pagan tests for homoscedasticity

breusch_pagan_test_OECD <- bptest(reg_OECD)
breusch_pagan_test_OECD

breusch_pagan_test_dev <- bptest(reg_dev)
breusch_pagan_test_dev

breusch_pagan_test_dev_best <- bptest(reg_dev_best)
breusch_pagan_test_dev_best

breusch_pagan_test_dev_best_mig <- bptest(reg_dev_best_mig)
breusch_pagan_test_dev_best_mig

# conduction of Durbin-Watson tests for seriusly uncorellated errors

durbin_watson_test_OECD <- dwtest(reg_OECD)
durbin_watson_test_OECD

durbin_watson_test_dev <- dwtest(reg_dev)
durbin_watson_test_dev

durbin_watson_test_dev_best <- dwtest(reg_dev_best)
durbin_watson_test_dev_best

durbin_watson_test_dev_best_mig <- dwtest(reg_dev_best_mig)
durbin_watson_test_dev_best_mig

# conduction of Jarque-Bera tests for the normality of error term

jarque_bera_test_OECD <- jarque.bera.test(reg_OECD$residuals)
jarque_bera_test_OECD

jarque_bera_test_dev <- jarque.bera.test(reg_dev$residuals)
jarque_bera_test_dev

jarque_bera_test_dev_best <-
  jarque.bera.test(reg_dev_best$residuals)
jarque_bera_test_dev_best

jarque_bera_test_dev_best_mig <-
  jarque.bera.test(reg_dev_best_mig$residuals)
jarque_bera_test_dev_best_mig

# Creation of regression plots

ggplot(final_OECD) +
  aes(x = Year, y = log(avg_GDPpc_OCED)) +
  geom_point(aes(y = log(avg_GDPpc_OCED), color = "avg_GDPpc"), size = 2) +
  geom_point(aes(y = fitted(reg_OECD), color = "Fitted Value"), size = 2) +
  scale_color_manual(name = "Legend",
                     values = c("avg_GDPpc" = "blue", "Fitted Value" = "black")) +
  labs(x = "Year", y = "Avg_GDPpc") +
  geom_smooth(method = 'lm', color = 'red')

ggplot(final_dev) +
  aes(x = Year, y = log(avg_GDPpc_dev)) +
  geom_point(aes(y = log(avg_GDPpc_dev), color = "avg_GDPpc"), size = 2) +
  geom_point(aes(y = fitted(reg_dev), color = "Fitted Value"), size = 2) +
  scale_color_manual(name = "Legend",
                     values = c("avg_GDPpc" = "blue", "Fitted Value" = "black")) +
  labs(x = "Year", y = "Avg_GDPpc") +
  geom_smooth(method = 'lm', color = 'red')

ggplot(final_dev_best) +
  aes(x = Year, y = log(avg_GDPpc_dev_best)) +
  geom_point(aes(y = log(avg_GDPpc_dev_best), color = "avg_GDPpc"), size = 2) +
  geom_point(aes(y = fitted(reg_dev_best), color = "Fitted Value"), size = 2) +
  scale_color_manual(name = "Legend",
                     values = c("avg_GDPpc" = "blue", "Fitted Value" = "black")) +
  labs(x = "Year", y = "Avg_GDPpc") +
  geom_smooth(method = 'lm', color = 'red')

ggplot(final_dev_best_mig) +
  aes(x = Year, y = log(avg_GDPpc_dev_best)) +
  geom_point(aes(y = log(avg_GDPpc_dev_best), color = "avg_GDPpc"), size = 2) +
  geom_point(aes(y = fitted(reg_dev_best_mig), color = "Fitted Value"), size = 2) +
  scale_color_manual(name = "Legend",
                     values = c("avg_GDPpc" = "blue", "Fitted Value" = "black")) +
  labs(x = "Year", y = "Avg_GDPpc") +
  geom_smooth(method = 'lm', color = 'red')