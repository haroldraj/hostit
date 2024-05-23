DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS roles ;
DROP TABLE IF EXISTS verification_token;
DROP TABLE IF EXISTS users;
SHOW TABLES;
-- Create the users table
CREATE TABLE users (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(255) NOT NULL UNIQUE,
                       password VARCHAR(255) NOT NULL,
                       email VARCHAR(255) UNIQUE,
                       enabled BOOLEAN DEFAULT FALSE,
                       secret VARCHAR(255) NOT NULL, -- For 2FA secret key
                       is2FAEnabled BOOLEAN DEFAULT FALSE -- For 2FA status
);

-- Create the roles table
CREATE TABLE roles (
                       id BIGINT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(255) NOT NULL UNIQUE
);

-- Create the user_roles table
CREATE TABLE user_roles (
                            user_id BIGINT,
                            role_id BIGINT,
                            PRIMARY KEY (user_id, role_id),
                            FOREIGN KEY (user_id) REFERENCES users(id),
                            FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- Create the verification_token table
CREATE TABLE verification_token (
                                    id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                    token VARCHAR(255) NOT NULL,
                                    expiry_date TIMESTAMP,
                                    user_id BIGINT,
                                    FOREIGN KEY (user_id) REFERENCES users(id)
);
