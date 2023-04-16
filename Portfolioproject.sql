select *
From BalaProtfolioproject..CovidDeaths$
order by 3,4

--select *
--From BalaProtfolioproject..CovidVaccinations$
--order by 3,4

--select required data

Select Location, Date ,total_cases, new_cases, total_deaths ,Population
From BalaProtfolioproject..CovidDeaths$
Order by 1,2

--total cases Vs total deaths
Select Location, Date ,total_cases,total_deaths , (total_cases/total_deaths) * 100 as Deathpercentage
From BalaProtfolioproject..CovidDeaths$
Where location like '%states%'
Order by 1,2

--Total cases Vs Population
Select Location, Date ,total_cases,Population , (total_cases/population) * 100 As Affectedpercentage
From BalaProtfolioproject..CovidDeaths$
Order by 1,2

--Countries with highest infection rate compared to population
Select Location, Population, MAX (total_cases) as highinfecioncount, MAX(total_cases/Population) *100 as percentpopulationinfected
From BalaProtfolioproject..CovidDeaths$
Group by location ,  population
Order by percentpopulationinfected desc

--Showing countries with highest death count by population

Select continent,  MAX(cast(total_deaths as int))  as totaldeathcount
From BalaProtfolioproject..CovidDeaths$
Where Continent is not null
Group by continent
Order by totaldeathcount desc

--Global Numbers

Select date, total_cases , total_deaths, (total_cases/total_deaths)*100 as Deathpercentage
From BalaProtfolioproject..CovidDeaths$
Where continent is not null
Order by date Desc

--Global Numbers aggregate

 

--Vaccination

--Total population vs vaccination

Select *
From BalaProtfolioproject..CovidVaccinations$ vac
join BalaProtfolioproject..CovidDeaths$ dea
on dea.location	= vac.location
and dea.date = vac.date

--Total population vs vaccination

with popvsvac ( continent , location,date,population,new_vaccinations , rollingpeoplevaccinated)
as
(
Select dea.continent, dea.date , dea.location ,dea.population,vac.new_vaccinations , 
SUM(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date)as rollingpeoplevaccinated
--rollingpeoplevaccinated/populkation*100
From BalaProtfolioproject..CovidVaccinations$ vac
join BalaProtfolioproject..CovidDeaths$ dea
on dea.location	= vac.location
and dea.date = vac.date
where dea.continent is not null
)


--Temp table  
Drop table if exists #Percentpopvac
create table #Percentpopvac
Location nvarchar (255),
Date datetime,
Population numeric ,
new_vaccinations numeric ,
rollingpeoplevaccinated numeric
)
Insert into

Select dea.continent, dea.date , dea.location ,dea.population,vac.new_vaccinations , 
SUM(convert(int, vac.new_vaccinations)) 
over (partition by dea.location order by dea.location ,dea.date)as rollingpeoplevaccinated
--rollingpeoplevaccinated/populkation*100
From BalaProtfolioproject..CovidVaccinations$ vac
join BalaProtfolioproject..CovidDeaths$ dea
on dea.location	= vac.location
and dea.date = vac.date
where dea.continent is not null

--creating view

create view new as
Select date, Sum(new_cases) as totalnew , SUM(cast (new_deaths as int )) as totalnewdeath  -- , total_deaths, (total_cases/total_deaths)*100 as Deathpercentage
From BalaProtfolioproject..CovidDeaths$
Where continent is not null
Group by date
