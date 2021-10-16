7. Write a query to display carton id, (len*width*height) as carton_vol and
identify the optimum carton (carton with the least volume whose volume is
greater than the total volume of all items (len * width * height *
product_quantity)) for a given order whose order id is 10006, Assume all
items of an order are packed into one single carton (box). (1 ROW) [NOTE:
CARTON TABLE]

=====
-- find 10006th order's total items volume. and compare that volume with list of carton volumes and find the minimum closest carton box.

select CARTON_ID, (LEN*WIDTH*HEIGHT) as CARTON_VOL from CARTON

-- gives the total volume of order_10006
select ORDER_ID , sum(Total_Volume) as TotalVolume from (select o.ORDER_ID, o.PRODUCT_ID, (p.LEN*p.WIDTH*p.HEIGHT*o.PRODUCT_QUANTITY) as Total_Volume from PRODUCT p join ORDER_ITEMS o  on o.PRODUCT_ID = p.PRODUCT_ID where o.ORDER_ID=10006); 
select * from CARTON;
select ORDER_ID , sum(Total_Volume) as TotalVolume from (select o.ORDER_ID, o.PRODUCT_ID, (p.LEN*p.WIDTH*p.HEIGHT*o.PRODUCT_QUANTITY) as Total_Volume from PRODUCT p join ORDER_ITEMS o  on o.PRODUCT_ID = p.PRODUCT_ID where o.ORDER_ID=10006);

select CARTON_ID, (LEN*WIDTH*HEIGHT) as CARTON_VOL from CARTON where CARTON_VOL > 980552700 order by CARTON_VOL asc limit 1;


8. Write a query to display details (customer id,customer fullname,order
id,product quantity) of customers who bought more than ten (i.e. total order
qty) products per shipped order. (11 ROWS) [NOTE: TABLES TO BE USED -
online_customer, order_header, order_items,]

select  c.CUSTOMER_ID, concat(c.CUSTOMER_FNAME,'  ', c.CUSTOMER_LNAME) AS FULL_NAME, x.ORDER_ID, x.ProductQuantity
from ONLINE_CUSTOMER c join
 (select oh.ORDER_ID as ORDER_ID,  oh.CUSTOMER_ID as CUSTOMER_ID , sum(o.PRODUCT_QUANTITY) as ProductQuantity from ORDER_HEADER oh join ORDER_ITEMS o 
 on oh.ORDER_ID = o.ORDER_ID where oh.ORDER_STATUS = "Shipped" group By o.ORDER_ID HAVING ProductQuantity>10) x
 on c.CUSTOMER_ID = x.CUSTOMER_ID;

=========

9. Write a query to display the order_id, customer id and cutomer full name
of customers along with (product_quantity) as total quantity of products
shipped for order ids > 10060. (6 ROWS) [NOTE: TABLES TO BE USED -
online_customer, order_header, order_items]


  select oh.ORDER_ID, oh.CUSTOMER_ID, concat(c.CUSTOMER_FNAME,'  ', c.CUSTOMER_LNAME) AS FULL_NAME,  sum(o.PRODUCT_QUANTITY) as ProductQuantity from ORDER_HEADER oh join ORDER_ITEMS o on oh.ORDER_ID = o.ORDER_ID 
  join ONLINE_CUSTOMER c on c.CUSTOMER_ID = oh.CUSTOMER_ID
  where oh.ORDER_STATUS = "Shipped" and oh.ORDER_ID>10060 group By o.ORDER_ID;

=========

10. Write a query to display product class description ,total quantity
(sum(product_quantity),Total value (product_quantity * product price) and
show which class of products have been shipped highest(Quantity) to
countries outside India other than USA? Also show the total value of those
items. (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS
TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER
TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]
=========

  select pc.PRODUCT_CLASS_DESC, sum( o.PRODUCT_QUANTITY) as PRODUCT_QUANTITY, (o.PRODUCT_QUANTITY * p.PRODUCT_PRICE) as TotalValue 
  from ORDER_ITEMS o join PRODUCT p on o.PRODUCT_ID = p.PRODUCT_ID join PRODUCT_CLASS pc on p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
 where ORDER_ID in (select oh.ORDER_ID as ORDER_ID from ADDRESS a join ONLINE_CUSTOMER c on c.ADDRESS_ID = a.ADDRESS_ID 
 join ORDER_HEADER oh on c.CUSTOMER_ID = oh.CUSTOMER_ID where a.COUNTRY not in ('India', 'USA'));
