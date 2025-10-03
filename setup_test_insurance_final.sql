-- AI-generated code - Test insurance company setup for OpenEMR auto-billing testing
-- This script creates test data including insurance company, patient, and insurance assignments

-- Create test insurance company
INSERT INTO insurance_companies (
    name,
    attn,
    cms_id,
    ins_type_code,
    x12_receiver_id,
    x12_default_partner_id
) VALUES (
    'BadgerCare Insurance Company',
    'Claims Processing Department', 
    'BC001',
    1,
    'BC001',
    1
);

-- Get the insurance company ID we just created
SET @insurance_company_id = LAST_INSERT_ID();

-- Create address for the insurance company
INSERT INTO addresses (
    line1,
    city,
    state,
    zip,
    foreign_id
) VALUES (
    '123 Insurance Way',
    'Healthcare City',
    'TX',
    '75001',
    @insurance_company_id
);

-- Create test patient (pid will auto-increment)
INSERT INTO patient_data (
    fname,
    lname,
    DOB,
    sex,
    street,
    city,
    state,
    postal_code,
    phone_home,
    ss,
    pubpid
) VALUES (
    'TestPatient',
    'AutoBilling',
    '1985-06-15',
    'Male',
    '456 Test Street',
    'Test City',
    'TX',
    '75002',
    '5559876543',
    '123456789',
    'TEST001'
);

-- Get the patient ID we just created
SET @patient_id = LAST_INSERT_ID();

-- Create primary insurance assignment for the test patient
INSERT INTO insurance_data (
    pid,
    type,
    provider,
    policy_number,
    group_number,
    subscriber_fname,
    subscriber_lname,
    subscriber_relationship,
    subscriber_DOB,
    subscriber_ss,
    date
) VALUES (
    @patient_id,
    'primary',
    @insurance_company_id,
    'BC001-TEST-001',
    'BADGER-GROUP-001',
    'TestPatient',
    'AutoBilling',
    'self',
    '1985-06-15',
    '123456789',
    NOW()
);

-- Display success message
SELECT 'Test insurance setup completed successfully!' as Status;
SELECT CONCAT('Insurance Company ID: ', @insurance_company_id) as InsuranceInfo;
SELECT CONCAT('Patient ID: ', @patient_id) as PatientInfo;

-- End AI-generated code