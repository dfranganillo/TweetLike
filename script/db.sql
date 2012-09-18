CREATE TABLE users (
  `user_id` bigint NOT NULL,
  `screen_name` varchar(20) NOT NULL,
  `name` varchar(40) DEFAULT NULL,
  `profile_image_url` varchar(200) DEFAULT NULL,
  `location` varchar(30) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `followers_count` int DEFAULT NULL,
  `friends_count` int DEFAULT NULL,
  `statuses_count` int DEFAULT NULL,
  `time_zone` varchar(40) DEFAULT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `oauth_secret` TEXT,
  `oauth_validator` TEXT,
  PRIMARY KEY (`user_id`)
);
