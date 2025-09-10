-- a) Crear la base de datos con el archivo create_restaurant_db.sql
-- b) Explorar la tabla “menu_items” para conocer los productos del menú.

-- 1.- Realizar consultas para contestar las siguientes preguntas:
-- Encontrar el número de artículos en el menú.


select count(menu_item_id)
from menu_items;

-- ¿Cuál es el artículo menos caro y el más caro en el menú?

select min(price), max(price)
from menu_items;

			-- artículo menos caro
			
select item_name, min (price)
from menu_items
group by item_name
order by min (price) asc;


			-- artículo más caro
			
select item_name, max (price)
from menu_items
group by item_name
order by max (price) desc;

 			-- artículo menos caro  y más caro

select item_name, price
from menu_items
where price = (select min(price) from menu_items) or price = (select max(price) from menu_items)
group by item_name, price;


-- ¿Cuántos platos americanos hay en el menú?

select count(menu_item_id)
from menu_items
where category = 'American';

-- ¿Cuáles el precio promedio de los platos

select category, round (avg(price),2)
from menu_items
group by category;


-- c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
-- 1.- Realizar consultas para contestar las siguientes preguntas:
-- ¿Cuántos pedidos únicos se realizaron en total?

select count (distinct order_id)
from order_details;

select distinct order_id
from order_details
order by order_id desc;

-- ¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?

-- Aquí limito a 5 los pedidos con mayor cantidad de artículos, pero si hay mas pedidos 
-- con la misma cantidad no van a salir.

select order_id, count (item_id) as numero_articulos
from order_details
group by order_id
order by count (item_id) desc
limit 5; 

-- Y aquí me muestra el total de pedidos que tienen la cantidad máxima de artículos.

select t.order_id, t.cantidad_articulos
from (select order_id, count (item_id) as cantidad_articulos
	from order_details
	group by order_id) t
where t.cantidad_articulos = (select max(cantidad_articulos)
								from (select order_id, count (item_id) as cantidad_articulos
										from order_details
										group by order_id) tt)


-- ¿Cuándo se realizó el primer pedido y el último pedido?

(select order_date
from order_details
order by order_date asc
limit 1)
UNION ALL
(select order_date
from order_details
order by order_date desc
limit 1)

-- ¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?

select count (distinct order_id)
from order_details
where order_date between '2023-01-01' and '2023-01-05';

-- d)  Usar ambas tablas para conocer la reacción de los clientes respecto al menú.

-- 1.- Realizar un left join entre entre order_details y menu_items con el identificador
-- item_id(tabla order_details) y menu_item_id(tabla menu_items).

-- El artículo que mas se vendió 
SELECT menu.item_name,menu.category, count(od.item_id)
FROM menu_items as menu left join order_details as od
ON menu.menu_item_id = od.item_id
GROUP BY menu.item_name, menu.category 
ORDER BY count(od.item_id) desc
limit 1;

-- Los 3 productos que mas se han vendido
SELECT menu.item_name,menu.category, count(od.item_id)
FROM menu_items as menu left join order_details as od
ON menu.menu_item_id = od.item_id
GROUP BY menu.item_name, menu.category 
ORDER BY count(od.item_id) desc
limit 3;

-- El producto menos vendido
SELECT menu.item_name,menu.category, count(od.item_id)
FROM menu_items as menu left join order_details as od
ON menu.menu_item_id = od.item_id
GROUP BY menu.item_name, menu.category 
ORDER BY count(od.item_id) asc
limit 1;

-- Cantidad de pedidos por categoría.
select menu.category, count (distinct od.order_id)
from menu_items as menu left join order_details as od
ON menu.menu_item_id = od.item_id
group by menu.category
order by count (distinct od.order_id) desc


-- e) Una vez que hayas explorado los datos en las tablas correspondientes y respondido las
-- preguntas planteadas, realiza un análisis adicional utilizando este join entre las tablas. El
-- objetivo es identificar 5 puntos clave que puedan ser de utilidad para los dueños del
-- restaurante en el lanzamiento de su nuevo menú. Para ello, crea tus propias consultas y
-- utiliza los resultados obtenidos para llegar a estas conclusiones.


/*

1.- Hay un total de 32 artículos en el menú
2.- El artículo mas caro es el Shrimp Scampi 19.95 dolares.
3.- El precio promedio del plato por categoría

	"American"	10.07 dolares
	"Mexican"	11.80 dolares
	"Asian"		13.48 dolares
	"Italian"	16.75 dolares

4.- Se ha realizado un tota de 5370 pedidos en total.

5.- La cantidad de artículos máximo por pedido que se han hecho es de 14 artículos
    y aqui se muestran los pedidos que han tenido dicha cantidad.

	Order_id	Artículos
	2675		14
	3473		14
	4305		14
	440			14
	443			14
	1957		14
	330			14

6.- El artículo que mas se ha vendido del 2023-01-01 al 2023-03-31 es la Hamburguesa (Categoría: American), 
    el cual se ha vendido 622 veces.

7.- Los 3 productos mas venidos son los siguientes:

"Hamburger"		"American"	622
"Edamame"		"Asian"		620
"Korean Beef Bowl"	"Asian"		588

8.- El producto menos vendido es el Chicken tacos (Categoría: Mexican), el cual se ha vendido 123 veces.

9.- La cantidad de pedidos por categoría es la siguientes:
	Categoría	Num.Pedidos
	"Asian"		2635
	"Italian"	2292
	"Mexican"	2266
	"American"	2152

*/