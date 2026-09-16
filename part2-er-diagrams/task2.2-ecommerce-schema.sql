-- Task 2.2: E-commerce Platform
-- Реляционная схема, полученная из ER-диаграммы (task2.2-ecommerce.md)

CREATE TABLE Category (
    CategoryID  SERIAL PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL
);

CREATE TABLE Vendor (
    VendorID    SERIAL PRIMARY KEY,
    Name        VARCHAR(150) NOT NULL,
    ContactInfo VARCHAR(200)
);

CREATE TABLE Customer (
    CustomerID      SERIAL PRIMARY KEY,
    Name            VARCHAR(100) NOT NULL,
    Email           VARCHAR(150) UNIQUE NOT NULL,
    BillingStreet   VARCHAR(150),
    BillingCity     VARCHAR(100),
    BillingState    VARCHAR(100),
    BillingZip      VARCHAR(20)
);

CREATE TABLE Product (
    ProductID   SERIAL PRIMARY KEY,
    Name        VARCHAR(150) NOT NULL,
    Price       DECIMAL(10,2) NOT NULL,
    Description TEXT,
    StockLevel  INT NOT NULL DEFAULT 0,
    CategoryID  INT REFERENCES Category(CategoryID),
    VendorID    INT REFERENCES Vendor(VendorID)
);

CREATE TABLE "Order" (
    OrderID         SERIAL PRIMARY KEY,
    CustomerID      INT NOT NULL REFERENCES Customer(CustomerID),
    OrderDate       TIMESTAMP NOT NULL DEFAULT now(),
    ShippingStreet  VARCHAR(150),
    ShippingCity    VARCHAR(100),
    ShippingState   VARCHAR(100),
    ShippingZip     VARCHAR(20),
    Status          VARCHAR(30) NOT NULL DEFAULT 'pending'
);

-- weak entity: полный ключ (OrderID, ProductID)
CREATE TABLE OrderItem (
    OrderID         INT NOT NULL REFERENCES "Order"(OrderID) ON DELETE CASCADE,
    ProductID       INT NOT NULL REFERENCES Product(ProductID),
    Quantity        INT NOT NULL CHECK (Quantity > 0),
    PriceAtOrder    DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ProductID)
);

-- weak entity: полный ключ (ProductID, CustomerID)
CREATE TABLE Review (
    ProductID   INT NOT NULL REFERENCES Product(ProductID) ON DELETE CASCADE,
    CustomerID  INT NOT NULL REFERENCES Customer(CustomerID),
    Rating      SMALLINT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comment     TEXT,
    ReviewDate  DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (ProductID, CustomerID)
);
