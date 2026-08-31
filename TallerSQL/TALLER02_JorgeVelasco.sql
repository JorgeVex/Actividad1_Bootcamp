-- ============================================================
-- TALLER 3 - SQL Práctico (Sakila)
-- Autor: Jorge Hernán Velasco Gómez
-- Base de datos: sakila (MySQL)


USE sakila;


-- 1. Mostrar nombre y apellido de todos los clientes
SELECT first_name, last_name
FROM customer;

-- 2. Películas con duración mayor a 120 minutos
SELECT title, length
FROM film
WHERE length > 120;


-- PARTE 2 - ORDER BY

-- 3. Ordenar clientes por apellido (A a la Z)
SELECT first_name, last_name
FROM customer
ORDER BY last_name ASC;

-- 4. Top 5 películas más largas
SELECT title, length
FROM film
ORDER BY length DESC
LIMIT 5;



-- PARTE 3 - INNER JOIN


-- 5. Cantidad pagada y fecha del pago con nombre y apellido del cliente
--    (JOIN entre Payment - Customer)
SELECT c.first_name,
       c.last_name,
       p.amount,
       p.payment_date
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id;

-- 6. Películas alquiladas (JOIN entre Rental - Inventory - Film)
SELECT r.rental_id,
       r.rental_date,
       f.title
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id;



-- PARTE 4 - LEFT JOIN


-- 7. Nombre y apellido de clientes sin pagos
--    (LEFT JOIN entre Payment - Customer, filtrando con WHERE)
SELECT c.first_name,
       c.last_name
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

-- 8. Nombre de las películas y su duración de los títulos que no tienen actores
SELECT f.title,
       f.length
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
WHERE fa.actor_id IS NULL;



-- PARTE 5 - INSERT, UPDATE, DELETE


-- 9. Insertar actor temporal
INSERT INTO actor (first_name, last_name)
VALUES ('TEMPORAL', 'ACTOR');

-- 10. Actualizar actor
--     Se actualiza usando WHERE para identificar exactamente al actor temporal
UPDATE actor
SET first_name = 'TEMPORAL_MODIFICADO'
WHERE first_name = 'TEMPORAL' AND last_name = 'ACTOR';

-- 11. Eliminar actor
--     Se elimina usando WHERE para no afectar otros registros
DELETE FROM actor
WHERE first_name = 'TEMPORAL_MODIFICADO' AND last_name = 'ACTOR';



-- PARTE 6 - Consultas Avanzadas


-- 12. Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       SUM(p.amount) AS total_pagado
FROM customer c
INNER JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_pagado DESC
LIMIT 5;

-- 13. Top 5 películas más alquiladas
--     (JOIN entre Rental - Inventory - Film, agrupando con conteo)
SELECT f.film_id,
       f.title,
       COUNT(*) AS veces_alquilada
FROM rental r
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
GROUP BY f.film_id, f.title
ORDER BY veces_alquilada DESC
LIMIT 5;
