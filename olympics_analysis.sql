-- creating a new schema named olympics
create schema olympics;

-- create tables inside the schema
-- table 1
drop table if exists olympics.olympics_data;
create table if not exists olympics.olympics_data
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

-- table 2
drop table if exists olympics.olympics_noc_regions;
create table if not exists olympics.olympics_noc_regions
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

-- populating data to the tables 
COPY olympics.olympics_data FROM '/home/kaushal/Vscode/data analytics/olympic/athlete_events.csv' DELIMITER ',' CSV HEADER;
COPY olympics.olympics_noc_regions FROM '/home/kaushal/Vscode/data analytics/olympic/noc_regions.csv' DELIMITER ',' CSV HEADER;


-- see the newly created tables
select * from olympics.olympics_data;  	-- this contains all the athletes' data
select * from olympics.olympics_noc_regions;   -- this contains the country code and country name

-- exploring the athelets data
select count(1) from olympics.olympics_data;  -- total 271116 rows, the column 1 has no null values

-- lets count the null values in some important columns
select count(age) age_null
from olympics.olympics_data
where age = 'NA';

select count(height) height_null
from olympics.olympics_data
where height = 'NA';
-- there are 9474 null values in 'age' and 60171 in 'height' cols


-- Number of times olympic took place, 51 total olympics
select count(distinct games)
from olympics.olympics_data;

-- Total winter olympics, 22 total winter olympics
select count(distinct games)
from olympics.olympics_data
where season = 'Winter';


------------------------------------ Analysing the dataset -------------------------------

-- 1. Which sports were played in all the summer olympics?
with t1 as 
	(	-- count the total summer olympics , 29
		select count (distinct games) as total_summer_olympics
		from olympics.olympics_data
		where season = 'Summer'
	),
	
	t2 as 
	(	-- all the distinct sports played in each olympics, ordered by games (olympic edition)
		select distinct sport, games 
		from olympics.olympics_data
		where season = 'Summer'
		order by games
	),
	
	t3 as 
	( 	-- all the sports and how many olympics they were part of
		select sport, count(games) as no_of_games
		from t2 group by sport
	)
select * from t3
join t1 on t1.total_summer_olympics = t3.no_of_games;



-- 2. Top 5 athletes with most Golds and their countries
with t1 as 
	(	-- fetches players with most golds in desc order
		select "name","team", count("name") as medals 
		from  olympics.olympics_data
		where season = 'Summer' and medal = 'Gold'
		group by "name","team"
		order by 2 desc
	),
	
	t2 as 
	( -- ranking them on the basis of their gold medals because there are multiple players with same no of golds
		select *, dense_rank() over(order by medals desc) as medal_rank 
		from t1
	)
select * from t2 where medal_rank <= 5;



-- 3. Total golds, silvers and bronzes won by each country, we will use this query in crosstab 
-- joining is done to map noc with country name, olympics_noc_regions table is imported as onr
select onr.region as country, medal,count(medal)
from olympics.olympics_data od
join olympics.olympics_noc_regions onr on onr.noc = od.noc
where medal <> 'NA'
group by onr.region, medal
order by onr.region, medal;

-- Pivoting the table we get through the above query to get our desired output
-- to pivot the table we first need crosstab function
create extension tablefunc;

select country,
		coalesce(gold,0) as gold,  -- replacing null with 0
		coalesce(silver,0) as silver,  
		coalesce(bronze,0) as bronze  
		
		-- inner query of crosstab can't have more than 3 columns
		from crosstab(' select onr.region as country, medal,count(medal)
						from olympics.olympics_data od
						join olympics.olympics_noc_regions onr on onr.noc = od.noc
						where medal <> ''NA''
						group by onr.region, medal
						order by onr.region, medal',
						'values (''Bronze''),(''Gold''),(''Silver'')'
					 )
		as result (country varchar, bronze bigint, gold bigint, silver bigint)
	order by gold desc, silver desc, bronze desc;		




-- 4. Which countries won the most golds, silvers and bronzes in each olympic
with temp as
(	
	select substring(games_country, 1, position(' - ' in games_country) -1) as games,
			substring(games_country, position(' - ' in games_country) +3) as country,
			coalesce(gold,0) as gold,  -- replacing null with 0
			coalesce(silver,0) as silver,  
			coalesce(bronze,0) as bronze 

			from crosstab(' select concat(games, '' - '', onr.region) as games_country, medal,count(medal)
							from olympics.olympics_data od
							join olympics.olympics_noc_regions onr on onr.noc = od.noc
							where medal <> ''NA''
							group by games, onr.region, medal
							order by games, onr.region, medal',
							'values (''Bronze''),(''Gold''),(''Silver'')'
						 )
			as result (games_country varchar, bronze bigint, gold bigint, silver bigint)
		order by games_country 
)

select distinct games,
		concat(first_value(country) over(partition by games order by gold desc), ' - ', 
			  	first_value(gold) over(partition by games order by gold desc)) as gold, 
		
		concat(first_value(country) over(partition by games order by silver desc), ' - ', 
			  	first_value(silver) over(partition by games order by silver desc)) as silver, 
				
		concat(first_value(country) over(partition by games order by bronze desc), ' - ', 
			  	first_value(bronze) over(partition by games order by bronze desc)) as bronze
from temp
order by games;



-- 5. Olympics and number of participating countries
select games,count( distinct noc) from olympics.olympics_data  
-- where season = 'Summer'
group by games
order by 2 desc;



-- 6. Countries to have participated in all olympic games
with t1 as 
	(	-- count the total summer olympics , 29
		select count (distinct games) as total_olympics
		from olympics.olympics_data
	),
	
	t2 as 
	(	-- all the distinct teams played in each olympics, ordered by games (olympic edition)
		select distinct noc, games 
		from olympics.olympics_data
		order by games
	),
	
	t3 as 
	( 	-- all the teams and how many olympics they were part of
		select noc, count(games) as no_of_games
		from t2 group by noc
	),
	
	t4 as 
	(
		select * from t3
		join t1 on t1.total_olympics = t3.no_of_games
		join olympics.olympics_noc_regions onr on onr.noc = t3.noc
	)
select region as country, total_olympics from t4;



-- 7. gold medals by age
select age, count(medal)
from olympics.olympics_data
where medal = 'Gold'
group by age;



-- 8. gold medals by height
select height, count(medal)
from olympics.olympics_data
where medal = 'Gold'
group by height;



-- 9. Cities to host the most summer olympics
select city, count( distinct games) no_of_times
from olympics.olympics_data
where season = 'Summer'
group by city
order by 2 desc;



-- 10. Total medals of countries that have won atleast one silver and/or bronze but not gold (only summer olympic)
with t1 as 
	(	-- selecting those countries 
		select * from olympics.olympics_data
		where season = 'Summer'and medal not in ('NA','Gold') 
		and noc not in (select distinct noc from olympics.olympics_data     -- noc not in gold medal winning country list
															where season = 'Summer' and medal = 'Gold')
	),
	t2 as
	(
		select noc,count(medal) as no_of_medal 
		from t1
		group by noc
	)
	
select region as country, no_of_medal from t2 
join olympics.olympics_noc_regions onr on onr.noc = t2.noc
order by 2 desc;


-- 11. Medals of countries that have won atleast one silver and/or bronze but not gold
select * from (
    	SELECT country, coalesce(gold,0) as gold, coalesce(silver,0) as silver, coalesce(bronze,0) as bronze
    		FROM CROSSTAB('SELECT onr.region as country
    					, medal, count(1) as total_medals
						from olympics.olympics_data od
						join olympics.olympics_noc_regions onr on onr.noc = od.noc
    					where medal <> ''NA''
    					GROUP BY onr.region,medal order BY onr.region,medal',
                    'values (''Bronze''), (''Gold''), (''Silver'')')
    		AS FINAL_RESULT(country varchar,
    		bronze bigint, gold bigint, silver bigint)) x
    where gold = 0 and (silver > 0 or bronze > 0)
    order by gold desc nulls last, silver desc nulls last, bronze desc nulls last;



-- 12. Lastly, seeing Nepal's record in the olympics ( disapointing )
select * from olympics.olympics_data
where noc = 'NEP' and medal <> 'NA'

