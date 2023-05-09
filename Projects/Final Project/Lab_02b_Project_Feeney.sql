-- --------------------------------------------------------------------------------------------------------------
-- TODO: Extract the appropriate data from the northwind database, and INSERT it into the Northwind_DW database.
-- --------------------------------------------------------------------------------------------------------------
USE sakila_dw;
-- ----------------------------------------------
-- Populate dim_customers
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_customer`
(`customer_id`,
`store_id`,
`first_name`,
`last_name`,
`email`,
`address_id`,
`active`,
`create_date`,
`last_update`)
SELECT
`customer_id`,
`store_id`,
`first_name`,
`last_name`,
`email`,
`address_id`,
`active`,
`create_date`,
`last_update`
FROM sakila.customer;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_customer;

-- ----------------------------------------------
-- Populate dim_address
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_address`
(`address_id`,
`address`,
`address2`,
`district`,
`postal_code`,
`phone`,
`location`,
`last_update`)
SELECT
`address_id`,
`address`,
`address2`,
`district`,
`postal_code`,
`phone`,
`location`,
`last_update`
FROM sakila.address;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_address;

-- ----------------------------------------------
-- Populate dim_film
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_film`
(`film_id`,
`title`,
`description`,
`release_year`,
`rental_duration`,
`rental_rate`,
`length`,
`replacement_cost`,
`rating`,
`special_features`,
`last_update`)
SELECT
`film_id`,
`title`,
`description`,
`release_year`,
`rental_duration`,
`rental_rate`,
`length`,
`replacement_cost`,
`rating`,
`special_features`,
`last_update`
FROM sakila.film;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_film;
-- ----------------------------------------------
-- Populate dim_inventory
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_inventory`
(`inventory_id`,
`film_id`,
`store_id`,
`last_update`)
SELECT
`inventory_id`,
`film_id`,
`store_id`,
`last_update`
FROM sakila.inventory;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_inventory;
-- ----------------------------------------------
-- Populate dim_staff
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_staff`
(`staff_id`,
`first_name`,
`last_name`,
`address_id`,
`picture`,
`email`,
`store_id`,
`active`,
`username`,
`password`,
`last_update`)
SELECT
`staff_id`,
`first_name`,
`last_name`,
`address_id`,
`picture`,
`email`,
`store_id`,
`active`,
`username`,
`password`,
`last_update`
FROM sakila.staff;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_staff;
-- ----------------------------------------------
-- Populate dim_store
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`dim_store`
(`store_id`,
`manager_staff_id`,
`address_id`,
`last_update`)
SELECT
`store_id`,
`manager_staff_id`,
`address_id`,
`last_update`
FROM sakila.store;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.dim_store;
-- ----------------------------------------------
-- Populate rental_fact
-- ----------------------------------------------
INSERT INTO `sakila_dw`.`rental_fact`
(`rental_id`,
`rental_date`,
#`rental_rate`,
`inventory_id`,
`customer_id`,
`return_date`,
`staff_id`,
#`store_id`,
`last_update`)
SELECT
`rental_id`,
`rental_date`,
#`rental_rate`,
`inventory_id`,
`customer_id`,
`return_date`,
`staff_id`,
#`store_id`,
`last_update`
FROM sakila.rental;

-- ----------------------------------------------
-- Validate that the Data was Inserted ----------
-- ----------------------------------------------
SELECT * FROM sakila_dw.rental_fact;
-- ----------------------------------------------
-- Add store_id and rental_rate columns to fact table ----------
-- ----------------------------------------------
#INSERT INTO rental_fact
SELECT `rental_fact`.`rental_id`,
    `rental_fact`.`rental_date`,
    `rental_fact`.`inventory_id`,
    `rental_fact`.`customer_id`,
    `rental_fact`.`return_date`,
    `rental_fact`.`staff_id`,
    `rental_fact`.`last_update`,
    `dim_inventory`.`film_id`,
    `dim_inventory`.`store_id`
FROM `sakila_dw`.`rental_fact`
LEFT JOIN dim_inventory
ON rental_fact.inventory_id = dim_inventory.inventory_id;

ALTER TABLE rental_fact ADD film_id smallint unsigned NOT NULL;
ALTER TABLE rental_fact ADD store_id smallint unsigned NOT NULL;

UPDATE rental_fact
INNER JOIN dim_inventory 
ON rental_fact.inventory_id = dim_inventory.inventory_id
SET rental_fact.film_id = dim_inventory.film_id;

UPDATE rental_fact
INNER JOIN dim_inventory 
ON rental_fact.inventory_id = dim_inventory.inventory_id
SET rental_fact.store_id = dim_inventory.store_id;

ALTER TABLE rental_fact ADD rental_rate decimal(4,2) NOT NULL DEFAULT '4.99';

UPDATE rental_fact
INNER JOIN dim_film 
ON rental_fact.film_id = dim_film.film_id
SET rental_fact.rental_rate = dim_film.rental_rate;

## run both versions of rental fact to make sure they are the same
SELECT * FROM sakila_dw.rental_fact;

SELECT * FROM sakila_dw2.rental_fact;

## RUN COMMANDS ON NEW FACT TABLE in dw2 to make sure data was transfered properly

##Which customers have checked out the most movies?
USE sakila_dw2;
SELECT customer_id, COUNT(rental_id)
FROM rental_fact
GROUP BY customer_id
ORDER BY COUNT(rental_id) DESC;
