-------------- Exploratory Data Analysis ---------------

-- Table structure

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'finance';

-- Table Preview

SELECT * 
FROM finance
LIMIT 10;

-- Column Preview

SELECT DISTINCT(department) 
FROM finance;

SELECT DISTINCT(cost_type) 
FROM finance;

SELECT DISTINCT(cost_category) 
FROM finance;

SELECT DISTINCT(approval_status) 
FROM finance;

-- Cheecking rows

SELECT COUNT(*) 
FROM finance;

-- Total actual and budgeted amounts

SELECT 
  SUM(budgeted_amount) AS total_budget,
  SUM(actual_amount) AS total_actual
FROM finance;

-------------- Querying Business QUestions --------------

-- 1. What are the top 5 categories or departments consistently over budget?

SELECT 
	cost_category, 
	department, 
	SUM(budgeted_amount) AS total_budget, 
	SUM(actual_amount) AS total_actual, 
	SUM(actual_amount) - SUM(budgeted_amount) AS variance,
	ROUND(SUM(actual_amount) - SUM(budgeted_amount) / NULLIF(SUM(budgeted_amount), 0) * 100.0, 2) AS variance_pct
FROM finance
GROUP BY cost_category, department
ORDER BY variance DESC
LIMIT 5;

-- 2. How does spending trend across quarters for each department?

SELECT quarter, department, SUM(actual_amount) AS total_spend
FROM finance
GROUP BY quarter, department
ORDER BY quarter, department;

-- 3. What is the total approved vs unapproved amount per cost type?

SELECT 
	cost_type, 
	approval_status,
	SUM(actual_amount) AS total_amount,
	COUNT(*) AS num_records
FROM finance
GROUP BY cost_type, approval_status
ORDER BY cost_type, approval_status;

-- 4. How much does each cost type contribute to total expenses?

SELECT 
	cost_type, 
	COUNT(*) AS num_records,
	SUM(actual_amount) AS total_expenses,
	ROUND(SUM(actual_amount) / 
	(
		SELECT SUM(actual_amount) 
		FROM finance
	) * 100.0, 2)  AS percent_of_total
FROM finance
GROUP BY cost_type
ORDER BY total_expenses DESC;

-- 5. Which projects are driving most of the over-budget spend?

SELECT 
	project_code, 
	department,
	SUM(budgeted_amount) AS total_budget,
	SUM(actual_amount) AS total_actual,
	SUM(actual_amount) - SUM(budgeted_amount) AS overage,
	ROUND(SUM(actual_amount) - SUM(budgeted_amount) / NULLIF(SUM(actual_amount), 0), 2) AS overage_pct
FROM finance
GROUP BY project_code, department
HAVING SUM(actual_amount) > SUM(budgeted_amount)
ORDER BY overage DESC
LIMIT 5;













