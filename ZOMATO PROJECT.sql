drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup (
    userid INT PRIMARY KEY,
    gold_signup_date DATE
);


INSERT INTO goldusers_signup (userid, gold_signup_date) 
VALUES 
(1, '09-22-2017'),
(3, '04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

1) What is total amount each customer spent on zomato?
SELECT a.userid, sum(b.price) 
FROM sales a 
INNER JOIN product b 
ON a.product_id = b.product_id
GROUP BY a.userid;

2)How many days has each customer visited zomato?
SELECT userid, COUNT(DISTINCT created_date) AS Times_VISITED FROM sales GROUP BY userid;

3)What was the first product purchased by each customer?
WITH CTE AS (
    SELECT *, 
           RANK() OVER (PARTITION BY userid ORDER BY created_date) AS rnk 
    FROM sales
)
SELECT *
FROM CTE
WHERE rnk = 1;

4)What is the most purchased item on menu and how many times was it purchased by all customers?
SELECT userid, COUNT(product_id) AS cnt 
FROM sales 
WHERE product_id = (
    SELECT TOP 1 product_id 
    FROM sales 
    GROUP BY product_id 
    ORDER BY COUNT(product_id) DESC
)
GROUP BY userid;

5)Which item is most popular for each customer?
SELECT * FROM
(
SELECT *,RANK() OVER(PARTITION BY userid ORDER BY cnt DESC) AS rnk FROM
(SELECT userid,product_id, COUNT(product_id) AS cnt FROM sales GROUP BY userid, product_id)AS a)AS b
WHERE rnk=1; 




5)