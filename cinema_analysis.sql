-- --------------------------------------------------------------------------------------------------------------------------------------- 
-- Funky Customers Analysis
-- --------------------------------------------------------------------------------------------------------------------------------------- 
-- 1. Write a query that pulls all bookings from the customer with ID 37
SELECT *
FROM cinema_booking_system.bookings
WHERE customer_id = 37;

-- 2. Write a query that pulls all bookings from the customers with IDs 37, 20, or 68
SELECT *
FROM cinema_booking_system.bookings
WHERE customer_id IN (37, 20, 68);

-- 3. There's something funky with the customers mentioned above. Can you spot it? Write a query that pulls all customers that have 
--    the same issue as those with IDs 20, 37, and 68 (for your query you CANNOT hardcode any IDs). How many are there?
-- Problem: There are a total of 6 customers with missing first names.
SELECT *
FROM cinema_booking_system.customers
WHERE first_name IS NULL;

-- 4. I want to e-mail all the customers with the issue above, but I want to prioritize the best ones. Write a query that pulls
--    Customer ID, First Name, Last Name, Email, and their total number of bookings for customers with the issue we've been talking about
SELECT c.id, c.first_name, c.last_name, c.email, COUNT(b.customer_id) AS total_no_bookings
FROM cinema_booking_system.customers c
JOIN cinema_booking_system.bookings b
ON b.customer_id = c.id
WHERE first_name IS NULL
GROUP BY c.id
ORDER BY total_no_bookings DESC;

-- 5. So I spoke with the higher-ups about this, they want to know how long this issue has been happening potentially. Using the query above, 
--    can you add the fields "First_booking_date" and "Last_booking_date" to it? We want to know the first time they ever went to our cinema
--    as well as the last time they came in
SELECT c.id, c.first_name, c.last_name, c.email, MIN(date(s.start_time)) AS first_booking_date, MAX(date(s.start_time)) AS last_booking_date, COUNT(b.customer_id) AS total_no_bookings
FROM cinema_booking_system.customers c
JOIN cinema_booking_system.bookings b
ON b.customer_id = c.id
JOIN cinema_booking_system.screenings s
ON b.screening_id = s.id
WHERE first_name IS NULL
GROUP BY c.id
ORDER BY total_no_bookings DESC;

-- --------------------------------------------------------------------------------------------------------------------------------------- 
-- Theater Analysis
-- --------------------------------------------------------------------------------------------------------------------------------------- 
-- 1. How many rooms do we have? Write a query that pulls all rooms and the number of seats. Use the rooms table only.
SELECT rooms.name, rooms.no_seats
FROM cinema_booking_system.rooms;
-- There are currently three rooms in the cinema. 

-- 2. Let's double check the numbers to see if the Rooms table is updated. Write a query that pulls the number of seats per room. Use the seats table only. 
SELECT room_id, COUNT(seat_num) AS seats_per_room
FROM cinema_booking_system.seats
GROUP BY room_id;

-- 3. Do the results match? Let's see them side by side. Use the your query above and use a JOIN to add room name and the number of seats they are
--    supposed to have
SELECT r.id, r.name, r.no_seats, COUNT(s.seat_num) AS seats_per_room
FROM cinema_booking_system.rooms r
JOIN cinema_booking_system.seats s
ON r.id = s.room_id 
GROUP BY room_id;
-- No, the results do not match. Chaplin is missing 3 seats, Kubrick is missing 1 seat, and Coppola is also missing 1 seat. 

-- 4. The boss wants a report that shows the exact number of missing seats per room. Use your query from last time and add a column called "Data_discrepancy" to show
--    the difference in the number of seats between the Rooms and Seats tables, grouped by room. 
--    The final report should have these columns: ID, ROOM, REGISTERED_SEATS, ACTUAL_SEATS, DATA_DISCREPANCY
SELECT r.id, r.name AS room_name, r.no_seats AS registered_seats, COUNT(s.seat_num) AS actual_seats, (no_seats - COUNT(s.seat_num)) AS data_discrepancy
FROM cinema_booking_system.rooms r
JOIN cinema_booking_system.seats s
ON r.id = s.room_id 
GROUP BY room_id;