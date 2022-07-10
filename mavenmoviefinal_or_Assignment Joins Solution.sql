use mavenmovies;

/* My partners and I want to come by each of the stores in person and meet the managers. Please send over the managers'
names at each store , with the full address of each property (street address,district , city , and country please). */
select 
	store.store_id,
    store.manager_staff_id,
    address.address,
    address.district,
    city.city,
    country.country
 from store,address,city,country
 where store.address_id=address.address_id and address.city_id=city.city_id
 and city.country_id=country.country_id;

/* I would like to get a better understanding of all of the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked , including the store_id number , the
inventory_id,the name of the film , the film's rating , its rental rate and replacement cost.*/

select 
	store.store_id,
    inventory.inventory_id,
    film.title,
    film.rating,
    film.replacement_cost
from store,inventory,film
where store.store_id=inventory.store_id and inventory.film_id=film.film_id;

/* From the same list of films you just pulled , please roll that data up and provide a summary level overview of your inventory.
We would like to know how many inventory items you have with each rating at each store. */

select 
	store.store_id,
    inventory.inventory_id,
    
    film.rating,
    count(film.rating)
from store,inventory,film
where store.store_id=inventory.store_id and inventory.film_id=film.film_id
group by store_id,inventory_id,rating;

/*Similarly, we want to understand how diversified the inventory is in terms of replacement cost.
We want to see how big of a hit it would be if a certain category of film became unpopular at a certain store. We would like to see
the number of films, as well as the average replacement cost , and total replacement cost , sliced by store and film category.*/

select 
	store.store_id,
    category.category_id,
    category.name,
	count(film.film_id),
    avg(film.replacement_cost)
from store,inventory , film , category ,film_category
where store.store_id=inventory.store_id and inventory.film_id=film.film_id and 
film.film_id=film_category.category_id and film_category.category_id=category.category_id
group by film_category.category_id
order by film_category.category_id ;
    
/* We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names , which store they go to , whether or not they are currently active, and their full 
address - street address , city and country.*/

select 
	customer.customer_id,
    CONCAT(customer.first_name,' ', customer .last_name ) name ,
    customer.store_id,
    customer.active,
    address.address,
	city.city,
    country.country
from customer , address, city , country 
where customer.address_id=address.address_id and address.city_id=city.city_id 
and city.country_id=country.country_id
order by customer_id;

/* We would like to understand how much your customers are spending with you , and also to know 
who your most valuable customers are . Please pull together a list of customer names, their total 
lifetime rentals , and the sum of all payments you have collected from them . It would be great to see this 
ordered on total lifetime value with the most valuable customers at the top of the list.*/

select 
	customer.customer_id,
    CONCAT (customer.first_name,' ',customer.last_name) name,
    count(rental.rental_id),
    sum(payment.amount)
from customer, rental , payment 
where customer.customer_id=rental.customer_id and rental.rental_id= payment.rental_id
group by customer_id
order by sum(payment.amount) desc;


/* My partner and I would like to get to know your board advisors and any current investors. Could you 
please provide a list of advisor and investor names in one table? Could you please note whether they are an 
investor or an advisor , and for the investors, it would be good to include which company they work with.*/

select 
	
    CONCAT(advisor.first_name,' ',advisor.last_name) as name ,
    case 
		when advisor.advisor_id>0 then "advisor"
        else "investor"
	end as status,
    case 
		when advisor.is_chairmain <0 then advisor.is_chairmain
        else "NULL"
	end as company_name
from advisor 
UNION 
select 
	
    CONCAT(first_name,' ' ,last_name) as name ,
    case 
		when investor.investor_id>0 then "investor"
        else "advisor"
	end as status,
    investor.company_name
    
from investor

/* We are interested in how well you have covered the most awarded actors. Of all the actors with three 
types of awards, for what % of them do we carry a film? And how about for actors with two types of awards? Same 
questions. Finally , how about actors with just one award?*/


select 
    distinct actor_award.awards ,
    count(film.film_id),
    (count(film.film_id)/max(film.film_id))*100 as percent

from actor_award,film_actor,film
where actor_award.actor_id=film_actor.actor_id and film_actor.film_id=film.film_id
group by actor_award.awards;

