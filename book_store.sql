CREATE TABLE books(Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(100) NOT NULL,
Author VARCHAR(100) NOT NULL,
Genre VARCHAR(100),
Published_Year INT,
Price NUMERIC,
Stock INT
);

COPY 
books(Book_ID, Title, Author, Genre, Published_Year, Price,Stock
)
FROM 'C:\sql\Books.csv'
WITH (FORMAT csv, HEADER true);

SELECT * FROM books;

CREATE TABLE customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(50),
City VARCHAR(100),
Country VARCHAR(100)

);


--importing data into customers table

COPY customers(customer_id, name, email, phone, city, country)
FROM 'C:/sql/Customers.csv'
WITH (FORMAT csv, HEADER true);

SELECT * FROM customers;



CREATE TABLE orders(Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES customers(customer_id), -- foreign key
Book_ID INT REFERENCES books(Book_ID), --foreign key
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10, 2)
);



-- IMPORTING DATA
COPY
orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount
)
FROM 'C:\sql\Orders.csv'
WITH (FORMAT csv, HEADER true);

SELECT * FROM orders;

--1) Retrieve all books in the "fiction" genre
SELECT * FROM books WHERE Genre='Fiction';


--2) find books published after the year 1950
SELECT * FROM books WHERE published_year>1950;

--3) list all the customers from canada
SELECT name, country FROM customers WHERE Country = 'Canada';
select* from customers;

--4)show order placed in november 2023
select* from orders;
SELECT * FROM orders WHERE order_date between '2023-11-01' AND  '2023-11-30';

--5) retrieve the total stock of books available
SELECT SUM(stock) AS total_stock FROM books;

--6) find the details of the most expensive book
SELECT* FROM books ORDER BY price DESC LIMIT 1;

--7)show all customers who ordered more than 1 quantiti of book

SELECT * FROM orders
WHERE quantity>1;

--8) retrieve all orders where the total amount exceeds $20
SELECT* FROM orders WHERE total_amount>20;

--9) list all genre avaliable on nooks table

SELECT distinct genre from books;

--10) find the book with the lowest stock
SELECT * FROM books ORDER BY stock ASC  LIMIT 1;

--11) calculate total revenue generated from all orders
SELECT SUM(total_amount) AS total_revenue FROM orders;

--12) retrieve the total number of books sold for each genre
SELECT b.genre, SUM(o.quantity) AS total_books_sold
FROM 
orders o
join
books b
on o.book_id = b.book_id
GROUP BY b.genre;

--13) find the average price of book in the fantasy genre
 SELECT AVG(price) FROM books WHERE genre ='Fantasy';

--14)  list of customer who have placed atleast 2 orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM orders o
JOIN
customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id)>=2;

--15) find most frequently ordered book
SELECT  b.book_id, b.title, COUNT(order_id) AS order_count
FROM orders o
JOIN books b
ON o.book_id = b.book_id
GROUP BY b.book_id
ORDER BY order_count desc;

--16) Show the top 3 most expensive books of 'Fantasy' genre

SELECT tiTle, genre, price FROM books WHERE genre='Fantasy' ORDER BY price DESC  LIMIT 3;

--17) retreive the total quantity of books sold by each author
SELECT b.author,  SUM( o.quantity)AS total_quantity_sold
FROM books b
JOIN orders o
ON  b.book_id = o.book_id
GROUP BY b.author;

--18) list the cities where customers who spend over $30 are located 
SELECT  DISTINCT c.city, total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.total_amount> 30;

--19) find the customer who spend the most on orders
SELECT  c.customer_id,c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC LIMIT 1;


--20) calculate the stock remaning after fulfulling  all orders
SELECT b.book_id, b.title,b.stock, COALESCE(SUM(o.quantity),0) AS order_quantity,
b.stock - COALESCE(SUM(o.quantity),0) AS remaining_quantity
FROM books b
LEFT JOIN
orders o
ON b.book_id = o.book_id
GROUP BY b.book_id;