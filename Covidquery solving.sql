--Shows the Total cases, Total deaths and death percentage on daily basis

SELECT  location, CONVERT (DATE,DATE) AS Date,total_cases,total_deaths,
ISNULL (CAST((CAST( total_deaths AS FLOAT)/ NULLIF (total_cases,0))*100 
AS decimal(10,2)),0) AS
death_perc
FROM CovidDeaths
order by location

--Shows the Total cases, Total deaths and death percentage highest to lowest 
--according to the location 

SELECT LOCATION, 
SUM(total_cases) as Total_case, 
SUM (total_deaths) as Total_death,
ISNULL (Cast((Cast(Sum(total_deaths) AS FLOAT)/NULLIF (Sum(total_cases),0))*100
AS DECIMAL(10,2)),0) AS Death_percentage
FROM CovidDeaths
GROUP BY LOCATION
ORDER BY Death_percentage DESC

--Looking at Total cases each year and Population Vs Percentage of Total cases 

SELECT 
LOCATION, 
population AS Population, 
SUM(CASE WHEN YEAR(date) = 2020 THEN TOTAL_CASES ELSE 0 END) AS Total_case_2020,
SUM(CASE WHEN YEAR(date) = 2021 THEN TOTAL_CASES ELSE 0 END) AS Total_case_2021,
CASE 
WHEN population = 0 THEN 0
ELSE ISNULL(CAST(CAST(SUM(CASE WHEN YEAR(date) = 2020 THEN 
NULLIF(TOTAL_CASES, 0) ELSE 0 END) AS FLOAT) / population * 100 AS DECIMAL(10, 2)), 0)
END AS Perc_infected_2020,
CASE
WHEN population = 0 THEN 0
ELSE ISNULL(CAST(CAST(SUM(CASE WHEN YEAR(date) = 2021 THEN 
NULLIF(TOTAL_CASES, 0) ELSE 0 END) AS FLOAT) / population * 100 AS DECIMAL(10, 2)), 0)
END AS Perc_infected_2021
FROM 
CovidDeaths
GROUP BY 
population, LOCATION
ORDER BY location


--Showing countries with the highest death rate

SELECT location,population,
SUM(TOTAL_DEATHS) AS deaths, 
ISNULL(CAST((CAST(SUM(total_deaths) as float)/ nullif (population,0)*100)
AS DECIMAL (10,2)),0) as Death_rate
FROM CovidDeaths
where continent is not null
GROUP BY location,population
ORDER BY Death_rate DESC

-- SELECT * FROM CovidDeaths

--total population, Infection rate, death rate as per continents

SELECT continent,SUM(POPULATION) AS total_popu, SUM(TOTAL_DEATHS) AS total_death,
ISNULL (CAST((CAST(SUM(total_cases) AS FLOAT)/NULLIF(SUM(POPULATION),0) * 100) 
AS DECIMAL (10,5)), 0) AS Infec_rate,
ISNULL (CAST((CAST(SUM(TOTAL_DEATHS) AS FLOAT)/ NULLIF (SUM(POPULATION),0)*100)
AS DECIMAL (10,5)),0) AS death_rate
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY death_rate DESC

--Global death percentage on daily basis since the day 1 when covid began

SELECT CONVERT(DATE,DATE) AS Date, SUM(NEW_CASES) AS Total_cases, SUM(NEW_deaths) AS Totaldeaths,
ISNULL (CAST((CAST (SUM(NEW_deaths) as float) / NULLIF (SUM(NEW_CASES),0)*100)
AS DECIMAL (10,2)),0) AS Death_perc
FROM CovidDeaths
where new_cases<>0 
group by date
ORDER BY date

-- Total death percentage globally

SELECT SUM(NEW_CASES) AS Total_cases, SUM(NEW_deaths) AS Totaldeaths,
ISNULL (CAST((CAST (SUM(NEW_deaths) as float) / NULLIF (SUM(NEW_CASES),0)*100)
AS DECIMAL (10,2)),0) AS Death_perc
FROM CovidDeaths

-- Total population Vs Vaccinated and comparision btw 2020 and 2021

SELECT dea.location,dea.population,
SUM(CASE WHEN YEAR(dea.date) = 2020 THEN vac.total_vaccinations ELSE 0 END) AS Total_vaccination_2020,
SUM(CASE WHEN YEAR(dea.date) = 2021 THEN vac.total_vaccinations ELSE 0 END) AS Total_vaccination_2021,
ISNULL(CAST((CAST(SUM(CASE WHEN YEAR(dea.date) = 2020 THEN vac.total_vaccinations ELSE 0 END) AS FLOAT) / NULLIF(dea.population, 0) * 100) AS DECIMAL(10, 5)), 0) AS Vac_rate_2020,
ISNULL(CAST((CAST(SUM(CASE WHEN YEAR(dea.date) = 2021 THEN vac.total_vaccinations ELSE 0 END) AS FLOAT) / NULLIF(dea.population, 0) * 100) AS DECIMAL(10, 5)), 0) AS Vac_rate_2021
FROM CovidDeaths dea
JOIN CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
WHERE DEA.continent IS NOT NULL
AND YEAR(dea.date) IN (2020, 2021) 
GROUP BY dea.location, dea.population
ORDER BY location