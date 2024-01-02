--select * from Covid_Deaths
--order by 3,4

--Select * from Covid_Vaccinations
--order by 3,4


select location, date, total_cases, new_cases , total_deaths, population
from Covid_Deaths
order by 1,2



--Looking at Total Cases Vs Total Deaths
-- showing likelihood of dying if you came in contact with covid
select location, date, total_cases, new_cases , total_deaths, population
, 
case 
	when convert(float, total_cases) <> 0 then (convert(float, total_deaths)/ convert(float, total_cases))*100
	else (convert(float, total_deaths)/ 1)*100
end as DeathPercentage
from Covid_Deaths
where location = 'Canada'
order by 1,2 

-- Looking at Total Cases VS Population
-- shows what percentage of population got covid
select location, date, total_cases, population,
case 
 when convert (float, population) <> 0 then (convert (float, total_cases)/convert (float, population))
  else (convert (float, total_cases)/1)*100
  end PopulationPercentage
from Covid_Deaths
where location = 'Canada'
order by 1,2

--Looking at countries with highest infection rate compared to population
select location, max(total_cases) as HighestInfectionCount, population,
case 
 when convert (float, population) <> 0 then (convert (float, total_cases)/convert (float, population))
  else (convert (float, total_cases)/1)*100
  end PopulationPercentage
from Covid_Deaths
group by location, population, total_cases
order by PopulationPercentage desc

--Showing Countries with highest deathcount per population
select location, MAX(CONVERT (int, total_deaths)) as TotalDeathCount
from Covid_Deaths
group by location
order by TotalDeathCount desc

--By Continent
select continent, MAX(CONVERT (int, total_deaths)) as TotalDeathCount
from Covid_Deaths
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS
select sum(convert (int,new_cases)) as totalcases , sum(convert (int,new_deaths)) as totaldeaths, 
sum(convert (int,new_cases))/sum(convert (int,new_deaths))*100 as deathpercentage
from Covid_Deaths


select*
from Project1..Covid_Vaccinations


--Looking at Total Population Vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum (cast( vac.new_vaccinations as int)) over 
(partition by dea.date) as RollingPeopleVaccinated
from dbo.Covid_Deaths dea
Join dbo.Covid_Vaccinations  vac
  ON dea.location = vac.location
  and dea.date = vac.date
  order by 5 desc

  --Using CTE

  With PopVsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)

 AS (select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum (cast( vac.new_vaccinations as int)) over 
(partition by dea.date) as RollingPeopleVaccinated
from dbo.Covid_Deaths dea
Join dbo.Covid_Vaccinations  vac
  ON dea.location = vac.location
  and dea.date = vac.date)
 -- order by 5 des

 select * 
 from PopVsVac

 --TEMP Table

 DROP Table if exists #PercentPopulationVaccinates
 Create table #PercentPopulationVaccinates
 (
 Continent nvarchar(200),
 Location nvarchar(200),
 Date DateTime,
 Population float,
 new_vaccinations float,
 RollingPeopleVaccinated float)

 Insert into #PercentPopulationVaccinates
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum (cast( vac.new_vaccinations as int)) over 
(partition by dea.date) as RollingPeopleVaccinates
from dbo.Covid_Deaths dea
Join dbo.Covid_Vaccinations  vac
  ON dea.location = vac.location
  and dea.date = vac.date

  select * from #PercentPopulationVaccinates

-- Creating view to store data for later visualizations

Create View  PercentPopulationVaccinates as
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum (cast( vac.new_vaccinations as int)) over 
(partition by dea.date) as RollingPeopleVaccinates
from dbo.Covid_Deaths dea
Join dbo.Covid_Vaccinations  vac
  ON dea.location = vac.location
  and dea.date = vac.date



  select * from PercentPopulationVaccinates