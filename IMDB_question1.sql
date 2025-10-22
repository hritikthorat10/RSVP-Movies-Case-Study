USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
Select Count(*) From director_mapping;
Select Count(*) From genre;
Select Count(*) From movie;
Select Count(*) From names;
Select Count(*) from ratings;
Select Count(*) from role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:


Select Sum(Case When id is null then 1 else 0 END) AS null_count_column1,
       Sum(Case When title is null then 1 else 0 END) AS null_count_column2,
       Sum(Case When year is null then 1 else 0 END) as null_count_column3,
       sum(case when date_published is null then 1 else 0 END) as null_count_column4,
       sum(case when duration is null then 1 else 0 END) as null_count_column5,
       sum(case when country is null then 1 else 0 END) as null_count_column6,
       sum(case when worlwide_gross_income is null then 1 else 0 END) as null_count_column7,
       sum(case when languages is null then 1 else 0 END) as null_count_column8,
       sum(case when production_company is null then 1 else 0 END) as null_count_column9
       From movie;
       
       
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
Select Year as Year,
       Count(title) as number_of_movies
From movie
Group by year
order by year;

Select Month(Date_published) as month_num,
	   Count(title) as number_of_movies
From movie
Group by month_num
order by month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
    country, COUNT(title) AS number_of_movies
FROM
    movie
WHERE
    (Country = 'USA' OR Country = 'India')
        AND Year = 2019
GROUP BY country;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
Select distinct(genre) from genre; 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

Select g.genre as Genre,count(g.movie_id) as number_of_movies
From genre as g
Inner join 
movie as m
ON g.movie_id = m.id
group by Genre
Order by number_of_movies desc 
limit 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
Select count(*) as movie_belong_to_one_genre From
(select movie_id
From genre
Group by movie_id
Having Count(genre) = 1) as single_genre_movie;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select g.genre,Avg(m.duration) as avg_duration
From genre as g
Inner Join 
movie as m
On g.movie_id = m.id
Group by genre
Order by avg_duration desc;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
Select * 
From ( Select genre,
       Count(date_published) as movie_count,
       Rank() Over (order by count(date_published) desc) as genre_rank
From genre as g
Inner Join 
movie as m
on g.movie_id = m.id
group by genre) ranked_genres
Where genre = 'Thriller';



/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
Select min(avg_rating) as min_avg_rating,
       max(avg_rating) as max_avg_rating,
       min(total_votes) as min_total_votes,
       max(total_votes) as max_total_votes,
       min(median_rating) as min_median_rating,
       max(median_rating) as max_median_rating
From ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)
SELECT title,
       avg_rating,
       movie_rank
FROM (
    SELECT m.title,
           r.avg_rating,
           RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM movie AS m
    INNER JOIN ratings AS r
           ON m.id = r.movie_id
) ranked_movies
WHERE movie_rank <= 10;
       

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
Select median_rating,
       Count(movie_id) as movie_count
From ratings
Group by median_rating
Order by movie_count desc;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
Select m.production_company,
       Count(m.title)as movie_count,
       Rank() Over (Order By Count(m.title) desc) as prod_company_rank
From movie as m
Inner Join
ratings as r
ON m.id = r.movie_id
Where r.avg_rating > 8
	AND m.production_company is not null
Group by production_company
limit 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

Select genre,
       Count(title) as movie_count
From movie as m
Inner Join 
genre as g
ON m.id = g.movie_id
Inner join
ratings as r
ON g.movie_id = r.movie_id
Where m.year = 2017 AND month(date_published) = 3 AND lower(country) like '%usa%' AND total_votes > 1000
Group by genre
order by movie_count desc;



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
Select m.title,
       r.avg_rating,
       g.genre
From movie as m
Inner Join
genre as g
ON m.id = g.movie_id
Inner Join
ratings as r
ON m.id = r.movie_id
where title Like 'The%' And r.avg_rating >8
ORDER BY genre, avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


Select count(*) as Total_Movies
From movie as m
Inner join 
ratings as r
On m.Id = r.movie_id
Where date_published between  '2018-04-01' And '2019-04-01'
AND median_rating =8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    CASE 
        WHEN 
            (SELECT SUM(r.total_votes)
             FROM movie AS m
             INNER JOIN ratings AS r ON m.id = r.movie_id
             WHERE m.languages LIKE '%German%')
        >
            (SELECT SUM(r.total_votes)
             FROM movie AS m
             INNER JOIN ratings AS r ON m.id = r.movie_id
             WHERE m.languages LIKE '%Italian%')
        THEN 'Yes, German movies got more votes'
        ELSE 'No, Italian movies got more votes'
    END AS Answer;
    
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
Select
       Sum(Case When name is null then 1 else 0 END) AS null_count_name,
       Sum(Case When height is null then 1 else 0 END) as null_count_height,
       sum(case when date_of_birth is null then 1 else 0 END) as null_count_dob,
       sum(case when known_for_movies is null then 1 else 0 END) as null_count_kfm
       From names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_genres AS (
    SELECT g.genre
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
    ORDER BY COUNT(g.movie_id) DESC
    LIMIT 3
),
director_counts AS (
    SELECT n.name AS director_name,
           COUNT(DISTINCT m.id) AS movie_count,
           g.genre
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    JOIN genre g ON m.id = g.movie_id
    JOIN director_mapping d ON m.id = d.movie_id
    JOIN names n ON d.name_id = n.id
    WHERE r.avg_rating > 8
      AND g.genre IN (SELECT genre FROM top_genres)
    GROUP BY n.name, g.genre
)
SELECT director_name, SUM(movie_count) AS movie_count
FROM director_counts
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
Select n.name as actor_name,
      count(distinct(r.movie_id))as movie_count
From role_mapping as r
Inner Join
names as n
ON r.name_id = n.id
Inner join
ratings as rr
ON r.movie_id = rr.movie_id
where rr.median_rating >=8 AND r.category = 'actor'
group by n.name
order by count(distinct(r.movie_id))desc
limit 2;



/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
Select m.production_company,
       sum((r.total_votes)) as vote_count,
       Rank() Over (Order by sum(r.total_votes) desc) as prod_comp_rank
From movie as m
Inner Join
ratings as r
ON m.id = r.movie_id
Group BY m.production_company
limit 3;

       
       
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
Select n.name as actor_name,
       sum(r.total_votes) as total_votes,
       Count(m.title) as movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes), 2) AS actor_avg_rating,
    RANK() OVER (ORDER BY 
                    ROUND(SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes), 2) DESC,
                    SUM(r.total_votes) DESC) AS actor_rank
From movie as m
Inner Join 
role_mapping as rr
On m.id = rr.movie_id
Inner join
names as n
ON rr.name_id = n.id
Inner Join
ratings as r
ON rr.movie_id = r.movie_id
Where m.country Like "India" And rr.category = 'actor'
Group by n.name
Having Count(m.title) >=5;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
Select n.name as actress_name,
       sum(r.total_votes) as total_votes,
       Count(m.title) as movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes), 2) AS actress_avg_rating,
    RANK() OVER (ORDER BY 
                    ROUND(SUM(r.avg_rating * r.total_votes) * 1.0 / SUM(r.total_votes), 2) DESC,
                    SUM(r.total_votes) DESC) AS actress_rank
From movie as m
Inner Join 
role_mapping as rr
On m.id = rr.movie_id
Inner join
names as n
ON rr.name_id = n.id
Inner Join
ratings as r
ON rr.movie_id = r.movie_id
Where m.country Like "%India%" And rr.category = 'actress' AND languages Like '%Hindi%'
Group by n.name
Having Count(m.title) >= 3
limit 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
Select m.title as movie_name,
       CASE 
           WHEN r.avg_rating > 8 Then 'Superhit'
           WHEN r.avg_rating BETWEEN 7 AND 8 Then 'Hit'
           WHEN r.avg_rating BETWEEN 5 AND 7 Then 'One-time-watch'
           WHEN r.avg_rating < 5 Then 'Flop'
	   End AS movie_category
From movie as m
Inner Join 
genre as g
ON m.id = g.movie_id
Inner Join 
ratings as r
ON m.id = r.movie_id
Where g.genre Like '%Thriller%' AND r.Total_votes >=25000
order by r.avg_rating desc;

           
           
/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_avg AS
 (
Select g.genre as genre,
        Avg(m.duration) as avg_duration
FROM movie as m
Inner Join
genre as g
ON m.id = g.movie_id
Group by g.genre)
Select genre,
       Round(avg_duration,0) as avg_duration,
       Round(SUM(avg_duration) OVER (order by genre ROWS unbounded preceding),1) AS running_total_duration,
       Round(AVG(avg_duration) OVER (order by genre ROWS unbounded preceding),2) AS moving_avg_duration
From genre_avg
order by avg_duration desc;


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Step 1: Identify the top 3 genres
WITH top_genres AS (
    SELECT 
        g.genre
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    GROUP BY g.genre
    ORDER BY COUNT(*) DESC
    LIMIT 3
),

-- Step 2: Get movies from those genres and rank them by gross income per year
ranked_movies AS (
    SELECT 
        g.genre,
        m.year,
        m.title AS movie_name,
        -- Clean and convert worldwide_gross_income (remove '$' and commas)
        CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS DECIMAL(20,2)) AS worldwide_gross_income,
        RANK() OVER (
            PARTITION BY m.year, g.genre
            ORDER BY 
                CAST(REPLACE(REPLACE(m.worlwide_gross_income, '$', ''), ',', '') AS DECIMAL(20,2)) DESC
        ) AS movie_rank
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres)
)

-- Step 3: Select only top 5 movies per year per genre
SELECT 
    genre,
    year,
    movie_name,
    CONCAT('$', FORMAT(worldwide_gross_income, 0)) AS worldwide_gross_income,
    movie_rank
FROM ranked_movies
WHERE movie_rank <= 5
ORDER BY year,genre, movie_rank;

       

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH multilingual_hits AS (
    SELECT 
        m.production_company,
        m.id AS movie_id
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.median_rating >= 8
      AND m.languages LIKE '%,%'        -- multilingual condition
      AND m.production_company IS NOT NULL
)
SELECT 
    production_company,
    COUNT(DISTINCT movie_id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(DISTINCT movie_id) DESC) AS prod_comp_rank
FROM multilingual_hits
GROUP BY production_company
ORDER BY movie_count DESC
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH superhit_drama AS (
    SELECT 
        n.id AS actress_id,
        n.name AS actress_name,
        rr.avg_rating,
        rr.total_votes,
        m.title
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    JOIN ratings rr ON m.id = rr.movie_id
    JOIN role_mapping r ON m.id = r.movie_id
    JOIN names n ON r.name_id = n.id
    WHERE g.genre = 'drama'
      AND rr.avg_rating > 8
      AND r.category = 'actress'
)
SELECT 
    actress_name,
    SUM(total_votes) AS total_votes,
    COUNT(title) AS movie_count,
    ROUND(SUM(avg_rating * total_votes) * 1.0 / SUM(total_votes), 4) AS actress_avg_rating,
    RANK() OVER (
        ORDER BY 
            ROUND(SUM(avg_rating * total_votes) * 1.0 / SUM(total_votes), 2) DESC,
            SUM(total_votes) DESC,
            actress_name ASC
    ) AS actress_rank
FROM superhit_drama
GROUP BY actress_id, actress_name
ORDER BY actress_rank
LIMIT 3;	


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH director_movies AS (
    SELECT 
        d.name_id AS director_id,
        n.name AS director_name,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM director_mapping d
    JOIN names n ON d.name_id = n.id
    JOIN movie m ON d.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
),
movie_gaps AS (
    SELECT 
        director_id,
        director_name,
        movie_id,
        DATEDIFF(
            LEAD(date_published) OVER (PARTITION BY director_id ORDER BY date_published),
            date_published
        ) AS inter_movie_days,
        duration,
        avg_rating,
        total_votes
    FROM director_movies
)
SELECT 
    director_id,
    director_name,
    COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(inter_movie_days), 2) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating), 2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM movie_gaps
GROUP BY director_id, director_name
ORDER BY number_of_movies DESC
LIMIT 9;



       
       
       
       







