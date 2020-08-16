DROP DATABASE IF EXISTS tetrika_tst;
CREATE DATABASE tetrika_tst;
USE tetrika_tst;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`num_id` bigint,
   `id` varchar(200),
   `role` VARCHAR(200),
    FOREIGN KEY (`id`) REFERENCES participants(user_id)
)
COLLATE='utf8_unicode_ci'
ENGINE=MyISAM
ROW_FORMAT=DEFAULT;

DROP TABLE IF EXISTS `lessons`;
CREATE TABLE `lessons` (
	`num_id` bigint,
   `id` varchar(200),
   `event_id` bigint,
	`subject` varchar(200),
    `sheduled_time` datetime,
    FOREIGN KEY (event_id) REFERENCES participants(event_id),
    FOREIGN KEY (id) REFERENCES quality(lesson_id)
)
COLLATE='utf8_unicode_ci'
ENGINE=MyISAM
ROW_FORMAT=DEFAULT;

DROP TABLE IF EXISTS `participants`;
CREATE TABLE `participants` (
	`num_id` bigint,
   `event_id` bigint,
   `user_id` varchar(255),
   FOREIGN KEY (event_id) REFERENCES lessons(event_id),
   FOREIGN KEY (`user_id`) REFERENCES users(id)
)
COLLATE='utf8_unicode_ci'
ENGINE=MyISAM
ROW_FORMAT=DEFAULT;

DROP TABLE IF EXISTS `quality`;
CREATE TABLE `quality` (
	`num_id` bigint,
   `lesson_id` varchar(255),
   `tech_quality` int,
   FOREIGN KEY (lesson_id) REFERENCES lessons(id)
)
COLLATE='utf8_unicode_ci'
ENGINE=MyISAM
ROW_FORMAT=DEFAULT;


LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\users.csv'
INTO TABLE `users`
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY '\\'
LINES STARTING BY '' TERMINATED BY '\r\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\lessons.csv'
INTO TABLE `lessons`
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY '\\'
LINES STARTING BY '' TERMINATED BY '\r\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\participants.csv'
INTO TABLE `participants`
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY '\\'
LINES STARTING BY '' TERMINATED BY '\r\n';

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\quality.csv'
INTO TABLE `quality`
FIELDS TERMINATED BY '|' ENCLOSED BY '' ESCAPED BY '\\'
LINES STARTING BY '' TERMINATED BY '\r\n';

SET SQL_SAFE_UPDATES = 0;

-- При расчёте среднего значения не нужно учитывать ситуации, когда пользователь не выставил оценку.
 DELETE FROM quality WHERE tech_quality = 0; 
 


CREATE TABLE solve AS SELECT users.id as tutor_id, lessons.sheduled_time as time_l, AVG(quality.tech_quality) as qual
FROM users, participants, lessons, quality
WHERE users.id = participants.user_id and lessons.event_id = participants.event_id and
users.role = 'tutor' and lessons.id = quality.lesson_id GROUP BY lessons.sheduled_time order by qual limit 2;







