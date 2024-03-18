/* PROBLEM 1:
 *
 * The Office of Foreign Assets Control (OFAC) is the portion of the US government that enforces international sanctions.
 * OFAC is conducting an investigation of the Pagila company to see if you are complying with sanctions against North Korea.
 * Current sanctions limit the amount of money that can be transferred into or out of North Korea to $5000 per year.
 * (You don't have to read the official sanctions documents, but they're available online at <https://home.treasury.gov/policy-issues/financial-sanctions/sanctions-programs-and-country-information/north-korea-sanctions>.)
 * You have been assigned to assist the OFAC auditors.
 *
 * Write a SQL query that:
 * Computes the total revenue from customers in North Korea.
 *
 * NOTE:
 * All payments in the pagila database occurred in 2022,
 * so there is no need to do a breakdown of revenue per year.
 */

SELECT customer_id, sum(amount) 
from payment 
join customer using(customer_id) 
join address using(address_id) 
join city using(city_id) 
join country using(country_id) 
where country_id=70 
group by customer_id 
order by sum(amount) desc;





/* PROBLEM 2:
 *
 * Management wants to hire a family-friendly actor to do a commercial,
 * and so they want to know which family-friendly actors generate the most revenue.
 *
 * Write a SQL query that:
 * Lists the first and last names of all actors who have appeared in movies in the "Family" category,
 * but that have never appeared in movies in the "Horror" category.
 * For each actor, you should also list the total amount that customers have paid to rent films that the actor has been in.
 * Order the results so that actors generating the most revenue are at the top.
 */

SELECT first_name || ' ' || last_name as "Actor Name", sum(amount) as "Revenue" 
from actor 
join film_actor using(actor_id) 
join film using(film_id) 
join inventory using(film_id) 
join rental using(inventory_id) 
join payment using(customer_id) 
where actor_id in (
    select actor_id 
    from film_actor 
    join film_category using(film_id) 
    join category using(category_id) 
    where category_id=8
) 
and actor_id not in (
    select actor_id 
    from film_actor 
    join film_category using(film_id) 
    join category using(category_id) 
    where category_id=11
) group by "Actor Name" 
order by "Revenue" desc;





/* PROBLEM 3:
 *
 * You love the acting in AGENT TRUMAN, but you hate the actor RUSSELL BACALL.
 *
 * Write a SQL query that lists all of the actors who starred in AGENT TRUMAN
 * but have never co-starred with RUSSEL BACALL in any movie.
 */

SELECT select distinct first_name || ' ' || last_name as "Actor Name"
from actor
join film_actor using(actor_id)
join film using(film_id)
where title like 'AGENT TRUMAN'
and first_name || ' ' || last_name not in (
    select distinct first_name || ' ' || last_name
    from actor
    join film_actor using(actor_id)
    join film using(film_id)
    where title <> 'AGENT TRUMAN'
    and actor_id in (
        select actor_id
        from film_actor
        join film using (film_id)
        where title like 'AGENT TRUMAN'
    ) 
    and actor_id in (
        select actor_id
        from film_actor
        join film using(film_id)
        where title <> 'AGENT TRUMAN'
        and title in (
            select title
            from film
            join film_actor using(film_id)
            join actor using(actor_id)
            where first_name || ' ' || last_name like 'RUSSELL BACALL'
        )
    )
);





/* PROBLEM 4:
 *
 * You want to watch a movie tonight.
 * But you're superstitious,
 * and don't want anything to do with the letter 'F'.
 * List the titles of all movies that:
 * 1) do not have the letter 'F' in their title,
 * 2) have no actors with the letter 'F' in their names (first or last),
 * 3) have never been rented by a customer with the letter 'F' in their names (first or last).
 *
 * NOTE:
 * Your results should not contain any duplicate titles.
 */

SELECT distinct title 
from film 
left join film_actor using(film_id) 
left join actor using(actor_id) 
left join inventory using(film_id) 
left join rental using(inventory_id) 
left join customer using(customer_id) 
where title not like '%F%' and actor.first_name || ' ' || actor.last_name not like '%F%' and customer.first_name || ' ' || customer.last_name not like '%F%' 
order by title;

