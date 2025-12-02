-- Clinic Management System: Schema Setup

-- Table: clinics
CREATE TABLE clinics (
    cid VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Table: customer
CREATE TABLE customer (
    uid VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(15)
);

-- Table: clinic_sales
CREATE TABLE clinic_sales (
    oid VARCHAR(50) PRIMARY KEY,
    uid VARCHAR(50),
    cid VARCHAR(50),
    amount FLOAT,
    datetime TIMESTAMP,
    sales_channel VARCHAR(50)
);

-- Table: expenses
CREATE TABLE expenses (
    eid VARCHAR(50) PRIMARY KEY,
    cid VARCHAR(50),
    description TEXT,
    amount FLOAT,
    datetime TIMESTAMP
);

-- Sample Data
INSERT INTO clinics VALUES ('cnc-0100001', 'XYZ clinic', 'lorem', 'ipsum', 'dolor');
INSERT INTO customer VALUES ('bk-093fe-95hj', 'Jon Doe', '970000000X');
INSERT INTO clinic_sales VALUES ('ord-00100-00100', 'bk-093fe-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'social');
INSERT INTO expenses VALUES ('exp-0100-00100', 'cnc-0100001', 'first-aid supplies', 557, '2021-09-23 07:36:48');

