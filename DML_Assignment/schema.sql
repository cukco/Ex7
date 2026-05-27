INSERT INTO customers (full_name, email, phone, city, join_date) VALUES
                                                                     ('Nguyễn Văn A', 'a@gmail.com', '0912345678', 'Hà Nội', '2023-01-10'),
                                                                     ('Trần Thị B', 'b@gmail.com', '0922345678', 'Hồ Chí Minh', '2023-02-15'),
                                                                     ('Lê Văn C', 'c@gmail.com', '0932345678', 'Đà Nẵng', '2023-03-20'),
                                                                     ('Phạm Thị D', 'd@gmail.com', '0942345678', 'Cần Thơ', '2023-04-25'),
                                                                     ('Hoàng Văn E', 'e@gmail.com', '0952345678', 'Hải Phòng', '2023-05-30'),
                                                                     ('Vũ Thị F', 'f@gmail.com', '0962345678', 'Hà Nội', '2023-06-05'),
                                                                     ('Đặng Văn G', 'g@gmail.com', '0972345678', 'Hồ Chí Minh', '2023-07-10'),
                                                                     ('Bùi Thị H', 'h@gmail.com', '0982345678', 'Huế', '2023-08-15'),
                                                                     ('Lý Văn I', 'i@gmail.com', '0992345678', 'Vũng Tàu', '2023-09-20'),
                                                                     ('Chu Thị K', 'k@gmail.com', '0902345678', 'Hà Nội', '2023-10-25');
INSERT INTO products (product_name, category, price, stock_quantity) VALUES
                                                                         ('iPhone 15', 'Điện tử', 25000000, 50),
                                                                         ('Macbook M3', 'Điện tử', 45000000, 20),
                                                                         ('Samsung S24', 'Điện tử', 22000000, 30),
                                                                         ('Tai nghe Sony', 'Điện tử', 5000000, 100),
                                                                         ('Chuột Logitech', 'Điện tử', 1000000, 200),
                                                                         ('Áo thun Polo', 'Thời trang', 500000, 500),
                                                                         ('Quần Jean Levi''s', 'Thời trang', 1500000, 150),
                                                                         ('Váy dạ hội', 'Thời trang', 2000000, 50),
                                                                         ('Giày Adidas', 'Thời trang', 3000000, 80),
                                                                         ('Mũ bảo hiểm', 'Thời trang', 300000, 300),
                                                                         ('Nồi cơm điện', 'Gia dụng', 1200000, 40),
                                                                         ('Máy lọc nước', 'Gia dụng', 6000000, 15),
                                                                         ('Lò vi sóng', 'Gia dụng', 2500000, 25),
                                                                         ('Quạt đứng', 'Gia dụng', 800000, 60),
                                                                         ('Máy hút bụi', 'Gia dụng', 3500000, 10);
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
                                                                       (1, '2024-01-05', 26000000, 'SHIPPED'),
                                                                       (2, '2024-01-06', 1500000, 'CONFIRMED'),
                                                                       (3, '2024-01-07', 45000000, 'PENDING'),
                                                                       (4, '2024-01-08', 3500000, 'CANCELLED'),
                                                                       (5, '2024-01-09', 12000000, 'SHIPPED'),
                                                                       (1, '2024-01-10', 5000000, 'CONFIRMED'),
                                                                       (6, '2024-01-11', 1000000, 'PENDING'),
                                                                       (7, '2024-01-12', 3000000, 'SHIPPED');
INSERT INTO order_details (order_id, product_id, quantity, unit_price) VALUES
                                                                           (1, 1, 1, 25000000), (1, 5, 1, 1000000), -- Đơn 1 có 2 SP
                                                                           (2, 7, 1, 1500000),                     -- Đơn 2 có 1 SP
                                                                           (3, 2, 1, 45000000),                    -- Đơn 3 có 1 SP
                                                                           (4, 9, 1, 3000000), (4, 10, 1, 500000), -- Đơn 4 có 2 SP
                                                                           (5, 12, 2, 6000000),                    -- Đơn 5 có 1 SP
                                                                           (6, 4, 1, 5000000),                     -- Đơn 6 có 1 SP
                                                                           (7, 6, 2, 500000),                      -- Đơn 7 có 1 SP
                                                                           (8, 9, 1, 3000000),                     -- Đơn 8 có 1 SP
                                                                           (1, 14, 1, 800000),                     -- Thêm cho đủ 15 dòng
                                                                           (2, 15, 1, 3500000),
                                                                           (3, 11, 2, 1200000),
                                                                           (5, 8, 1, 2000000),
                                                                           (6, 13, 1, 2500000),
                                                                           (7, 10, 2, 300000);