/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


-- Select Data that we are going to be starting with

SELECT location, date, population, total_cases, new_cases_smoothed, total_deaths
FROM covid_deaths
WHERE continent IS NOT null 
ORDER BY 1,2;


-- GLOBAL NUMBERS (Sheet 1)

SELECT 
    SUM(new_cases_smoothed)::int AS total_cases, 
    SUM(new_deaths_smoothed)::int AS total_deaths, 
    ROUND((SUM(new_deaths_smoothed) / SUM(new_cases_smoothed) * 100)::numeric, 2) AS DeathPercentage
FROM covid_deaths
WHERE continent IS NOT null;


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population (Sheet 2)

SELECT location, population, MAX(total_deaths) AS death_count
FROM covid_deaths
WHERE 
	continent IS null
		AND
	location NOT LIKE '%income%'
		AND
	location != 'World'
GROUP BY location, population
ORDER BY death_count DESC;


-- Countries with Highest Infection Rate compared to Population (Sheet 3)

SELECT location, population, MAX(total_cases), MAX(total_cases) / population * 100 AS infected_percentage
FROM covid_deaths
WHERE 
	continent IS NOT null
		AND
	total_cases IS NOT null
		AND
	total_deaths IS NOT null
GROUP BY location, population
ORDER BY infected_percentage DESC;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid (Sheet 4)

SELECT location, population, date, MAX(total_cases) AS highest_infection_count, MAX(total_cases / population) * 100 AS percent_population_infected
FROM covid_deaths
WHERE 
	continent IS NOT null
		AND
	total_cases IS NOT null
		AND
	total_deaths IS NOT null
GROUP BY location, population, date
ORDER BY percent_population_infected DESC;


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, total_deaths / total_cases * 100 AS deaths_percentage
FROM covid_deaths
WHERE 
	continent IS NOT null
		AND
	total_cases IS NOT null
		AND
	total_deaths IS NOT null
ORDER BY 1,2;


-- Countries with Highest Death Count per Population

SELECT location, population, COALESCE(MAX(total_deaths), 0) AS death_count
FROM covid_deaths
WHERE continent IS NOT null
GROUP BY location, population
ORDER BY death_count DESC;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (location, date, population, new_tests_smoothed, total_vaccinated) AS (
	SELECT 
		location, date, population, new_tests_smoothed, 
		SUM(new_tests_smoothed) OVER(PARTITION BY location ORDER BY location, date) AS total_vaccinated
	FROM covid_vaccinations
	ORDER BY 1, 2
)
SELECT 
	location, 
	date, 
	population, 
	COALESCE(new_tests_smoothed, 0) AS new_tests_smoothed,
	COALESCE(total_vaccinated, 0) AS total_vaccinated,
	COALESCE(ROUND((total_vaccinated / population * 100)::numeric, 2), 0) AS vaccination_percentage 
FROM PopvsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS percent_population_vaccinated;
CREATE TEMPORARY TABLE percent_population_vaccinated (
	location varchar(50),
	date date,
	population numeric,
	new_tests_smoothed numeric,
	total_vaccinated numeric
);

INSERT INTO percent_population_vaccinated
SELECT
	location, date, population, new_tests_smoothed, 
	SUM(new_tests_smoothed) OVER(PARTITION BY location ORDER BY location, date) AS total_vaccinated
FROM covid_vaccinations
ORDER BY 1, 2;

SELECT * FROM percent_population_vaccinated;


-- Creating View to store data for later visualizations

CREATE VIEW percent_population_vaccinated AS
SELECT
	location, date, population, new_tests_smoothed, 
	SUM(new_tests_smoothed) OVER(PARTITION BY location ORDER BY location, date) AS total_vaccinated
FROM covid_vaccinations
ORDER BY 1, 2;