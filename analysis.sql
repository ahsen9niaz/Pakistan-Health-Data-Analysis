# Checking the Data types of all columns
DESCRIBE pakistan_health_data;


# Perform Data Cleaning
# Check for any Null Values 
Select * FROM pakistan_health_data WHERE 
Unique_id is NULL or Unique_id = ''
OR `Hospital Name` is NULL or `Hospital Name` = ''
OR `Patient Name` is NULL or `Patient Name` = ''
OR `Age` is NULL or `Age` = ''
OR `Disease` is NULL or `Disease` = ''
OR `Gender` is NULL or `Gender` = ''
OR `Treatment Cost` is NULL or `Treatment Cost` = ''
OR `Insurance` is NULL or `Insurance` = ''
OR `Blood Group` is NULL or `Blood Group` = ''
OR `Height (cm)` is NULL or `Height (cm)` = ''
OR `Weight (kg)` is NULL or `Weight (kg)` = ''
OR `Weight_category` is NULL or `Weight_category` = ''
OR `Contact Number` is NULL or `Contact Number` = ''
OR `Weight_category` is NULL or `Weight_category` = ''
OR `City` is NULL or `City` = ''
OR `Province` is NULL or `Province` = ''
OR `Date of Admission` is NULL
OR `Date of Discharge` is NULL;

# Answer - No null values found


#Checking for any duplicate rows
SELECT Unique_id,COUNT(*) FROM pakistan_health_data GROUP BY Unique_id HAVING count(*) > 1;

# Answer : No duplicates found


# change the type and format of the date of discharge as the date is imported as a text type and also not in the 'yyyy-mm-dd' format
ALTER TABLE pakistan_health_data
ADD COLUMN new_date_of_discharge DATE;

UPDATE pakistan_health_data
SET new_date_of_discharge = STR_TO_DATE(`Date of Discharge`, '%c/%e/%Y');

SELECT `Date of Discharge`, new_date_of_discharge
FROM pakistan_health_data
LIMIT 10;

ALTER TABLE pakistan_health_data
DROP COLUMN `Date of Discharge`,
CHANGE new_date_of_discharge `Date of Discharge` DATE;

# change the type and format of the date of admission as the date is imported as a text type and also not in the 'yyyy-mm-dd' format
ALTER TABLE pakistan_health_data
ADD COLUMN new_date_of_admission DATE;

UPDATE pakistan_health_data
SET new_date_of_admission = STR_TO_DATE(`Date of Admission`, '%c/%e/%Y');

SELECT `Date of Admission`, new_date_of_admission
FROM pakistan_health_data
LIMIT 10;

ALTER TABLE pakistan_health_data
DROP COLUMN `Date of Admission`,
CHANGE new_date_of_admission `Date of Admission` DATE;




# Check the distribution of age across different hospitals
SELECT `Hospital Name` , AVG(Age) FROM pakistan_health_data GROUP BY `Hospital Name`;

# Check the distribution of gender of patients across hospitals
SELECT `Hospital Name` , Gender, COUNT(*) as GenderCount FROM pakistan_health_data GROUP BY `Hospital Name`, Gender;


# check height and weight distribution across hospitals
SELECT `Hospital Name` , AVG(`Height (cm)`) as average_height , AVG(`Weight (kg)`) as average_weight
 FROM
 pakistan_health_data 
 GROUP BY
 `Hospital Name`;


# check prevelance of different disease across hospitals
SELECT `Hospital Name` , Disease, COUNT(*) as disease_name FROM pakistan_health_data GROUP BY `Hospital Name`,Disease; 

# checking treatment cost across hospitals and provinces
SELECT `Hospital Name` ,Province, AVG(`Treatment Cost`) as average_treatment_cost FROM pakistan_health_data GROUP BY `Hospital Name`,Province;

# compare patient volume across hospitals
SELECT `Hospital Name` , COUNT(Unique_id) as patients_voulme FROM pakistan_health_data GROUP BY `Hospital Name`;

# peak admission time in different hospitals to plan better and optimize resources
SELECT `Hospital Name` , COUNT(Unique_id) as no_of_patients , month(`Date of Admission`) as admission_month 
FROM 
pakistan_health_data 
GROUP BY 
`Hospital Name`, admission_month 
ORDER BY no_of_patients DESC; 

# checking the patients with or without insurance coverage
SELECT Insurance,COUNT(*) as count FROM pakistan_health_data GROUP BY Insurance;

# impact of insurance on treatment cost
SELECT Insurance , SUM(`Treatment Cost`) as treatment_cost FROM pakistan_health_data GROUP BY Insurance;

# analyzing the diseases prevalent in different provinces
SELECT Province, Disease, COUNT(*) as count FROM pakistan_health_data GROUP BY Province,Disease;

# Investigate potential correlations between patient demographics (e.g., age) and treatment costs
SELECT Age_category , SUM(`Treatment Cost`) as treatment_cost FROM pakistan_health_data GROUP BY Age_category;

