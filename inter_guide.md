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

### Table: Partner [Merchants/External Financial Provider] 
    *   **partner_id**: The id of the merchant where the deposit is made 
        *   Unique 
        *   Foreign Key 
    *   **partner_name**: Name of the merchant where the deposit is made
        *   String/Varchar 
    *   **partner_type**: Type of the business partner
        *   Category 
        *   Options: Merchant [merchant], Financial Provider [pay_provider]
    *   **partner_sub_type**: Type of the business partner within partner_type
        *   Category [dependent on partner_type] 
        *   Options: If merchant [merchant_goods; merchant_services; merchant_other]; If pay_provier [bank; pay_method] 
### Tables and structure: Task 

#### Table example: User  