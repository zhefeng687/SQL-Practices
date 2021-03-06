#1. 
##a) A LEFT JOIN B
SELECT * FROM A 
	LEFT JOIN B 
	ON A.Department_id = B.Department_id);
+---------------+---------------+---------------+-----------------+
 Employee_name  | Department_id | Department_id | Department_name |
+---------------+---------------+---------------+-----------------+
| John          |           123 |           123 | Human Resource  |
| Peter         |           345 |          NULL | NULL            |
+---------------+---------------+---------------+-----------------+

SELECT A.Employee_name, A.Department_id, B.Department_name 
FROM A
	LEFT JOIN B 
	ON A.Department_id = B.Department_id;
+---------------+-----------------+---------------+
Employee_name   | Department_id | Department_name |
+---------------+---------------+-----------------+
| John          |           123 | Human Resource  |
| Peter         |           345 | NULL            |
+---------------+---------------+-----------------+


##b) A RIGHT JOIN B
SELECT B.Department_id, B.Department_name, A.Employee_name
FROM A 	
	RIGHT JOIN B 
	ON B.Department_id = A.Department_id;  -- on A.Department_id = B.Department_id
+---------------+-----------------+---------------+
| Department_id | Department_name | Employee_name |
+---------------+-----------------+---------------+
|           123 | Human Resource  | John          |
|           678 | Accounting      | NULL          |
 ---------------+-----------------+---------------+


##c)A FULL JOIN B 
SELECT * FROM A 
	LEFT JOIN B 
	ON A.Department_id = B.Department_id
UNION 
	SELECT * FROM A 
	RIGHT JOIN B 
	ON B.Department_id = A.Department_id;
--------------- +---------------+---------------+-----------------+
| Employee_name | Department_id | Department_id | Department_name |
+---------------+---------------+---------------+-----------------+
| John          |           123 |           123 | Human Resource  |
| Peter         |           345 |          NULL | NULL            |
| NULL          |          NULL |           678 | Accounting      |
+---------------+---------------+---------------+-----------------+


##d)A INNER JOIN B
SELECT A.Employee_name, A.Department_id, B.Department_name
FROM A 	
	INNER JOIN B 
	ON A.Department_id = B.Department_id;
+---------------+---------------+-----------------+
| Employee_name | Department_id | Department_name |
+---------------+---------------+-----------------+
| John          |           123 | Human Resource  |
+---------------+---------------+-----------------+



#2. 
##a) No, the primary key needs to be unqiue and not null; the Employee_name in Table C has a duplicate record of 'John'.


##b)SELECT employee_name FROM A
	GROUP BY department_id 
	ORDER BY 1;
+---------------+
| employee_name |
+---------------+
| John          |
| John          |
| Peter         |
+---------------+

-- FIND DUPLICATES
SELECT Employee_name, COUNT (*) num_employee_name
FROM A 
GROUP BY Employee_name 
HAVING num_employee_name > 1-- COUNT(*) >1;
+---------------+-------------------+
| employee_name | num_employee_name |
+---------------+-------------------+
| John          |                 2 |
+---------------+-------------------+


##c) How to set the primary key for table A to identify the employee ?

Employee_name   | Department_id |
+---------------+---------------+
| John          |           123 |
| Peter         |           345 |
| John          |           789 |

step 1 -- add a column employee_id integer 
step 2 -- add constraint UNIQUE
step 3 -- modify  column auto_increment
step 4 -- add CONSTRAINT PRIMARY KEY 

-- MODIFY column_name data_type 

ALTER TABLE A ADD COLUMN Employee_id INTEGER;
ALTER TABLE A ADD CONSTRAINT unique_a UNIQUE(Employee_id);
ALTER TABLE A MODIFY Employee_id INTEGER AUTO_INCREMENT;
ALTER TABLE A ADD CONSTRAINT pk_a PRIMARY KEY(Employee_id);

-- HOW TO DELETE duplicate records in mysql ?
step 1 aggregate function min to arbitrarily choose the ID to retain 
step 2 use the above subquery in delete from where ID NOT IN STEP 1 

DELETE FROM A 
WHERE Employee_id 
NOT IN 
(SELECT MIN(Employee_id) 
FROM 
	(SELECT * FROM A)A1
GROUP BY Employee_name);



#3.
- find difference between two tables
-- step 1 UNION ALL two tables
-- step 2 COUNT()>1 -- DUPLICATES ; COUNT()=1 UNIQUE RECORD

SELECT * FROM D
UNION ALL 
SELECT * FROM E
---- must specify the select items

SELECT cd.department_id, cd.employee_name, count(*)num_of_records
FROM
	(SELECT c.department_id, c.employee_name FROM c
	 UNION ALL 
	 SELECT d.department_id, d.employee_name FROM d)cd
GROUP BY cd.department_id, cd.employee_name
HAVING COUNT(*) > 1                                                  
ORDER BY 1;
+---------------+---------------+----------------+
| department_id | employee_name | num_of_records |
+---------------+---------------+----------------+
|           345 | Peter         |              2 |
+---------------+---------------+----------------+



#4) 
##a. COUNT the employee for each department, sort by department name
SELECT g.department_name, COUNT(employee_name)num_of_employees 
FROM F 
	JOIN G 
	ON F.department_id = G.department_id
GROUP BY G.department_name
ORDER BY 2 DESC;
+-----------------+------------------+
| department_name | num_of_employees |
+-----------------+------------------+
| Accounting      |                2 |
| Human Resource  |                1 |
| IT              |                1 |
-----------------+-------------------+


##b. update the record in F 
-- UPDATE F
-- SET UPPER(F.Employee_name) 
-- WHERE F.Department_id = 
-- (SELECT F.Department_id
-- FROM F JOIN G 
-- ON F.department_id = G.department_id
-- WHERE G.department_name = 'Accouting')

UPDATE F 
SET Employee_name = UPPER(Employee_name)
WHERE F.Department_id = (SELECT G.Department_id FROM G WHERE G.Department_name = 'Accounting');



#5) 
TRADE_ID Can be set as the PRIMARY KEY because of its unique and not null features. (x) !!
IF TRADE TRANCATION CANCELLED, PK will be deleted.



#6)
CREATE TABLE Trades
(BSN_DT timestamp,
AC_SK_ID integer,
Trade_ID integer PRIMARY KEY,
CCY varchar(128),
EXPOSURE_AMT integer);

CREATE TABLE FX
(BSN_DT timestamp,
SOURCE_CCY varchar(128),
TARGET_CCY varchar(128),
EXCHAGE_RATE float);

INSERT INTO Trades(BSN_DT,AC_SK_ID,TRADE_ID,CCY,EXPOSURE_AMT)
VALUES('2020-11-30', 1,7,'JPY',2000),
('2020-11-30',2,8,'USD',1000),
('2020-12-31',1,1,'CAD',1000),
('2020-12-31',1,2,'USD',1000),
('2020-12-31',2,3,'CAD',1000),
('2020-12-31',2,4,'USD',1000),
('2020-12-31',2,5,'JPY',1000),
('2020-12-31',3,6,'CAD',3000);

INSERT INTO FX(BSN_DT,SOURCE_CCY,TARGET_CCY,EXCHAGE_RATE)
VALUES('2020-11-30','JPY','CAD',0.012),
('2020-11-30','USD','CAD',1.2),
('2020-11-30','JPY','USD',0.010),
('2020-11-30','CNY','CAD',0.168),
('2020-12-31','JPY','CAD',0.010),
('2020-12-31','USD','CAD',1.1),
('2020-12-31','JPY','USD',0.0099),
('2020-12-31','CNY','CAD',0.167);

-- HOW TO CHANGE THE NAME OF THE COLUMN?
ALTER TABLE (name) CHANGE old_column_name new_column_name data_type;

-- HOW TO CHANGE data type of the COLUMN?
ALTER TABLE (name) MODIFY column_name new_data_type;

DECIMAL(size,d) -- size = digits before decimal ; d = size after decimal; size default = 10, d default = 0;



#6) 
##a. currency List in all trades;
SELECT * FROM Trades
WHERE CCY IN ('CAD','JPY','USD')
GROUP BY CCY, TRADE_ID
ORDER BY TRADE_ID;

------------+----------+----------+------+--------------+
| BSN_DT     | AC_SK_ID | Trade_ID | CCY  | EXPOSURE_AMT |
+------------+----------+----------+------+--------------+
| 2020-12-31 |        1 |        1 | CAD  |         1000 |
| 2020-12-31 |        1 |        2 | USD  |         1000 |
| 2020-12-31 |        2 |        3 | CAD  |         1000 |
| 2020-12-31 |        2 |        4 | USD  |         1000 |
| 2020-12-31 |        2 |        5 | JPY  |         1000 |
| 2020-12-31 |        3 |        6 | CAD  |         3000 |
| 2020-11-30 |        1 |        7 | JPY  |         2000 |
| 2020-11-30 |        2 |        8 | USD  |         1000 |

SELECT COUNT(*)NUM_TRADES_CCY, CCY FROM Trades
WHERE CCY IN ('CAD','JPY','USD')
GROUP BY CCY
ORDER BY 2;
NUM_TRADES_CCY   | CCY  |
+----------------+------+
|              3 | CAD  |
|              2 | JPY  |
|              3 | USD  |
+----------------+------+


SELECT CCY FROM Trades
WHERE CCY IN ('CAD','JPY','USD')
GROUP BY CCY;
+------+
| CCY  |
+------+
| CAD  |
| JPY  |
| USD  |
+------+


##b. ZHE DID IT BY HERSELF!!!
Detail Report in CAD  

###Tricks:
1. find relationships between tables through the results; requires multiplication :ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)
Round -- ??????
2. rename the column Trades.EXPOSURE_AMT 'EXPOSURE_AMT(in CAD)'
3. write the subquery separately and union all 
4./*!!! USE backtick character  `EXPOSURE_AMT(in_CAD)` when you want to use parentheses (single: parenthesis) 
The backtick is the default character for "quoted identifiers". 
SET sql_mode = 'ANSI_QUOTES' (or any special combination mode that includes ANSI_QUOTES), 
you can also use the double quote character. 
Though we usually only enable that and actually use double quotes when we are working with scripts that already have the double quotes, 
and we want MySQL to accommodate. 
The backtick character doesn't have any other special use in MySQL, except to "quote" identifiers !!!*/


SELECT Trades.BSN_DT, Trades.AC_SK_ID,Trades.TRADE_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
FROM Trades WHERE Trades.CCY = 'CAD'
	UNION 
		SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.Trade_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
		FROM Trades 
			JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
			ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
ORDER BY BSN_DT, AC_SK_ID, TRADE_ID;

BSN_DT       | AC_SK_ID | TRADE_ID | EXPOSURE_AMT(in CAD) |
+------------+----------+----------+----------------------+
| 2020-11-30 |        1 |        7 |                   24 |
| 2020-11-30 |        2 |        8 |                 1200 |
| 2020-12-31 |        1 |        1 |                 1000 |
| 2020-12-31 |        1 |        2 |                 1100 |
| 2020-12-31 |        2 |        3 |                 1000 |
| 2020-12-31 |        2 |        4 |                 1100 |
| 2020-12-31 |        2 |        5 |                   10 |
| 2020-12-31 |        3 |        6 |                 3000 |


##c. SUMMARY REPORT IN CAD   `()`  
###Tricks:
###From the results, we can see aggregate function AVG has been used as well as the COUNT from the TRADEs, which records from the Detail report groupping by AC_SK_ID. 


SELECT BSN_DT, AC_SK_ID, 
	   COUNT(AC_SK_ID)TRADEs,`EXPOSURE_AMT(in CAD)`, 
	   ROUND(AVG(`EXPOSURE_AMT(in CAD)`),2) `AVERAGE_AMT(in CAD)`
FROM
(
	SELECT Trades.BSN_DT, Trades.AC_SK_ID,Trades.TRADE_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
	FROM Trades WHERE Trades.CCY = 'CAD'
		UNION
			SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.Trade_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT,0)`EXPOSURE_AMT(in CAD)` 
			FROM Trades 
				JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
				ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
	ORDER BY BSN_DT, AC_SK_ID, TRADE_ID
)FT
GROUP BY AC_SK_ID, BSN_DT 
ORDER BY 1,2;
+------------+----------+--------+----------------------+---------------------+
| BSN_DT     | AC_SK_ID | TRADEs | EXPOSURE_AMT(in CAD) | AVERAGE_AMT(in CAD) |
+------------+----------+--------+----------------------+---------------------+
| 2020-11-30 |        1 |      1 |                   24 |               24.00 |
| 2020-11-30 |        2 |      1 |                 1200 |             1200.00 |
| 2020-12-31 |        1 |      2 |                 1000 |             1050.00 |
| 2020-12-31 |        2 |      3 |                 1000 |              703.33 |
| 2020-12-31 |        3 |      1 |                 3000 |             3000.00 |
+------------+----------+--------+----------------------+---------------------+


##d. TOP Exposure by Trade 
SELECT FT_4.BSN_DT, FT_4.TRADE_ID, FT_4.`EXPOSURE_AMT(in CAD)`
FROM 
(	SELECT BSN_DT, TRADE_ID,MAX(`EXPOSURE_AMT(in CAD)`) `EXPOSURE_AMT(in CAD)` 
	FROM 
		(SELECT Trades.BSN_DT, Trades.AC_SK_ID,Trades.TRADE_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
		 FROM Trades WHERE Trades.CCY = 'CAD'
			UNION 
				SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.Trade_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
				FROM Trades 
					JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
					ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
		ORDER BY BSN_DT, AC_SK_ID, TRADE_ID
		)FT
	GROUP BY BSN_DT 
	LIMIT 2
)FT_2
	JOIN (SELECT BSN_DT, TRADE_ID,`EXPOSURE_AMT(in CAD)` 
		  FROM 
			(SELECT Trades.BSN_DT,Trades.TRADE_ID,Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
			 FROM Trades WHERE Trades.CCY = 'CAD'
				UNION 
					SELECT Trades.BSN_DT, Trades.TRADE_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
					FROM Trades 
						JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
						ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
			ORDER BY BSN_DT)FT_3
			)FT_4
	ON FT_2.`EXPOSURE_AMT(in CAD)` = FT_4.`EXPOSURE_AMT(in CAD)`;
+------------+----------+----------------------+
| BSN_DT     | TRADE_ID | EXPOSURE_AMT(in CAD) |
+------------+----------+----------------------+
| 2020-11-30 |        8 |                 1200 |
| 2020-12-31 |        6 |                 3000 |
+------------+----------+----------------------+


##e.Top Exposure by Account 
/*
SELECT BSN_DT, AC_SK_ID, 
MAX(`EXPOSURE_AMT(in CAD)`) `EXPOSURE_AMT(in CAD)`
FROM
(SELECT Trades.BSN_DT, Trades.AC_SK_ID,Trades.TRADE_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
FROM Trades WHERE Trades.CCY = 'CAD'
UNION
SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.Trade_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT,0)`EXPOSURE_AMT(in CAD)` 
FROM Trades JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
ORDER BY BSN_DT, AC_SK_ID, TRADE_ID)FT
GROUP BY AC_SK_ID
LIMIT 2;*/ #WRONG!!


SELECT FT_4.BSN_DT, FT_4.AC_SK_ID, FT_4.`EXPOSURE_AMT(in CAD)` 
FROM 
(	SELECT BSN_DT,AC_SK_ID, MAX(`EXPOSURE_AMT(in CAD)`) `EXPOSURE_AMT(in CAD)` 
	FROM 	
		(	SELECT Trades.BSN_DT, Trades.AC_SK_ID,Trades.TRADE_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` FROM Trades WHERE Trades.CCY = 'CAD'
			UNION 
			SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.Trade_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
			FROM Trades 			
				JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
				ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
			ORDER BY BSN_DT, AC_SK_ID, TRADE_ID
		)FT
	GROUP BY BSN_DT 
	LIMIT 2
)FT_2
	JOIN 
	(SELECT BSN_DT, AC_SK_ID,`EXPOSURE_AMT(in CAD)` 
	 FROM 
		(SELECT Trades.BSN_DT,Trades.AC_SK_ID,Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` FROM Trades WHERE Trades.CCY = 'CAD'
				UNION 
					SELECT Trades.BSN_DT, Trades.AC_SK_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
					FROM Trades 
					JOIN (SELECT * FROM FX WHERE TARGET_CCY = 'CAD')FX_1
					ON Trades.BSN_DT = FX_1.BSN_DT AND Trades.CCY = FX_1.SOURCE_CCY
			ORDER BY BSN_DT
		)FT_3
	)FT_4
	ON FT_2.`EXPOSURE_AMT(in CAD)` = FT_4.`EXPOSURE_AMT(in CAD)`;
+------------+----------+----------------------+
| BSN_DT     | AC_SK_ID | EXPOSURE_AMT(in CAD) |
+------------+----------+----------------------+
| 2020-11-30 |        2 |                 1200 |
| 2020-12-31 |        3 |                 3000 |
+------------+----------+----------------------


##f. Trend REPORT
SELECT FT_12.AC_SK_ID, 
	   COALESCE(FT_12.`EXPOSURE_AMT(in CAD) for 2020-12-31`,'')`EXPOSURE_AMT(in CAD) for 2020-12-31`,
	   COALESCE(FT_11.`EXPOSURE_AMT(in CAD) for 2020-11-30`,'')`EXPOSURE_AMT(in CAD) for 2020-11-30`,
	   COALESCE((FT_12.`EXPOSURE_AMT(in CAD) for 2020-12-31` / FT_11.`EXPOSURE_AMT(in CAD) for 2020-11-30`),'') Changed
FROM 
(
	SELECT AC_SK_ID, SUM(`EXPOSURE_AMT(in CAD)`) `EXPOSURE_AMT(in CAD) for 2020-12-31`
	FROM 
	(   SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` FROM Trades WHERE Trades.CCY = 'CAD' AND 
			   Trades.BSN_DT = '2020-12-31'
		UNION 
		SELECT Trades.BSN_DT, Trades.AC_SK_ID, ROUND(FX_1.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
		FROM Trades
			JOIN 
			(SELECT * FROM FX WHERE FX.TARGET_CCY = 'CAD' AND FX.BSN_DT = '2020-12-31')FX_1
			ON Trades.BSN_DT = FX_1.BSN_DT  AND Trades.CCY = FX_1.SOURCE_CCY
		ORDER BY AC_SK_ID
	)ft
	GROUP BY AC_SK_ID
)FT_12
	LEFT JOIN 
	(
		SELECT AC_SK_ID, SUM(`EXPOSURE_AMT(in CAD)`) `EXPOSURE_AMT(in CAD) for 2020-11-30`
		FROM 
			(   SELECT Trades.BSN_DT, Trades.AC_SK_ID, Trades.EXPOSURE_AMT `EXPOSURE_AMT(in CAD)` 
			    FROM Trades 
				WHERE Trades.CCY = 'CAD' AND Trades.BSN_DT = '2020-11-30'
					UNION 
						SELECT Trades.BSN_DT, Trades.AC_SK_ID, ROUND(FX_1B.EXCHANGE_RATE * Trades.EXPOSURE_AMT)`EXPOSURE_AMT(in CAD)`
						FROM Trades
							JOIN (SELECT * FROM FX WHERE FX.TARGET_CCY = 'CAD' AND FX.BSN_DT = '2020-11-30')FX_1B
							ON Trades.BSN_DT = FX_1B.BSN_DT  AND Trades.CCY = FX_1B.SOURCE_CCY
				ORDER BY AC_SK_ID
			)ft_B
		GROUP BY AC_SK_ID
	)FT_11
	ON FT_12.AC_SK_ID = FT_11.AC_SK_ID
	ORDER BY FT_12.AC_SK_ID;
	
	
	----------+-------------------------------------+
| AC_SK_ID | EXPOSURE_AMT(in CAD) for 2020-12-31 |
+----------+-------------------------------------+
|        1 |                                2100 |
|        2 |                                2110 |
|        3 |                                3000 |
+----------+-------------------------------------+

+----------+-------------------------------------+
| AC_SK_ID | EXPOSURE_AMT(in CAD) for 2020-11-30 |
+----------+-------------------------------------+
|        1 |                                  24 |
|        2 |                                1200 |
+----------+-------------------------------------+

/*HOW TO REPLACE NULL TO Empty string or other values"
COALESCE(column_name, expression) return the the first non-null value in a list.*/
----------+-------------------------------------+-------------------------------------+---------+
| AC_SK_ID | EXPOSURE_AMT(in CAD) for 2020-12-31 | EXPOSURE_AMT(in CAD) for 2020-11-30 | Changed |
+----------+-------------------------------------+-------------------------------------+---------+
|        1 |                                2100 |                                  24 | 87.5000 |
|        2 |                                2110 |                                1200 |  1.7583 |
|        3 |                                3000 |                                NULL |    NULL |


AC_SK_ID   | EXPOSURE_AMT(in CAD) for 2020-12-31 | EXPOSURE_AMT(in CAD) for 2020-11-30 | Changed |
+----------+-------------------------------------+-------------------------------------+---------+
|        1 | 2100                                | 24                                  | 87.5000 |
|        2 | 2110                                | 1200                                | 1.7583  |
|        3 | 3000                                |                                     |         |
+----------+-------------------------------------+-------------------------------------+---------+


##g. Currency Summary
STEP 1 :
modify TABLE FX
INSERT INTO FX (BSN_DT,SOURCE_CCY,TARGET_CCY, EXCHAGE_RATE)
VALUES('2020-11-30','CAD','CAD',1),
('2020-12-31','CAD','CAD',1);

SELECT BSN_DT, SOURCE_CCY, EXCHANGE_RATE 
FROM FX 
WHERE TARGET_CCY <> 'USD'
ORDER BY 1,2;
+------------+------------+---------------+
| BSN_DT     | SOURCE_CCY | EXCHANGE_RATE |
+------------+------------+---------------+
| 2020-11-30 | CAD        |        1.0000 |
| 2020-11-30 | CNY        |        0.1680 |
| 2020-11-30 | JPY        |        0.0120 |
| 2020-11-30 | USD        |        1.2000 |
| 2020-12-31 | CAD        |        1.0000 |
| 2020-12-31 | CNY        |        0.1670 |
| 2020-12-31 | JPY        |        0.0100 |
| 2020-12-31 | USD        |        1.1000 |
+------------+------------+---------------+

STEP 2 AGGREGATE TABLE Trades

SELECT BSN_DT, CCY, SUM(EXPOSURE_AMT)EXPOSURE_AMT 
FROM Trades 
GROUP BY BSN_DT, CCY
ORDER BY 1;
+------------+------+--------------+
| BSN_DT     | CCY  | EXPOSURE_AMT |
+------------+------+--------------+
| 2020-11-30 | JPY  |         2000 |
| 2020-11-30 | USD  |         1000 |
| 2020-12-31 | CAD  |         5000 |
| 2020-12-31 | JPY  |         1000 |
| 2020-12-31 | USD  |         2000 |
+------------+------+--------------+

STEP 3 MULTIPLCATION FOR TWO COLUMNS ; COALESCE FUNCTION TO REPLACE 0 FOR NULL; 
-- FX IS ALREADY MODIFED FROM THE INSERT INTO STATEMENT ; 
SELECT FX_g.BSN_DT, FX_g.SOURCE_CCY Currency, 
	   COALESCE(ROUND(FX_g.EXCHANGE_RATE * Trades_g.EXPOSURE_AMT),0)`EXPOSURE_AMT(in CAD)`
FROM 
	(SELECT BSN_DT, SOURCE_CCY, EXCHANGE_RATE FROM FX WHERE TARGET_CCY <> 'USD' ORDER BY 1,2)FX_g
		LEFT JOIN
			(SELECT BSN_DT, CCY, SUM(EXPOSURE_AMT)EXPOSURE_AMT FROM Trades GROUP BY BSN_DT, CCY ORDER BY 1)Trades_g
		ON FX_g.BSN_DT = Trades_g.BSN_DT AND FX_g.SOURCE_CCY = Trades_g.CCY 
ORDER BY 1,2;
+------------+----------+----------------------+
| BSN_DT     | Currency | EXPOSURE_AMT(in CAD) |
+------------+----------+----------------------+
| 2020-11-30 | CAD      |                    0 |
| 2020-11-30 | CNY      |                    0 |
| 2020-11-30 | JPY      |                   24 |
| 2020-11-30 | USD      |                 1200 |
| 2020-12-31 | CAD      |                 5000 |
| 2020-12-31 | CNY      |                    0 |
| 2020-12-31 | JPY      |                   10 |
| 2020-12-31 | USD      |                 2200 |
+------------+----------+----------------------+





