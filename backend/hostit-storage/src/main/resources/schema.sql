CREATE TABLE `file_metadata` (
                                 `id` BIGINT NOT NULL AUTO_INCREMENT,
                                 `name` VARCHAR(255) NOT NULL UNIQUE,
                                 `content_type` VARCHAR(255) NOT NULL,
                                 `size` BIGINT NOT NULL,
                                 `upload_date` TIMESTAMP NOT NULL,
                                 `path` TEXT NOT NULL,
                                 `user_id` BIGINT NOT NULL,
                                 PRIMARY KEY (`id`)
);


INSERT INTO `file_metadata` (`name`, `content_type`, `size`, `upload_date`, `path`, `user_id`) VALUES
                                                                                                   ('file1.pdf', 'application/pdf', 204800, CURRENT_TIMESTAMP, '/user-1/file1.pdf', 1),
                                                                                                   ('file2.docx', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 102400, CURRENT_TIMESTAMP, '/user-1/file2.docx', 1),
                                                                                                   ('image1.png', 'image/png', 512000, CURRENT_TIMESTAMP, '/user-2/image1.png', 2),
                                                                                                   ('music1.mp3', 'audio/mp3', 3072000, CURRENT_TIMESTAMP, '/user-3/music1.mp3', 3),
                                                                                                   ('video1.mp4', 'video/mp4', 20480000, CURRENT_TIMESTAMP, '/user-4/video1.mp4', 4),
                                                                                                   ('presentation1.pptx', 'application/vnd.openxmlformats-officedocument.presentationml.presentation', 409600, CURRENT_TIMESTAMP, '/user-5/presentation1.pptx', 5),
                                                                                                   ('script1.js', 'application/javascript', 20480, CURRENT_TIMESTAMP, '/user-6/script1.js', 6);
