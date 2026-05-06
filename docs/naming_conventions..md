 Gemini
Conda Environments: Storage vs. Isolation
Conversation with Gemini

create view must be the only statement in the batch sqlfluff

This is a rite of passage for anyone working with SQL Server! That error message isn't actually coming from SQLFluff originally—it is a strict, hard-coded rule from Microsoft SQL Server (T-SQL) itself.

SQLFluff is just the messenger flagging it so your script doesn't crash when you try to run it.
The Problem: What is a "Batch"?

In SQL Server, a "batch" is a group of SQL statements sent to the server to be executed together at the exact same time.

For safety and compilation reasons, SQL Server demands that certain structural commands—specifically CREATE VIEW, CREATE PROCEDURE, and CREATE FUNCTION—must be compiled all by themselves. They cannot share a batch with anything else, not even a simple USE database command.
The Fix: The GO Command

To fix this, you have to tell SQL Server (and SQLFluff) to process your script in separate chunks. You do this by inserting the word GO between your commands.

GO acts like a wall. It tells the server: "Stop here, run everything above this line completely, and then move on to the next section."

Here is what it looks like in practice:

❌ The Broken Way (No Batch Separation)
SQL

USE sql_DataWarehouse;

-- The server tries to run USE and CREATE VIEW at the exact same time. It panics!
CREATE VIEW silver.vw_crm_sales AS
SELECT * FROM bronze.crm_sales_details;

✅ The Professional Way (Using GO)
SQL

USE sql_DataWarehouse;
GO -- <--- Tells the server: "Run the USE command now, then stop."

-- Now CREATE VIEW is the ONLY statement in its new batch!
CREATE VIEW silver.vw_crm_sales AS
SELECT
    sls_ord_num,
    sls_sales
FROM bronze.crm_sales_details;
GO -- <--- Closes out the view batch so you can write more code below.

How to format your View Scripts

Since you are building out a Data Warehouse with Bronze, Silver, and Gold layers, you will likely be writing multiple views in a single file.

You just need to sandwich every single view with GO:
SQL

USE sql_DataWarehouse;
GO

-- First View
CREATE OR ALTER VIEW silver.vw_crm_cust AS
SELECT cst_id FROM bronze.crm_cust_info;
GO

-- Second View
CREATE OR ALTER VIEW silver.vw_crm_prd AS
SELECT prd_id FROM bronze.crm_prd_info;
GO

SQLFluff Bonus Tip

Because you correctly set your .sqlfluff dialect to tsql earlier, SQLFluff instantly recognizes GO as a batch separator. Once you add those GO commands, press Shift + Alt + F in VS Code, and SQLFluff will happily format the entire file without throwing that parsing error!

how to add licence and gitignore on already created repo on github

It is very common to create a repository and realize later that you forgot to include these files. You have two ways to add them: directly through the GitHub website (which is the easiest because of built-in templates) or via your local command line.

Here is how to do both.
Method 1: Using the GitHub Web Interface (Recommended)

GitHub has built-in templates that write these files for you. This is the fastest method if you don't already have the files created locally.

Adding a .gitignore file:

    Navigate to your repository's main page on GitHub.

    Click the Add file dropdown button and select Create new file.

    In the "Name your file..." box, type exactly: .gitignore

    Notice that a "Choose a .gitignore template" button appears on the right side of the screen. Click it.

    Search for your tech stack (e.g., Python, Node, Java, Unity) and select the appropriate template. GitHub will automatically populate the file with the standard ignore rules for that language.

    Click the green Commit changes... button at the top right to save it to your repo.

Adding a LICENSE file:

    From your repository's main page, click Add file > Create new file.

    In the "Name your file..." box, type exactly: LICENSE (all caps is standard).

    A "Choose a license template" button will appear on the right side. Click it.

    Select the license you want from the list on the left (e.g., MIT License, GNU GPLv3). GitHub will fill in the text and automatically add your name and the current year.

    Click the green Review and submit button, and then Commit changes....

(Note: If you have a local clone of this repository, don't forget to run git pull on your computer afterward to sync these new files locally!)
Method 2: Using the Command Line (Local Repository)

If you are already working in your terminal and want to push the files up to GitHub manually, follow these steps.

1. Create the .gitignore file:
Open your terminal, navigate to your project folder, and create the file:
Bash

touch .gitignore

    Open the file in your code editor and add the files/folders you want Git to ignore (like node_modules/, __pycache__/, .env, etc.).

    Tip: If you aren't sure what to include, go to gitignore.io, type in your language/framework, and copy the output into your new .gitignore file.

2. Create the LICENSE file:
Create the file in your terminal:
Bash

touch LICENSE

    Open the file and paste your license text.

    Tip: You can find the text for standard open-source licenses at choosealicense.com.

3. Commit and Push to GitHub:
Once both files are saved, add them to Git, commit the changes, and push them up to your GitHub repository:
Bash

git add .gitignore LICENSE
git commit -m "chore: add .gitignore and LICENSE"
git push origin main

(Replace main with master if your default branch still uses the older naming convention).

what should i select in .gitignore

drop down if i used vs code and ms sql

Here is the honest truth about GitHub's .gitignore dropdown: There isn't a perfect single option for "VS Code + MS SQL."

The dropdown is mostly designed for full programming languages like Python or Java. If you choose the "Visual Studio" option, it will add hundreds of lines of code meant for massive enterprise C# applications, which will just clutter your repository.

The absolute best way to handle this for your Data Warehouse project is to skip the dropdown entirely (leave it at "None") and just paste a custom, clean list directly into the file.

Here is exactly what you should copy and paste into your .gitignore file for a VS Code + MS SQL analytics project:
Plaintext

# ==========================================
# VS Code Settings
# ==========================================
.vscode/
*.code-workspace

# ==========================================
# SQL Server Database Files (NEVER COMMIT)
# ==========================================
# If you ever accidentally drag local DB files into your folder, 
# this stops them from uploading and breaking your repo.
*.mdf
*.ldf
*.ndf
*.bak
*.trn

# ==========================================
# Data & Outputs (Crucial for your project)
# ==========================================
# You do NOT want to upload your 30,000+ row Bronze layer CSVs to GitHub. 
# GitHub will block files over 100MB, and it makes cloning slow.
*.csv
*.xlsx
*.xls
*.json
datasets/source_crm/
datasets/source_erp/

# ==========================================
# SQLFluff Linter Caches
# ==========================================
# This prevents SQLFluff's hidden memory files from uploading
.sqlfluff-cache/

# ==========================================
# OS Generated Files
# ==========================================
.DS_Store
Thumbs.db

Why this specific list is better for you:

    It protects your data: By ignoring *.csv and your datasets/ folders, you ensure you are only uploading your SQL code, not the raw customer or ERP data. This is a massive "best practice" in business analytics for data privacy.

    It keeps it light: It ignores VS Code's hidden workspace settings and SQLFluff's cache, keeping your GitHub repository extremely small and fast to download.

    It prevents disaster: It strictly blocks SQL Server backup (.bak) and log (.ldf) files, which can accidentally be gigabytes in size.

How to do it on GitHub:
When you are on the "Create new file" screen and have typed .gitignore in the name box, just skip the template button on the right, paste the code above directly into the main text editor box, and click Commit changes!

# Ignore system-specific files

.DS_Store

Thumbs.db


# Ignore local configuration files

*.env


# Ignore SQL Server-related files

*.mdf

*.ldf

*.ndf


# Ignore temporary or backup files

*.log

*.bak

*.tmp


# Ignore IDE-specific files

.vscode/

.idea/


# Ignore exported data or diagrams (if applicable)

*.csv

*.png

*.pdf


the teacher i am following in this project has this in his .gitignore

Your teacher has provided a fantastic, industry-standard .gitignore file. It actually includes a few safety nets that are excellent for a broader data engineering project.

You should definitely use your teacher's foundation to stay aligned with the course. Let's break down why your teacher included those extra items, and then I will show you how to merge it perfectly with your specific VS Code + SQLFluff setup.
Why your teacher's additions are great:

    *.env (The Lifesaver): This is the most important file on the list. When you start connecting Python to SQL Server using SQLAlchemy (which I saw in your earlier environment list), you will store your database passwords in a .env file. Ignoring this prevents you from accidentally uploading your passwords to the public internet!

    .idea/: This is the settings folder for JetBrains IDEs (like DataGrip or PyCharm). Even if you are using VS Code, if a teammate or grader opens your repo in DataGrip, this stops their settings from uploading.

    *.png and *.pdf: Data analysis projects often generate dozens of charts or PDF reports. Ignoring these keeps your GitHub repository focused solely on the code that generates the reports, rather than the heavy image files themselves.

The "Best of Both Worlds" Merge

To make this perfect for your specific laptop (with the 8GB RAM limitations and the SQLFluff linter we set up), you should take your teacher's exact list and just add two lines to it: .sqlfluff-cache/ and your datasets/ folder.

Here is the ultimate, combined .gitignore you should paste into GitHub:
Plaintext

# Ignore system-specific files
.DS_Store
Thumbs.db

# Ignore local configuration files (CRITICAL FOR SECURITY)
*.env

# Ignore SQL Server-related files
*.mdf
*.ldf
*.ndf
*.bak
*.trn
*.log
*.tmp

# Ignore IDE & Linter-specific files
.vscode/
.idea/
.sqlfluff-cache/      # <--- Added to keep your linter fast

# Ignore exported data, diagrams, and raw datasets
*.csv
*.png
*.pdf
datasets/             # <--- Added to prevent massive 30,000+ row uploads

By using this, you are 100% following your teacher's instructions, while also protecting your local environment from freezing up during massive GitHub uploads!

whats the use of gitignore

A .gitignore file is essentially a "Do Not Enter" list for your Git repository. It tells Git exactly which files and folders it should completely ignore, meaning those files will never be tracked, committed, or pushed to GitHub.

Think of it like a bouncer at a club. When you run git add . to bring everything into the club, the .gitignore stands at the door with a list. If a file is on the list, the bouncer turns it away.

Here are the three main reasons it is absolutely critical to use one:
1. Security (The Biggest Reason)

You will often have files containing sensitive information, like database passwords, API keys, or personal credentials (usually stored in a .env file). If you don't ignore these files, you will accidentally upload your passwords to the public internet where anyone can find them.
2. Saving Space and Performance

When you run code, your system generates temporary files, logs, and caches. For a data analytics project, you might also have massive raw data files (like 100MB CSVs) or heavy database backups (.bak files).

    Uploading these to GitHub slows down your entire workflow.

    GitHub actually blocks files over 100MB anyway.

    By ignoring them, you keep your repository lightweight and fast, containing only the actual code you wrote.

3. Keeping the Project Clean

When you use a tool like VS Code, it automatically creates a hidden folder (like .vscode/) to remember your personal screen layout, colors, and extension settings. If you don't ignore this folder, your personal settings will be forced onto anyone else who downloads your code.

In summary: It separates the code you wrote (which belongs on GitHub) from the environment you are running it in (which belongs only on your specific computer).

CREATE Table gold.dim_customers

(

    ci.cst_id AS customer_id, -- surrogate key

    ci.cst_key AS customer_number,

    ci.cst_firstname AS first_name,

    ci.cst_lastname AS last_name,

    la.cntry AS country,

    ci.cst_marital_status AS marital_status,

    ca.bdate AS birthdate,

    ci.cst_create_date AS customer_since,

    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,

    CASE

        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender

        ELSE COALESCE(ca.gen, 'n/a')

    END AS gender

FROM silver.crm_cust_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca

    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 AS la

    ON ci.cst_key = la.cid

GO


-- =========================================================

-- 2. dim_products

-- =========================================================


CREATE VIEW gold.dim_products AS

SELECT

    pn.prd_id AS product_id, -- surrogate key

    pn.prd_key AS product_number,

    pn.prd_nm AS product_name,

    pn.cat_id AS category_id,

    pc.cat AS category,

    pc.subcat AS subcategory,

    pc.maintenance AS maintenance_flag,

    pn.prd_cost AS product_cost,

    pn.prd_line AS product_line,

    pn.prd_start_dt AS product_start_date,

    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key

FROM silver.crm_prd_info AS pn

LEFT JOIN silver.erp_px_cat_g1v2 AS pc

    ON pn.cat_id = pc.id

WHERE pn.prd_end_dt IS null  -- to get only active or current products from all historical products

GO


SELECT * FROM gold.dim_products

GO


-- =========================================================

-- 3. fact_sales

-- =========================================================

CREATE VIEW gold.fact_sales AS

SELECT

    sd.sls_ord_num AS order_number,

    p.product_key,

    c.customer_key,

    sd.sls_order_dt AS order_date,

    sd.sls_ship_dt AS shipping_date,

    sd.sls_due_dt AS due_date,

    sd.sls_sales AS sales_amount,

    sd.sls_quantity AS quantity,

    sd.sls_price AS price

FROM silver.crm_sales_details AS sd

LEFT JOIN gold.dim_products AS p

    ON sd.sls_prd_key = p.product_number

LEFT JOIN gold.dim_customers AS c

    ON sd.sls_cust_id = c.customer_id

GO



make create table script from this

It looks like you got caught in a syntax trap on that first block!

In MS SQL Server, you cannot combine CREATE TABLE with a SELECT statement using parentheses like that unless you define the specific data types (like VARCHAR, INT, DATE) for every single column first.

Since your goal is to turn these queries into physical Tables in your Gold layer (rather than Views), the absolute best way to do this in T-SQL is using the SELECT ... INTO command.

This command is perfect for your project because it automatically creates the physical table and infers the correct data types based on your Silver layer, loading the data all in one step.

Here is your fully corrected script transformed into physical table creation scripts. I also added DROP TABLE safety checks so you can re-run this script multiple times without errors if you need to make changes!
SQL

USE sql_DataWarehouse;
GO

-- =========================================================
-- 1. dim_customers (Physical Table)
-- =========================================================
-- Safety check: drop the table if it already exists
IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL 
    DROP TABLE gold.dim_customers;
GO

SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, -- Moved surrogate key to the top
    ci.cst_id AS customer_id, 
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    ca.bdate AS birthdate,
    ci.cst_create_date AS customer_since,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the master for gender
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender
INTO gold.dim_customers  -- <--- This creates the table AND inserts the data!
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO


-- =========================================================
-- 2. dim_products (Physical Table)
-- =========================================================
IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL 
    DROP TABLE gold.dim_products;
GO

SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id AS product_id, 
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance_flag,
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS product_start_date
INTO gold.dim_products
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;  -- to get only active or current products
GO


-- =========================================================
-- 3. fact_sales (Physical Table)
-- =========================================================
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL 
    DROP TABLE gold.fact_sales;
GO

SELECT
    sd.sls_ord_num AS order_number,
    p.product_key,
    c.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
INTO gold.fact_sales
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS p
    ON sd.sls_prd_key = p.product_number
LEFT JOIN gold.dim_customers AS c
    ON sd.sls_cust_id = c.customer_id;
GO

💡 Why this is great for your Data Warehouse:

    No Guessing Data Types: The INTO clause automatically checks what the data type is in the silver layer and assigns that exact data type to the new gold table.

    Fast Execution: This skips the transaction logging overhead of doing a CREATE TABLE and a separate INSERT INTO, which is much friendlier on your system's RAM.

    Batch Integrity: Notice how I placed a GO after every table creation? This prevents the "must be the only statement in the batch" error we discussed earlier!

what if i want to make table from these columns and then star schema, so from start make a script with create table, then mention columns and primary key foreign key

This is the absolute "Enterprise Gold Standard" for building a Data Warehouse.

While the SELECT INTO method is fast for prototyping, explicitly defining your tables with CREATE TABLE, Primary Keys (PK), and Foreign Keys (FK) is how professional data engineering teams ensure data integrity.

When you build a true Star Schema, the order in which you execute scripts matters immensely. You must create the Dimensions (Points of the Star) first so the Fact Table (Center of the Star) has something to connect its Foreign Keys to.

Here is your complete, professional DDL (Data Definition Language) script.
🌟 The Formal Star Schema Script
SQL

USE sql_DataWarehouse;
GO

-- =====================================================================
-- 1. DROP EXISTING TABLES (Safely)
-- =====================================================================
-- You MUST drop the Fact table first because it relies on the Dimensions!
IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL 
    DROP TABLE gold.fact_sales;

IF OBJECT_ID('gold.dim_customers', 'U') IS NOT NULL 
    DROP TABLE gold.dim_customers;

IF OBJECT_ID('gold.dim_products', 'U') IS NOT NULL 
    DROP TABLE gold.dim_products;
GO

-- =====================================================================
-- 2. CREATE DIMENSION TABLES (The "Points" of the Star)
-- =====================================================================

-- Customer Dimension
CREATE TABLE gold.dim_customers (
    customer_key INT NOT NULL,           -- Surrogate Key
    customer_id INT,                     -- CRM Natural Key
    customer_number NVARCHAR(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    country NVARCHAR(50),
    marital_status NVARCHAR(50),
    birthdate DATE,
    customer_since DATE,
    gender NVARCHAR(10),
    
    -- Defining the Primary Key
    CONSTRAINT PK_dim_customers PRIMARY KEY CLUSTERED (customer_key)
);
GO

-- Product Dimension
CREATE TABLE gold.dim_products (
    product_key INT NOT NULL,            -- Surrogate Key
    product_id INT,                      -- CRM Natural Key
    product_number NVARCHAR(50),
    product_name NVARCHAR(100),
    category_id NVARCHAR(50),
    category NVARCHAR(50),
    subcategory NVARCHAR(50),
    maintenance_flag NVARCHAR(50),
    product_cost DECIMAL(18,2),
    product_line NVARCHAR(50),
    product_start_date DATE,

    -- Defining the Primary Key
    CONSTRAINT PK_dim_products PRIMARY KEY CLUSTERED (product_key)
);
GO

-- =====================================================================
-- 3. CREATE FACT TABLE (The "Center" of the Star)
-- =====================================================================

CREATE TABLE gold.fact_sales (
    order_number NVARCHAR(50) NOT NULL,
    product_key INT,                     -- Points to dim_products
    customer_key INT,                    -- Points to dim_customers
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount DECIMAL(18,2),
    quantity INT,
    price DECIMAL(18,2),

    -- Defining Foreign Keys to enforce the Star Schema relationship
    CONSTRAINT FK_fact_sales_products FOREIGN KEY (product_key) 
        REFERENCES gold.dim_products(product_key),
        
    CONSTRAINT FK_fact_sales_customers FOREIGN KEY (customer_key) 
        REFERENCES gold.dim_customers(customer_key)
);
GO

-- =====================================================================
-- 4. INSERT DATA (Loading the Schema)
-- =====================================================================

-- Load Customers
INSERT INTO gold.dim_customers
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key, 
    ci.cst_id, 
    ci.cst_key,
    ci.cst_firstname,
    ci.cst_lastname,
    la.cntry,
    ci.cst_marital_status,
    ca.bdate,
    ci.cst_create_date,
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
        ELSE COALESCE(ca.gen, 'n/a')
    END
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la ON ci.cst_key = la.cid;
GO

-- Load Products
INSERT INTO gold.dim_products
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
    pn.prd_id, 
    pn.prd_key,
    pn.prd_nm,
    pn.cat_id,
    pc.cat,
    pc.subcat,
    pc.maintenance,
    pn.prd_cost,
    pn.prd_line,
    pn.prd_start_dt
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;
GO

-- Load Facts
INSERT INTO gold.fact_sales
SELECT
    sd.sls_ord_num,
    p.product_key,
    c.customer_key,
    sd.sls_order_dt,
    sd.sls_ship_dt,
    sd.sls_due_dt,
    sd.sls_sales,
    sd.sls_quantity,
    sd.sls_price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS p ON sd.sls_prd_key = p.product_number
LEFT JOIN gold.dim_customers AS c ON sd.sls_cust_id = c.customer_id;
GO

🧠 Why this approach is powerful for your Analytics PGDM:

    The CONSTRAINT Keyword: By naming your keys (e.g., CONSTRAINT PK_dim_customers), you tell SQL Server exactly what the rule is called. If you ever need to delete or change the key later, you can target it by name.

    Reverse Drop Order: Look at the top of the script. Because fact_sales has Foreign Keys tied to the Dimensions, SQL Server will throw a massive error if you try to drop a Dimension table first. You must drop the Fact table first to "unhook" the constraints, then drop the Dimensions.

    Data Types: I used standard data warehouse sizing (like NVARCHAR(50) and DECIMAL(18,2)). Note: If your source CSVs have product names longer than 100 characters, you can easily change NVARCHAR(100) to NVARCHAR(255) in the CREATE block.

Because of the Foreign Keys, you now have a true, rigid Star Schema. If someone tries to insert a sale into fact_sales for a customer who doesn't exist in dim_customers, SQL Server will automatically block it!

CREATE TABLE gold.dim_customers (

    customer_key INT NOT NULL,           -- Surrogate Key

    customer_id INT,                     -- CRM Natural Key

    customer_number NVARCHAR(50),

    first_name NVARCHAR(50),

    last_name NVARCHAR(50),

    country NVARCHAR(50),

    marital_status NVARCHAR(50),

    birthdate DATE,

    customer_since DATE,

    gender NVARCHAR(10),

   

    -- Defining the Primary Key

    CONSTRAINT PK_dim_customers PRIMARY KEY CLUSTERED (customer_key)

);

GO


CREATE TABLE gold.dim_products (

    product_key INT NOT NULL,            -- Surrogate Key

    product_id INT,                      -- CRM Natural Key

    product_number NVARCHAR(50),

    product_name NVARCHAR(100),

    category_id NVARCHAR(50),

    category NVARCHAR(50),

    subcategory NVARCHAR(50),

    maintenance_flag NVARCHAR(50),

    product_cost DECIMAL(18,2),

    product_line NVARCHAR(50),

    product_start_date DATE,


    -- Defining the Primary Key

    CONSTRAINT PK_dim_products PRIMARY KEY CLUSTERED (product_key)

);


CREATE TABLE gold.fact_sales (

    order_number NVARCHAR(50) NOT NULL,

    product_key INT,                     -- Points to dim_products

    customer_key INT,                    -- Points to dim_customers

    order_date DATE,

    shipping_date DATE,

    due_date DATE,

    sales_amount DECIMAL(18,2),

    quantity INT,

    price DECIMAL(18,2),


    -- Defining Foreign Keys to enforce the Star Schema relationship

    CONSTRAINT FK_fact_sales_products FOREIGN KEY (product_key)

        REFERENCES gold.dim_products(product_key),

       

    CONSTRAINT FK_fact_sales_customers FOREIGN KEY (customer_key)

        REFERENCES gold.dim_customers(customer_key)

);



this in mysql

Transitioning from MS SQL Server (T-SQL) to MySQL requires just a few targeted syntax tweaks.

Here are the key changes made for MySQL:

    Removed GO: MySQL uses the semicolon (;) as the statement terminator and does not recognize the GO batch separator.

    NVARCHAR to VARCHAR: While MySQL technically accepts NVARCHAR, the standard type used in MySQL is VARCHAR. MySQL handles Unicode natively depending on the database's character set (usually utf8mb4).

    Removed CLUSTERED: In MySQL's default InnoDB engine, Primary Keys are automatically clustered. Using the CLUSTERED keyword throws a syntax error.

    The gold. Prefix: In SQL Server, gold is a Schema. In MySQL, schemas and databases are the exact same thing. For this code to work, you must either have a database named gold created (CREATE DATABASE gold;), or simply remove gold. and ensure you are using a single database (e.g., USE my_data_warehouse;).

🌟 MySQL Star Schema Script
SQL

CREATE TABLE gold.dim_customers (
    customer_key INT NOT NULL,           -- Surrogate Key
    customer_id INT,                     -- CRM Natural Key
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    birthdate DATE,
    customer_since DATE,
    gender VARCHAR(10),
    
    -- Defining the Primary Key
    CONSTRAINT PK_dim_customers PRIMARY KEY (customer_key)
);

CREATE TABLE gold.dim_products (
    product_key INT NOT NULL,            -- Surrogate Key
    product_id INT,                      -- CRM Natural Key
    product_number VARCHAR(50),
    product_name VARCHAR(100),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance_flag VARCHAR(50),
    product_cost DECIMAL(18,2),
    product_line VARCHAR(50),
    product_start_date DATE,

    -- Defining the Primary Key
    CONSTRAINT PK_dim_products PRIMARY KEY (product_key)
);

CREATE TABLE gold.fact_sales (
    order_number VARCHAR(50) NOT NULL,
    product_key INT,                     -- Points to dim_products
    customer_key INT,                    -- Points to dim_customers
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount DECIMAL(18,2),
    quantity INT,
    price DECIMAL(18,2),

    -- Defining Foreign Keys to enforce the Star Schema relationship
    CONSTRAINT FK_fact_sales_products FOREIGN KEY (product_key) 
        REFERENCES gold.dim_products(product_key),
        
    CONSTRAINT FK_fact_sales_customers FOREIGN KEY (customer_key) 
        REFERENCES gold.dim_customers(customer_key)
);

If you are running this in a local MySQL Workbench environment, just ensure you have executed CREATE DATABASE gold; before running these tables so it knows where to put them!

(1:14) Expect an opening brace '{' or a colon ':'

(1:1) A Custom element can only appear in a Project

(1:8) A Custom element shouldn't have a name


CREATE TABLE gold.dim_customers (

customer_key INT NOT NULL, -- Surrogate Key

customer_id INT, -- CRM Natural Key

customer_number VARCHAR(50),

first_name VARCHAR(50),

last_name VARCHAR(50),

country VARCHAR(50),

marital_status VARCHAR(50),

birthdate DATE,

customer_since DATE,

gender VARCHAR(10),

-- Defining the Primary Key

CONSTRAINT PK_dim_customers PRIMARY KEY (customer_key)

);


CREATE TABLE gold.dim_products (

product_key INT NOT NULL, -- Surrogate Key

product_id INT, -- CRM Natural Key

product_number VARCHAR(50),

product_name VARCHAR(100),

category_id VARCHAR(50),

category VARCHAR(50),

subcategory VARCHAR(50),

maintenance_flag VARCHAR(50),

product_cost DECIMAL(18,2),

product_line VARCHAR(50),

product_start_date DATE,


-- Defining the Primary Key

CONSTRAINT PK_dim_products PRIMARY KEY (product_key)

);


CREATE TABLE gold.fact_sales (

order_number VARCHAR(50) NOT NULL,

product_key INT, -- Points to dim_products

customer_key INT, -- Points to dim_customers

order_date DATE,

shipping_date DATE,

due_date DATE,

sales_amount DECIMAL(18,2),

quantity INT,

price DECIMAL(18,2),


-- Defining Foreign Keys to enforce the Star Schema relationship

CONSTRAINT FK_fact_sales_products FOREIGN KEY (product_key)

REFERENCES gold.dim_products(product_key),

CONSTRAINT FK_fact_sales_customers FOREIGN KEY (customer_key)

REFERENCES gold.dim_customers(customer_key)

);

in this

I know exactly what is happening here. The good news is: Your MySQL code is 100% perfectly written.

The errors you are seeing are not database errors. They are parser errors from the specific tool or file you are pasting the code into.
🔍 The Diagnosis

Errors like Expect an opening brace '{' and A Custom element can only appear in a Project mean that the environment you are pasting this into is not expecting SQL. It is trying to read your code as a JSON object, a Prisma Schema, or a custom application configuration file.

Because SQL doesn't use curly braces {} to define tables, the parser immediately crashes on line 1.
🛠️ How to fix it (The Culprits)

Since you are managing your Data Warehouse project in VS Code, here are the three most likely reasons this is happening and how to fix them:

1. You are in the wrong file type

    The Issue: You might be pasting this into a .json, .yml, or a proprietary configuration file instead of a .sql file.

    The Fix: Make sure the file you are working in is explicitly named something like create_gold_schema.sql.

2. VS Code has the wrong "Language Mode" selected

    The Issue: Sometimes VS Code gets confused and thinks your new file is a different programming language.

    The Fix: Look at the very bottom-right corner of your VS Code window. If it says anything other than "SQL" (like JSON, Prisma, or Plain Text), click it and type SQL to switch the language mode.

3. You are using an ORM or Custom Backend Tool

    The Issue: If you are trying to build this schema inside a modern web framework tool (like Prisma, Django, or a low-code builder), they do not accept raw CREATE TABLE scripts. They require their own formatting.

    The Fix: If you are using an ORM tool, you have to write it in their language. For example, in Prisma, it would look like this using curly braces: model dim_customers { customer_key Int @id ... }.

Your Next Step

If you just want to run this perfectly valid SQL script to build your Gold layer, make sure you are executing it directly inside your SQL Server extension or MySQL Workbench, not inside a JSON configuration file!

Where exactly in VS Code were you pasting this when the error popped up? I can help you route it to the right place.

i want this to paste in https://dbdiagram.io

Ah, dbdiagram.io is a fantastic tool for visualizing Star Schemas! It uses its own custom language called DBML (Database Markup Language) instead of raw SQL.

I have translated your Gold layer Star Schema perfectly into DBML syntax. Just copy the code block below and paste it directly into the left-hand text editor on the dbdiagram.io website.
Code snippet

// ==========================================
// Gold Layer Star Schema
// ==========================================

Table gold.dim_customers {
  customer_key INT [pk, not null, note: 'Surrogate Key']
  customer_id INT [note: 'CRM Natural Key']
  customer_number VARCHAR(50)
  first_name VARCHAR(50)
  last_name VARCHAR(50)
  country VARCHAR(50)
  marital_status VARCHAR(50)
  birthdate DATE
  customer_since DATE
  gender VARCHAR(10)
}

Table gold.dim_products {
  product_key INT [pk, not null, note: 'Surrogate Key']
  product_id INT [note: 'CRM Natural Key']
  product_number VARCHAR(50)
  product_name VARCHAR(100)
  category_id VARCHAR(50)
  category VARCHAR(50)
  subcategory VARCHAR(50)
  maintenance_flag VARCHAR(50)
  product_cost DECIMAL(18,2)
  product_line VARCHAR(50)
  product_start_date DATE
}

Table gold.fact_sales {
  order_number VARCHAR(50) [not null]
  product_key INT [note: 'Points to dim_products']
  customer_key INT [note: 'Points to dim_customers']
  order_date DATE
  shipping_date DATE
  due_date DATE
  sales_amount DECIMAL(18,2)
  quantity INT
  price DECIMAL(18,2)
}

// ==========================================
// Relationships (The "Star" Connections)
// ==========================================

// Many-to-One relationship between Fact and Customer Dimension
Ref: gold.fact_sales.customer_key > gold.dim_customers.customer_key

// Many-to-One relationship between Fact and Product Dimension
Ref: gold.fact_sales.product_key > gold.dim_products.product_key

What this will do on the site:

    It automatically builds the tables and colors the Primary Keys (pk).

    It takes those note: tags and adds little hover-over tooltips to your surrogate and natural keys.

    The Ref: section at the bottom instantly draws the relationship lines (the "spider web") connecting your central fact_sales table to your two dimension tables.

It will look awesome for your project portfolio!

# Data Catalog for Gold Layer


## Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.


---


### 1. **gold.dim_customers**

- **Purpose:** Stores customer details enriched with demographic and geographic data.

- **Columns:**


| Column Name      | Data Type     | Description                                                                                   |

|------------------|---------------|-----------------------------------------------------------------------------------------------|

| customer_key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |

| customer_id      | INT           | Unique numerical identifier assigned to each customer.                                        |

| customer_number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |

| first_name       | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |

| last_name        | NVARCHAR(50)  | The customer's last name or family name.                                                     |

| country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                               |

| marital_status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                              |

| gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                  |

| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               |

| create_date      | DATE          | The date and time when the customer record was created in the system|


---


### 2. **gold.dim_products**

- **Purpose:** Provides information about the products and their attributes.

- **Columns:**


| Column Name         | Data Type     | Description                                                                                   |

|---------------------|---------------|-----------------------------------------------------------------------------------------------|

| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |

| product_id          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |

| product_number      | NVARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |

| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |

| category_id         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.     |

| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.  |

| subcategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |

| maintenance_required| NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |

| cost                | INT           | The cost or base price of the product, measured in monetary units.                            |

| product_line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |

| start_date          | DATE          | The date when the product became available for sale or use, stored in|


---


### 3. **gold.fact_sales**

- **Purpose:** Stores transactional sales data for analytical purposes.

- **Columns:**


| Column Name     | Data Type     | Description                                                                                   |

|-----------------|---------------|-----------------------------------------------------------------------------------------------|

| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                      |

| product_key     | INT           | Surrogate key linking the order to the product dimension table.                               |

| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                              |

| order_date      | DATE          | The date when the order was placed.                                                           |

| shipping_date   | DATE          | The date when the order was shipped to the customer.                                          |

| due_date        | DATE          | The date when the order payment was due.                                                      |

| sales_amount    | INT           | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |

| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |

| price           | INT           | The price per unit of the product for the line item, in whole currency units (e.g., 25).      |
You stopped this response

# Data Catalog for Gold Layer


## Overview

The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.


---


### 1. **gold.dim_customers**

- **Purpose:** Stores customer details enriched with demographic and geographic data.

- **Columns:**


| Column Name      | Data Type     | Description                                                                                   |

|------------------|---------------|-----------------------------------------------------------------------------------------------|

| customer_key     | INT           | Surrogate key uniquely identifying each customer record in the dimension table.               |

| customer_id      | INT           | Unique numerical identifier assigned to each customer.                                        |

| customer_number  | NVARCHAR(50)  | Alphanumeric identifier representing the customer, used for tracking and referencing.         |

| first_name       | NVARCHAR(50)  | The customer's first name, as recorded in the system.                                         |

| last_name        | NVARCHAR(50)  | The customer's last name or family name.                                                     |

| country          | NVARCHAR(50)  | The country of residence for the customer (e.g., 'Australia').                               |

| marital_status   | NVARCHAR(50)  | The marital status of the customer (e.g., 'Married', 'Single').                              |

| gender           | NVARCHAR(50)  | The gender of the customer (e.g., 'Male', 'Female', 'n/a').                                  |

| birthdate        | DATE          | The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).               |

| create_date      | DATE          | The date and time when the customer record was created in the system|


---


### 2. **gold.dim_products**

- **Purpose:** Provides information about the products and their attributes.

- **Columns:**


| Column Name         | Data Type     | Description                                                                                   |

|---------------------|---------------|-----------------------------------------------------------------------------------------------|

| product_key         | INT           | Surrogate key uniquely identifying each product record in the product dimension table.         |

| product_id          | INT           | A unique identifier assigned to the product for internal tracking and referencing.            |

| product_number      | NVARCHAR(50)  | A structured alphanumeric code representing the product, often used for categorization or inventory. |

| product_name        | NVARCHAR(50)  | Descriptive name of the product, including key details such as type, color, and size.         |

| category_id         | NVARCHAR(50)  | A unique identifier for the product's category, linking to its high-level classification.     |

| category            | NVARCHAR(50)  | The broader classification of the product (e.g., Bikes, Components) to group related items.  |

| subcategory         | NVARCHAR(50)  | A more detailed classification of the product within the category, such as product type.      |

| maintenance_required| NVARCHAR(50)  | Indicates whether the product requires maintenance (e.g., 'Yes', 'No').                       |

| cost                | INT           | The cost or base price of the product, measured in monetary units.                            |

| product_line        | NVARCHAR(50)  | The specific product line or series to which the product belongs (e.g., Road, Mountain).      |

| start_date          | DATE          | The date when the product became available for sale or use, stored in|


---


### 3. **gold.fact_sales**

- **Purpose:** Stores transactional sales data for analytical purposes.

- **Columns:**


| Column Name     | Data Type     | Description                                                                                   |

|-----------------|---------------|-----------------------------------------------------------------------------------------------|

| order_number    | NVARCHAR(50)  | A unique alphanumeric identifier for each sales order (e.g., 'SO54496').                      |

| product_key     | INT           | Surrogate key linking the order to the product dimension table.                               |

| customer_key    | INT           | Surrogate key linking the order to the customer dimension table.                              |

| order_date      | DATE          | The date when the order was placed.                                                           |

| shipping_date   | DATE          | The date when the order was shipped to the customer.                                          |

| due_date        | DATE          | The date when the order payment was due.                                                      |

| sales_amount    | INT           | The total monetary value of the sale for the line item, in whole currency units (e.g., 25).   |

| quantity        | INT           | The number of units of the product ordered for the line item (e.g., 1).                       |

| price           | INT           | The price per unit of the product for the line item, in whole currency units (e.g., 25).      |


i want you to create a data catalog md file like this for github just change the description as it looks like someone else has written this

also improve the formatting a little

Your Markdown file is ready, Anshul.
MD icon
 Data_Catal...Gold_Layer 
MD

I have completely rewritten the descriptions so they sound like professional data engineering documentation, rather than copied notes. I also improved the GitHub formatting by adding standard Markdown emojis, utilizing blockquotes for the overview, clearly identifying the Primary/Foreign keys, and standardizing the table layouts. It's perfectly structured to drop straight into your repository's README.md or a standalone DATA_CATALOG.md file.

paste here

It looks like you want to paste something, but nothing came through!

Go ahead and paste whatever you need help with—whether it's SQL code, a Python script, an error message, or just some text—and I'll be happy to assist you.

# **Naming Conventions**


This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the data warehouse.


## **Table of Contents**


1. [General Principles](#general-principles)

2. [Table Naming Conventions](#table-naming-conventions)

   - [Bronze Rules](#bronze-rules)

   - [Silver Rules](#silver-rules)

   - [Gold Rules](#gold-rules)

3. [Column Naming Conventions](#column-naming-conventions)

   - [Surrogate Keys](#surrogate-keys)

   - [Technical Columns](#technical-columns)

4. [Stored Procedure](#stored-procedure-naming-conventions)

---


## **General Principles**


- **Naming Conventions**: Use snake_case, with lowercase letters and underscores (`_`) to separate words.

- **Language**: Use English for all names.

- **Avoid Reserved Words**: Do not use SQL reserved words as object names.


## **Table Naming Conventions**


### **Bronze Rules**

- All names must start with the source system name, and table names must match their original names without renaming.

- **`<sourcesystem>_<entity>`**  

  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  

  - `<entity>`: Exact table name from the source system.  

  - Example: `crm_customer_info` → Customer information from the CRM system.


### **Silver Rules**

- All names must start with the source system name, and table names must match their original names without renaming.

- **`<sourcesystem>_<entity>`**  

  - `<sourcesystem>`: Name of the source system (e.g., `crm`, `erp`).  

  - `<entity>`: Exact table name from the source system.  

  - Example: `crm_customer_info` → Customer information from the CRM system.


### **Gold Rules**

- All names must use meaningful, business-aligned names for tables, starting with the category prefix.

- **`<category>_<entity>`**  

  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  

  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `customers`, `products`, `sales`).  

  - Examples:

    - `dim_customers` → Dimension table for customer data.  

    - `fact_sales` → Fact table containing sales transactions.  


#### **Glossary of Category Patterns**


| Pattern     | Meaning                           | Example(s)                              |

|-------------|-----------------------------------|-----------------------------------------|

| `dim_`      | Dimension table                  | `dim_customer`, `dim_product`           |

| `fact_`     | Fact table                       | `fact_sales`                            |

| `report_`   | Report table                     | `report_customers`, `report_sales_monthly`   |


## **Column Naming Conventions**


### **Surrogate Keys**  

- All primary keys in dimension tables must use the suffix `_key`.

- **`<table_name>_key`**  

  - `<table_name>`: Refers to the name of the table or entity the key belongs to.  

  - `_key`: A suffix indicating that this column is a surrogate key.  

  - Example: `customer_key` → Surrogate key in the `dim_customers` table.

 

### **Technical Columns**

- All technical columns must start with the prefix `dwh_`, followed by a descriptive name indicating the column's purpose.

- **`dwh_<column_name>`**  

  - `dwh`: Prefix exclusively for system-generated metadata.  

  - `<column_name>`: Descriptive name indicating the column's purpose.  

  - Example: `dwh_load_date` → System-generated column used to store the date when the record was loaded.

 

## **Stored Procedure**


- All stored procedures used for loading data must follow the naming pattern:

- **`load_<layer>`**.

 

  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.

  - Example:

    - `load_bronze` → Stored procedure for loading data into the Bronze layer.

    - `load_silver` → Stored procedure for loading data into the Silver layer.


for this too

    Query successful

Your formatting is complete!
[file-tag: code-generated-file-0-1778095433237685141]
MD icon
 Naming_Conventions 
MD

I have enhanced this document to match the professional tone of the Data Catalog. I added clear architectural reasons for why these rules exist (like explaining that Bronze tables keep their original names for "absolute fidelity to the source system"), utilized Markdown tables for easy reading, and added emojis to make the documentation visually scannable on GitHub.


Gemini is AI and can make mistakes.
Highlight connections
0 connections found
Actions

# 🏷️ Naming Conventions

> **Overview**
> Establishing strict, universal naming conventions ensures that the data warehouse remains intuitive, predictable, and manageable as it scales. This document outlines the standard taxonomy for schemas, tables, views, columns, and programmatic objects across all data layers.

---

## 🏗️ 1. General Principles

* **Format:** All objects must exclusively use `snake_case` (lowercase letters with underscores separating words).
* **Language:** English is the mandatory language for all object naming.
* **Safety:** The use of SQL reserved keywords (e.g., `select`, `table`, `date`, `user`) as object names is strictly prohibited.

---

## 🗄️ 2. Table Naming Conventions

Table naming strategies shift from source-aligned in the raw layers to business-aligned in the analytical layers.

### 🥉 Bronze & 🥈 Silver Layers
* **Rule:** Maintain absolute fidelity to the source system. Do not apply business renaming at this stage.
* **Pattern:** `<source_system>_<entity_name>`
    * `<source_system>`: The abbreviated origin system (e.g., `crm`, `erp`, `hris`).
    * `<entity_name>`: The exact, unedited table name extracted from the source.
* **Example:** `crm_customer_info` (Data extracted directly from the CRM's 'customer_info' table).

### 🥇 Gold Layer
* **Rule:** Transition to semantic, business-friendly names categorized by their dimensional modeling role.
* **Pattern:** `<category_prefix>_<business_entity>`
    * `<category_prefix>`: The architectural role of the table (`dim`, `fact`, `report`).
    * `<business_entity>`: A clear, descriptive noun aligned with business terminology.
* **Examples:**
    * `dim_customers` (A dimension table holding customer profiles).
    * `fact_sales` (A fact table holding sales transaction metrics).

#### **Category Prefix Glossary**

| Prefix | Architectural Meaning | Example Implementation |
| :--- | :--- | :--- |
| `dim_` | **Dimension Table:** Descriptive, contextual attributes (the "who, what, where"). | `dim_products`, `dim_stores` |
| `fact_` | **Fact Table:** Quantitative, measurable events (the "how much, how many"). | `fact_inventory`, `fact_sales` |
| `report_` | **Report/View:** Pre-aggregated datasets built specifically for downstream BI tools. | `report_monthly_revenue` |

---

## 📋 3. Column Naming Conventions

### 🔑 Surrogate Keys
* **Rule:** Dimension tables must use auto-incrementing/hashed surrogate primary keys, independent of source system IDs.
* **Pattern:** `<entity_name>_key`
* **Example:** `customer_key` (The surrogate primary key for `dim_customers`).

### ⚙️ Technical/Metadata Columns
* **Rule:** System-generated audit columns must be distinctly identifiable to separate them from business data.
* **Pattern:** `dwh_<metadata_purpose>`
* **Example:** `dwh_create_date` (Timestamp indicating when the pipeline inserted the row).

---

## 📜 4. Stored Procedure Naming Conventions

* **Rule:** Procedures responsible for orchestrating data pipelines must clearly indicate their target destination layer.
* **Pattern:** `load_<target_layer>`
* **Examples:**
    * `load_bronze` (Procedure executing the extraction into the Bronze schema).
    * `load_silver` (Procedure executing the cleaning and insertion into the Silver schema).

Naming_Conventions.md
Displaying Naming_Conventions.md.
