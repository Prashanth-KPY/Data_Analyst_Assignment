-- Hotel Management System: Query Solutions

-- Q1: Last booked room per user
SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) latest ON b.user_id = latest.user_id AND b.booking_date = latest.last_booking;

-- Q2: Booking ID, item ID, billing amount for November 2021
SELECT bc.booking_id, bc.item_id, SUM(bc.item_quantity * i.item_rate) AS billing_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
JOIN bookings b ON bc.booking_id = b.booking_id
WHERE b.booking_date >= '2021-11-01' AND b.booking_date < '2021-12-01'
GROUP BY bc.booking_id, bc.item_id;

-- Q3: Bills > 1000 in October 2021
SELECT bc.bill_id, bc.item_id, SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01' AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id, bc.item_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;

-- Q4: Most and least ordered item per month
WITH monthly_item_totals AS (
    SELECT DATE_TRUNC('month', bill_date) AS month,
           item_id,
           SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE bill_date >= '2021-01-01' AND bill_date < '2022-01-01'
    GROUP BY DATE_TRUNC('month', bill_date), item_id
),
ranked_items AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS most_rank,
           RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS least_rank
    FROM monthly_item_totals
)
SELECT month, item_id, total_qty, 'Most Ordered' AS status
FROM ranked_items WHERE most_rank = 1
UNION ALL
SELECT month, item_id, total_qty, 'Least Ordered' AS status
FROM ranked_items WHERE least_rank = 1
ORDER BY month, status;

-- Q5: Second highest bill value per month
WITH bill_values AS (
    SELECT DATE_TRUNC('month', bc.bill_date) AS month,
           b.user_id,
           bc.bill_id,
           SUM(bc.item_quantity * i.item_rate) AS bill_total
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE bc.bill_date >= '2021-01-01' AND bc.bill_date < '2022-01-01'
    GROUP BY DATE_TRUNC('month', bc.bill_date), b.user_id, bc.bill_id
),
ranked_bills AS (
    SELECT *, DENSE_RANK() OVER (PARTITION BY month ORDER BY bill_total DESC) AS rank
    FROM bill_values
)
SELECT month, user_id, bill_id, bill_total
FROM ranked_bills
WHERE rank = 2
ORDER BY month;

