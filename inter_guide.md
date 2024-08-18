# Guide for myself 
To create this database, I will need to register what I do and why, which is the main purpose of this file.    

## External details
*   Type of transactions
    *   Deposits: Users can deposit money in merchants (such as Zara) 
    *   Payin: Money from external banks/payment providers to XISO account 
    *   Payout: Money from XISO to external banks/payment providers

## Tables and structure 

### Tables and structure: Overview 
### Table: User 
*   **Users**: Table for all users, it is [theoretically] created when someone registers.    
    *   **user_id**: Unique identifier for the user. 
        *   Primary key
        *   Interger only    
        *   Unique   
        *   Automatically created 
        *   Increments 
    *   **user_name**: Name of the person 
        *   Varchar  
    *   **user_lastname**: Lastname of the person   
        *   Varchar    
    *   **local_account_id**: Unique identifier for the local currency account id.    
        *   String/Varchar   
        *   Combination of integers and characters    
        *   Unique     
        *   Foreign key   
        *   Automatically created    
    *   **usd_account_id**: Unique identifier for the usd currency account id.    
        *   String/Varchar   
        *   Combination of integers and characters    
        *   Unique     
        *   Foreign key   
        *   Automatically created    
    *   **nacional_id**: Their national id, part of KYC   
        *   Varchar   
        *   Unique (but completed by user and reject if not unique)  
    *   **email**: Email address 
        *   String/Varchar 
        *   Unique (but completed by user and reject if not unique) 
        
### Table: Local account 
*   **Local Account**: Account in local currency
        *   **local_account_id**: Unique identifier for the local currency account id.  
            *   Primary key     
            *   String/Varchar     
            *   Combination of integers and characters    
            *   Unique      
            *   Automatically created   
        *   **available_amount**: Money currently available on the account    
            *   Integer     
            *   No max amount   
        *   **currency**: Account currency      
            *   Varchar     
            *   Constant (the same for all rows)        
        *   **user_name**: Name of the person       
            *   Varchar     
        *   **user_lastname**: Lastname of the person   
            *   Varchar     

### Table: USD account
*   **USD Account**: Account in USD currency
        *   **usd_account_id**: Unique identifier for the usd currency account id. 
            *   Primary key
            *   String/Varchar
            *   Combination of integers and characters 
            *   Unique  
            *   Automatically created 
        *   **available_amount**: Money currently available on the account  
            *   Integer
            *   No max amount 
        *   **currency**: Account currency
            *   Varchar
            *   Constant (the same for all rows)
        *   **user_name**: Name of the person 
            *   Varchar  
        *   **user_lastname**: Lastname of the person
            *   Varchar 

### Table: Deposits 
*   **Deposit**: A deposit done by a user. It could be to another user, bank account, etc.    
    *   **deposit_id**: Unique identifier for the transaction    
        *   Unique
        *   Varchar (Integer and characters)
        *   Primary Key
        *   Automatically complete
    *   **account_id**: The account id of the users account, independently if it is the local currency one or the USD account 
        *   Foreign Key 
        *   Unique
        *   String/Varchar   
        *   Combination of integers and characters    
    *   **amount**: Transaction amount  
        *   Integer
        *   No max amount 
    *   **currency**: Account currency
        *   Varchar
        *   Depence on the account_id field 
    *   **merchant_id**: The id of the merchant where the deposit is made 
        *   Unique 
        *   Foreign Key 
    *   **merchant_name**: Name of the merchant where the deposit is made
        *   String/Varchar 
    *   **dep_external_id**: Deposit id vissible for third parties 
        *   Unique  
        *   Varchar     

### Table Payin 
*   **Payin**: Payin is the hability to deposit in this payment method with the financial provider
    *   **payin_id**: Unique identifier for the transaction    
        *   Unique
        *   Varchar (Integer and characters)
        *   Primary Key
        *   Automatically complete
    *   **account_id**: The account id of the users account, independently if it is the local currency one or the USD account 
        *   Foreign Key 
        *   Unique
        *   String/Varchar   
        *   Combination of integers and characters    
    *   **amount**: Transaction amount  
        *   Integer
        *   No max amount 
    *   **currency**: Account currency
        *   Varchar
        *   Depence on the account_id field 
    *   **provider_id**: The id of the financial provider where the deposit is made 
        *   Unique 
        *   Foreign Key 
    *   **provider_name**: Name of the financial provider where the deposit is made
        *   String/Varchar 
    *   **in_external_id**: Deposit id vissible for third parties 
        *   Unique  
        *   Varchar    

### Table: Payout
*   **Payout**: payout is the hability to deposit in the financial provider with this payment method.
    *   **payout_id**: Unique identifier for the transaction    
        *   Unique
        *   Varchar (Integer and characters)
        *   Primary Key
        *   Automatically complete
    *   **account_id**: The account id of the users account, independently if it is the local currency one or the USD account 
        *   Foreign Key 
        *   Unique
        *   String/Varchar   
        *   Combination of integers and characters    
    *   **amount**: Transaction amount  
        *   Integer
        *   No max amount 
    *   **currency**: Account currency
        *   Varchar
        *   Depence on the account_id field 
    *   **provider_id**: The id of the financial provider where the deposit is made 
        *   Unique 
        *   Foreign Key 
    *   **provider_name**: Name of the financial provider where the deposit is made
        *   String/Varchar 
    *   **in_external_id**: Deposit id vissible for third parties 
        *   Unique  
        *   Varchar    
   
### Table: Merchant 
*   **Merchant**: Any business partner that accepts deposits in exchange of their goods and services. 
    *   **merchant_id**: The id of the merchant where the deposit is made 
        *   Unique 
        *   Primary Key 
    *   **merchant_name**: Name of the merchant where the deposit is made
        *   String/Varchar 
    *   **merchant_type**: Type of the business partner
        *   Category 
        *   Options: merchant_goods; merchant_services; merchant_other 
    *   **amount**: Amount of money by deposit still in merchant account
    *   **currency**: Currency 

### Table: Financial Provider
*   **Financial Provider**: Any financial intermediary that accepts transaction for payins and/or payouts. 
    *   **provider_id**: The id of the merchant where the deposit is made 
        *   Unique 
        *   Foreign Key 
    *   **provider_name**: Name of the merchant where the deposit is made
        *   String/Varchar 
    *   **provider_type**: Type of the business partner
        *   Category 
        *   Options: bank_method or pay_method 
    *   **payin_status**: Boolean if payin is enabled with the method or not. Payin is the hability to deposit in this payment method with the financial provider
        *   TRUE/FALSE 
    *   **payouts_status**: Boolean if payout is enabled with the method or not. Payout is the hability to deposit in the financial provider with this payment method. 
        *   TRUE/FALSE 


### Tables and structure: Task 

#### Table example: User  