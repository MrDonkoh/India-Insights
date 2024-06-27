select * from project.data1;
select * from project.data2;


-- number of rows in our dataset

select count(*) from project.data1;
select count(*) from project.data2;


-- dataset for jharkhand and bihar

select * from project.data1 where state in ('Jharkhand','bihar');


-- population of India

select sum(population) from project.data2;

-- recalculate the sum(population) by treating it as a numeric value instead of text

-- Add the 'id' column if not already present
ALTER TABLE project.data2 ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

-- Add a new temporary column
ALTER TABLE project.data2 ADD COLUMN population_numeric BIGINT;

-- Update the new column with converted values:
UPDATE project.data2 
SET population_numeric = CAST(REPLACE(population, ',', '') AS UNSIGNED)
WHERE id IS NOT NULL;

-- Drop the old 'population' column
ALTER TABLE project.data2 DROP COLUMN population;

-- Rename the new column to 'population'
ALTER TABLE project.data2 CHANGE population_numeric population BIGINT;

-- Recalculate the sum
SELECT SUM(population) as population FROM project.data2;


-- average growth
select avg(growth)*100 avg_growth from project.data1;
select state,avg(growth)*100 avg_growth from project.data1 group by state;

-- average sex ratio
select state,round(avg(sex_ratio),0) avg_sex_ratio from project.data1 group by state order by avg_sex_ratio desc;


-- max growth
select max(growth) from project.data1;

-- min growth
select min(growth) from project.data1;


-- avg literacy rate
select state,round(avg(literacy),0) avg_literacy_rate from project.data1 group by state order by avg_literacy_rate desc;

-- avg literacy rate greater than 90
select state,round(avg(literacy),0) avg_literacy_rate from project.data1 group by state having round(avg(literacy),0)>90 order by avg_literacy_rate desc;


-- top 3 states showing highest growth ratio

select state, avg(growth)*100 avg_growth from project.data1 group by state order by avg_growth desc limit 3;

-- bottom 3 states showing lowest sex ratio
select state,round(avg(sex_ratio),0) avg_sex_ratio from project.data1 group by state order by avg_sex_ratio asc limit 3;


-- top and bottom 3 states in literacy state
drop table if exists project.topstates;
create table project.topstates 
( state text,
 topstates float
);

insert into project.topstates
select state,round(avg(literacy),0) avg_literacy_ratio from project.data1
group by state order by avg_literacy_ratio desc;

select * from project.topstates;


-- Top 3 states in literacy rates

drop table if exists project.topstates;
create table project.topstates 
( state text,
 topstates float
);

insert into project.topstates
select state,round(avg(literacy),0) avg_literacy_ratio from project.data1
group by state order by avg_literacy_ratio desc;

select * from project.topstates limit 3;


-- bottom 3 states

drop table if exists project.bottomstates;
create table project.bottomstates 
( state text,
 bottomstates float
);

insert into project.bottomstates
select state,round(avg(literacy),0) avg_literacy_ratio from project.data1
group by state order by avg_literacy_ratio asc;

select * from project.bottomstates limit 3;


-- union operator
select * from (
select * from project.topstates order by topstates desc limit 3) a
union
select * from (
select * from project.bottomstates order by bottomstates asc limit 3) b;


-- states starting with letter a or b

select distinct state from project.data1 where lower(state) like 'a%' or lower(state) like 'b%';

-- states starting with letter d or ending with d
select distinct state from project.data1 where lower(state) like 'a%' or lower(state) like '%d';

