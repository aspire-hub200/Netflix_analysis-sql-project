Create Table netflix
(show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550));

Select * From netflix;
Select Count(*) as  total_Count From netflix;

-- Business problems

-- 1) Count the Number of Movies vs TV Shows

SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY type;


-- 2) Find the Most Common Rating for Movies and TV Shows
Select 
     type,
	 rating
From
(Select 
    type,
	rating,
	Count(*),
	Rank() Over(PARTITION BY type ORDER BY Count(*) DESC) AS ranking
from netflix
Group by 1,2 ) as t1
Where ranking = 1


-- 3) List All Movies Released in a Specific Year (e.g., 2020)
SELECT * 
FROM netflix
WHERE 
type = 'Movie' and
release_year = 2020;

-- 4) Find the Top 5 Countries with the Most Content on Netflix
Select
    UNNEST(String_To_Array(country,',')) as new_country,
	Count(show_id) as total_content
from netflix
Group by 1
order by 2 desc
limit 5


-- 5) Identify the Longest Movie
Select * from netflix
where 
   type = 'Movie' and
   duration = (Select Max(duration)from netflix)

-- 6) Find Content Added in the Last 5 Years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
	
-- 7) Find All Movies/TV Shows by Director 'Rajiv Chilaka'
Select * from netflix
where director ILike '%Rajiv Chilaka%'

-- 8) List All TV Shows with More Than 5 Seasons
Select *
from netflix
where 
    type = 'TV Show' and
	Split_Part(duration,' ',1):: INT > 5 

-- 9) Count the Number of Content Items in Each GenrSELECT 
Select
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(show_id) AS total_content
FROM netflix
GROUP BY 1;

-- 10) Find each year and the average numbers of content release in India on netflix
-- return top 5 year with highest avg content release!.

Select 
     Extract(Year from To_Date(date_added, 'Month DD,YYYY')) as year,
	 count(*) as yearly_count,
	 Round(
	 count(*)::numeric /(Select count(*)from netflix where country = 'India')::numeric *100 
	 ,2) as avg_content
from netflix
where country = 'India'
Group by 1


--11) List All Movies that are Documentaries
SELECT * 
FROM netflix
WHERE listed_in ILIKE '%Documentaries%';

--12) Find All Content Without a Director
Select * from netflix
where director is null

-- 13) Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
and 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


-- 14)Find the Top 10 Actors Who Have Appeared in the 
-- Highest Number of Movies Produced in India
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*) as total_count
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY COUNT(*) DESC limit 10;

-- 15) Categorize Content Based on the Presence of 'Kill' and
--'Violence' Keywords Categorize content as 'Bad' 
--if it contains 'kill' or 'violence' and 'Good' otherwise. 
--Count the number of items in each category.

with new_table
as
(
select *,
       CASE
	   When description ILIKE '%Kill%' OR description ILIKE '%violence%'
	   Then 'Bad' Else 'Good'
	   End category
from netflix
)
SELECT 
    category,
    COUNT(*) as total_content from new_table
	Group by 1















