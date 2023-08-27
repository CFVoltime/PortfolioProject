#COVID-19 Exploratory Data Analysis

SELECT * FROM portfolio.`covid deaths` ;

select location, date, total_cases, new_cases, total_deaths, population
FROM portfolio.`covid deaths`
order by 1,2;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Looking at total cases vs Total Deaths;
#Percentage of population got covid
select location, date, total_cases, population, (total_cases/population)*100 as Infection_Percentage
FROM portfolio.`covid deaths`
where location like '%haiti%'
order by 1,2;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Looking at countries with Highest Infection Rate compared to Population;
select location, population, Max(total_cases) as infectioncount, max(total_cases/population)*100 as Infection_Percentage
FROM portfolio.`covid deaths`
#where location like '%haiti%'
where continent <> ''
group by location, population
order by infection_percentage desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Showing Countries with Highest Death Count per Population;
select location, Max(cast(total_deaths as Unsigned)) as TotalDeathCount
FROM portfolio.`covid deaths`
#where location like '%haiti%'
where continent <> ''
Group by location
order by TotalDeathCount desc;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Showing Continents with highest deaths
select location, Max(cast(total_deaths as Unsigned)) as TotalDeathCount
FROM portfolio.`covid deaths`
#where location like '%haiti%'
where continent = '' and location not like '%income%'
Group by location
order by TotalDeathCount desc;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Global Numbers
select  date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as Unsigned)) as Total_deaths, sum(cast(new_deaths as Unsigned))/sum(new_cases)
FROM portfolio.`covid deaths`
where continent <> ''
group by date
order by 1,2;

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as Unsigned)) as Total_deaths, sum(cast(new_deaths as Unsigned))/sum(new_cases)
FROM portfolio.`covid deaths`
where continent <> ''
order by 1,2;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#Looking at total Population vs Vaccination
select a.continent, a.location, a.date, b.population, a.new_vaccinations, sum(cast(a.new_vaccinations as unsigned)) over (partition by a.location order by a.location, a.date) as RollingPeopleVaccinated 
from portfolio.`covid vaccinations` a
Join portfolio.`covid deaths` b 
	on a.location = b. location and a.date = b.date
    where b.continent <> ''
    order by 2,3;
    
With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select a.continent, a.location, a.date, b.population, a.new_vaccinations, sum(cast(a.new_vaccinations as unsigned)) over (partition by a.location order by a.location, a.date) as RollingPeopleVaccinated 
from portfolio.`covid vaccinations` a
Join portfolio.`covid deaths` b 
	on a.location = b. location and a.date = b.date
    where b.continent <> ''
    ) Select *, (rollingPeopleVaccinated/Population)*100 from PopvsVac;
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Creating View to Store Data for visualization
Create View PercentPopulationVaccinated as
select a.continent, a.location, a.date, b.population, a.new_vaccinations, sum(cast(a.new_vaccinations as unsigned)) over (partition by a.location order by a.location, a.date) as RollingPeopleVaccinated 
from portfolio.`covid vaccinations` a
Join portfolio.`covid deaths` b 
	on a.location = b. location and a.date = b.date
    where b.continent <> '';

select * from percentpopulationvaccinated