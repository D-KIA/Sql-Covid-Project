--SELECT * 
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
--ORDER BY 3,4

----SELECT *
----FROM PortfolioProject..CovidVaccinations
----ORDER BY 3,4

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
--ORDER BY 1,2


---- Looking at total cases vs Total Deaths
---- Likelihood of dying from covid in India
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE location LIKE 'India'
--and continent is not null
--ORDER BY 1,2


----Looking at Total Cases vs Population
--SELECT location, date, total_cases, population, (total_cases/population)*100 AS Infected_Population
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
--and location = 'India'
--ORDER BY 1, 2

----Countries with highest infection rate
----Looking at Total Cases vs Population
--SELECT location, population, max(total_cases) as HighestInfectionCountry, MAX((total_cases/population))*100 AS Infected_Population
--FROM PortfolioProject..CovidDeaths
----WHERE location = 'India'
--WHERE continent is not null
--GROUP BY location, population
--ORDER BY Infected_Population DESC

----Country with highest death count
--SELECT location, max(CAST(total_deaths AS INT)) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location = 'WORLD'
--WHERE continent is not null
--GROUP BY location
--ORDER BY TotalDeathCount DESC

----BY Continent

--SELECT location, max(CAST(total_deaths AS INT)) as TotalDeathCount
--FROM PortfolioProject..CovidDeaths
----WHERE location = 'WORLD'
--WHERE continent is null
--GROUP BY location
--ORDER BY TotalDeathCount DESC


----Global Numbers
--SELECT  sum(new_cases) AS Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not null
----GROUP BY date
--ORDER BY 1,2

---- Total Population vs vaccinations
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	sum(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.date)
--FROM PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2,3


----CTE
--WITH PopvsVac (Continent, Location, Date, Population, New_Vaccination, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	sum(CONVERT(INT, vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.date) as  RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is not null
----order by 2,3
--)
--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM PopvsVac


----TEMP TABLE
--DROP TABLE IF exists #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--population numeric, 
--New_vaccination numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
--	sum(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.date) as  RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--join PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is not null
----order by 2,3

--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM #PercentPopulationVaccinated

--Creating view to store data for later visualizations

use PortfolioProject
CREATE VIEW PercentPopulationVaccinated
AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	sum(CONVERT(BIGINT, vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.date) as  RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3