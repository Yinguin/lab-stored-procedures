USE sakila;

DELIMITER //
CREATE PROCEDURE get_action_film_customers()
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = "Action"
  GROUP BY first_name, last_name, email;
END;
// DELIMITER ;

CALL get_action_film_customers();

DELIMITER //
CREATE PROCEDURE get_customers_by_category(IN category_name VARCHAR(100))
BEGIN
  SELECT first_name, last_name, email
  FROM customer
  JOIN rental ON customer.customer_id = rental.customer_id
  JOIN inventory ON rental.inventory_id = inventory.inventory_id
  JOIN film ON film.film_id = inventory.film_id
  JOIN film_category ON film_category.film_id = film.film_id
  JOIN category ON category.category_id = film_category.category_id
  WHERE category.name = category_name
  GROUP BY first_name, last_name, email;
END;
// DELIMITER ;

CALL get_customers_by_category("Animation");

SELECT category.name, COUNT(*) AS num_films
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
GROUP BY category.name;

DELIMITER //
CREATE PROCEDURE get_categories_with_min_films(IN param INT)
BEGIN
  SELECT category.name, COUNT(*) AS num_films
  FROM category
  JOIN film_category ON category.category_id = film_category.category_id
  JOIN film ON film_category.film_id = film.film_id
  GROUP BY category.name
  HAVING num_films >= param;
END;
// DELIMITER ;

CALL get_categories_with_min_films(60);