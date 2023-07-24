-- --------------------------------------------------------------------------------------------------------------------------------------- 
-- Funky Customers Analysis
-- --------------------------------------------------------------------------------------------------------------------------------------- 
SELECT *
FROM cinema_booking_system.bookings
WHERE customer_id = 37;

SELECT *
FROM cinema_booking_system.bookings
WHERE customer_id IN (37, 20, 68);

-- Problem: There are a total of 6 customers with missing first names.
SELECT *
FROM cinema_booking_system.customers
WHERE first_name IS NULL;

SELECT c.id, c.first_name, c.last_name, c.email, COUNT(b.customer_id) AS total_no_bookings
FROM cinema_booking_system.customers c
JOIN cinema_booking_system.bookings b
ON b.customer_id = c.id
WHERE first_name IS NULL
GROUP BY c.id
ORDER BY total_no_bookings DESC;

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
SELECT rooms.name, rooms.no_seats
FROM cinema_booking_system.rooms;
-- There are currently three rooms in the cinema. 

SELECT room_id, COUNT(seat_num) AS seats_per_room
FROM cinema_booking_system.seats
GROUP BY room_id;

SELECT r.id, r.name, r.no_seats, COUNT(s.seat_num) AS seats_per_room
FROM cinema_booking_system.rooms r
JOIN cinema_booking_system.seats s
ON r.id = s.room_id 
GROUP BY room_id;
-- No, the results do not match. Chaplin is missing 3 seats, Kubrick is missing 1 seat, and Coppola is also missing 1 seat. 

SELECT r.id, r.name AS room_name, r.no_seats AS registered_seats, COUNT(s.seat_num) AS actual_seats, (no_seats - COUNT(s.seat_num)) AS data_discrepancy
FROM cinema_booking_system.rooms r
JOIN cinema_booking_system.seats s
ON r.id = s.room_id 
GROUP BY room_id;
