#You need to use SQL built-in functions to gain insights relating to the duration of movies:
#1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
USE sakila;

SELECT MAX(length) AS max_length, MIN(length) AS min_length
FROM film;

#1.2. Express the average movie duration in hours and minutes. Don't use decimals.
#Hint: Look for floor and round functions.

SELECT
		FLOOR(AVG(length) / 60) as average_hours,
		ROUND(AVG(length) % 60) as average_minutes
FROM film;

# 2 You need to gain insights related to rental dates:

# 2.1 Calculate the number of days that the company has been operating.
# Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest
# date in the rental_date column from the latest date.

SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) as days_operating
FROM rental;

######## Random Q: what if I want to calculate the date of a specific time. It's kind of easy to calculate from MAX to MIN..

#2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

SELECT *, MONTH(rental_date), YEAR(rental_date)
FROM rental;

#2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', 
#depending on the day of the week.
#Hint: use a conditional expression.

SELECT rental_id, rental_date, return_date,
  CASE 
	WHEN DAYOFWEEK(rental_date) IN (1, 7) THEN 'weekend'
    ELSE 'workday'
	END as DAY_TYPE
FROM rental;

#You need to ensure that customers can easily access information about the movie collection. 
#To achieve this, retrieve the film titles and their rental duration. 
#If any rental duration value is NULL, replace it with the string 'Not Available'. 
#Sort the results of the film title in ascending order.

#Please note that even if there are currently no null values in the rental duration column, 
#the query should still be written to handle such cases in the future.
#Hint: Look for the IFNULL() function.

#answer is film titles and rental duration
#if any answer is null, replace with rental duration
#ORDER BY ASC

SELECT title as film_title, IFNULL(rental_duration,'Not Available') as rental_duration
FROM film
ORDER BY title ASC;

#Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
#1.1 The total number of films that have been released.

SELECT COUNT(release_year), release_year
FROM film
GROUP BY release_year;

#1.2 The number of films for each rating.

SELECT COUNT(rating), rating
FROM film
GROUP BY rating;

#1.3 The number of films for each rating, sorting the results in descending order of the number of films. 

SELECT COUNT(rating), rating
FROM film
GROUP BY rating
ORDER BY COUNT(rating) DESC;

# Using the film table, determine:
# 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
# Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.

SELECT AVG(length), rating
FROM film
GROUP BY rating
ORDER BY AVG(length) DESC;

# 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers 
# who prefer longer movies.

#SELECT rating
#FROM film
#GROUP BY rating, length
#HAVING AVG(length)>120;

SELECT rating, average_duration
			FROM( SELECT rating, AVG(length) AS average_duration
				FROM film
				GROUP BY rating) AS rating_average
WHERE average_duration > 120;

#Bonus: determine which last names are not repeated in the table actor.

SELECT last_name
FROM actor
GROUP BY last_name
HAVING COUNT(*) = 1;

