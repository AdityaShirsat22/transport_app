-- Migration: Add staffing_date to transports table
-- Description: Adds optional staffing_date timestamp column to transports

ALTER TABLE transports 
ADD COLUMN IF NOT EXISTS staffing_date TIMESTAMPTZ;

COMMENT ON COLUMN transports.staffing_date IS 'Fixed staffing date assigned during booking creation';
