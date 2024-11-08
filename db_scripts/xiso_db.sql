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
  usd_account_id char(15) UNIQUE NOT NULL,
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
  provider_id char(4),
  method_name varchar(255),
  card_num integer,
  cvv_num integer,
  card_name varchar(255),
  card_lastname varchar(255)
);

-- Create table to track account money transactions
CREATE TABLE usd_accounts (
  usd_account_id char(15) PRIMARY KEY,
  user_id char(15) UNIQUE NOT NULL,
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  user_name varchar(255) NOT NULL DEFAULT 'DefaultName',
  user_lastname varchar(255) NOT NULL DEFAULT 'DefaultLastname'
);

-- Create table for all deposits
CREATE TABLE deposit (
  deposit_id char(40) PRIMARY KEY,
  usd_account_id char(15),
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  merchant_id char(10),
  merchant_name varchar(255),
  external_id char(36) UNIQUE NOT NULL DEFAULT (UUID()),
  deposit_date timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Create table for all payin
CREATE TABLE payin (
  payin_id char(40) PRIMARY KEY,
  usd_account_id char(15),
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  provider_id char(4),
  provider_name varchar(255),
  external_id char(36) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payin_date timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Create table for all payouts
CREATE TABLE payout (
  payout_id char(40) PRIMARY KEY,
  usd_account_id char(15),
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  provider_id char(4),
  provider_name varchar(255),
  external_id char(36) UNIQUE NOT NULL DEFAULT (UUID()),
  provider_fee integer,
  payout_date timestamp DEFAULT CURRENT_TIMESTAMP
);

-- Create table for merchants 
CREATE TABLE merchant (
  merchant_id char(10) UNIQUE PRIMARY KEY,
  merchant_name varchar(255) UNIQUE,
  merchant_type varchar(255),
  amount decimal (15, 2) NOT NULL,
  currency varchar(3) DEFAULT 'USD',
  merchant_fee integer
);

-- Create table for financial providers
CREATE TABLE financial_provider (
  provider_id char(4) UNIQUE PRIMARY KEY,
  provider_name varchar(255) UNIQUE,
  provider_type varchar(255),
  payin_status boolean DEFAULT FALSE,
  payout_status boolean DEFAULT FALSE,
  provider_fee integer
);

-- Create elements needed when users create an account
-- Create produres and triggers for the db to properly function 
-- Create stored procedure to generate a unique 15-digit user_id
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

-- Create stored procedure to generate a unique 15 digit and letter usd_account_id
DELIMITER //

CREATE PROCEDURE generate_alphanumeric_id(OUT new_usd_account_id CHAR(15))
BEGIN
    DECLARE done INT DEFAULT FALSE;
	DECLARE temp_usd_id CHAR(15);
    DECLARE chars CHAR(36) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE i INT DEFAULT 1;
    DECLARE random_index INT;

    -- Function to generate a random alphanumeric ID
    SET @generate_random_id = CONCAT(
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1)
    );

    -- Loop until a unique ID is found
    WHILE NOT done DO
        -- Generate a random 15-character alphanumeric ID
        SET temp_usd_id = @generate_random_id;

        -- Check if this ID already exists
        IF NOT EXISTS (SELECT 1 FROM usd_accounts WHERE usd_account_id = temp_usd_id) THEN
            SET done = TRUE;
        END IF;
    END WHILE;

    -- Set the output parameter
    SET new_usd_account_id = temp_usd_id;
END//

DELIMITER ;

-- Create trigger to generate user_id  and usd_account_id before insert
DELIMITER //

CREATE TRIGGER before_user_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE new_user_id CHAR(15);
    DECLARE new_usd_account_id CHAR(15);
    
    -- Call the stored procedure to generate a new user ID
    CALL generate_user_id(new_user_id);
    
    -- Set the new user ID for the inserted row
    SET NEW.user_id = new_user_id;

    -- Call the stored procedure to generate a new usd account ID
    CALL generate_alphanumeric_id(new_usd_account_id);

    -- Set the new usd account ID for the inserted row
    SET NEW.usd_account_id = new_usd_account_id;


END//

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
        provider_id,
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


-- Create elements needed for inserts in financial provider id
-- Create procedures and trigger for the db to properly function
-- Create stored procedure to generate a unique 3 digit and letters id for providers
DELIMITER //

CREATE PROCEDURE generate_provider_id(OUT new_provider_id CHAR(4))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE temp_provider_id CHAR(4);
    DECLARE chars CHAR(36) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    
    -- Loop until a unique ID is found
    WHILE NOT done DO
        -- Generate a random 4-character alphanumeric ID
        SET temp_provider_id = CONCAT(
            SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
            SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
            SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
            SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1)
        );
        
        -- Check if this ID already exists
        IF NOT EXISTS (SELECT 1 FROM financial_provider WHERE provider_id = temp_provider_id) THEN
            SET done = TRUE;
        END IF;
    END WHILE;

    -- Set the output parameter
    SET new_provider_id = temp_provider_id;
END//

DELIMITER ;

-- Create trigger for id for financial_provider
DELIMITER //

CREATE TRIGGER before_provider_insert
BEFORE INSERT ON financial_provider
FOR EACH ROW
BEGIN
    DECLARE new_provider_id CHAR(4);

    -- Call the stored procedure to generate a new provider ID
    CALL generate_provider_id(new_provider_id);

    -- Set the new provider ID for the inserted row
    SET NEW.provider_id = new_provider_id;
END//

DELIMITER ;


-- Create elements needed when users create a transaction (payin, payout or deposit)
-- Create procedures and triggers for the db to properly function 
-- Create stored procedure to generate a unique 40 digit and letter  id for transactions
DELIMITER //

CREATE PROCEDURE generate_trans_id(OUT new_trans_id CHAR(40))
BEGIN
    DECLARE done INT DEFAULT FALSE;
  DECLARE temp_trans_id CHAR(40);
    DECLARE chars CHAR(36) DEFAULT '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE i INT DEFAULT 1;
    DECLARE random_trans_index INT;

    -- Function to generate a random transaction alphanumeric ID
    SET @generate_trans_random_id = CONCAT(
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1),
        SUBSTRING(chars, FLOOR(RAND() * 36) + 1, 1)
    );

    -- Loop until a unique ID is found
    WHILE NOT done DO
        -- Generate a random 40-character alphanumeric ID
        SET temp_trans_id = @generate_trans_random_id;

        -- Check if this ID already exists through payout, paying and deposit
        IF NOT EXISTS (SELECT 1 FROM payout WHERE payout_id = temp_trans_id)
           AND NOT EXISTS (SELECT 1 FROM payin WHERE payin_id = temp_trans_id)
           AND NOT EXISTS (SELECT 1 FROM deposit WHERE deposit_id = temp_trans_id) THEN
            SET done = TRUE;
        END IF;
    END WHILE;

    -- Set the output parameter
    SET new_trans_id = temp_trans_id;
END//

DELIMITER ;

-- Create trigger for id for payin
DELIMITER //

CREATE TRIGGER before_payin_insert
BEFORE INSERT ON payin
FOR EACH ROW
BEGIN
    DECLARE new_trans_id CHAR(40);

    -- Call the stored procedure to generate a new transaction ID
    CALL generate_trans_id(new_trans_id);

    -- Set the new transaction ID for the inserted row
    SET NEW.payin_id = new_trans_id;
END//

DELIMITER ;

-- Create trigger for id for payout
DELIMITER //

CREATE TRIGGER before_payout_insert
BEFORE INSERT ON payout
FOR EACH ROW
BEGIN
    DECLARE new_trans_id CHAR(40);

    -- Call the stored procedure to generate a new transaction ID
    CALL generate_trans_id(new_trans_id);

    -- Set the new transaction ID for the inserted row
    SET NEW.payout_id = new_trans_id;
END//

DELIMITER ;

-- Create trigger for id for deposit
DELIMITER //

CREATE TRIGGER before_deposit_insert
BEFORE INSERT ON deposit
FOR EACH ROW
BEGIN
    DECLARE new_trans_id CHAR(40);

    -- Call the stored procedure to generate a new transaction ID
    CALL generate_trans_id(new_trans_id);

    -- Set the new transaction ID for the inserted row
    SET NEW.deposit_id = new_trans_id;
END//

DELIMITER ;


-- Create elements needed when merchants create an account
-- Create produres and triggers for the db to properly function 
-- Create stored procedure to generate a unique 10-digit merchant_id
DELIMITER //

CREATE PROCEDURE generate_merchant_id(OUT new_merchant_id CHAR(15))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE temp_merchant_id CHAR(10);

    -- Loop until a unique ID is found
    WHILE NOT done DO
        -- Generate a unique 10-digit ID
        SET temp_merchant_id = LPAD(FLOOR(RAND() * 1000000000000000), 10, '0');

        -- Check if this ID already exists
        IF NOT EXISTS (SELECT 1 FROM merchant WHERE merchant_id = temp_merchant_id) THEN
            SET done = TRUE;
        END IF;
    END WHILE;

    -- Set the output parameter
    SET new_merchant_id = temp_merchant_id;
END//

DELIMITER ;

-- Create trigger to generate merchant_id before insert
DELIMITER //

CREATE TRIGGER before_merchant_insert
BEFORE INSERT ON merchant
FOR EACH ROW
BEGIN
    DECLARE new_merchant_id CHAR(10);
    
    -- Call the stored procedure to generate a new user ID
    CALL generate_merchant_id(new_merchant_id);
    
    -- Set the new user ID for the inserted row
    SET NEW.merchant_id = new_merchant_id;

    -- Call the stored procedure to generate a new usd account ID
    CALL generate_merchant_id(new_merchant_id);

    -- Set the new usd account ID for the inserted row
    SET NEW.merchant_id = new_merchant_id;


END//


-- Foreig keys
-- Alter tables for foreign keys and references
ALTER TABLE user_kyc ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES user_kyc (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (user_id) REFERENCES users (user_id);

ALTER TABLE deposit ADD FOREIGN KEY (merchant_id) REFERENCES merchant (merchant_id);

ALTER TABLE payin ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);

ALTER TABLE payout ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);

ALTER TABLE payin ADD FOREIGN KEY (usd_account_id) REFERENCES usd_accounts (usd_account_id);

ALTER TABLE payout ADD FOREIGN KEY (usd_account_id) REFERENCES usd_accounts (usd_account_id);

ALTER TABLE deposit ADD FOREIGN KEY (usd_account_id) REFERENCES usd_accounts (usd_account_id);


