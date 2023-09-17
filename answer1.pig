listing = LOAD 'C:\Users\max99\Downloads\AB_NYC_2019.csv' USING PigStorage(',')
as
(id: int, name: chararray,host_id: int, host_name: chararray,
neighbourhood_group: chararray,neighbourhood: chararray,
latitude: float,longitude: float,room_type: chararray,price: float,
minimum_nights: int,number_of_reviews: int,
last_review: chararray,reviews_per_month: float,
calculated_host_listings_count: int, availability_365: int);


listing = FILTER listing BY last_review is not null; 
listing = FILTER listing BY price is not null; 

filter_list = FOREACH listing GENERATE neighbourhood_group, price, number_of_reviews, 
ToDate(last_review, 'YYYY-MM-dd') AS last_review_date, 
availability_365;
filter_list = FILTER filter_list BY number_of_reviews > 10 AND GetYear(last_review_date) == 2019;

group_list = GROUP filter_list BY neighbourhood_group;

output_list = FOREACH group_list GENERATE group, 
SUM(filter_list.price)/COUNT(filter_list.price) AS average, 
MAX(filter_list.availability_365) AS max_365;

STORE output_list INTO '/Users/micha/cp422_a2/AirBndB_ neighbourhood _ group';


