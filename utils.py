import pathlib
import pandas as pd


url = pathlib.Path(__file__).parent / "owid-covid-data.csv"

deaths_fields = [
    "iso_code",
    "continent",
    "location",
    "date",
    "population",
    "total_cases",
    "new_cases_smoothed",
    "total_deaths",
    "new_deaths_smoothed",
    "total_cases_per_million",
    "new_cases_smoothed_per_million",
    "total_deaths_per_million",
    "new_deaths_smoothed_per_million",
    "reproduction_rate",
    "icu_patients",
    "icu_patients_per_million",
    "hosp_patients",
    "hosp_patients_per_million",
    "weekly_icu_admissions",
    "weekly_icu_admissions_per_million",
    "weekly_hosp_admissions",
    "weekly_hosp_admissions_per_million",
]
vaccinations_fields = [
    "iso_code",
    "continent",
    "location",
    "date",
    "population",
    "new_tests_smoothed",
    "total_tests",
    "total_tests_per_thousand",
    "new_tests_smoothed_per_thousand",
    "positive_rate",
    "tests_per_case",
    "tests_units",
    "total_vaccinations",
    "people_vaccinated",
    "people_fully_vaccinated",
    "new_vaccinations_smoothed",
    "new_vaccinations_smoothed_per_million",
    "new_people_vaccinated_smoothed",
    "total_vaccinations_per_hundred",
    "people_vaccinated_per_hundred",
    "people_fully_vaccinated_per_hundred",
    "stringency_index",
    "population_density",
    "median_age",
    "aged_65_older",
    "aged_70_older",
    "gdp_per_capita",
    "extreme_poverty",
    "cardiovasc_death_rate",
    "diabetes_prevalence",
    "life_expectancy",
    "human_development_index",
]

deaths_df = pd.read_csv(url, usecols=deaths_fields)
vaccinations_df = pd.read_csv(url, usecols=vaccinations_fields)

deaths_df["date"] = pd.to_datetime(
    deaths_df["date"], format="%Y-%m-%d", errors="coerce"
).dt.date
vaccinations_df["date"] = pd.to_datetime(
    vaccinations_df["date"], format="%Y-%m-%d", errors="coerce"
).dt.date
