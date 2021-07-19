SELECT *
From portfolioproject..['-covid dealth $']
order by 3,4

SELECT *
From portfolioproject..['-covid vacination$']
order by 3,4

Select Location, date, total_cases, new_cases,total_deaths,population
From portfolioproject..['-covid dealth $']
order by 1,2

--Looking at Total cases vs Total Deaths
--Shows likehood of dying if you contract covid in nigeria
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Dealthpercentage
From portfolioproject..['-covid dealth $']
where location like '%nigeria%'
order by 1,2

--Looking at Total cases vs Population
--shows what percentage of population got covid
Select Location, date,population, total_cases, (total_cases/population)*100 as Percentpopulationinfected
From portfolioproject..['-covid dealth $']
where location like '%nigeria%'
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location,population, MAX(total_cases) as HigestInfectionCount, MAX(total_cases/population)*100 as Percentpopulationinfected
From portfolioproject..['-covid dealth $']
Group by location, population
order by Percentpopulationinfected desc

--SHOWING CONTINENTS WITH THE HIGHEST DEALTH COUNT PER POPULATION

Select continent, MAX(cast((total_deaths) as int)) as TotalDealthcount
From portfolioproject..['-covid dealth $']
where continent is not null
Group by continent
order by TotalDealthcount desc

--WORLD NUMBERS

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Dealthpercentage
From portfolioproject..['-covid dealth $']
where location like '%nigeria%'
order by 1,2

--LOOKING AT TOTAL POPULATION VS VACCINATIONS

SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location)
FROM portfolioproject ..['-covid dealth $'] dea
join portfolioproject..['-covid vacination$'] vac
     On dea.location = VAC.LOCATION
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 1,2,3
	 


SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROM portfolioproject ..['-covid dealth $'] dea
join portfolioproject..['-covid vacination$'] vac
     On dea.location = VAC.LOCATION
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3
  
  --USE CTE

  with popvsvac (continent, location,date, population, New_vaccinations, rollingpeoplevaccinated)
  as
  (
  SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROM portfolioproject ..['-covid dealth $'] dea
join portfolioproject..['-covid vacination$'] vac
     On dea.location = VAC.LOCATION
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3
	 
--TEMP TABLE

DROP Table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
Location nvarchar(225),
Date datetime,
population numeric
new_Vaccination,numeric
Rollingpeoplevaccinated numeric
)
)


Insert into #percentpopulationvaccinated
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROM portfolioproject ..['-covid dealth $'] dea
join portfolioproject..['-covid vacination$'] vac
     On dea.location = VAC.LOCATION
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 2,3

select *, Rollingpeoplevaccinated/populatiom)*100
From #percentpopulationvaccinated

--Creating view to store data for later visualizations
create view percenpopulationvaccinated as
SELECT dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated
--,(rollingpeoplevaccinated/population)*100
FROM portfolioproject ..['-covid dealth $'] dea
join portfolioproject..['-covid vacination$'] vac
     On dea.location = VAC.LOCATION
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *
From #percentpopulationvaccinated
