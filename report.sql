create database project ;
use project ;

-- data cleaning
alter table hr
change column ï»¿id  emp_id varchar(20) null ;

describe hr;

UPDATE hr
SET birthdate = CASE 
    WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

select birthdate from hr ;

alter table hr
modify column birthdate date ;

UPDATE hr
SET hire_date = CASE 
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

alter table hr
modify column hire_date date ;

UPDATE hr
set termdate = date(str_to_date(termdate , '%Y-%m-%d %H:%i:%s UTC' ))
where termdate is not null and termdate != " ";

alter table hr
modify column termdate date ;

select termdate from hr ;

alter table hr
add column age int;

update hr
set age = timestampdiff(year , birthdate ,CURDATE()); 

select min(age) as youngest,
max(age) as oldest
from hr ;

select count(age)
from hr
where age <0 ;

-- what is the gender breakdown of company 
select gender , count(gender) 
from hr
where age >=18 and termdate = "0000-00-00"
group by gender ;

-- what is the race and ethnicity breakdown of company
select count(race) , race
from hr
where age >=18 and termdate = "0000-00-00"
group by race ; 

-- what is the age distribution of company in the country
select min(age) as "youngest",
max(age) as "oldest"
from hr
where age >=18 and termdate = "0000-00-00";

select
	case
		when age >= 18 and age <= 24 Then "18-24"
        when age >= 25 and age <= 34 Then "25-34"
        when age >= 35 and age <= 44 Then "35-44"
        when age >= 45 and age <= 54 Then "45-54"
        when age >= 55 and age <= 64 Then "55-64"
        else "65+"
        end as age_group , gender ,
		count(*) as count
        from hr 
        where age >=18 and termdate = "0000-00-00"
        group by age_group ,gender
        order by age_group ,gender ;
        
-- how many emp work in office vs how many work in remote        
 select count(location) ,location
 from hr
 where age >=18 and termdate = "0000-00-00"
 group by location ;
 
-- what is the avg length of employment for employee who has been terminated ?
select
	round(avg(datediff(termdate , hire_date))/365 , 0) as "avg_length_emp"
    from hr 
	where age >=18 and termdate != "0000-00-00" and termdate <= current_date() ;

-- how the gender distribution across various departments and job titles
select count(gender) , gender , department 
from hr
where age >=18 and termdate = "0000-00-00"
group by department 
order by department , gender ;

-- what is the distribution of job titles among company?
select count(*) ,jobtitle
from hr
where age >=18 and termdate != "0000-00-00"
group by jobtitle 
order by jobtitle desc;

-- which dept has highest turnover rate  

-- 9) what is the distribution of employee across locations by cities and state ? 
select location_state ,  count(emp_id) as cnt
from hr
where age >=18 and termdate = "0000-00-00"
group by location_state 
order by cnt desc ;

-- How has the company's employee count changed over time based on hire and term dates ?
select
year ,hires ,terminations,
hires - terminations as net_change,
round((hires - terminations)/hires * 100 , 2) as net_change_percent
from (
select year(hire_date) as year,
count(*) as hires,
sum(case when termdate <> "0000-00-00" and termdate <= curdate() then 1 else 0 end)
as terminations
from hr 
where age >= 18 
group by year(hire_date) 
) as subquery
order by year asc ;
-- 11) what is the tenure distrivution for each distribution
select department , round(avg(datediff(termdate ,hire_date)/365),0) as avg_tenure
from hr
where termdate <= curdate() and termdate <> "0000-00-00" and age >= 18
group by department ;



select *
from hr;
 
set sql_mode = " "; 
set sql_safe_updates = 0 ;

