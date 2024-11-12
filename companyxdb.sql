-- Creation of Entities
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT  CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    size ENUM('small', 'medium', 'large') NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    description TEXT,
    category_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);


CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id)
);


-- 2. Inserting records
INSERT INTO Users (username, password, email, role) 
VALUES ('admin1', 'admin1234', 'admin@mail.com', 'admin'),
('Abiodun001', 'abiodun@mail.com', 'user');

INSERT INTO Categories (name, description) 
VALUES ('Tennis', 'Tennis sports shop'),
('Tennis Coach/Software Engineer', 'Teaching people how to play good tennis and stay happy.');


INSERT INTO Items (name, price, size, quantity, description, category_id) 
VALUES ('racket', 999.99, 'medium', 10, 'graphite', 1);

INSERT INTO Orders (user_id, status) 
VALUES (1, 'pending');

INSERT INTO OrderItems (order_id, item_id, quantity, unit_price, total_price) 
VALUES (1, 1, 2, 999.99, 1999.98);

-- 3. Getting records from multiple entities
SELECT i.name, i.price, c.name as category
FROM Items i
JOIN Categories c ON i.category_id = c.category_id;

-- 4. Updating records from multiple entities
UPDATE Items i
JOIN Categories c ON i.category_id = c.category_id
SET i.price = i.price * 1.1
WHERE c.name = 'Tennis sports shop';

-- 5. Deleting records from multiple entities
DELETE i, oi
FROM Items i
LEFT JOIN OrderItems oi ON i.item_id = oi.item_id
WHERE i.category_id = 1;

-- 6. Querying records using joins
SELECT 
    o.order_id,
    u.username,
    i.name as item_name,
    oi.quantity,
    oi.unit_price,
    oi.total_price,
    o.status
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Items i ON oi.item_id = i.item_id
WHERE o.status = 'pending';

