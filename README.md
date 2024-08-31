# About 
The proyect is a partial design for fintech (XISO) application database using MySQL. The database is design for users to be able to charge money in the fintechs account, withdraw and deposit in merchants. It aims to support basic functionalities, however it has a few limitations, for example, not supporting transactions between users.  

## Database, tables and columns
The database is called *xiso_staging* and in contains multiple tables, which are created in **[xiso_db.sql](https://github.com/r41ss4/xisov1/blob/main/xiso_db.sql)**
A detail text description of the database is available in **[inter_guide.md](https://github.com/r41ss4/xisov1/blob/main/inter_guide.md)**. The file is complemented with a png file that illustrates the relationship between tables, a image based on dbml script: **[xiso_diagram.dbml](https://github.com/r41ss4/xisov1/blob/main/xiso_diagram.dbml)**.    


## Scope and limitations 
This project includes the creation of needed basic tables for a fintech database, users creation and general types of transactions, such as deposits. It is complemented with the needed procedures and triggers to automatically generate a user id and account id when creating a new user.   
However, the account amount of money, understood as the *amount* in the table *usd_accounts*, it does not change in relation with transactions. This means that inserts in *payin*, *payout* or *deposit* related to a certain *usd_account_id* will not modify the amount of in the table *usd_accounts*. Another limitation is that a user account can not transfer money to another user account.    