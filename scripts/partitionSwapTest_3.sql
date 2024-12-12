-- Select all data from the original table
select * from "Cases" c;

-- Select all data from the temporary table
select * from "Cases_temp" ct;

-- Insert data into the original table
INSERT INTO "Cases" ("hospitalId", "patientId", "caseData", "isActive", "admissionDate", "createdAt", "updatedAt")
VALUES
(1, 101, '{"diagnosis": "flu", "severity": "mild"}', true, '2024-12-01', NOW(), NOW()),
(2, 102, '{"diagnosis": "cold", "severity": "moderate"}', true, '2024-12-02', NOW(), NOW()),
(3, 103, '{"diagnosis": "fracture", "severity": "severe"}', true, '2024-12-03', NOW(), NOW()),
(4, 104, '{"diagnosis": "fever", "severity": "high"}', true, '2024-12-04', NOW(), NOW()),
(5, 105, '{"diagnosis": "migraine", "severity": "moderate"}', true, '2024-12-05', NOW(), NOW());

-- Create a temporary table for the new partition
CREATE TABLE "Cases_temp" (
    "id" SERIAL PRIMARY KEY,
    "hospitalId" INTEGER NOT NULL,
    "patientId" INTEGER,
    "caseData" JSONB,
    "isActive" BOOLEAN DEFAULT true,
    "admissionDate" TIMESTAMP WITH TIME ZONE,
    "createdAt" TIMESTAMP WITH TIME ZONE NOT NULL,
    "updatedAt" TIMESTAMP WITH TIME ZONE NOT NULL
);

-- Copy data from the original table to the new partition
INSERT INTO "Cases_temp"
SELECT * FROM "Cases";

-- Add new records to the temporary partition
INSERT INTO "Cases_temp" ("hospitalId", "patientId", "caseData", "isActive", "admissionDate", "createdAt", "updatedAt")
VALUES
(6, 106, '{"diagnosis": "aa", "severity": "mild"}', true, '2024-12-01', NOW(), NOW()),
(7, 107, '{"diagnosis": "ss", "severity": "moderate"}', true, '2024-12-02', NOW(), NOW()),
(8, 108, '{"diagnosis": "ff", "severity": "severe"}', true, '2024-12-03', NOW(), NOW()),
(9, 109, '{"diagnosis": "gg", "severity": "high"}', true, '2024-12-04', NOW(), NOW()),
(10, 110, '{"diagnosis": "hh", "severity": "moderate"}', true, '2024-12-05', NOW(), NOW());

-- View tables
select * from "Cases_temp" ct;
select * from "Cases_backup" c;
select * from "Cases" c;

-- Rename the original table
ALTER TABLE "Cases" RENAME TO "Cases_backup";

-- Rename the temporary partition to the original table's name
ALTER TABLE "Cases_temp" RENAME TO "Cases";

-- Clear data from tables
truncate table "Cases";
truncate table "Cases_temp";
truncate table "Cases_backup";

-- Drop all tables
drop table "Cases";
drop table "Cases_temp";
