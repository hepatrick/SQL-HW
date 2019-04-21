/* 1a, Display the first and last names of all actors from the table actor */
select a.first_name, a.last_name from actor a;

/* 1b. Display the first and last name of each actor in a single column in upper case letters. 
Name the column Actor Name. */
select upper(concat(a.first_name,' ', a.last_name)) as ACTOR_NAME from actor a;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information? */
select a.actor_id, a.first_name, a.last_name from actor a
where a.first_name = 'Joe';

/* 2b. Find all actors whose last name contain the letters GEN */
select * from actor a
where upper(a.last_name) like '%GEN%';

/* 2c. Find all actors whose last names contain the letters LI. 
This time, order the rows by last name and first name, in that order: */
select * from actor a
where upper(a.last_name) like '%LI%'
order by a.last_name, a.first_name;

/* 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China: */
select c.country_id, c.country from country c
where c.country in ('Afghanistan', 'Bangladesh', 'China');

/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant). */
alter table actor
add column DESCRIPTION blob;

/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column. */
alter table actor
drop column DESCRIPTION;

/* 4a. List the last names of actors, as well as how many actors have that last name. */
select a.last_name, count(a.actor_id) from actor a
group by a.last_name;

/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors */
select a.last_name, count(a.actor_id) from actor a
group by a.last_name
having count(a.actor_id) >= 2;

/* 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record. */
update actor a
set a.first_name = 'HARPO'
where a.first_name = 'GROUCHO'
and a.last_name = 'WILLIAMS';

/* 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. */
update actor a
set a.first_name = 'GROUCHO'
where a.first_name = 'HARPO'
and a.last_name = 'WILLIAMS';

/* 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? */
create table address_backup (
`address_id` int(5) NOT NULL auto_increment,
`address` varchar(50),
`address2` varchar(50),
`distinct` varchar(20),
`city_id` int(5),
`postal_code` int(10),
`phone` varchar(20),
`location` geometry,
`last_update` timestamp,
primary key (`address_id`))
ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address: */
select distinct s.first_name, s.last_name, a.address from staff s
inner join address a on s.address_id = a.address_id;

/* 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment. */
select staff.first_name, staff.last_name, sum(payment.amount) from payment, staff
where payment.staff_id = staff.staff_id
and payment.payment_date like '2005-08%'
group by staff.first_name, staff.last_name;

/* 6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join. */
select film.film_id, film.title, count(film_actor.actor_id) from film
inner join film_actor on film_actor.film_id = film.film_id 
group by film.film_id, film.title;

/* 6d. How many copies of the film Hunchback Impossible exist in the inventory system? */
select film.title, count(inventory.inventory_id) from inventory, film
where inventory.film_id = film.film_id
and film.title = 'Hunchback Impossible'
group by film.title;

/* 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name: */
select customer.first_name, customer.last_name, sum(payment.amount) as `Total Amount Paid`
from payment
inner join customer on customer.customer_id = payment.customer_id
group by customer.first_name, customer.last_name
order by customer.last_name;

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
films starting with the letters K and Q have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. */
select film.title from film
where film.language_id in
(select language.language_id from language
where language.name = 'English')
and (film.title like 'K%' or film.title like 'Q%');

/* 7b. Use subqueries to display all actors who appear in the film Alone Trip. */
select actor.actor_id, actor.first_name, actor.last_name from actor
where actor.actor_id in
(select actor_id from film_actor
where film_id in
(select film_id from film
where film.title = 'Alone Trip'));

/* 7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information. */
select country.country, customer.first_name, customer.last_name, customer.email 
from customer, address, city, country
where customer.address_id = address.address_id
and address.city_id = city.city_id
and city.country_id = country.country_id
and country.country = 'Canada';

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films. */
select film.* from film_category, film, category
where film_category.category_id = category.category_id
and film_category.film_id = film.film_id
and category.name = 'Family';

/* 7e. Display the most frequently rented movies in descending order. */
select film.title, count(distinct rental.rental_id) from rental, inventory, film
where rental.inventory_id = inventory.inventory_id
and film.film_id = inventory.film_id
group by film.title
order by count(distinct rental.rental_id) desc;

/* 7f. Write a query to display how much business, in dollars, each store brought in. */
select store.store_id, sum(payment.amount) from staff, store, payment
where staff.store_id = store.store_id
and payment.staff_id = staff.staff_id
group by store.store_id;

/* 7g. Write a query to display for each store its store ID, city, and country. */
select store.store_id, city.city, country.country from store, address, city, country
where store.address_id = address.address_id
and address.city_id = city.city_id
and city.country_id = country.country_id;

/* 7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */
select category.name, sum(payment.amount) from film_category, category, inventory, rental, payment
where film_category.category_id = category.category_id
and film_category.film_id = inventory.film_id
and inventory.inventory_id = rental.inventory_id
and payment.rental_id = rental.rental_id
group by category.name
order by sum(payment.amount) desc;

/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. */
CREATE VIEW `top_five_genres` AS
select category.name, sum(payment.amount) from film_category, category, inventory, rental, payment
where film_category.category_id = category.category_id
and film_category.film_id = inventory.film_id
and inventory.inventory_id = rental.inventory_id
and payment.rental_id = rental.rental_id
group by category.name
order by sum(payment.amount) desc;

/* 8b. How would you display the view that you created in 8a? */
select * from top_five_genres;

/* 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. */
drop view top_five_genres;

