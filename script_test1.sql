CREATE DATABASE xiso_staging;

USE xiso_staging;

CREATE DATABASE xiso_staging;

USE xiso_staging;

CREATE TABLE user (
  user_id integer PRIMARY KEY,
  user_name varchar(255) NOT NULL,
  user_lastname varchar(255) NOT NULL,
  local_account_id integer UNIQUE NOT NULL,
  usd_account_id integer UNIQUE NOT NULL,
  nacional_id varchar(255) UNIQUE NOT NULL
);

CREATE TABLE user_kyc (
  user_id integer PRIMARY KEY,
  user_name varchar(255) NOT NULL,
  user_lastname varchar(255) NOT NULL,
  nacional_id varchar(255) UNIQUE NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  address varchar(255) NOT NULL,
  birthday date NOT NULL,
  phone integer UNIQUE NOT NULL
);

CREATE TABLE user_cards (
  user_id integer PRIMARY KEY,
  method_id integer UNIQUE NOT NULL,
  method_name varchar(255) UNIQUE NOT NULL,
  card_num integer UNIQUE NOT NULL,
  cvv_num integer UNIQUE NOT NULL,
  card_name varchar(255) NOT NULL,
  card_lastname varchar(255) NOT NULL
);

CREATE TABLE usd_accounts (
  usd_account_id integer PRIMARY KEY,
  user_id integer UNIQUE NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  user_name varchar(255) NOT NULL,
  user_lastname varchar(255) NOT NULL
);

CREATE TABLE local_accounts (
  local_account_id integer PRIMARY KEY,
  user_id integer UNIQUE NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  user_name varchar(255) NOT NULL,
  user_lastname varchar(255) NOT NULL
);

CREATE TABLE deposit (
  deposit_id integer PRIMARY KEY,
  account_id integer UNIQUE NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  merchant_id integer UNIQUE NOT NULL,
  merchant_name varchar(255) UNIQUE NOT NULL,
  external_id varchar(255) UNIQUE NOT NULL,
  date timestamp NOT NULL
);

CREATE TABLE payin (
  payin_id bigint PRIMARY KEY,
  account_id integer UNIQUE NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  provider_id integer NOT NULL,
  provider_name varchar(255) UNIQUE NOT NULL,
  external_id varchar(255) UNIQUE NOT NULL,
  provider_fee integer NOT NULL,
  date timestamp NOT NULL
);

CREATE TABLE payout (
  payout_id integer PRIMARY KEY,
  account_id integer UNIQUE NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  provider_id integer NOT NULL,
  provider_name varchar(255) UNIQUE NOT NULL,
  external_id varchar(255) UNIQUE NOT NULL,
  provider_fee integer NOT NULL,
  date timestamp NOT NULL
);

CREATE TABLE merchant (
  merchant_id integer PRIMARY KEY,
  merchant_name varchar(255) UNIQUE NOT NULL,
  merchant_type varchar(255) NOT NULL,
  amount integer NOT NULL,
  currency varchar(255) NOT NULL,
  merchant_fee integer NOT NULL
);

CREATE TABLE financial_provider (
  provider_id integer PRIMARY KEY,
  provider_name varchar(255) UNIQUE NOT NULL,
  provider_type varchar(255) NOT NULL,
  payin_status boolean NOT NULL,
  payout_status boolean NOT NULL,
  provider_fee integer NOT NULL
);

ALTER TABLE user_kyc ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES user_kyc (user_id);

ALTER TABLE user_cards ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (usd_account_id) REFERENCES user (usd_account_id);

ALTER TABLE local_accounts ADD FOREIGN KEY (user_id) REFERENCES user (user_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (usd_account_id) REFERENCES deposit (account_id);

ALTER TABLE local_accounts ADD FOREIGN KEY (local_account_id) REFERENCES deposit (account_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (usd_account_id) REFERENCES payin (account_id);

ALTER TABLE local_accounts ADD FOREIGN KEY (local_account_id) REFERENCES payin (account_id);

ALTER TABLE usd_accounts ADD FOREIGN KEY (usd_account_id) REFERENCES payout (account_id);

ALTER TABLE local_accounts ADD FOREIGN KEY (local_account_id) REFERENCES payout (account_id);

ALTER TABLE deposit ADD FOREIGN KEY (merchant_id) REFERENCES merchant (merchant_id);

ALTER TABLE payin ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);

ALTER TABLE payout ADD FOREIGN KEY (provider_id) REFERENCES financial_provider (provider_id);
