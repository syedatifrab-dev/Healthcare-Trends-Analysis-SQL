drop database healthcare;

create database healthcare;

use healthcare;

-- =========================================
-- 1) PATIENTS
-- =========================================
CREATE TABLE patients (
    patient_id      INT AUTO_INCREMENT PRIMARY KEY,
    birth_date      DATE NOT NULL,
    gender          VARCHAR(20),
    race            VARCHAR(50),
    ethnicity       VARCHAR(50),
    state           VARCHAR(2),
    zip             VARCHAR(10),
    county          VARCHAR(50)
) ;

-- =========================================
-- 2) ENCOUNTERS
-- =========================================
CREATE TABLE encounters (
    encounter_id        INT AUTO_INCREMENT PRIMARY KEY,
    patient_id          INT NOT NULL,
    start_time          DATETIME NOT NULL,
    end_time            DATETIME,
    encounter_class     VARCHAR(30),   -- inpatient / ambulatory / emergency
    encounter_type      VARCHAR(100),

    -- ER throughput
    er_throughput_min   INT,

    -- Financials
    total_claim_cost      DECIMAL(12,2),
    total_payer_coverage  DECIMAL(12,2),
    payer_name            VARCHAR(100),

    -- Organization & provider
    organization_name   VARCHAR(100),
    provider_name       VARCHAR(100),

    -- FK
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
) ;


-- =========================================
-- 2) ENCOUNTERS
-- =========================================
CREATE TABLE encounters (
    encounter_id        INT AUTO_INCREMENT PRIMARY KEY,
    patient_id          INT NOT NULL,
    start_time          DATETIME NOT NULL,
    end_time            DATETIME,
    encounter_class     VARCHAR(30),   -- inpatient / ambulatory / emergency
    encounter_type      VARCHAR(100),

    -- ER throughput
    er_throughput_min   INT,

    -- Financials
    total_claim_cost      DECIMAL(12,2),
    total_payer_coverage  DECIMAL(12,2),
    payer_name            VARCHAR(100),

    -- Organization & provider
    organization_name   VARCHAR(100),
    provider_name       VARCHAR(100),

    -- FK
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
) ;


-- =========================================
-- 3) CLINICAL_EVENTS
-- One row per diagnosis, procedure, medication, or vital
-- =========================================
CREATE TABLE clinical_events (
    event_id        INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id    INT NOT NULL,
    patient_id      INT NOT NULL,

    event_type      VARCHAR(30),    -- condition / procedure / medication / vital
    code            VARCHAR(20),    -- ICD-10 / CPT / NDC / LOINC
    description     VARCHAR(255),

    -- Optional fields for vitals (BP, HR, etc.)
    systolic        INT,
    diastolic       INT,
    event_time      DATETIME,

    FOREIGN KEY (encounter_id) REFERENCES encounters(encounter_id)
        ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
        ON DELETE CASCADE
) ;



INSERT INTO patients (patient_id, birth_date, gender, race, ethnicity, state, zip, county)
VALUES
(1, '1975-05-12', 'female', 'White', 'Not Hispanic', 'CA', '90001', 'Los Angeles'),
(2, '1982-11-20', 'male', 'Black', 'Not Hispanic', 'TX', '77001', 'Harris'),
(3, '1990-02-14', 'female', 'Asian', 'Not Hispanic', 'NY', '10001', 'New York'),
(4, '1969-08-02', 'male', 'White', 'Hispanic', 'FL', '33012', 'Miami-Dade'),
(5, '2001-07-18', 'female', 'Black', 'Not Hispanic', 'IL', '60601', 'Cook'),
(6, '1958-12-01', 'male', 'White', 'Not Hispanic', 'CA', '94102', 'San Francisco'),
(7, '1977-09-10', 'female', 'Asian', 'Not Hispanic', 'WA', '98101', 'King'),
(8, '1985-03-21', 'male', 'White', 'Not Hispanic', 'NV', '89030', 'Clark'),
(9, '1995-01-05', 'female', 'Hispanic', 'Hispanic', 'AZ', '85001', 'Maricopa'),
(10, '1971-10-28', 'male', 'White', 'Not Hispanic', 'CO', '80014', 'Arapahoe'),
(11, '1988-04-16', 'female', 'Asian', 'Not Hispanic', 'MA', '02118', 'Suffolk'),
(12, '2000-12-12', 'male', 'Black', 'Not Hispanic', 'GA', '30303', 'Fulton'),
(13, '1963-07-07', 'female', 'White', 'Not Hispanic', 'NC', '27514', 'Orange'),
(14, '1999-09-09', 'male', 'Hispanic', 'Hispanic', 'CA', '92801', 'Orange'),
(15, '1983-06-03', 'female', 'Black', 'Not Hispanic', 'TX', '78205', 'Bexar');


INSERT INTO encounters (
  encounter_id, patient_id, start_time, end_time, encounter_class, encounter_type,
  er_throughput_min, total_claim_cost, total_payer_coverage, payer_name,
  organization_name, provider_name
)
VALUES
-- Emergency encounters 2018-2019
(101, 1, '2019-01-05 08:00', '2019-01-05 12:00', 'emergency', 'ER Visit', 180, 1200, 900, 'Aetna', 'CA Hospital', 'Dr. Smith'),
(102, 2, '2019-03-11 10:15', '2019-03-11 15:30', 'emergency', 'ER Visit', 240, 1500, 1200, 'Blue Shield', 'TX Med Center', 'Dr. Roberts'),
(103, 3, '2018-11-20 18:30', '2018-11-20 22:00', 'emergency', 'ER Visit', 150, 900, 600, 'Medicare', 'NY Hospital', 'Dr. Wang'),
(104, 4, '2019-07-25 05:45', '2019-07-25 09:00', 'emergency', 'ER Visit', 190, 1100, 850, 'Aetna', 'FL General', 'Dr. Lopez'),
(105, 5, '2019-12-30 21:00', '2019-12-31 01:00', 'emergency', 'ER Visit', 210, 1000, 700, 'Medicaid', 'IL Hospital', 'Dr. Shah'),

-- Inpatient encounters
(201, 1, '2019-04-10 08:00', '2019-04-15 13:00', 'inpatient', 'Surgery', NULL, 18000, 16000, 'Aetna', 'CA Hospital', 'Dr. Lee'),
(202, 6, '2019-06-20 10:00', '2019-06-25 14:30', 'inpatient', 'Cardiac Admit', NULL, 25000, 20000, 'Medicare', 'SF Medical', 'Dr. Green'),
(203, 7, '2018-09-09 07:45', '2018-09-14 11:15', 'inpatient', 'GI Admit', NULL, 14000, 12000, 'United', 'WA Hospital', 'Dr. Kim'),
(204, 8, '2019-02-02 09:00', '2019-02-05 10:00', 'inpatient', 'Respiratory Admit', NULL, 13000, 9000, 'Aetna', 'NV Medical', 'Dr. Patel'),
(205, 9, '2019-08-12 14:00', '2019-08-16 10:00', 'inpatient', 'Maternal Admit', NULL, 9000, 7000, 'Medicaid', 'AZ Hospital', 'Dr. Davis'),

-- Ambulatory encounters
(301, 10, '2019-01-12 11:00', '2019-01-12 11:45', 'ambulatory', 'Office Visit', NULL, 300, 250, 'Cigna', 'CO Clinic', 'Dr. White'),
(302, 11, '2018-05-22 13:15', '2018-05-22 13:50', 'ambulatory', 'Checkup', NULL, 220, 180, 'Blue Shield', 'MA Center', 'Dr. Li'),
(303, 12, '2019-03-02 16:00', '2019-03-02 16:30', 'ambulatory', 'Follow-up', NULL, 180, 150, 'United', 'GA Clinic', 'Dr. Carter'),
(304, 13, '2018-10-10 09:20', '2018-10-10 10:00', 'ambulatory', 'Office Visit', NULL, 250, 200, 'Cigna', 'NC Clinic', 'Dr. Gray'),
(305, 14, '2019-11-18 12:30', '2019-11-18 13:00', 'ambulatory', 'GI Follow-up', NULL, 260, 210, 'Medicaid', 'CA Clinic', 'Dr. Lopez'),

-- More encounters
(306, 15, '2019-02-20 11:45', '2019-02-20 12:15', 'ambulatory', 'Routine Visit', NULL, 200, 160, 'Aetna', 'TX Clinic', 'Dr. Adams'),
(307, 3, '2019-05-02 08:00', '2019-05-02 08:45', 'ambulatory', 'BP Check', NULL, 100, 80, 'Medicare', 'NY Clinic', 'Dr. Chen'),
(308, 2, '2018-12-10 15:00', '2018-12-10 15:40', 'ambulatory', 'Diabetes Follow-up', NULL, 190, 150, 'Blue Shield', 'TX Med', 'Dr. Evans'),
(309, 6, '2019-09-01 10:30', '2019-09-01 11:00', 'ambulatory', 'Cardiac Follow-up', NULL, 210, 170, 'Medicare', 'SF Cardiology', 'Dr. Miller'),
(310, 7, '2019-10-22 14:10', '2019-10-22 15:00', 'ambulatory', 'GI Consult', NULL, 230, 180, 'United', 'WA GI Center', 'Dr. Kim');

INSERT INTO clinical_events (event_id, encounter_id, patient_id, event_type, code, description, systolic, diastolic, event_time)
VALUES
(1, 101, 1, 'condition', 'I10', 'Hypertension', NULL, NULL, '2019-01-05 08:10'),
(2, 102, 2, 'condition', 'E11.9', 'Type 2 Diabetes', NULL, NULL, '2019-03-11 10:30'),
(3, 103, 3, 'condition', 'J18.9', 'Pneumonia', NULL, NULL, '2018-11-20 18:45'),
(4, 104, 4, 'condition', 'R07.9', 'Chest Pain', NULL, NULL, '2019-07-25 06:00'),
(5, 105, 5, 'condition', 'S93.4', 'Ankle Sprain', NULL, NULL, '2019-12-30 21:15'),
(6, 201, 1, 'condition', 'K35', 'Acute Appendicitis', NULL, NULL, '2019-04-10 08:30'),
(7, 202, 6, 'condition', 'I21', 'Acute MI', NULL, NULL, '2019-06-20 10:15'),
(8, 203, 7, 'condition', 'K52.9', 'GI Disorder', NULL, NULL, '2018-09-09 08:00'),
(9, 204, 8, 'condition', 'J44.1', 'COPD Exacerbation', NULL, NULL, '2019-02-02 09:15'),
(10, 205, 9, 'condition', 'O80', 'Normal Delivery', NULL, NULL, '2019-08-12 14:30');


INSERT INTO clinical_events VALUES
(20, 201, 1, 'procedure', '44970', 'Laparoscopic Appendectomy', NULL, NULL, '2019-04-10 12:00'),
(21, 202, 6, 'procedure', '92928', 'Cardiac Stent Placement', NULL, NULL, '2019-06-20 12:30'),
(22, 203, 7, 'procedure', '45378', 'Colonoscopy', NULL, NULL, '2018-09-09 10:00'),
(23, 301, 10, 'procedure', '99213', 'Office Evaluation', NULL, NULL, '2019-01-12 11:10'),
(24, 305, 14, 'procedure', '88305', 'GI Pathology Review', NULL, NULL, '2019-11-18 12:45'),
(25, 308, 2, 'procedure', '83036', 'HbA1C Test', NULL, NULL, '2018-12-10 15:10');



INSERT INTO clinical_events VALUES
(40, 101, 1, 'medication', 'C09AA05', 'Lisinopril 10mg', NULL, NULL, '2019-01-05 09:00'),
(41, 102, 2, 'medication', 'A10BA02', 'Metformin 500mg', NULL, NULL, '2019-03-11 11:00'),
(42, 202, 6, 'medication', 'C07AB02', 'Metoprolol', NULL, NULL, '2019-06-20 15:00'),
(43, 203, 7, 'medication', 'A07EA06', 'Mesalamine', NULL, NULL, '2018-09-09 12:00'),
(44, 204, 8, 'medication', 'R03AK06', 'Symbicort Inhaler', NULL, NULL, '2019-02-02 11:30'),
(45, 303, 12, 'medication', 'A10AE04', 'Trulicity', NULL, NULL, '2019-03-02 16:10');



INSERT INTO clinical_events VALUES
(60, 307, 3, 'vital', NULL, 'Blood Pressure', 142, 92, '2019-05-02 08:10'),
(61, 307, 3, 'vital', NULL, 'Blood Pressure', 130, 84, '2019-05-02 08:35'),
(62, 101, 1, 'vital', NULL, 'Blood Pressure', 150, 98, '2019-01-05 08:20'),
(63, 102, 2, 'vital', NULL, 'Blood Pressure', 160, 100, '2019-03-11 10:45'),
(64, 202, 6, 'vital', NULL, 'Blood Pressure', 170, 110, '2019-06-20 10:30'),
(65, 301, 10, 'vital', NULL, 'Blood Pressure', 128, 82, '2019-01-12 11:20'),
(66, 304, 13, 'vital', NULL, 'Blood Pressure', 135, 88, '2018-10-10 09:30');


-- Patients with documented uncontrolled hypertension (BP >=140/90) any time in 2018–2019
WITH bp AS (
  SELECT DISTINCT patient_id, encounter_id, systolic, diastolic, event_time
  FROM clinical_events
  WHERE event_type='vital'
    AND description LIKE '%Blood Pressure%'
),
bp_1819 AS (
  SELECT b.*
  FROM bp b
  JOIN encounters e ON e.encounter_id=b.encounter_id
  WHERE YEAR(e.start_time) IN (2018,2019)
),
uncontrolled AS (
  SELECT DISTINCT patient_id
  FROM bp_1819
  WHERE (COALESCE(systolic,0) >= 140) OR (COALESCE(diastolic,0) >= 90)
)
SELECT COUNT(*) AS patients_uncontrolled_2018_2019
FROM uncontrolled;

-- Providers who treated patients with uncontrolled hypertension in 2018–2019
WITH bp AS (
  SELECT encounter_id, patient_id, systolic, diastolic
  FROM clinical_events
  WHERE event_type='vital' AND description LIKE '%Blood Pressure%'
),
uncontrolled_enc AS (
  SELECT DISTINCT b.encounter_id
  FROM bp b
  JOIN encounters e ON e.encounter_id=b.encounter_id
  WHERE YEAR(e.start_time) IN (2018,2019)
    AND (COALESCE(b.systolic,0) >= 140 OR COALESCE(b.diastolic,0) >= 90)
)
SELECT e.provider_name, COUNT(DISTINCT e.encounter_id) AS encounters
FROM uncontrolled_enc ue
JOIN encounters e ON e.encounter_id = ue.encounter_id
GROUP BY e.provider_name
ORDER BY encounters DESC;

-- Medications given to patients with uncontrolled hypertension (within those encounters)
WITH bp AS (
  SELECT encounter_id, patient_id, systolic, diastolic
  FROM clinical_events
  WHERE event_type='vital' AND description LIKE '%Blood Pressure%'
),
uncontrolled_enc AS (
  SELECT DISTINCT b.encounter_id
  FROM bp b
  JOIN encounters e ON e.encounter_id=b.encounter_id
  WHERE YEAR(e.start_time) IN (2018,2019)
    AND (COALESCE(b.systolic,0) >= 140 OR COALESCE(b.diastolic,0) >= 90)
)
SELECT ce.description AS medication, COUNT(*) AS administrations
FROM clinical_events ce
JOIN uncontrolled_enc ue ON ue.encounter_id = ce.encounter_id
WHERE ce.event_type='medication'
GROUP BY ce.description
ORDER BY administrations DESC;

-- Using lower cutoff 135/85, how many patients would be flagged in 2018 or 2019?
WITH bp AS (
  SELECT encounter_id, patient_id, systolic, diastolic
  FROM clinical_events
  WHERE event_type='vital' AND description LIKE '%Blood Pressure%'
),
flagged AS (
  SELECT DISTINCT b.patient_id
  FROM bp b
  JOIN encounters e ON e.encounter_id=b.encounter_id
  WHERE YEAR(e.start_time) IN (2018,2019)
    AND (COALESCE(b.systolic,0) >= 135 OR COALESCE(b.diastolic,0) >= 85)
)
SELECT COUNT(*) AS patients_bp_135_85_2018_2019
FROM flagged;

-- Most commonly prescribed medication to patients with hypertension (>=140/90 at any point in 2018–2019)
WITH hypertensive_patients AS (
  SELECT DISTINCT b.patient_id
  FROM clinical_events b
  JOIN encounters e ON e.encounter_id=b.encounter_id
  WHERE b.event_type='vital' AND b.description LIKE '%Blood Pressure%'
    AND YEAR(e.start_time) IN (2018,2019)
    AND (COALESCE(b.systolic,0) >= 140 OR COALESCE(b.diastolic,0) >= 90)
),
meds AS (
  SELECT ce.description AS medication
  FROM clinical_events ce
  JOIN hypertensive_patients hp ON hp.patient_id = ce.patient_id
  JOIN encounters e ON e.encounter_id = ce.encounter_id
  WHERE ce.event_type='medication' AND YEAR(e.start_time) IN (2018,2019)
)
SELECT medication, COUNT(*) AS administrations
FROM meds
GROUP BY medication
ORDER BY administrations DESC
LIMIT 1;

-- Which race had the highest total number of patients with BP >=140/90 before 2020?
WITH bp_high AS (
  SELECT DISTINCT ce.patient_id
  FROM clinical_events ce
  JOIN encounters e ON e.encounter_id = ce.encounter_id
  WHERE ce.event_type='vital' AND ce.description LIKE '%Blood Pressure%'
    AND e.start_time < '2020-01-01'
    AND (COALESCE(ce.systolic,0) >= 140 OR COALESCE(ce.diastolic,0) >= 90)
)
SELECT p.race, COUNT(*) AS patients
FROM bp_high h
JOIN patients p ON p.patient_id=h.patient_id
GROUP BY p.race
ORDER BY patients DESC
LIMIT 1;

-- Which race had the highest PERCENTAGE of BP readings >=140/90 before 2020?
WITH bp_pre AS (
  SELECT ce.patient_id, p.race,
         (COALESCE(ce.systolic,0) >= 140 OR COALESCE(ce.diastolic,0) >= 90) AS high_flag
  FROM clinical_events ce
  JOIN encounters e ON e.encounter_id = ce.encounter_id
  JOIN patients  p ON p.patient_id = ce.patient_id
  WHERE ce.event_type='vital' AND ce.description LIKE '%Blood Pressure%'
    AND e.start_time < '2020-01-01'
),
agg AS (
  SELECT race,
         COUNT(*) AS total_readings,
         SUM(high_flag) AS high_readings,
         100*SUM(high_flag)/NULLIF(COUNT(*),0) AS pct_high
  FROM bp_pre
  GROUP BY race
)
SELECT race, total_readings, high_readings, ROUND(pct_high,2) AS pct_high
FROM agg
ORDER BY pct_high DESC
LIMIT 1;



