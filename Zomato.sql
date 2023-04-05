CREATE DATABASE restaurant;
USE restaurant;

CREATE TABLE goldusers(userid integer,gold_signup_date date);

INSERT INTO goldusers(userid,gold_signup_date) 
 VALUES (1, '2017-09-22' ),
(3,'2017-04-21');

CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'2014-09-02'),
(2,'2015-01-15'),
(3,'2014-04-11');


CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'2017-04-19',2),
(3,'2019-12-18',1),
(2,'2020-07-20',3),
(1,'2019-10-23',2),
(1,'2018-03-19',3),
(3,'2016-12-20',2),
(1,'2016-11-09',1),
(1,'2016-05-20',3),
(2,'2017-09-24',1),
(1,'2017-03-11',2),
(1,'2016-03-11',1),
(3,'2016-11-10',1),
(3,'2017-12-07',2),
(3,'2016-12-15',2),
(2,'2017-11-08',2),
(2,'2018-09-10',3);

CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


-- 1. Total Amount Spend by customer

Select userid, sum(price) as total_amount
	from sales s
    join  product p
    on s.product_id=p.product_id
group by userid;


-- 2. How many days has each customer visited

Select userid, count(userid) as no_of_visits
	from sales
group by userid;


-- 3. First prodct purchased

select *
	from ( 
		select *, 
			dense_rank() over(partition by userid order by created_date) as rn
				from sales s ) t
		
	where rn=1;
    

-- 4. Most purchase item on menu

Select userid, count(product_id)
from sales
where product_id= (select product_id
						FROM sales
                         group by product_id
                         order by count(product_id) desc
                         LIMIT 1)
Group by userid
LIMIT 1;


-- 5. first Item purchased by member

Select s.userid, s.product_id, 
row_number() Over( Partition by userid) 
From  sales s
Inner Join users u
On s.userid= u.userid
AND s.created_date >= u.signup_date;

