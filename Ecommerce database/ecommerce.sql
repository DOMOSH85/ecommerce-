-- Create the database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Create attribute_type table
CREATE TABLE attribute_type (
    id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create attribute_category table
CREATE TABLE attribute_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create brand table
CREATE TABLE brand (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    brand_name VARCHAR(100) NOT NULL,
    description TEXT,
    logo_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create product_category table with self-referencing parent_id
CREATE TABLE product_category (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    category_name VARCHAR(100) NOT NULL,
    parent_id INT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES product_category(id) ON DELETE SET NULL
);

-- Create product table
CREATE TABLE product (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    category_id INT NOT NULL,
    brand_id INT NOT NULL,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES product_category(id),
    FOREIGN KEY (brand_id) REFERENCES brand(id)
);

-- Create product_image table
CREATE TABLE product_image (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    product_id INT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Create color table
CREATE TABLE color (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    color_name VARCHAR(50) NOT NULL,
    hex_code VARCHAR(7) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create size_category table
CREATE TABLE size_category (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    category_name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create size_option table
CREATE TABLE size_option (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    category_id INT NOT NULL,
    size_value VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES size_category(id)
);

-- Create product_variation table
CREATE TABLE product_variation (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    product_id INT NOT NULL,
    variation_name VARCHAR(50) NOT NULL,
    is_required BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Create product_item table
CREATE TABLE product_item (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    product_id INT NOT NULL,
    SKU VARCHAR(50) NOT NULL UNIQUE,
    quantity INT NOT NULL DEFAULT 0,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE
);

-- Create product_attribute table
CREATE TABLE product_attribute (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    product_id INT NOT NULL,
    attribute_type_id INT NOT NULL,
    category_id INT NOT NULL,
    value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(id),
    FOREIGN KEY (category_id) REFERENCES attribute_category(id)
);

-- Create variation_option table to link product items to their variations
CREATE TABLE variation_option (
    id INT PRIMARY KEY AUTO_INCREMENT ,
    variation_id INT NOT NULL,
    product_item_id INT NOT NULL,
    color_id INT,
    size_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (variation_id) REFERENCES product_variation(id),
    FOREIGN KEY (product_item_id) REFERENCES product_item(id) ON DELETE CASCADE,
    FOREIGN KEY (color_id) REFERENCES color(id) ON DELETE SET NULL,
    FOREIGN KEY (size_id) REFERENCES size_option(id) ON DELETE SET NULL,
    CONSTRAINT chk_variation_value CHECK (color_id IS NOT NULL OR size_id IS NOT NULL)
);

-- Create indexes for better performance
CREATE INDEX idx_product_category ON product(category_id);
CREATE INDEX idx_product_brand ON product(brand_id);
CREATE INDEX idx_product_item_product ON product_item(product_id);
CREATE INDEX idx_variation_product ON product_variation(product_id);
CREATE INDEX idx_variation_option_item ON variation_option(product_item_id);
CREATE INDEX idx_product_attribute_product ON product_attribute(product_id);