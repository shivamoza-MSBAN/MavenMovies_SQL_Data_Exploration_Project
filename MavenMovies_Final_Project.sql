/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 	CONCAT(s.first_name, ' ', s.last_name) AS manager_full_name,
		a.address,
        a.district,
        c.city,
        ct.country
FROM 	staff AS s
INNER JOIN address AS a
ON		s.address_id  = a.address_id
INNER JOIN city AS c
ON		a.city_id = c.city_id
INNER JOIN country AS ct
ON		c.country_id = ct.country_id;

	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 	f.film_id, 
		i.inventory_id,
        i.store_id,
		f.title, 
        f.rating,
        f.rental_rate,
        f.replacement_cost 
FROM 	film AS f 
INNER JOIN inventory AS i
ON		f.film_id = i.film_id;


/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

SELECT 	i.store_id,
        f.rating,
        COUNT(i.inventory_id) AS total_numbrer_of_items
FROM 	film AS f 
INNER JOIN inventory AS i
ON		f.film_id = i.film_id
GROUP BY i.store_id,
         f.rating
ORDER BY store_id;


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

SELECT	store_id,
		c.name AS category,
		COUNT(i.inventory_id) AS films,
        AVG(f.replacement_cost) AS avg_replacement_cost,
        SUM(f.replacement_cost) AS total_replacement_cost
FROM	inventory AS i
LEFT JOIN film AS f
ON		i.film_id = f.film_id
LEFT JOIN film_category AS fc
ON		f.film_id = fc.film_id
LEFT JOIN category AS c
ON		c.category_id = fc.category_id

GROUP BY 	store_id, category; 


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT * FROM customer; -- cusotmer_id, store_id, address_id
SELECT * FROM city; -- city_id, country_id
SELECT * FROM address; -- city_id
SELECT * FROM country; -- cusotmer_id


SELECT	CONCAT(first_name, ' ', last_name) AS customer_full_name,
		cm.store_id,
		a.address,
        c.city,
        ct.country,
        IF(active = 1, "Active", "Inactive") AS active_status
FROM	customer AS cm
LEFT JOIN address AS a
ON		cm.address_id = a.address_id
LEFT JOIN city AS c
ON		c.city_id = a.city_id
LEFT JOIN country AS ct
ON		c.country_id = ct.country_id;


/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM customer;

SELECT	CONCAT(first_name, ' ', last_name) AS customer_full_name,
		COUNT(r.rental_id) AS total_rentals,
        SUM(amount) AS total_payment_amount
FROM	customer AS c
LEFT JOIN rental AS r
ON 		c.customer_id = r.customer_id
LEFT JOIN payment AS p
ON		p.rental_id = r.rental_id
GROUP BY customer_full_name
ORDER BY total_payment_amount DESC;

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

SELECT 'Investor' AS type, first_name, last_name, company_name FROM investor
UNION
SELECT 'Advisor' AS type, first_name, last_name, NULL FROM advisor;
