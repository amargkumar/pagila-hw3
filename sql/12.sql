/* 
 * A new James Bond movie will be released soon, and management wants to send promotional material to "action fanatics".
 * They've decided that an action fanatic is any customer where at least 4 of their 5 most recently rented movies are action movies.
 *
 * Write a SQL query that finds all action fanatics.
 */

SELECT customer_id, first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT r.customer_id,
               row_number() OVER (PARTITION BY r.customer_id ORDER BY r.rental_date DESC) AS rn,
               EXISTS (
                   SELECT 1 FROM film_category fc JOIN category c USING (category_id)
                   WHERE fc.film_id = i.film_id AND c.name = 'Action'
               ) AS is_action
        FROM rental r
        JOIN inventory i USING (inventory_id)
    ) t
    WHERE rn <= 5
    GROUP BY customer_id
    HAVING count(*) FILTER (WHERE is_action) >= 4
)
ORDER BY customer_id;
