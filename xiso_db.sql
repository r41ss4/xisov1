-- Create db and use it
CREATE DATABASE xiso_staging;

USE xiso_staging;

-- Create tables
-- Create users main table
CREATE TABLE users (
  user_id integer UNIQUE PRIMARY KEY,
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname',
  phone varchar (25) UNIQUE NOT NULL,
  usd_account_id integer UNIQUE NOT NULL,
  nacional_id varchar(255) UNIQUE NOT NULL,
  birthdate date
);

-- Create table for extra user info
CREATE TABLE user_kyc (
  user_id integer PRIMARY KEY,
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname',
  nacional_id varchar(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  address varchar(255) UNIQUE NOT NULL,
  birthdate date,
  phone varchar (25) UNIQUE NOT NULL,
  	FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

-- Create table for cards
CREATE TABLE user_cards (
  user_id integer PRIMARY KEY,
  method_id integer UNIQUE,
  method_name varchar(255) UNIQUE,
  card_num integer UNIQUE,
  cvv_num integer UNIQUE,
  card_name varchar(255),
  card_lastname varchar(255),
	FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

-- Create table to track account money transactions
CREATE TABLE usd_accounts (
  usd_account_id integer PRIMARY KEY,
  user_id integer UNIQUE NOT NULL,
  amount integer,
  currency varchar(255) DEFAULT 'USD',
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname',
  	FOREIGN KEY (user_id)
        REFERENCES users(user_id)
);

-- Create table for all deposits
CREATE TABLE deposit (
  deposit_id integer PRIMARY KEY,
  account_id integer UNIQUE,
  amount integer,
  currency varchar(255) DEFAULT 'USD',
  merchant_id integer UNIQUE,
  merchant_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  deposit_date timestamp,
	FOREIGN KEY (account_id)
        REFERENCES usd_accounts(usd_account_id)
);

-- Create table for all payin
CREATE TABLE payin (
  payin_id bigint PRIMARY KEY,
  account_id integer UNIQUE,
  amount integer,
  currency varchar(255) DEFAULT 'USD',
  provider_id integer,
  provider_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payin_date timestamp,
  	FOREIGN KEY (account_id)
        REFERENCES usd_accounts(usd_account_id)
);

-- Create table for all payouts
CREATE TABLE payout (
  payout_id integer PRIMARY KEY,
  account_id integer UNIQUE,
  amount integer,
  currency varchar(255) DEFAULT 'USD',
  provider_id integer,
  provider_name varchar(255) UNIQUE,
  external_id char(25) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payout_date timestamp,
  	FOREIGN KEY (account_id)
        REFERENCES usd_accounts(usd_account_id)
);

-- Create table for merchants 
CREATE TABLE merchant (
  merchant_id integer PRIMARY KEY,
  merchant_name varchar(255) UNIQUE,
  merchant_type varchar(255),
  amount integer,
  currency varchar(255) DEFAULT 'USD',
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


-- Create trigger to cascade info when user creates an account
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
        0,       -- Default value for amount
        '',      -- Default value for currency
        NEW.user_name,
        NEW.user_lastname
        
    );
END//

DELIMITER ;






