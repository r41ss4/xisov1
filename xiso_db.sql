-- Create db and use it
CREATE DATABASE xiso_staging;

USE xiso_staging;

-- Create tables
-- Create users main table
CREATE TABLE users (
  user_id char(15) UNIQUE PRIMARY KEY,
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname',
  phone varchar (25) UNIQUE NOT NULL,
  usd_account_id integer UNIQUE NOT NULL,
  nacional_id varchar(255) UNIQUE NOT NULL,
  birthdate date
);

-- Create table for extra user info
CREATE TABLE user_kyc (
  user_id char(15) PRIMARY KEY,
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname',
  nacional_id varchar(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  address varchar(255) UNIQUE NOT NULL,
  birthdate date,
  phone varchar (25) UNIQUE NOT NULL
);

-- Create table for cards
CREATE TABLE user_cards (
  user_id char(15) PRIMARY KEY,
  method_id integer UNIQUE,
  method_name varchar(255) UNIQUE,
  card_num integer UNIQUE,
  cvv_num integer UNIQUE,
  card_name varchar(255),
  card_lastname varchar(255)
);

-- Create table to track account money transactions
CREATE TABLE usd_accounts (
  usd_account_id integer PRIMARY KEY,
  user_id char(15) UNIQUE NOT NULL,
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname'
);

-- Create table for all deposits
CREATE TABLE deposit (
  deposit_id integer PRIMARY KEY,
  account_id integer UNIQUE,
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  merchant_id integer UNIQUE,
  merchant_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  deposit_date timestamp
);

-- Create table for all payin
CREATE TABLE payin (
  payin_id bigint PRIMARY KEY,
  account_id integer UNIQUE,
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  provider_id integer,
  provider_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payin_date timestamp
);

-- Create table for all payouts
CREATE TABLE payout (
  payout_id integer PRIMARY KEY,
  account_id integer UNIQUE,
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  provider_id integer,
  provider_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payout_date timestamp
);

-- Create table for merchants 
CREATE TABLE merchant (
  merchant_id integer PRIMARY KEY,
  merchant_name varchar(255) UNIQUE,
  merchant_type varchar(255),
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  merchant_fee integer
);

-- Create table for financial providers
CREATE TABLE financial_provider (
  provider_id integer PRIMARY KEY,
  provider_name varchar(255) UNIQUE,
  provider_type varchar(255),
  payin_status boolean,
  payout_status boolean,
  provider_fee integer
);

-- Create stored procedure to generate a unique 15-digit user ID
DELIMITER //

DELIMITER //

CREATE PROCEDURE generate_user_id(OUT new_id CHAR(15))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE temp_id CHAR(15);

    -- Loop until a unique ID is found
    WHILE NOT done DO
        -- Generate a unique 15-digit ID
        SET temp_id = LPAD(FLOOR(RAND() * 1000000000000000), 15, '0');

        -- Check if this ID already exists
        IF NOT EXISTS (SELECT 1 FROM users WHERE user_id = temp_id) THEN
            SET done = TRUE;
        END IF;
    END WHILE;

    -- Set the output parameter
    SET new_id = temp_id;
END//

DELIMITER ;

-- Create trigger to generate user ID before insert
DELIMITER //

CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE new_user_id CHAR(15);
    
    -- Call the stored procedure to generate a new user ID
    CALL generate_user_id(new_user_id);
    
    -- Set the new user ID for the inserted row
    SET NEW.user_id = new_user_id;
END//

-- Create trigger to cascade info when user creates an account (insert)
DELIMITER //

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    -- Insert into user_kyc
    INSERT INTO user_kyc (
        user_id,
        user_name,
        user_lastname,
        nacional_id,
        email,
        address,
        birthdate,
        phone
    ) VALUES (
        NEW.user_id,
        NEW.user_name,
        NEW.user_lastname,
        NEW.nacional_id,
        '',  -- Default empty values, adjust as needed
        '',
        NEW.birthdate,
        NEW.phone
    );

    -- Insert into user_cards
    INSERT INTO user_cards (
        user_id,
        method_id,
        method_name,
        card_num,
        cvv_num,
        card_name,
        card_lastname
    ) VALUES (
        NEW.user_id,
        0,       -- Default values, adjust as needed
        '',
        0, 
        0,
        '',
        ''
    );

     -- Insert into usd_accounts
    INSERT INTO usd_accounts (
        usd_account_id,
        user_id,
        amount,
        currency,
        user_name,
        user_lastname
    ) VALUES (
        NEW.usd_account_id,
        NEW.user_id,
        0.00,          -- Default value for amount
        'USD',         -- Default value for currency
        NEW.user_name,
        NEW.user_lastname
        
    );
END//

DELIMITER ;

ALTER TABLE user_kyc ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES user_kyc (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE deposit ADD FOREIGN KEY (merchant_id) REFERENCES merchant (merchant_id);

ALTER TABLE payin ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);

ALTER TABLE payout ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);



