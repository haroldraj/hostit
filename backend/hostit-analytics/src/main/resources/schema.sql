-- This script creates the 'file_metadata' table for storing file information.
CREATE TABLE IF NOT EXISTS file_metadata (
                                             id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                             user_id INT NOT NULL,
                                             file_type VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    directory_id INT,
    INDEX(user_id),   -- Index for faster query performance on user_id
    INDEX(file_type), -- Index for faster query performance on file_type
    INDEX(upload_date) -- Index for faster query performance on upload_date
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Note: Adjust column types and sizes according to your specific requirements.

-- Inserting sample data into file_metadata table
INSERT INTO file_metadata (user_id, file_type, file_size, upload_date, directory_id) VALUES
                                                                                         (1, 'pdf', 1048576, '2024-05-24 12:00:00', 1),
                                                                                         (1, 'docx', 204800, '2024-05-25 12:00:00', 1),
                                                                                         (2, 'pdf', 1048576, '2024-05-26 12:00:00', 2),
                                                                                         (2, 'jpeg', 512000, '2024-05-27 12:00:00', 3),
                                                                                         (3, 'mp4', 2147483648, '2024-05-28 12:00:00', 4),
                                                                                         (3, 'mp3', 10485760, '2024-05-29 12:00:00', 5),
                                                                                         (1, 'xlsx', 307200, '2024-05-30 12:00:00', 1);

-- Add more rows as necessary to simulate a variety of data
