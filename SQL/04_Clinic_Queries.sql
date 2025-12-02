-- Clinic Management System: Query Solutions

-- Q1: Revenue from each sales channel in the year 2021
SELECT sales_channel,
       SUM(amount) AS total_revenue
FROM clinic_sales
WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
GROUP BY sales_channel
ORDER BY total_revenue DESC;

-- Q2: Top 10 most valuable customers for the year 2021
SELECT cs.uid,
       c.name,
       SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c ON cs.uid = c.uid
WHERE cs.datetime >= '2021-01-01' AND cs.datetime < '2022-01-01'
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- Q3: Month-wise revenue, expense, profit, and status for the year 2021
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY DATE_TRUNC('month', datetime)
),
monthly_expense AS (
    SELECT DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS expense
    FROM expenses
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY DATE_TRUNC('month', datetime)
)
SELECT COALESCE(r.month, e.month) AS month,
       COALESCE(r.revenue, 0) AS revenue,
       COALESCE(e.expense, 0) AS expense,
       COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit,
       CASE WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) > 0
            THEN 'profitable'
            ELSE 'not-profitable'
       END AS status
FROM monthly_revenue r
FULL OUTER JOIN monthly_expense e ON r.month = e.month
ORDER BY month;

-- Q4: Most profitable clinic per city for each month of 2021
WITH revenue AS (
    SELECT cid,
           DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY cid, DATE_TRUNC('month', datetime)
),
expense AS (
    SELECT cid,
           DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS expense
    FROM expenses
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY cid, DATE_TRUNC('month', datetime)
),
profit AS (
    SELECT COALESCE(r.cid, e.cid) AS cid,
           COALESCE(r.month, e.month) AS month,
           COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM revenue r
    FULL OUTER JOIN expense e ON r.cid = e.cid AND r.month = e.month
),
ranked AS (
    SELECT p.cid,
           cl.city,
           p.month,
           p.profit,
           ROW_NUMBER() OVER (PARTITION BY cl.city, p.month ORDER BY p.profit DESC) AS rn
    FROM profit p
    JOIN clinics cl ON p.cid = cl.cid
)
SELECT city, month, cid, profit
FROM ranked
WHERE rn = 1
ORDER BY city, month;

-- Q5: Second least profitable clinic per state for each month of 2021
WITH revenue AS (
    SELECT cid,
           DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS revenue
    FROM clinic_sales
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY cid, DATE_TRUNC('month', datetime)
),
expense AS (
    SELECT cid,
           DATE_TRUNC('month', datetime) AS month,
           SUM(amount) AS expense
    FROM expenses
    WHERE datetime >= '2021-01-01' AND datetime < '2022-01-01'
    GROUP BY cid, DATE_TRUNC('month', datetime)
),
profit AS (
    SELECT COALESCE(r.cid, e.cid) AS cid,
           COALESCE(r.month, e.month) AS month,
           COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) AS profit
    FROM revenue r
    FULL OUTER JOIN expense e ON r.cid = e.cid AND r.month = e.month
),
ranked AS (
    SELECT p.cid,
           cl.state,
           p.month,
           p.profit,
           DENSE_RANK() OVER (PARTITION BY cl.state, p.month ORDER BY p.profit ASC) AS rnk
    FROM profit p
    JOIN clinics cl ON p.cid = cl.cid
)
SELECT state, month, cid, profit
FROM ranked
WHERE rnk = 2
ORDER BY state, month;
-- End of Clinic Management System: Query Solutions
