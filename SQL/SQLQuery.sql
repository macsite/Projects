Select Location, date , total_cases, total_deaths, population, cast(total_deaths as float) as float_deaths
from covid_deaths
where Location = 'North Korea' and total_deaths is not null and total_cases is not null
--order by 1,2`


--Check Total Cases / Total deaths

Select Location,
-- date , total_cases, total_deaths, population, 
avg(100*(cast(total_deaths as float)/cast(total_cases as float))) as death_ratio
from covid_deaths
where total_deaths is not null and total_cases is not null 
group by location
order by 2 desc


--Looking at Total cases vs population
-- shows % of population that got covid

Select Location,population ,date, 
 total_cases, total_cases/population *100 as Covid_chance
from covid_deaths
where Location='Poland'
order by 1,2 desc


--Which countries have highest infection rate compared to population

Select Location, population, MAX(total_cases) as max_total_cases, (MAX(total_cases)/population)*100 as max_percent_population_infected
from covid_deaths
--where Location='Poland
group by location, population
order by 4 desc


-- Shows countries with highest death_rate per population

Select Location, population, MAX(cast(total_deaths as int)) as max_total_deaths, (MAX(cast(total_deaths as int))/population)*100 as max_percent_population_dead
from covid_deaths
where continent is not null
group by location, population
order by 4 desc


-- Continents analysis, #error, but continent for vis purpose
--Show continents with highest death count per  population

Select continent, sum(population) as total_population, MAX(cast(total_deaths as int)) as max_total_deaths, round((MAX(cast(total_deaths as int))/sum(population))*100,5) as max_percent_population_dead
from covid_deaths
where continent is not null
group by continent
order by 3 desc


--Breaking global numbers

Select  
--date , 
sum(new_cases) as sum_new_cases, sum(cast(new_deaths as int)) as sum_new_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as death_percentage
from covid_deaths
where continent is not null
--group by date
order by 1,2 desc

Select  
date , 
sum(new_cases) as sum_new_cases, sum(cast(new_deaths as int)) as sum_new_deaths, sum(cast(new_deaths as int))/sum(new_cases) *100 as death_percentage
from covid_deaths
where continent is not null
group by date
order by 4 desc


-- Join vaccination table , check Total population vs Vaccination

Select 
	dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations AS float)) over (partition by dea.Location order by dea.date) as rolling_new_vac
from  [SQL Data Exploration - Covid].[dbo].[covid_deaths] dea
	join  [SQL Data Exploration - Covid].[dbo].[covid_vaccination] vac
	on dea.location = vac.location
	and dea.date = vac.date
where
	(dea.continent is not null)
order by 2,3


--Use CTE

With PopVsVac (continent, location, date, population, new_vaccinations, rolling_new_vac)
as (
	Select 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations AS float)) over (partition by dea.Location order by dea.date) as rolling_new_vac
	From  [SQL Data Exploration - Covid].[dbo].[covid_deaths] dea
		join  [SQL Data Exploration - Covid].[dbo].[covid_vaccination] vac
		on dea.location = vac.location
		and dea.date = vac.date
	Where
		(dea.continent is not null)
)
Select *, (rolling_new_vac/Population)*100 as "new_vac/pop"
From PopVsVac


--Temp table

--Drop table if exists #Percent_Population_Vaccinated  
Create Table #Percent_Population_Vaccinated 
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_new_vac  numeric
)

Insert into #Percent_Population_Vaccinated 
	Select 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations AS float)) over (partition by dea.Location order by dea.date) as rolling_new_vac
	From  [SQL Data Exploration - Covid].[dbo].[covid_deaths] dea
		join  [SQL Data Exploration - Covid].[dbo].[covid_vaccination] vac
		on dea.location = vac.location
		and dea.date = vac.date
	--Where
	--	(dea.continent is not null)

Select *, (rolling_new_vac/Population)*100 as "rolling_vac/pop_perc"
From #Percent_Population_Vaccinated 


-- Create view

Use [SQL Data Exploration - Covid]
GO

Create View .[Percent_Population_Vaccinated]
as (
	Select 
		dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		sum(cast(vac.new_vaccinations AS float)) over (partition by dea.Location order by dea.date) as rolling_new_vac
	From  [SQL Data Exploration - Covid].[dbo].[covid_deaths] dea
		join  [SQL Data Exploration - Covid].[dbo].[covid_vaccination] vac
		on dea.location = vac.location
		and dea.date = vac.date
	Where
		(dea.continent is not null)
	)
