create database Finance_db;

use Finance_db;

SHOW COLUMNS FROM Finance_1;
SHOW COLUMNS FROM Finance_2;

-- ------------------------------
-- Number of customers
SELECT COUNT(DISTINCT member_id) AS Number_of_Customers FROM finance_1 ;

-- Total_Loan_Amount

SELECT 
    ROUND(SUM(loan_amnt) / 1000, 2) AS Total_Loan_Amount_K
FROM finance_1;


-- Average_Interest_Rate
SELECT ROUND(AVG(CAST(REPLACE(int_rate, '%', '') AS DECIMAL(5,2))), 2) AS Average_Interest_Rate FROM finance_1;

-- Total_Revolve_Balance
SELECT ROUND(SUM(CAST(revol_bal AS DECIMAL(15,2))) / 1000000, 2) AS Total_Revolve_Balance_Million FROM finance_2 ;

-- Average_DTI
SELECT ROUND(AVG(dti), 8) AS Average_DTI FROM finance_1;

-- Total_Recoveries 
SELECT ROUND(SUM(recoveries), 1) AS Total_Recoveries FROM finance_2 ;

-- Average_Annual_Income
SELECT ROUND(AVG(annual_inc), 5) AS Average_Annual_Income FROM finance_1;

-- Average_loan_Payment
SELECT ROUND(AVG(total_pymnt), 6) AS Average_total_Payment FROM finance_2;



 -- ------------------------------
 
-- 1.Year wise loan amount Status


SELECT Year,
    ROUND(SUM(loan_amnt) / 100000, 10) AS Loan_Amount_Millions
FROM Finance_1
GROUP BY Year
ORDER BY Year;

-- 2. total payment of varified vs non varified status


SELECT 
    f1.verification_status,
    CONCAT("$", FORMAT(ROUND(SUM(f2.total_pymnt)/1000000, 2), 2), "m") AS total_payment,
    CONCAT(ROUND(SUM(f2.total_pymnt) * 100 / 
                 (SELECT SUM(total_pymnt) FROM finance_2), 2), "%") AS percentage_share
FROM finance_1 f1
INNER JOIN finance_2 f2
    ON f1.id = f2.id
    WHERE verification_status in ('Verified','Not Verified')
GROUP BY f1.verification_status;


-- 3. Grade & sub-grade wise revol balance
SELECT 
    f1.grade,
    f1.sub_grade,
    ROUND(SUM(f2.revol_bal) / 1000000, 0) AS revol_bal_millions
FROM Finance_1 f1
JOIN Finance_2 f2 
    ON f1.id = f2.id
GROUP BY f1.grade, f1.sub_grade
ORDER BY f1.grade, f1.sub_grade;



-- 4. State wise loan status

SELECT 
    addr_state AS state,
    loan_status,
    COUNT(*) AS total_loans
FROM Finance_1
GROUP BY addr_state, loan_status
ORDER BY addr_state, loan_status; -- add month col extra

SELECT 
    addr_state AS state,
    loan_status,
    DATE_FORMAT(STR_TO_DATE(issue_d, '%b-%Y'), '%Y-%m') AS loan_month,
    COUNT(*) AS total_loans
FROM Finance_1
GROUP BY addr_state, loan_status, loan_month
ORDER BY addr_state, loan_status, loan_month;


SELECT 
    ROUND(SUM(recoveries), 2) AS total_recoveries
FROM finance_2;



-- 5. Home ownership vs last paymment date


SELECT 
    f1.home_ownership,
    COALESCE(f2.last_pymnt_d, 'No Payment') AS last_pymnt_d,
    CONCAT('$', FORMAT(ROUND(SUM(f2.last_pymnt_amnt)/10000, 2), 2), 'k') AS total_amount
FROM finance_1 f1
INNER JOIN finance_2 f2
    ON f1.id = f2.id
GROUP BY f1.home_ownership, last_pymnt_d
ORDER BY last_pymnt_d DESC, f1.home_ownership DESC;





