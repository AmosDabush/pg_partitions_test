-- Drop all partitions
DROP TABLE IF EXISTS "Swaps_partition_1_100" CASCADE;
DROP TABLE IF EXISTS "Swaps_partition_101_200" CASCADE;
DROP TABLE IF EXISTS "Swaps_partition_201_300" CASCADE;
DROP TABLE IF EXISTS "Swaps_partition_default" CASCADE;

-- Drop the main partitioned table
DROP TABLE IF EXISTS "Swaps" CASCADE;


-----------------------------------------

-- Step 1: Create the partitioned table
-- Base table that manages partitions by hospitalId range
CREATE TABLE "Swaps" (
    "id" SERIAL NOT NULL, -- Unique identifier for each record
    "hospitalId" INTEGER NOT NULL, -- Hospital ID, used for partitioning
    "patientId" INTEGER, -- Patient ID
    "caseData" JSONB, -- Additional data in JSON format
    "isActive" BOOLEAN DEFAULT true, -- Active status
    "admissionDate" TIMESTAMP WITH TIME ZONE, -- Admission date
    PRIMARY KEY ("id", "hospitalId") -- Composite primary key
) PARTITION BY RANGE ("hospitalId");


-- Step 2: Create partitions
-- Create partitions based on hospitalId range
CREATE TABLE "Swaps_partition_1_100" PARTITION OF "Swaps"
FOR VALUES FROM (1) TO (101);

CREATE TABLE "Swaps_partition_101_200" PARTITION OF "Swaps"
FOR VALUES FROM (101) TO (201);

CREATE TABLE "Swaps_partition_default" PARTITION OF "Swaps"
DEFAULT; -- Default partition for data not matching any range

-- Step 3: Insert data into the partitioned table
-- Insert data into the base table, data will be routed automatically to partitions
INSERT INTO "Swaps" ("hospitalId", "patientId", "caseData", "isActive", "admissionDate")
VALUES
(50, 101, '{"diagnosis": "flu", "severity": "mild"}', true, '2024-12-12'),
(150, 102, '{"diagnosis": "cold", "severity": "moderate"}', true, '2024-12-13'),
(300, 103, '{"diagnosis": "fracture", "severity": "severe"}', true, '2024-12-14');

SELECT * FROM "Swaps";

SELECT * FROM "Swaps_partition_1_100";

SELECT * FROM "Swaps_partition_101_200";

SELECT * FROM "Swaps_partition_default";

SELECT * FROM "Swaps_partition_201_300";

-- Step 4: Query the partitioned table
-- Query the base table. PostgreSQL will scan only relevant partitions
SELECT * FROM "Swaps" WHERE "hospitalId" BETWEEN 1 AND 100;

-- Step 5: Add a new partition
-- Create a new partition for an additional range of hospitalId
CREATE TABLE "Swaps_partition_201_300" PARTITION OF "Swaps"
FOR VALUES FROM (201) TO (300);

-- Step 6: Migrate data between partitions (optional)
-- Move data from one partition to another if needed
-- Ensure data falls within the correct range
INSERT INTO "Swaps" ("hospitalId", "patientId", "caseData", "isActive", "admissionDate")
SELECT "hospitalId", "patientId", "caseData", "isActive", "admissionDate"
FROM "Swaps_partition_default"
WHERE "hospitalId" BETWEEN 201 AND 300;

-- Delete migrated data from the default partition
DELETE FROM "Swaps_partition_default" WHERE "hospitalId" BETWEEN 201 AND 300;

-- Step 7: Drop an old partition (optional)
-- Drop a partition that is no longer in use
DROP TABLE "Swaps_partition_1_100";

-- Step 8: Default partition check
-- Check data that entered the default partition
SELECT * FROM "Swaps_partition_default";
