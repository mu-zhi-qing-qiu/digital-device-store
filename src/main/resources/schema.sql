-- ============================================================
-- 数码设备商城 - 全量 DDL
-- 由 Spring Boot 启动时自动执行（spring.sql.init.mode=always）
-- 可重复执行：全部使用 CREATE TABLE IF NOT EXISTS
-- 种子数据由 DataInitializer.java 在启动时写入（密码经 BCrypt 加密）
-- ============================================================

CREATE TABLE IF NOT EXISTS `user` (
    `id`       BIGINT       NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    `username` VARCHAR(50)  NOT NULL COMMENT '用户名',
    `password` VARCHAR(100) NOT NULL COMMENT '密码（BCrypt）',
    `phone`    VARCHAR(20)  DEFAULT NULL COMMENT '手机号',
    `email`    VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    `role`     TINYINT      NOT NULL DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_username` (`username`)
-- 用户名唯一
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';

CREATE TABLE IF NOT EXISTS `category` (
    `id`        BIGINT      NOT NULL AUTO_INCREMENT COMMENT '分类ID',
    `name`      VARCHAR(50) NOT NULL COMMENT '分类名称',
    `parent_id` BIGINT      DEFAULT NULL COMMENT '父分类ID（NULL 表示顶级）',
    PRIMARY KEY (`id`),
    KEY `idx_parent_id` (`parent_id`),
    CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品分类表';

CREATE TABLE IF NOT EXISTS `product` (
    `id`          BIGINT         NOT NULL AUTO_INCREMENT COMMENT '商品ID',
    `name`        VARCHAR(100)   NOT NULL COMMENT '商品名称',
    `price`       DECIMAL(10, 2) NOT NULL COMMENT '价格',
    `stock`       INT            NOT NULL DEFAULT 0 COMMENT '库存',
    `category_id` BIGINT         DEFAULT NULL COMMENT '分类ID',
    `brand`       VARCHAR(50)    DEFAULT NULL COMMENT '品牌',
    `description` TEXT           DEFAULT NULL COMMENT '描述',
    PRIMARY KEY (`id`),
    KEY `idx_category_id` (`category_id`),
    CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品表';

CREATE TABLE IF NOT EXISTS `product_image` (
    `id`         BIGINT        NOT NULL AUTO_INCREMENT COMMENT '图片ID',
    `product_id` BIGINT        NOT NULL COMMENT '商品ID',
    `url`        VARCHAR(255)  NOT NULL COMMENT '图片URL',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_image_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '商品图片表';

CREATE TABLE IF NOT EXISTS `cart` (
    `id`      BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_id` (`user_id`),
    CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '购物车表';

CREATE TABLE IF NOT EXISTS `cart_item` (
    `id`       BIGINT NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
    `cart_id`  BIGINT NOT NULL COMMENT '购物车ID',
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `quantity` INT    NOT NULL DEFAULT 1 COMMENT '数量',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_cart_product` (`cart_id`, `product_id`),
    CONSTRAINT `fk_cart_item_cart`    FOREIGN KEY (`cart_id`)    REFERENCES `cart`    (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_cart_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '购物车项表';

CREATE TABLE IF NOT EXISTS `order` (
    `id`           BIGINT         NOT NULL AUTO_INCREMENT COMMENT '订单ID',
    `user_id`      BIGINT         NOT NULL COMMENT '用户ID',
    `total_amount` DECIMAL(10, 2) NOT NULL COMMENT '总金额',
    `status`       TINYINT        NOT NULL DEFAULT 0 COMMENT '订单状态：0-待付款，1-已付款，2-已发货，3-已完成，4-已取消',
    `created_time` DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单表';

CREATE TABLE IF NOT EXISTS `order_item` (
    `id`             BIGINT         NOT NULL AUTO_INCREMENT COMMENT '订单详情ID',
    `order_id`       BIGINT         NOT NULL COMMENT '订单ID',
    `product_id`     BIGINT         NOT NULL COMMENT '商品ID',
    `quantity`       INT            NOT NULL COMMENT '购买数量',
    `purchase_price` DECIMAL(10, 2) NOT NULL COMMENT '购买单价（快照）',
    PRIMARY KEY (`id`),
    KEY `idx_order_id` (`order_id`),
    CONSTRAINT `fk_order_item_order`   FOREIGN KEY (`order_id`)   REFERENCES `order`   (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '订单详情表';

CREATE TABLE IF NOT EXISTS `review` (
    `id`         BIGINT NOT NULL AUTO_INCREMENT COMMENT '评论ID',
    `user_id`    BIGINT NOT NULL COMMENT '用户ID',
    `product_id` BIGINT NOT NULL COMMENT '商品ID',
    `rating`     TINYINT NOT NULL COMMENT '评分（1-5）',
    `content`    TEXT    DEFAULT NULL COMMENT '评论内容',
    PRIMARY KEY (`id`),
    KEY `idx_product_id` (`product_id`),
    CONSTRAINT `fk_review_user`    FOREIGN KEY (`user_id`)    REFERENCES `user`    (`id`),
    CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COMMENT = '评论表';
