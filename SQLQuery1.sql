select *
from [SQL Project]..project$
order by 3,4

--select *
--from [SQL Project]..covid$
--order by 3,4

-- actual data we are working 
select location ,date ,total_cases ,new_cases ,total_deaths ,population
from [SQL Project]..project$
order by 1,2

-- total cases vs total death 

select location ,date ,total_cases ,total_deaths ,(total_deaths/total_cases) as ratio
from [SQL Project]..project$
order by 1,2

-- total cases vs total death ( india)

select location ,date ,total_cases ,total_deaths ,(total_deaths/total_cases) as ratio
from [SQL Project]..project$
where location like ' %India%'
order by 1,2

--- TOTAL cases vs population 

select location ,date ,total_cases , population ,total_deaths ,(total_cases/population) as ratio
from [SQL Project]..project$
order by 1,2

-- looking at country with highest infection rate compared to population
select location , max(total_cases) as highestinfection  , population ,max((total_cases/population)) as ratio
from [SQL Project]..project$
group by location, population
order by ratio desc

--- joining both table 

select *
from [SQL Project]..project$ a
join [SQL Project]..covid$ b
on a.location = b.location
and a.date = b.date

--- total pop vs vacination
select a.location , a.continent , a.population ,sum(cast(b.people_fully_vaccinated as int))over(partition by a.location)
from [SQL Project]..project$ a
join [SQL Project]..covid$ b
on a.location = b.location
and a.date = b.date
order by 2,3

--use cte

with popvsvacc ( location,continent , population , peoplevaccinated)
as
(
select a.location , a.continent , a.population ,sum(cast(b.people_fully_vaccinated as int))over(partition by a.location)
from [SQL Project]..project$ a
join [SQL Project]..covid$ b
on a.location = b.location
and a.date = b.date
)
select *
from popvsvacc

-- create temp table
create table #populationandvaccination
(
location nvarchar(225),
continent nvarchar(225),
population numeric,
peoplevaccinated numeric
)

insert into #populationandvaccination
select a.location , a.continent , a.population ,sum(cast(b.people_fully_vaccinated as int))over(partition by a.location)
from [SQL Project]..project$ a
join [SQL Project]..covid$ b
on a.location = b.location
and a.date = b.date

select *
from #populationandvaccination




