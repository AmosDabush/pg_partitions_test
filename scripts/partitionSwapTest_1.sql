-- Initialization
DROP TABLE "Swaps";

-- Step 1: Create the partitioned table
-- Create the base table partitioned by hospitalId
CREATE TABLE Swaps (
    id SERIAL, -- Unique identifier
    hospitalId INT NOT NULL, -- Hospital identifier
    patientId INT, -- Patient identifier
    caseData JSONB, -- Additional case information
    isActive BOOLEAN DEFAULT TRUE, -- Indicates if the record is active
    admissionDate TIMESTAMPTZ, -- Admission date
    createdAt TIMESTAMPTZ DEFAULT NOW(), -- Creation timestamp
    updatedAt TIMESTAMPTZ DEFAULT NOW(), -- Update timestamp
    PRIMARY KEY (id, hospitalId) -- Composite primary key including hospitalId
) PARTITION BY LIST (hospitalId);

-- Create a partition for hospital 1
CREATE TABLE Swaps_hospital_1 PARTITION OF Swaps FOR VALUES IN (1);

-- Create a partition for hospital 2
CREATE TABLE Swaps_hospital_2 PARTITION OF Swaps FOR VALUES IN (2);

-- Create a default partition for hospitals without a specific partition
CREATE TABLE Swaps_default PARTITION OF Swaps DEFAULT;

-- Step 2: Insert data into the partitions
-- Insert data into the existing partitions
INSERT INTO Swaps (hospitalId, patientId, caseData, isActive, admissionDate)
VALUES
(1, 101, '{"diagnosis": "flu", "severity": "mild"}', TRUE, '2024-12-01'),
(1, 102, '{"diagnosis": "cold", "severity": "moderate"}', TRUE, '2024-12-02'),
(2, 103, '{"diagnosis": "fracture", "severity": "severe"}', TRUE, '2024-12-03'),
(2, 104, '{"diagnosis": "fever", "severity": "high"}', TRUE, '2024-12-04');

-- Step 3: Create a temporary partition
-- Create a temporary partition for updating data for hospital 1
CREATE TABLE Swaps_hospital_1_temp (LIKE Swaps INCLUDING ALL);

-- Step 4: Populate the temporary partition
-- Transfer data from the existing partition to the temporary partition
INSERT INTO Swaps_hospital_1_temp
SELECT * FROM Swaps_hospital_1;

-- Add new data to the temporary partition
INSERT INTO Swaps_hospital_1_temp (hospitalId, patientId, caseData, isActive, admissionDate)
VALUES
(1, 105, '{"diagnosis": "migraine", "severity": "moderate"}', TRUE, '2024-12-05'),
(1, 106, '{"diagnosis": "asthma", "severity": "severe"}', TRUE, '2024-12-06');

-- Step 5: Swap the partitions
-- Detach the old partition
ALTER TABLE Swaps DETACH PARTITION Swaps_hospital_1;

-- Attach the temporary partition as the main partition
ALTER TABLE Swaps ATTACH PARTITION Swaps_hospital_1_temp FOR VALUES IN (1);

-- Step 6: Drop the old partition
-- Delete the old partition after the swap
DROP TABLE Swaps_hospital_1;

-- Step 7: Verify the data
-- Check the partitions and data in the main table
SELECT * FROM Swaps;
