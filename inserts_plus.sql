-- This file is to introduce data directly via INSERT statements

-- INSERT user info in users table
INSERT INTO users (user_name, user_lastname, phone, nacional_id, birthdate) 
VALUES ('Tester', 'Testty', '598678778', '73520962', '1999-04-11');

-- Review tables row to see if insert properly worked
SELECT * FROM users;
SELECT * FROM user_kyc;
SELECT * FROM usd_accounts;


-- INSERT provider info in financial_provider table

-- Review financial_provider table


-- INSERT merchant info in merchants table

-- Review merchants table


-- INSERT payin transactions 

-- Review payin table


-- INSERT payout transactions 

-- Review payout table


-- INSERT deposit transactions 

-- Review depósit table

INSERT INTO payin (payin_id, account_id, amount, provider_id, provider_name, external_id, 
provider_fee)
VALUES ('6897', '6897879', 05768, '897698', '6879698', '6876', 687);


-- Generally used statements while designing the database
DROP DATABASE xiso_staging;
DROP DATABASE xiso_staging_t;
SELECT * FROM users;
SELECT * FROM user_kyc;
SELECT * FROM usd_accounts;


