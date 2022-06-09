
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--WHERE total_cases IS NOT NULL
--ORDER BY 3,4
 
 -- Total Deaths vs Total Cases
 -- This shows the liklihood of dying if you contract covid in Hong Kong
--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL AND location = 'Hong Kong'
--ORDER BY 1,2 DESC

-- The total Cases vs Population
--SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectionPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE total_cases IS NOT NULL 
--ORDER BY 2 

-- Countries with Highest Infectio Rate Compared to Population
--SELECT location, population, MAX(total_cases) AS HighestInfectionCount, 
--Max((total_cases/population)*100) AS MaxInfectionPercentage
--FROM PortfolioProject..CovidDeaths
--GROUP BY location,population
--ORDER BY 4 DESC

-- Countries with Highest Death Count per Population
--SELECT location,population, MAX(cast(total_deaths as int)) AS TotalDeathCount,
--(MAX(cast(total_deaths as int))/population)*100 AS DeathPercent
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY location, population
--ORDER BY 4 DESC

--SELECT location,MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

-- Continents with the highest death count
--SELECT continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC


-- Global Numbers
--SELECT date, SUM(new_cases) AS NewCases, SUM(cast(new_deaths AS INT)) AS NewDeaths,
--SUM(CAST(total_deaths AS INT))/SUM(total_cases)*100 AS DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE new_cases IS NOT NULL AND continent ='Asia'
--GROUP BY date
--ORDER BY date

-- Population vs Vaccinations
--SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
--SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY vac.location ORDER BY 
--dea.location,dea.date) AS RollingPeopleVaccinated,
--(/population)*100 
--FROM PortfolioProject..CovidDeaths AS dea
--JOIN PortfolioProject..CovidVaccinations AS vac
--On dea.location = vac.location AND dea.date=vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

-- CTE
--With PopvsVac (continent, location, date, population,new_vaccinations,RollingPeopleVaccinated) 
--AS
--(SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
--SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY vac.location ORDER BY 
--dea.location,dea.date) AS RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths AS dea
--JOIN PortfolioProject..CovidVaccinations AS vac
--On dea.location = vac.location AND dea.date=vac.date
--WHERE dea.continent IS NOT NULL
----ORDER BY 2,3
--)
--SELECT *,(RollingPeopleVaccinated/population)*100 AS VaccinationPercentage 
--FROM PopvsVac


-- Temporary Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),location nvarchar(255),date datetime,
population numeric,new_vaccinations numeric,RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,SUM(CONVERT(FLOAT,vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

-- Creating View to Store Data for Later Visualisations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,SUM(CONVERT(FLOAT,vac.new_vaccinations))
OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location=vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL




