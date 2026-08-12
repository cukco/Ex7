CREATE TABLE Product(
                        Product_Id serial primary key,
                        Product_Name varchar(100) not null unique,
                        Product_Price double precision not null check (Product_Price > 0),
                        Product_Title varchar(200) not null,
                        Product_created Date not null default current_date,
                        Product_catalog varchar(100) not null,
                        Product_Status bit default B'1'
);

CREATE OR REPLACE PROCEDURE show_all_products(p_result INOUT REFCURSOR)
    LANGUAGE plpgsql AS $$
BEGIN
OPEN p_result FOR SELECT * FROM Product;
END;
$$;

CREATE OR REPLACE PROCEDURE check_catalog_exists(p_catalog VARCHAR, OUT p_exists BOOLEAN)
    LANGUAGE plpgsql AS $$
BEGIN
SELECT EXISTS (SELECT 1 FROM Product WHERE Product_catalog = p_catalog) INTO p_exists;
END;
$$;

CREATE OR REPLACE PROCEDURE insert_product(
    p_name varchar(100), p_price float, p_title varchar(200), p_catalog varchar(100)
) LANGUAGE plpgsql AS $$
BEGIN
INSERT INTO Product (Product_Name, Product_Price, Product_Title, Product_catalog)
VALUES (p_name, p_price, p_title, p_catalog);
END;
$$;

CREATE OR REPLACE PROCEDURE update_product(
    p_id int, p_name varchar(100), p_price float, p_title varchar(200), p_catalog varchar(100)
) LANGUAGE plpgsql AS $$
BEGIN
UPDATE Product
SET Product_Name = p_name, Product_Price = p_price,
    Product_Title = p_title, Product_catalog = p_catalog
WHERE Product_Id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE delete_product(p_id int)
    LANGUAGE plpgsql AS $$
BEGIN
DELETE FROM Product WHERE Product_Id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE get_product_by_id(p_id int, p_result INOUT REFCURSOR)
    LANGUAGE plpgsql AS $$
BEGIN
OPEN p_result FOR SELECT * FROM Product WHERE Product_Id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE search_product_by_name(p_name varchar, p_result INOUT REFCURSOR)
    LANGUAGE plpgsql AS $$
BEGIN
OPEN p_result FOR SELECT * FROM Product WHERE Product_Name ILIKE '%' || p_name || '%';
END;
$$;

CREATE OR REPLACE PROCEDURE count_by_catalog(p_catalog VARCHAR, OUT p_count INT)
    LANGUAGE plpgsql AS $$
BEGIN
SELECT COUNT(*) INTO p_count FROM Product WHERE Product_catalog = p_catalog;
END;
$$;

CREATE OR REPLACE PROCEDURE sort_by_price_asc(p_result INOUT REFCURSOR)
    LANGUAGE plpgsql AS $$
BEGIN
OPEN p_result FOR SELECT * FROM Product ORDER BY Product_Price ASC;
END;
$$;
