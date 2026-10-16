---CREATE DATABASE 
CREATE DATABASE OnlineBookstore;

---SWITCH TO THE DATABASE
----\connect OnlineBookstore;

---CREATE TABLE
DROP TABLE IF EXISTS BOOKS;
CREATE TABLE books(

		book_id SERIAL PRIMARY KEY,
		title VARCHAR(100),
		author VARCHAR(100),
		genre VARCHAR(50),
		publish_year INT,
		price NUMERIC(10,2),
		stock INT
		
);


DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE customers(

		customer_id SERIAL PRIMARY KEY,
		name VARCHAR(100),
		email VARCHAR(100),
		phone VARCHAR(15),
		city VARCHAR(50),
		country VARCHAR(150)
		
		
);

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE orders(

		order_id SERIAL PRIMARY KEY,
		customer_id INT REFERENCES customers(customer_id),
		book_id INT REFERENCES books(book_id),
		order_date DATE,
		quantity INT,
		total_amount NUMERIC(10,2)
);

SELECT*FROM books;
SELECT*FROM customers;
SELECT*FROM orders;

---IMPORT DATA INTO BOOKS TABLE
copy books(book_id, title, author, genre, publish_year, price	,stock)
FROM'C:\Users\HP\Desktop\NEW SQL COURSE 30 DAYS\ST - SQL ALL PRACTICE FILES SD61 (2)\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Books.csv'
CSV HEADER;

---IMPORT DATA INTO CUSTOMERS TABLE
copy customers(customer_id, name, email, phone, city, country)
FROM'C:\Users\HP\Desktop\NEW SQL COURSE 30 DAYS\ST - SQL ALL PRACTICE FILES SD61 (2)\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Customers.csv'
CSV HEADER;

---IMPORT DATA INTO ORDERS TABLE
copy orders(order_id, customer_id, book_id, order_date, quantity, total_amount )
FROM'C:\Users\HP\Desktop\NEW SQL COURSE 30 DAYS\ST - SQL ALL PRACTICE FILES SD61 (2)\ST - SQL ALL PRACTICE FILES-2\All Excel Practice Files\Orders.csv'
CSV HEADER;


---------------------------------------BASIC QUERIES------------------------------------------------

---1.RETRIVE ALL THE BOOKS IN THE 'FICTION' GENRE

SELECT*FROM books
WHERE gener='Fiction';

---2.LIST ALL  BOOKS PUBLISHED AFTER THE YEAR 1950:

SELECT*FROM books
WHERE publish_year>1950;

---3.LIST ALL COUSTOMERS FROM THE CANADA 

SELECT*FROM customers
where country='Canada';


---4.SHOW ORDER PLACED IN NOVEMBER 2023

SELECT*FROM orders
WHERE order_date BETWEEN '2023-11-1' AND '2023-11-30';

---5.RETRIVE THE TOTAL STOCKS OF BOOK AVAILABLE 

SELECT SUM(stock) AS total_stock
FROM books;


---6.FIND THE DETAILS OF THE MOST EXPENSIVE BOOK

SELECT*FROM books ORDER BY price DESC LIMIT 1;


---7.SHOW ALL CUSTOMERS WHO ORDERED MORE THAN 1 QUANTITY OF BOOKS

SELECT*FROM orders
WHERE quantity>1;


---8.RETRIVE ALL ORDERS WHERE THE TOTAL AMOUNT EXCEEDS $20

SELECT*FROM orders
WHERE total_amount>20;


---9.LIST AL THE GENER AVAILABLE IN THE BOOKS TABLE

SELECT DISTINCT gener FROM books;


---10.FIND THE BOOK WITH THE LOWEST STOCK

SELECT*FROM books ORDER BY stock ASC LIMIT 1;


---11.CALCULATE THE TOTAL REVENUE GENERATED FROM ALL ORDERS

SELECT sum(total_amount) FROM orders AS revenue;



------------------------------ADVANCED QUERIES----------------------------------
---1.RETRIVE THE TOTAL NUMBER OF BOOKS SOLD FOR EACH GENER
SELECT*FROM orders;

SELECT b.Gener, SUM(o.Quantity) AS total_book_sold
FROM orders o
JOIN books b
ON b.book_id=b.book_id
GROUP BY b.Gener;

---2.FIND THE AVG PRICE OF BOOKS IN THE FANTACY'GENER'
SELECT*FROM books;
SELECT AVG(PRICE) AS avg_price
FROM books
WHERE GENRE='Fantasy';

---3.LIST CUSTOMERS WHO HAVE PLACED AT LEAST 2 ORDERS

/*SELECT customer_id, COUNT(order_id) AS ORDER_COUNT
FROM orders
GROUP BY customer_id 
HAVING COUNT(order_id)>=2;*/

----WITH NAME---
SELECT o.customer_id,c.name, COUNT(order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id ,c.name
HAVING COUNT(order_id)>=2;

---4.FIND THE MOST FREQUENTLY ORDERED BOOK

/*SELECT book_id , COUNT(order_id)AS ORDER_COUNT
FROM orders
GROUP BY book_id
ORDER BY ORDER_COUNT DESC LIMIT 1;*/

---WITH BOOK NAME---
SELECT o.book_id ,b.title, COUNT(order_id)AS ORDER_COUNT
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY o.book_id,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1;
 

---5.SHOW THE TOP 3 MOST EXPENSIVE BOOKS OF 'FANTACY'GENER

SELECT*FROM books
WHERE genre='Fantasy'
ORDER BY price DESC LIMIT 3;

---6.RETRIVES THE TOTAL QUANTITY OF BOOKS SOLD BY EACH AUTHOR

SELECT b.author,SUM(o.quantity) AS total_book_sold
FROM orders o
JOIN books b ON o.book_id=b.book_id
GROUP BY b.author;

---7.LIST THE CITIES WHERE CUSTOMERS WHO SPEND OVER $30 ARE LOCATED

SELECT DISTINCT c.city,total_amount 
FROM orders o
JOIN customers c ON c.customer_id=c.customer_id
WHERE o.total_amount>30;


---8.FIND THE CUSTOER WHO SPEND THE MOST ON ORDERS

SELECT c.customer_id,c.name,SUM (total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_spent DESC LIMIT 1;

---9.CALCULATE THE STOCK REMAINING AFTER FULLFILLING ALL ORDERS

SELECT  b.book_id,b.title,b.stock , COALESCE (SUM (quantity),0) AS order_quantity, 
   b.stock-COALESCE(SUM(quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

