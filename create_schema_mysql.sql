CREATE DATABASE IF NOT EXISTS readmission_db;
USE readmission_db;

DROP TABLE IF EXISTS encounters;

CREATE TABLE encounters (
    encounter_id          BIGINT       PRIMARY KEY,
    patient_nbr           BIGINT       NOT NULL,
    encounter_seq         INT,
    is_first_encounter    TINYINT,
    race                  VARCHAR(30),
    gender                VARCHAR(10),
    age                   VARCHAR(10),
    age_years             INT,
    admission_type        VARCHAR(30),
    admission_source      VARCHAR(30),
    discharge_group       VARCHAR(40),
    specialty_group       VARCHAR(60),
    payer_code            VARCHAR(10),
    time_in_hospital      INT,
    los_band              VARCHAR(15),
    num_lab_procedures    INT,
    num_procedures        INT,
    num_medications       INT,
    number_outpatient     INT,
    number_emergency      INT,
    number_inpatient      INT,
    total_prior_visits    INT,
    prior_inpatient_band  VARCHAR(5),
    number_diagnoses      INT,
    primary_diagnosis     VARCHAR(20),
    diag_2_group          VARCHAR(20),
    diag_3_group          VARCHAR(20),
    A1Cresult             VARCHAR(12),
    max_glu_serum         VARCHAR(12),
    a1c_tested            TINYINT,
    a1c_high              TINYINT,
    hba1c_management      VARCHAR(40),
    n_diabetes_meds       INT,
    n_med_changes         INT,
    on_insulin            TINYINT,
    med_changed           TINYINT,
    on_diabetes_med       TINYINT,
    readmitted            VARCHAR(5),
    readmitted_30d        TINYINT      NOT NULL,
    INDEX idx_patient   (patient_nbr),
    INDEX idx_discharge (discharge_group)
);

USE readmission_db;

SELECT
    COUNT(*)                               AS total_visits,
    COUNT(DISTINCT patient_nbr)            AS unique_patients,
    SUM(readmitted_30d)                    AS readmissions_30d,
    ROUND(100 * AVG(readmitted_30d), 2)    AS readmit_rate_pct
FROM encounters;

SELECT * FROM encounters LIMIT 5;