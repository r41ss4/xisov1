# Database guidance

## External details
*   Type of transactions
    *   **Deposits:** Users can deposit money in merchants (such as Zara). 
    *   **Payin:** Money from external banks/payment providers to XISO account. 
    *   **Payout:** Money from XISO to external banks/payment providers.

## Tables and structure 

### Tables and structure: Overview 
### Table: User 
*   **Users**: Table for all users, it is [theoretically] created when someone registers.    
    - `user_id`: Unique identifier for the user (15 characters). Automatically generated using a stored procedure.
    - `user_name`: The user's first name.
    - `user_lastname`: The user's last name.
    - `phone`: The user's phone number. This must be unique.
    - `usd_account_id`: Unique identifier for the user’s USD account (15 characters). Automatically generated using a stored procedure.
    - `nacional_id`: The user’s national identification number. Must be unique.
    - `birthdate`: The user’s birthdate.

**Primary Key**: `user_id`

### Table: User KYC 
*   **Users KYC**: Table regarding users detail kyc.    
    - `user_id`: Unique identifier for the user (15 characters). Foreign key referencing `users(user_id)`.
    - `user_name`: The user's first name.
    - `user_lastname`: The user's last name.
    - `nacional_id`: The user's national ID (must match `users(nacional_id)`).
    - `email`: The user’s email address. Must be unique.
    - `address`: The user’s physical address.
    - `birthdate`: The user’s birthdate.
    - `phone`: The user’s phone number (must match `users(phone)`).

**Primary Key**: `user_id`  

### Table: USD account
*   **USD Account**: Account in USD currency
    - `user_id`: Unique identifier for the user (15 characters). Foreign key referencing `users(user_id)`.
    - `user_name`: The user's first name.
    - `user_lastname`: The user's last name.
    - `nacional_id`: The user's national ID (must match `users(nacional_id)`).
    - `email`: The user’s email address. Must be unique.
    - `address`: The user’s physical address.
    - `birthdate`: The user’s birthdate.
    - `phone`: The user’s phone number (must match `users(phone)`).

**Primary Key**: `user_id` 

### Table: Cards 
*   **Cards**: A card associate with a user or users account. It could be to Visa, Mastercard, AMEX, among others.
    - `user_id`: Unique identifier for the user (15 characters). Foreign key referencing `users(user_id)`.
    - `provider_id`: Identifier for the card provider (4 characters).
    - `method_name`: The name of the card provider (e.g., Visa, MasterCard).
    - `card_num`: The card number.
    - `cvv_num`: The CVV number of the card.
    - `card_name`: The name on the card owner.
    - `card_lastname`: The lastname on the card owner.

**Composite Key**: `user_id` + `card_num`

### Table: Deposits 
*   **Deposit**: A deposit done by a user. It could be to another user, bank account, etc.    
    - `deposit_id`: Unique identifier for the deposit transaction (40 characters).
    - `usd_account_id`: The USD account ID (15 characters) involved in the deposit. Foreign key referencing `usd_accounts(usd_account_id)`.
    - `amount`: The amount of the deposit.
    - `currency`: The currency of the deposit (depends on the user’s account currency).
    - `merchant_id`: The unique identifier of the merchant receiving the deposit (10 characters). Foreign key referencing `merchant(merchant_id)`.
    - `merchant_name`: The name of the merchant.
    - `external_id`: A unique external ID visible to third parties.
    - `deposit_date`: Timestamp of when the deposit was made.

**Primary Key**: `deposit_id` 

### Table Payin 
*   **Payin**: Payin is the hability to deposit in this payment method with the financial provider
    - `payin_id`: Unique identifier for the payin transaction (40 characters).
    - `usd_account_id`: The USD account ID (15 characters) involved in the payin. Foreign key referencing `usd_accounts(usd_account_id)`.
    - `amount`: The amount received from the payin.
    - `currency`: The currency of the payin.
    - `provider_id`: The financial provider’s ID (4 characters). Foreign key referencing `financial_provider(provider_id)`.
    - `provider_name`: The name of the financial provider.
    - `external_id`: A unique external ID visible to third parties.
    - `provider_fee`: The fee charged by the provider for the transaction.
    - `payin_date`: Timestamp of when the payin occurred.

**Primary Key**: `payin_id` 

### Table: Payout
*   **Payout**: payout is the hability to deposit in the financial provider with this payment method.
    - `payout_id`: Unique identifier for the payout transaction (40 characters).
    - `usd_account_id`: The USD account ID (15 characters) involved in the payout. Foreign key referencing `usd_accounts(usd_account_id)`.
    - `amount`: The amount of the payout.
    - `currency`: The currency of the payout.
    - `provider_id`: The financial provider’s ID (4 characters). Foreign key referencing `financial_provider(provider_id)`.
    - `provider_name`: The name of the financial provider.
    - `external_id`: A unique external ID visible to third parties.
    - `provider_fee`: The fee charged by the provider for the transaction.
    - `payout_date`: Timestamp of when the payout occurred.

**Primary Key**: `payout_id` 
   
### Table: Merchant 
*   **Merchant**: Any business partner that accepts deposits in exchange of their goods and services. 
    - `merchant_id`: Unique identifier for the merchant (10 characters).
    - `merchant_name`: Name of the merchant.
    - `merchant_type`: Type of merchant (e.g., goods, services).
    - `amount`: The amount of money still in the merchant’s account (after processing deposits).
    - `currency`: The currency used by the merchant.
    - `merchant_fee`: The fee charged by the merchant for the transaction.

**Primary Key**: `merchant_id` 

### Table: Financial Provider
*   **Financial Provider**: Any financial intermediary that accepts transaction for payins and/or payouts. 
    - `provider_id`: Unique identifier for the provider (4 characters).
    - `provider_name`: The name of the financial provider.
    - `provider_type`: Type of provider (e.g., bank, card, payment gateway).
    - `payin_status`: Boolean value indicating if payins are allowed from this provider (TRUE/FALSE).
    - `payout_status`: Boolean value indicating if payouts are allowed to this provider (TRUE/FALSE).
    - `provider_fee`: The fee charged by the provider for a transaction.

**Primary Key**: `provider_id` 

## Relationships between Tables

- **`users` to `user_kyc`**: One-to-one relationship. Each user has exactly one corresponding KYC record.
- **`users` to `usd_accounts`**: One-to-one relationship. Each user has exactly one USD account.
- **`users` to `user_cards`**: One-to-many relationship. A user can have multiple associated cards.
- **`users` to `deposit`, `payin`, `payout`**: One-to-many relationship. A user can have multiple deposits, payins, and payouts.
- **`merchant` to `deposit`, `payin`, `payout`**: One-to-many relationship. A merchant can receive multiple deposits, payins, and payouts.
- **`financial_provider` to `deposit`, `payin`, `payout`**: One-to-many relationship. A financial provider can process multiple deposit, payin, and payout transactions.

## Triggers and Procedures

- **`before_user_insert` Trigger**: Automatically generates `user_id` and `usd_account_id` before a new user is inserted.
- **`after_user_insert` Trigger**: Automatically inserts related data into `user_kyc`, `user_cards`, and `usd_accounts` after a new user is inserted.
- **`before_payin_insert`, `before_payout_insert`, `before_deposit_insert` Triggers**: Automatically generates unique transaction IDs (`payin_id`, `payout_id`, `deposit_id`) for each transaction before insertion.
- **Stored Procedures**: 
    - `generate_user_id`: Generates a unique 15-character alphanumeric user ID.
    - `generate_alphanumeric_id`: Generates a unique alphanumeric ID for the USD account.
    - `generate_provider_id`: Generates a unique 4-character provider ID for financial providers.
    - `generate_trans_id`: Generates a unique 40-character transaction ID for deposits, payins, and payouts.
    - `generate_merchant_id`: Generates a unique 10-character merchant ID.

## Foreign Key Constraints

- Foreign keys enforce relationships between tables:
    - `user_kyc(user_id)` references `users(user_id)`
    - `user_cards(user_id)` references `users(user_id)`
    - `usd_accounts(user_id)` references `users(user_id)`
    - `deposit(merchant_id)` references `merchant(merchant_id)`
    - `payin(provider_id)` references `financial_provider(provider_id)`
    - `payout(provider_id)` references `financial_provider(provider_id)`
    - `payin(usd_account_id)` references `usd_accounts(usd_account_id)`


## Tables and structure  
### Diagram made in dbdiagram.oi
<p>
    <img src="/db_visualization/xiso_dbmldiagram.png" width="800" height="800" />
</p>    

### ERR Diagram
<p>
    <img src="/db_visualization/xiso_errdiagram.png" width="800" height="800" />
</p>    
