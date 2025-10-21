USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
  COUNT(*) AS Total_Movies 
FROM 
  movie;
  
SELECT 
  COUNT(*) AS Total_Genres 
FROM 
  genre;

SELECT 
  COUNT(*) AS Total_DirectorMappings 
FROM 
  director_mapping;

SELECT 
  COUNT(*) AS Total_RoleMappings 
FROM 
  role_mapping;

SELECT 
  COUNT(*) AS Total_Names 
FROM 
  names;

SELECT 
  COUNT(*) AS Total_Ratings 
FROM 
  ratings;


/* OR */


SELECT 
  table_name, 
  table_rows
FROM 
  INFORMATION_SCHEMA.TABLES 
WHERE 
  TABLE_SCHEMA = 'imdb'; -- To determine the total number of rows in each table of our 'imdb' database





-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the title field has either null or an empty string ('')
WHERE 
  title IS NULL 
  OR title = '';

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the year field has either null or an empty string ('')
WHERE 
  year IS NULL 
  OR year = '';

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the date_published field is null
WHERE 
  date_published IS NULL;

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the duration field is null
WHERE 
  duration IS NULL;

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the country field has either null or an empty string ('')
WHERE 
  country IS NULL 
  OR country = '';

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the worlwide_gross_income field has either null or an empty string ('')
WHERE 
  worlwide_gross_income IS NULL 
  OR worlwide_gross_income = '';

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the languages field has either null or an empty string ('')
WHERE 
  languages IS NULL 
  OR languages = '';

SELECT 
  count(*) 
FROM 
  movie -- Counting the number of null values where the production_company field has either null or an empty string ('')
WHERE 
  production_company IS NULL 
  OR production_company = '';





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

SELECT 
  year AS Year, 
  count(distinct id) AS number_of_movies
FROM 
  movie 
GROUP BY 
  year; -- Query for the first part of the question

SELECT 
  month(date_published) AS month_num, 
  count(distinct id) AS number_of_movies 
FROM 
  movie 
GROUP BY 
  month(date_published) 
ORDER BY 
  month_num; -- Query for the second part of the question





/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

WITH USA_IND -- Determining the number of movies produced in the USA or India in 2019
AS (
  SELECT 
    * 
  FROM 
    movie 
  WHERE 
    country LIKE '%USA%' 
    OR country LIKE '%India%'
) 
SELECT 
  count(DISTINCT id) AS count_of_movies_2019_for_USA_or_India 
FROM 
  USA_IND 
WHERE 
  year = 2019;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT 
  distinct genre -- Retrieving a unique or distinct list of genres
FROM 
  genre;





/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
  count(DISTINCT id) AS num_of_movies, -- Counting the distinct movie IDs for each genre
  genre 
FROM 
  genre AS g 
  LEFT JOIN movie AS m -- Performing a left join between the genre and movies tables to ensure that all genres from the genre dataset are preserved
  ON g.movie_id = m.id 
GROUP BY 
  genre 
ORDER BY 
  num_of_movies DESC -- Sorting genres based on the number of movies
LIMIT 1; -- Selecting the top one drama genre which has the highest number of movies produced





/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Movies_with_genre_1 AS (
  SELECT 
    id, 
    title, 
    count(genre) AS num_of_genres -- Number of genres associated with a movie
  FROM 
    genre AS g 
    INNER JOIN movie AS m -- Combining the genre data with the movies data
    ON g.movie_id = m.id 
  GROUP BY 
    id 
  HAVING 
    num_of_genres = 1 -- Selecting movies that are associated with only one genre
    ) 
SELECT 
  count(DISTINCT id) AS 'count of movies with 1 genre' 
FROM 
  Movies_with_genre_1;





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

WITH movies_with_genre_1 AS (
  SELECT 
    id, 
    title, 
    count(genre) AS num_of_genres, -- Number of genres associated with a movie
    genre, 
    duration 
  FROM 
    genre AS g 
    INNER JOIN movie AS m -- Combining the genre data with the movies data
    ON g.movie_id = m.id 
  GROUP BY 
    id 
  HAVING 
    num_of_genres = 1 -- Selecting movies that are associated with only one genre
    ) 
SELECT 
  genre, 
  avg(duration) AS avg_duration 
FROM 
  movies_with_genre_1 
GROUP BY 
  genre;





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

SELECT 
  genre, 
  count(DISTINCT id) AS movie_count, -- Counting the distinct movie IDs for each genre
  RANK() OVER(
    ORDER BY 
      count(DISTINCT id) DESC
  ) AS genre_rank -- Ranking each entry based on the count of distinct movie IDs or movie count 
FROM 
  genre AS g 
  LEFT JOIN movie AS m -- Combining the genre data with the movies data using a left join to ensure all genres from the genre dataset are included
  ON g.movie_id = m.id 
GROUP BY 
  genre;





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

SELECT 
  min(avg_rating) AS min_avg_rating, 
  max(avg_rating) AS max_avg_rating, 
  min(total_votes) AS min_total_votes, 
  max(total_votes) AS max_total_votes, 
  min(median_rating) AS min_median_rating, 
  max(median_rating) AS max_median_rating 
FROM 
  ratings; 


    

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

WITH ranked_ratings AS (
  SELECT 
    title, 
    avg_rating, 
    RANK() OVER(window_rating) AS movie_rank -- Ranking movies based on their average ratings
  FROM 
    ratings AS r 
    INNER JOIN movie AS m -- Combining the ratings data with the movies data
    ON r.movie_id = m.id WINDOW window_rating AS (
      ORDER BY 
        avg_rating DESC
    ) -- Creating a window to rank movies based on their average ratings
    ) 
SELECT 
  * 
FROM 
  ranked_ratings 
WHERE 
  movie_rank <= 10;





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

SELECT 
  median_rating, 
  count(DISTINCT id) AS movie_count -- Determining the number of movies for each rating
FROM 
  ratings AS r 
  INNER JOIN movie AS m -- Combining the ratings and movies tables
  ON r.movie_id = m.id 
GROUP BY 
  median_rating -- Categorizing by rating
ORDER BY 
  movie_count DESC;





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

WITH hit_movie_list -- Identifying all hit movies and their production companies that have an average rating exceeding 8
AS (
  SELECT 
    production_company, 
    id, 
    title, 
    avg_rating 
  FROM 
    movie AS m 
    INNER JOIN ratings AS r -- Combining the movies and ratings tables
    ON m.id = r.movie_id 
  WHERE 
    avg_rating > 8 -- Movie is classified as a hit if its average rating exceeds more than 8
    ) 
SELECT 
  production_company, 
  count(DISTINCT id) AS movie_count, -- The number of hit movies produced by each production house
  RANK() OVER(
    ORDER BY 
      count(DISTINCT id) DESC
  ) AS prod_company_rank -- Ranking production companies based on the number of hit movies they have produced
FROM 
  hit_movie_list 
GROUP BY 
  production_company 
ORDER BY 
  movie_count DESC; -- Arranging the production houses based on the number of hit movies they have produced





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

WITH USA_movies AS (
  SELECT 
    id, 
    year, 
    date_published, 
    country, 
    genre, 
    total_votes -- Filtering all the movies released in the USA in March 2017 that have received more than 1,000 votes
  FROM 
    movie AS m 
    INNER JOIN genre AS g ON m.id = g.movie_id -- Combining the movies and genre table
    INNER JOIN ratings AS r -- And now combining with ratings table
    ON m.id = r.movie_id 
  WHERE 
    year = 2017 
    AND month(date_published)= 3 
    AND country LIKE '%USA%' 
    AND total_votes > 1000
) 
SELECT 
  genre, 
  count(id) AS movie_count -- Count of movies/genre
FROM 
  USA_movies 
GROUP BY 
  genre 
ORDER BY
  movie_count DESC; 





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

SELECT 
  title, 
  avg_rating, 
  genre 
FROM 
  movie AS m 
  INNER JOIN genre AS g ON m.id = g.movie_id -- Combining the movies and genre table
  INNER JOIN ratings AS r -- And now combining with ratings table
  ON m.id = r.movie_id 
WHERE 
  title LIKE 'The%' 
  AND avg_rating > 8 -- Filtering the movies that begins with "The" and have an average rating greater than 8
ORDER BY 
  genre;





-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
  count(DISTINCT id) AS movie_count -- Count of the movies
FROM 
  movie AS m 
  INNER JOIN ratings AS r -- Combining the movies and ratings table
  ON m.id = r.movie_id 
WHERE 
  (
    date_published BETWEEN '2018-04-01' 
    AND '2019-04-01'
  ) 
  AND median_rating = 8 -- Filtering the movies released between April 1, 2018 and April 1, 2019 that received a median rating of 8 
ORDER BY 
  date_published;





-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
  sum(total_votes) AS votes_count -- Count of the German Movies
FROM 
  movie AS m 
  INNER JOIN ratings AS r -- Combining the movies and ratings tables
  ON m.id = r.movie_id 
WHERE 
  country LIKE '%Germany%';

SELECT 
  sum(total_votes) AS votes_count -- Count of the Italian Movies
FROM 
  movie AS m 
  INNER JOIN ratings AS r -- Combining the movies and ratings tables
  ON m.id = r.movie_id 
WHERE 
  country LIKE '%Italy%';





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

SELECT 
  count(*) as name_nulls
FROM 
  names 
WHERE 
  name IS NULL;

SELECT 
  count(*) as height_nulls
FROM 
  names 
WHERE 
  height IS NULL;

SELECT 
  count(*) as date_of_birth_nulls
FROM 
  names 
WHERE 
  date_of_birth IS NULL;

SELECT 
  count(*) as known_for_moviesh_nulls 
FROM 
  names 
WHERE 
  known_for_movies IS NULL;





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

WITH directors_in_top_3_genres
AS (
  SELECT 
    n.name AS director_name, 
    d.name_id, 
    d.movie_id, 
    g.genre 
  FROM 
    director_mapping AS d 
    INNER JOIN names AS n -- Combining the names table with director_mapping table to get the director's names
    ON d.name_id = n.id 
    INNER JOIN ratings AS r -- And now combining the ratings table to get rating values on an average
    ON d.movie_id = r.movie_id 
    INNER JOIN genre AS g -- And now combining the genre table to get the genres
    ON d.movie_id = g.movie_id 
  WHERE 
    avg_rating > 8 
    AND (
      genre = 'Drama' 
      OR genre = 'Comedy' 
      OR genre = 'Thriller'
    ) -- Filtering out the movies that have an average rating > 8 and belonging to the genres of ‘Drama,’ ‘Comedy,’ or ‘Thriller,’ as we’ve established in earlier query responses that these three are the top most prolific genres in terms of movie production
  ORDER BY 
  name
) 
SELECT 
  director_name, 
  count(DISTINCT movie_id) AS movie_count -- Count of the movies
FROM 
  directors_in_top_3_genres 
GROUP BY 
  director_name 
ORDER BY 
  movie_count DESC -- Arranging the top 3 directors based on top 3 genres
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

WITH actors AS(
  SELECT 
    n.name AS actor_name, 
    rm.name_id, 
    rm.movie_id, 
    r.median_rating 
  FROM 
    role_mapping AS rm 
    INNER JOIN names AS n -- Combining role_mapping table with names table to get the actor's names
    ON rm.name_id = n.id 
    INNER JOIN ratings AS r -- And now combining the ratings table to get the values on median rating
    ON rm.movie_id = r.movie_id 
  WHERE 
    category = 'actor' 
    AND median_rating >= 8 -- Identifying all actors whose films have a median rating of 8 or higher
    ) 
SELECT 
  actor_name, 
  count(distinct movie_id) AS movie_count -- Count of the movies
FROM 
  actors 
GROUP BY
  actor_name 
ORDER BY 
  movie_count DESC -- Filtering out the top 2 actors who has made the most movies with median rating 8 or higher
LIMIT 2;





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

WITH prod_houses_ranked AS (
  SELECT 
    m.production_company, 
    sum(r.total_votes) AS votes_count, -- Summation of total votes/production house
    row_number() OVER(
      ORDER BY 
        sum(r.total_votes) DESC
    ) AS prod_comp_rank -- List the ranking of each production house based on the total number of votes they have received
  FROM 
    movie AS m 
    INNER JOIN ratings AS r -- Combining the ratings table with movie table to get the total votes
    ON m.id = r.movie_id 
  GROUP BY 
    production_company -- Grouping by production house 
  ORDER BY 
    votes_count DESC -- Arranging by total votes received
    ) 
SELECT 
  * 
FROM 
  prod_houses_ranked 
WHERE 
  prod_comp_rank <= 3;





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

CREATE VIEW ACTORS AS -- This table is created and used for storing information about actor's
SELECT 
  * 
FROM 
  role_mapping AS rm 
  INNER JOIN names AS n ON rm.name_id = n.id 
WHERE 
  category = 'actor';

CREATE VIEW INDIAN_MOVIES AS -- This table is created and used for storing information on Indian Movies
SELECT 
  * 
FROM 
  movie 
WHERE 
  country LIKE '%India%';

SELECT 
  a.name AS actor_name, 
  sum(r.total_votes) AS total_votes, 
  count(DISTINCT a.movie_id) AS movie_count, 
  (
    sum(r.avg_rating * r.total_votes)/ sum(r.total_votes)
  ) AS actor_avg_rating, -- Calculating the weighted average rating for each actor by using the total votes as the weighting factor
  RANK() OVER(
    ORDER BY 
      (
        sum(r.avg_rating * r.total_votes)/ sum(r.total_votes)
      ) DESC, 
      r.total_votes DESC
  ) AS actor_rank -- Ranking actors based on their average rating, and for those with identical average ratings, sort them by total votes in descending order
FROM 
  ACTORS AS a 
  INNER JOIN INDIAN_MOVIES AS mi -- Combining the ACTORS table with the INDIAN_MOVIES table
  ON a.movie_id = mi.id 
  INNER JOIN ratings AS r -- And now combining the ratings table
  ON a.movie_id = r.movie_id 
GROUP BY
  actor_name
HAVING 
  movie_count >= 5 
LIMIT 1;

DROP 
  VIEW ACTORS;

DROP 
  VIEW INDIAN_MOVIES; -- Dropping both tables ACTORS and INDIAN_MOVIES as our task is completed succesfully





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

CREATE VIEW ACTRESSES AS -- This table is created and used for storing the ACTRESSES details
SELECT 
  * 
FROM 
  role_mapping AS rm 
  INNER JOIN names AS n ON rm.name_id = n.id 
WHERE 
  category = 'actress';

CREATE VIEW INDIAN_HINDI_MOVIES AS -- This table is created and used for storing the details of hindi movies in India
SELECT 
  * 
FROM 
  movie 
WHERE 
  country LIKE '%India%' 
  and languages LIKE '%Hindi%'; -- Filtering movies by country = India and languages = Hindi

SELECT 
  a.name AS actress_name, 
  sum(r.total_votes) AS total_votes, 
  count(distinct a.movie_id) AS movie_count, 
  (
    sum(r.avg_rating * r.total_votes)/ sum(r.total_votes)
  ) AS actress_avg_rating, -- Calculating the weighted average rating for each actress by using the total votes as the weighting factor
  RANK() OVER(
    ORDER BY 
      (
        sum(r.avg_rating * r.total_votes)/ sum(r.total_votes)
      ) DESC, 
      r.total_votes DESC
  ) as actress_rank -- Ranking actresses according to their average rating, and for those with the same average rating, order them by total votes in descending order
FROM 
  ACTRESSES AS a 
  INNER JOIN INDIAN_HINDI_MOVIES AS mi -- Combining the ACTRESSES table with the INDIAN_HINDI_MOVIES
  ON a.movie_id = mi.id 
  INNER JOIN ratings AS r -- And now combining the ratings table
  ON a.movie_id = r.movie_id 
GROUP BY 
  actress_name
HAVING 
  movie_count >= 3 
LIMIT 3;





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

WITH thriller_movies AS (
  SELECT 
    m.title, 
    m.id, 
    g.genre, 
    r.avg_rating 
  FROM 
    genre AS g 
    INNER JOIN ratings AS r -- Combining the genre table with ratings table
    ON g.movie_id = r.movie_id -- And now combining the movie table
    INNER JOIN movie AS m ON g.movie_id = m.id 
  WHERE 
    g.genre = 'Thriller' -- Filtering out by thriller movies
    ) 
SELECT 
  title AS movie_name, 
  CASE -- Categorizing movies into various groups according to their average rating
  WHEN avg_rating > 8 THEN 'Superhit' WHEN avg_rating BETWEEN 7 
  AND 8 THEN 'Hit' WHEN avg_rating BETWEEN 5 
  AND 7 THEN 'One-time-watch' WHEN avg_rating < 5 THEN 'Flop' END AS Movie_Category 
FROM 
  thriller_movies
  ORDER BY 
  avg_rating DESC;  -- Sorting by average ratings in descending order





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

WITH avg_duration_per_genre AS ( 
  SELECT 
    genre, 
    avg(duration) AS avg_duration 
  FROM 
    movie AS m 
    INNER JOIN genre AS g ON m.id = g.movie_id 
  GROUP BY 
    genre
) 
SELECT 
  *, 
  sum(
    round(avg_duration, 2)
  ) OVER w1 AS running_total_duration, -- Calculating the cumulative sum of the average duration for each genre 
  avg(avg_duration) OVER w2 AS moving_avg_duration -- Calculating the moving averages of the average duration for each genre 
FROM 
  avg_duration_per_genre WINDOW w1 AS (
    ORDER BY 
      genre ROWS UNBOUNDED PRECEDING
  ),
  w2 AS (
    ORDER BY 
      genre ROWS UNBOUNDED PRECEDING
  );





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

WITH movies_ranked_by_grossIncome AS(
  SELECT 
    genre, 
    year, 
    title AS movie_name, 
    worlwide_gross_income, 
    dense_rank() OVER (
      PARTITION BY year 
      ORDER BY 
        worlwide_gross_income DESC
    ) AS movie_rank -- Ranking each year individually based on worldwide_gross_income
  FROM 
    movie m 
    INNER JOIN genre g ON -- Combining the movie table with genre table
    m.id = g.movie_id 
  WHERE 
    genre = 'Drama' 
    OR genre = 'Comedy' 
    OR genre = 'Thriller' -- We have established from our earlier query responses that Drama, Comedy, and Thriller are the three leading genres based on the number of movies produced
    ) 
SELECT 
  * 
FROM 
  movies_ranked_by_grossIncome -- Selecting top 5 ranked movies for each year 
WHERE 
  movie_rank <= 5;

-- Tried out for Reference purposes!
SELECT 
  * 
FROM 
  movie 
WHERE 
  worlwide_gross_income IS NOT NULL 
  AND worlwide_gross_income LIKE '%INR%'; -- Filtering out the movies where the gross income includes the currency 'INR' 





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

SELECT 
  production_company, 
  count(m.id) AS movie_count, 
  rank() OVER (
    ORDER BY 
      count(m.id) DESC
  ) AS prod_comp_rank -- Ranking based on the number of successful movies that have a median rating of 8 or higher
FROM 
  movie m 
  JOIN ratings r ON m.id = r.movie_id -- Combining movie and ratings table to get the median rating
WHERE 
  median_rating >= 8 
  AND production_company IS NOT NULL 
  AND POSITION(',' IN languages)> 0 -- A movie is considered as hit if its median rating is 8 or higher
GROUP BY 
  production_company
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

SELECT 
  n.name AS actress_name, 
  sum(r.total_votes) AS total_votes, 
  count(rm.movie_id) AS movie_count, 
  r.avg_rating AS actress_avg_rating, 
  rank() OVER (
    ORDER BY 
      avg_rating DESC
  ) AS actress_rank -- Ranking each actress based on the number of superhit movies
FROM 
  names n 
  JOIN role_mapping rm -- Combining the role_mapping table with names table
  ON n.id = rm.name_id 
  JOIN ratings r -- And now combining the ratings table
  ON rm.movie_id = r.movie_id 
  JOIN genre g -- And now combining the genre table
  ON r.movie_id = g.movie_id 
WHERE 
  genre = 'drama' 
  AND category = 'actress' 
  AND avg_rating > 8 -- Filtering the actresses in the drama genre who has movies with an average rating greater than 8
GROUP BY 
  actress_name
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

WITH director_details AS (
  SELECT 
    name_id AS director_id, 
    name AS director_name, 
    dm.movie_id, 
    m.title, 
    m.date_published, 
    r.avg_rating, 
    r.total_votes, 
    m.duration 
  FROM 
    director_mapping AS dm 
    INNER JOIN names AS n -- Combining names table with director_mapping table
    ON dm.name_id = n.id 
    INNER JOIN movie AS m -- And now combining the movies table
    ON dm.movie_id = m.id 
    INNER JOIN ratings AS r -- And now combining the ratings table
    ON dm.movie_id = r.movie_id
), 
next_date_published AS (
  SELECT 
    *, 
    lead(date_published, 1) OVER(
      PARTITION BY director_id 
      ORDER BY 
        date_published, 
        movie_id
    ) AS next_date_published -- This will determine the upcoming release date for each director’s next film
  FROM 
    director_details
), 
diff_in_date_published_in_days
AS (
  SELECT 
    *, 
    datediff(
      next_date_published, date_published
    ) AS inter_movie_duration
  FROM 
    next_date_published
), 
directors_ranked AS (
  SELECT 
    director_id, 
    director_name, 
    count(movie_id) AS number_of_movies, 
    avg(inter_movie_duration) AS avg_inter_movie_days, 
    avg(avg_rating) AS avg_rating, 
    sum(total_votes) AS total_votes, 
    min(avg_rating) AS min_rating, 
    max(avg_rating) AS max_rating, 
    sum(duration) AS total_duration, 
    ROW_NUMBER() OVER(
      ORDER BY 
        count(movie_id) DESC, 
        avg_rating DESC
    ) AS rank_of_director -- Ranking all directors according to the number of movies they have produced, and for those with the same rank, we will resolve ties using their average rating
  FROM 
    diff_in_date_published_in_days 
  GROUP BY 
    director_id
    ) 
SELECT 
  director_id,
  director_name, 
  number_of_movies, 
  avg_inter_movie_days, 
  avg_rating, 
  total_votes, 
  min_rating, 
  max_rating, 
  total_duration 
FROM 
  directors_ranked 
WHERE 
  rank_of_director <= 9; -- Filtering out the top 9 directors




  