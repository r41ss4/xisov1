-- This file is to introduce data directly via INSERT statements

-- INSERT user info in users table
INSERT INTO users (user_name, user_lastname, phone, nacional_id, birthdate) 
VALUES ('Tester', 'Testty', '598678778', '73520962', '1999-04-11');
-- Review tables row to see if insert properly worked
SELECT * FROM users;
SELECT * FROM user_kyc;
SELECT * FROM usd_accounts;

-- INSERT provider info in financial_provider table
INSERT INTO financial_provider (provider_name, provider_type, payin_status, payout_status, provider_fee)
VALUES ('VISA', 'Credit Card', TRUE, TRUE, 10);
-- Review financial_provider table
SELECT * FROM financial_provider;

-- INSERT merchant info in merchants table
INSERT INTO merchant (merchant_name, merchant_type, amount, currency, merchant_fee) 
VALUES ('Acme Corp', 'Retail', 10000.00, 'USD', 2);
-- Review merchants table
SELECT * FROM merchant;

-- INSERT payin transactions 
-- Use the usd_account_id and provider_id automatically generated from previous inserts
INSERT INTO payin (usd_account_id, amount, currency, provider_id, provider_name, provider_fee)
VALUES (
    (SELECT usd_account_id FROM usd_accounts WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Tester' LIMIT 1)), 
    45.00, 'USD', 
    (SELECT provider_id FROM financial_provider WHERE provider_name = 'VISA' LIMIT 1), 
    'VISA', 675
);
-- Review payin table
SELECT * FROM payin;

-- INSERT payout transactions
-- Use the usd_account_id and provider_id automatically generated from previous inserts
INSERT INTO payout (usd_account_id, amount, currency, provider_id, provider_name, provider_fee) 
VALUES (
    (SELECT usd_account_id FROM usd_accounts WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Tester' LIMIT 1)), 
    30.00, 'USD', 
    (SELECT provider_id FROM financial_provider WHERE provider_name = 'VISA' LIMIT 1), 
    'VISA', 10
);
-- Review payout table
SELECT * FROM payout;

-- INSERT deposit transactions
-- Use the usd_account_id and merchant_id automatically generated from previous inserts
INSERT INTO deposit (usd_account_id, amount, currency, merchant_id, merchant_name) 
VALUES (
    (SELECT usd_account_id FROM usd_accounts WHERE user_id = (SELECT user_id FROM users WHERE user_name = 'Tester' LIMIT 1)), 
    100.00, 'USD', 
    (SELECT merchant_id FROM merchant WHERE merchant_name = 'Acme Corp' LIMIT 1), 
    'Acme Corp'
);
-- Review deposit table
SELECT * FROM deposit;
