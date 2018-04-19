DROP TABLE IF EXISTS `ele_restaurant`;
CREATE TABLE `ele_restaurant` (
	`id` INT(11) UNSIGNED AUTO_INCREMENT,
	`restaurant_id` INT(11) UNSIGNED COMMENT '商家id，来自数据源',
	`name` VARCHAR(100) DEFAULT NULL COMMENT '商家名称',
	`source` TINYINT(1) COMMENT '数据来源',
	`sales` INT(11) UNSIGNED COMMENT '销量',
	`arrive_time` INT(4) UNSIGNED COMMENT '平均到达时间',
	`send_fee` FLOAT UNSIGNED DEFAULT 0 COMMENT '配送费',
	`score` FLOAT UNSIGNED DEFAULT 0 COMMENT '评分',
	`latitude` VARCHAR(20),
	`longitude` VARCHAR(20),
	PRIMARY KEY (`id`),
	KEY `idx_restaurant_id` (`restaurant_id`)
) ENGINE = InnoDB CHARSET = utf8;

DROP TABLE IF EXISTS `ele_dish`;
CREATE TABLE `ele_dish` (
	`id` INT(11) UNSIGNED AUTO_INCREMENT,
	`food_id` INT(11) UNSIGNED COMMENT '菜品id',
	`restaurant_id` INT(11) UNSIGNED COMMENT 'restaurant 表中的 id',
	`name` VARCHAR(100)  DEFAULT NULL COMMENT '菜品名称',
	`rating` FLOAT UNSIGNED  DEFAULT 0 COMMENT '评价',
	`moth_sales` INT(11) UNSIGNED DEFAULT 0 COMMENT '月销量',
	`rating_count` INT(11) UNSIGNED  DEFAULT 0 COMMENT '评价数',
	`price` FLOAT UNSIGNED  DEFAULT 0 COMMENT '价格',
	`crawler_id` INT(11) UNSIGNED NOT NULL COMMENT '提交任务的爬虫id',
	PRIMARY KEY (`id`),
	KEY `idx_restaurant_id` (`restaurant_id`)
) ENGINE = InnoDB CHARSET = utf8;

DROP TABLE IF EXISTS `crawler`;
CREATE TABLE `crawler` (
	`id` INT(11) UNSIGNED AUTO_INCREMENT,
	`u_id` INT(11) UNSIGNED NOT NULL COMMENT '提交任务的用户id',
	`status` TINYINT(1) DEFAULT 0 COMMENT '任务执行的状态',
	`created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`finished` TIMESTAMP NULL DEFAULT NULL,
	`args` TEXT COMMENT '任务的参数',
	`info` TEXT,
	`extras` TEXT,
	`data_count` INT(11) UNSIGNED DEFAULT 0 COMMENT '当前获取到的数据量',
	`total` INT(11) UNSIGNED DEFAULT 0 COMMENT '总数据量',
	`type` INT(1) UNSIGNED COMMENT '爬虫类型',
	`source` INT(1) COMMENT '数据来源',
	PRIMARY KEY (`id`)
) ENGINE = InnoDB CHARSET = utf8;

DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
	`id` INT(11) UNSIGNED AUTO_INCREMENT,
	`created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`name` varchar(50),
	`passwd` varchar(16),
	`email` varchar(50),
	`mobile` varchar(20),
	`visitor_count` INT(11) DEFAULT 0,
	PRIMARY KEY (`id`),
	KEY `idx_name_passwd` (`name`, `passwd`),
	KEY `idx_email_passwd` (`email`, `passwd`),
	KEY `idx_mobile_passwd` (`mobile`, `passwd`)
) ENGINE = InnoDB CHARSET = utf8;

DROP TABLE IF EXISTS `ele_rate`;
CREATE TABLE `ele_rate` (
    `id` INT(11) UNSIGNED AUTO_INCREMENT,
    `rating_id` INT(10),
    `rating_start` INT(1),
    `rated_at` VARCHAR(50),
    `rating_text` TEXT,
    `time_spent_desc` VARCHAR(50),
    `restaurant_id` INT(11) UNSIGNED,
    `restaurant_crawler_id` INT(11) UNSIGNED,
    `food_id` INT(11) UNSIGNED COMMENT '菜品id 对应 dish 表中 food_id',
    `food_name` TEXT,
    `food_star` INT(4),
    `food_rate` TEXT,
    PRIMARY KEY (`id`),
    KEY `idx_restaurant_crawler_food_id` (`restaurant_id`, `restaurant_crawler_id`, `food_id`),
    KEY `idx_restaurant_id_rating_start` (`restaurant_id`, `rating_start`),
    KEY `idx_food` (`food_id`)
) ENGINE = InnoDB CHARSET = utf8;

DROP TABLE IF EXISTS `user_log`;
CREATE TABLE `user_log` (
    `id` INT(11) UNSIGNED AUTO_INCREMENT,
    `user_id` INT(11) NOT NULL COMMENT '用户 id ,对应 user 表中 id',
    `created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `action_name` TEXT NOT NULL,
    `action_args` TEXT DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`)
) ENGINE = InnoDB CHARSET = utf8;