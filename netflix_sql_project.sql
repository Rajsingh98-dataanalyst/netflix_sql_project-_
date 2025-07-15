--create database


--create table netflix
CREATE table  netflix(
show_id  varchar(6),
type  varchar(10),
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year INT,
rating	varchar(10),
duration varchar(15),
listed_in	 varchar(100),
description varchar(250)
);

select * from netflix;

select count(*) as total_count
from netflix;

select 
    DISTINCT type 
	from netflix;

--business problems

--Count the number of Movies vs TV Shows
select 
    type,
	count(*) as total_content
	from netflix 
	group by type;

--Find the most common rating for movies and TV shows

select 
type,
rating
 from 
  (select type,rating,
  count(*),
 rank() over(partition by type order by count(*) desc) as ranking
 from netflix
 group by 1,2
 ) as t1
 where ranking= 1;

-- List all movies released in a specific year (e.g., 2020)

select *  from netflix
where type = 'Movie' 
and 
release_year = '2020'


-- Find the top 5 countries with the most content on Netflix

select 
UNNEST(STRING_TO_ARRAY(country, ',')) as new_contry,
count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

--Identify the longest movie

select * from netflix
where 
  type = 'Movie'
and 
   duration = (select max(duration) from netflix);

--Find content added in the last 5 years

select *
from  netflix
where 
    TO_DATE(date_added, 'month-DD-YYYY') >= CURRENT_DATE - INTERVAL '5 years' ;


 -- Find all the movies/TV shows by director 'Rajiv Chilaka'!

select
 * from
netflix 
where 
    director LIKE '%Rajiv Chilaka%';
	

-- List all TV shows with more than 5 seasons

select *
 from 
     netflix
where 
type = 'TV Show'
AND
SPLIT_PART(duration, ' ', 1):: numeric > 5;

---- Count the number of content items in each genre

select
   	UNNEST(STRING_TO_ARRAY(listed_in, ','))	as genre,
	count(show_id) as total_show
from netflix
group by 1;

--Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content relaese!

select 
    EXTRACT(year from TO_DATE(date_added, 'Month DD, YYYY')) as year,
	count(*) as yearly_content,
	round(
count(*)::numeric/(select count(*) from netflix where country = 'India'):: numeric * 100,2
	) as avg_content_per_year
	from netflix
	where country = 'India'
group by 1;


-- List all movies that are documentariess
select * from netflix
where 
    listed_in ilike '%documentaries%';


-- Find all content without a director
select * from netflix
 where 
    director IS NULL;


--Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
casts ilike '%salman khan%'
and 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


-- Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10;



--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
with new_table
AS
(
SELECT 
*,
 case 
 when 
  description ilike '%kill%' or
  description ilike '%violence%' then 'Bad_content'
  ELSE 'Good Content'
  END category
from netflix
)
select category,
COUNT(*) as total_content
from new_table
group by 1

--END--OF--PROJECT--





















 

