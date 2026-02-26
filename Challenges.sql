-- 1. Rolling Average
-- Question Link:- https://www.db-fiddle.com/f/fufVxMKne1xMNHCbFoANMo/0


WITH daily_totals AS (
-- Aggregate once at the day level
SELECT
transaction_time::DATE AS transaction_date,
SUM(transaction_amount) AS daily_total,
COUNT(*) AS transaction_count
FROM transactions
WHERE transaction_time >= '2021-01-29'
AND transaction_time < '2021-02-01'

GROUP BY transaction_time::DATE
),

rolling_avg AS (
SELECT
transaction_date,
daily_total,
transaction_count,

    AVG(daily_total) OVER (
    	ORDER BY transaction_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) 											 	AS rolling_3day_avg,
    
    SUM(daily_total) OVER (
    	ORDER BY transaction_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )												AS rolling_3day_sum,
    
    COUNT(*) OVER(
    	ORDER BY transaction_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )												AS days_in_window	
 FROM daily_totals 
)

SELECT
transaction_date,
transaction_count,
ROUND(daily_total::NUMERIC, 2) AS daily_total,
ROUND(rolling_3day_sum::NUMERIC, 2) AS rolling_3day_sum,
ROUND(rolling_3day_avg::NUMERIC, 2) AS rollig_3day_avg,
days_in_window
FROM rolling_avg
WHERE transaction_date = '2021-01-31';
