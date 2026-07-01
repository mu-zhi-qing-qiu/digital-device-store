/*
MySQL Backup
Database: digital_device_store
Backup Time: 2026-07-01 11:41:47
*/

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS `digital_device_store`.`cart`;
DROP TABLE IF EXISTS `digital_device_store`.`cart_item`;
DROP TABLE IF EXISTS `digital_device_store`.`category`;
DROP TABLE IF EXISTS `digital_device_store`.`order`;
DROP TABLE IF EXISTS `digital_device_store`.`order_item`;
DROP TABLE IF EXISTS `digital_device_store`.`product`;
DROP TABLE IF EXISTS `digital_device_store`.`product_image`;
DROP TABLE IF EXISTS `digital_device_store`.`review`;
DROP TABLE IF EXISTS `digital_device_store`.`user`;
CREATE TABLE `cart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_id` (`user_id`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车表';
CREATE TABLE `cart_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '购物车项ID',
  `cart_id` bigint(20) NOT NULL COMMENT '购物车ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `quantity` int(11) NOT NULL DEFAULT '1' COMMENT '数量',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cart_product` (`cart_id`,`product_id`),
  KEY `fk_cart_item_product` (`product_id`),
  CONSTRAINT `fk_cart_item_cart` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='购物车项表';
CREATE TABLE `category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) NOT NULL COMMENT '分类名称',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '父分类ID（NULL 表示顶级）',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  CONSTRAINT `fk_category_parent` FOREIGN KEY (`parent_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品分类表';
CREATE TABLE `order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `total_amount` decimal(10,2) NOT NULL COMMENT '总金额',
  `status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '订单状态：0-待付款，1-已付款，2-已发货，3-已完成，4-已取消',
  `created_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_user_created` (`user_id`,`created_time`),
  KEY `idx_order_created_time` (`created_time`),
  CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单表';
CREATE TABLE `order_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '订单详情ID',
  `order_id` bigint(20) NOT NULL COMMENT '订单ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `quantity` int(11) NOT NULL COMMENT '购买数量',
  `purchase_price` decimal(10,2) NOT NULL COMMENT '购买单价（快照）',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `fk_order_item_product` (`product_id`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='订单详情表';
CREATE TABLE `product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '商品ID',
  `name` varchar(100) NOT NULL COMMENT '商品名称',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `stock` int(11) NOT NULL DEFAULT '0' COMMENT '库存',
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类ID',
  `brand` varchar(50) DEFAULT NULL COMMENT '品牌',
  `description` text COMMENT '描述',
  PRIMARY KEY (`id`),
  KEY `idx_category_id` (`category_id`),
  FULLTEXT KEY `ft_product_name` (`name`) /*!50100 WITH PARSER `ngram` */ ,
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品表';
CREATE TABLE `product_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `url` varchar(255) NOT NULL COMMENT '图片URL',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_image_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='商品图片表';
CREATE TABLE `review` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` bigint(20) NOT NULL COMMENT '用户ID',
  `product_id` bigint(20) NOT NULL COMMENT '商品ID',
  `rating` tinyint(4) NOT NULL COMMENT '评分（1-5）',
  `content` text COMMENT '评论内容',
  PRIMARY KEY (`id`),
  KEY `idx_product_id` (`product_id`),
  KEY `fk_review_user` (`user_id`),
  CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='评论表';
CREATE TABLE `user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `password` varchar(100) NOT NULL COMMENT '密码（BCrypt）',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) DEFAULT NULL COMMENT '邮箱',
  `role` tinyint(4) NOT NULL DEFAULT '0' COMMENT '角色：0-普通用户，1-管理员',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';
BEGIN;
LOCK TABLES `digital_device_store`.`cart` WRITE;
DELETE FROM `digital_device_store`.`cart`;
INSERT INTO `digital_device_store`.`cart` (`id`,`user_id`) VALUES (1, 3);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`cart_item` WRITE;
DELETE FROM `digital_device_store`.`cart_item`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`category` WRITE;
DELETE FROM `digital_device_store`.`category`;
INSERT INTO `digital_device_store`.`category` (`id`,`name`,`parent_id`) VALUES (1, '台式机', NULL),(2, '存储设备', NULL),(3, '平板', NULL),(4, '手机', NULL),(5, '手机配件', NULL),(6, '摄影相机', NULL),(7, '无人机', NULL),(8, '显示器', NULL),(9, '智能手表', NULL),(10, '电脑配件', NULL),(11, '笔记本电脑', NULL),(12, '耳机音响', NULL),(13, '键盘', NULL),(14, '鼠标', NULL);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`order` WRITE;
DELETE FROM `digital_device_store`.`order`;
INSERT INTO `digital_device_store`.`order` (`id`,`user_id`,`total_amount`,`status`,`created_time`) VALUES (1, 3, 49440.00, 1, '2026-06-29 17:05:52'),(2, 3, 25045.00, 1, '2026-06-29 18:12:58'),(3, 3, 7799.00, 1, '2026-06-30 22:11:52');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`order_item` WRITE;
DELETE FROM `digital_device_store`.`order_item`;
INSERT INTO `digital_device_store`.`order_item` (`id`,`order_id`,`product_id`,`quantity`,`purchase_price`) VALUES (1, 1, 1, 1, 5999.00),(2, 1, 2, 1, 7799.00),(3, 1, 6, 1, 4599.00),(4, 1, 7, 1, 9299.00),(5, 1, 8, 1, 1849.00),(6, 1, 9, 1, 3099.00),(7, 1, 12, 4, 4199.00),(8, 2, 2, 1, 7799.00),(9, 2, 3, 1, 5999.00),(10, 2, 4, 1, 4799.00),(11, 2, 6, 1, 4599.00),(12, 2, 8, 1, 1849.00),(13, 3, 2, 1, 7799.00);
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`product` WRITE;
DELETE FROM `digital_device_store`.`product`;
INSERT INTO `digital_device_store`.`product` (`id`,`name`,`price`,`stock`,`category_id`,`brand`,`description`) VALUES (1, 'vivo X200 Pro 16+512GB 淡紫', 5999.00, 99, 4, 'vivo', '蔡司四摄，2K 护眼曲面屏，120W 闪充，AI 人像算法'),(2, 'iPhone 17 ProMax 256GB 白色', 7799.00, 97, 4, 'Apple', '6.7 英寸 XDR 显示屏，A18 Pro 芯片，5G 全网通，钛金属机身，4800 万像素主摄'),(3, 'iPhone 17 128GB 星光白', 5999.00, 99, 4, 'Apple', '6.3 英寸屏幕，A18 芯片，5G，4800 万主摄，轻量化机身'),(4, 'iPad Air M4 11 英寸 256GB 银色', 4799.00, 99, 3, 'Apple', 'M4 芯片，Liquid 视网膜屏，支持 Apple Pencil 二代'),(5, 'iPad Pro 11 英寸 M4 256GB 深空黑', 7999.00, 100, 3, 'Apple', 'M4 芯片，120Hz 自适应高刷，四扬声器，全贴合屏幕'),(6, 'MacBook Neo 13 英寸 A18 Pro 512GB 银', 4599.00, 98, 11, 'Apple', '2026 新款轻薄本，无风扇静音，全天续航，教育优惠'),(7, 'MacBook Air M3 15 英寸 512GB 午夜色', 9299.00, 99, 11, 'Apple', 'M3 芯片，18 小时续航，大屏轻薄，影音创作'),(8, 'AirPods Pro 第三代', 1849.00, 98, 12, 'Apple', '深度主动降噪，空间音频，IP54 防水，无线充电'),(9, 'Apple Watch Series 11 46mm GPS 黑', 3099.00, 99, 9, 'Apple', '全新健康传感器，体温睡眠监测，全天候续航'),(10, '苹果 60W USB-C 快充线', 149.00, 100, 5, 'Apple', '原装 PD 快充，适配 iPhone 全系列'),(11, '苹果原装 MagSafe 手机壳 iPhone17e', 399.00, 100, 5, 'Apple', '磁吸充电，防摔硅胶，官方原配保护壳'),(12, 'iPad mini M4 256GB 星光白', 4199.00, 96, 3, 'Apple', 'M4 芯片，8.3 英寸小平板，便携游戏阅读'),(13, 'Bose QuietComfort Ultra 降噪耳塞', 2299.00, 100, 12, 'Bose', '空间音频，自适应降噪，舒适佩戴久戴不痛'),(14, 'BOW 折叠蓝牙便携键盘', 89.00, 100, 5, 'BOW', '三折叠便携，手机平板通用办公键盘'),(15, 'HKC MG27Q 27 英寸 2K 260Hz 电竞屏', 949.00, 100, 8, 'HKC', '高性价比电竞显示器，FastIPS 面板'),(16, 'OPPO Find X9 Ultra 16+1TB 雾黑', 6299.00, 100, 4, 'OPPO', '哈苏全焦段影像，双潜望长焦，100W 有线 + 50W 无线充'),(17, 'realme GT 8 12+512GB 蓝', 2999.00, 100, 4, 'realme', '骁龙 8 Elite，150W 光速快充，高性价比游戏手机'),(18, 'AOC Q27G3S 27 英寸 2K 240Hz 电竞屏', 1099.00, 100, 8, 'AOC', '高刷电竞面板，低延迟，游戏赛事专用'),(19, '贝尔金雷电 4 拓展坞 7 合 1', 599.00, 100, 10, '贝尔金', '雷电 4 高速传输，4K 双屏输出，办公拓展'),(20, '倍思车载无线手机支架', 79.00, 100, 5, '倍思', '自动感应夹紧，15W 无线快充，汽车导航专用'),(21, '戴尔 XPS13 Plus 2026 i7 512G', 7999.00, 100, 11, '戴尔', '4K OLED 触控，超薄机身，雷电 4 接口，商务办公'),(22, '戴尔 OptiPlex 7020 i7 16G 1TB 台式主机', 5499.00, 100, 1, '戴尔', '商用办公台式机，拓展性强，低噪音稳定运行'),(23, '戴尔 U2724DE 27 英寸 4K 专业显示器', 1749.00, 100, 8, '戴尔', '100% sRGB，硬件低蓝光，升降旋转，设计修图专用'),(24, '大疆 DJI Mini 4 Pro 畅飞套装', 4499.00, 100, 7, '大疆', '249g 轻量化，全向避障，4K HDR 航拍'),(25, '大疆 Air3 双摄航拍无人机标准版', 6999.00, 100, 7, '大疆', '双主摄长焦，长续航，夜景航拍优化'),(26, '大疆 Osmo Mobile 7 手机稳定器', 499.00, 100, 5, '大疆', '手机 vlog 防抖，自动跟拍，短视频拍摄神器'),(27, '杜伽 K620W 三模机械键盘', 699.00, 100, 13, '杜伽', '原厂 PBT 键帽，静音轴，办公码字舒适'),(28, '方正二合一 Win 平板 BSI16E0A 8+128G', 1499.00, 100, 3, '方正', '10.1 英寸触控屏，N5030 处理器，自带 HDMI 拓展'),(29, '飞智八爪鱼 4 无线游戏手柄', 329.00, 100, 5, '飞智', '手机平板电脑通用，原神手游手柄'),(30, '腹灵 F12 三模热插拔机械键盘', 459.00, 100, 13, '腹灵', '全键热插拔，RGB 背光，客制化入门键盘'),(31, '华硕天选 6pro 15.6 i7+RTX4060', 6499.00, 100, 11, '华硕', '240Hz 电竞屏，二次元外观，双风扇游戏本'),(32, '华硕 ROG 创世神 i9+4080 Super', 13299.00, 100, 1, '华硕', 'ROG 水冷机箱，神光同步，专业电竞主机'),(33, '华硕 VG27AQ5A 27 英寸 2K 180Hz 电竞屏', 1299.00, 100, 8, '华硕', 'FastIPS，1ms 响应，Adaptive Sync，游戏显示器'),(34, '华硕无畏 Pro14 2026 i5 轻薄本', 4699.00, 100, 11, '华硕', '2.8K OLED 护眼屏，长效续航商务轻薄本'),(35, '华为 Mate80 Pro 12GB+512GB 曜石黑', 6499.00, 100, 4, '华为', '麒麟 9030，鸿蒙 OS6，双向北斗卫星通信，红枫影像系统'),(36, '华为 Pura90 12+256GB 粉红芭乐', 4499.00, 100, 4, '华为', '6.8 英寸超薄 OLED，6500mAh 电池，100W 快充，前置人像'),(37, '华为 MatePad 14 2026 款 12+256G 星云灰', 3199.00, 100, 3, '华为', '鸿蒙 6，14 英寸 2.8K 护眼屏，星闪手写笔，多设备协同'),(38, '华为 MateBook X Pro 14.2 2026 i7 1TB', 8699.00, 100, 11, '华为', '3.1K 触控屏，鸿蒙多屏协同，轻薄金属机身，长续航'),(39, '华为 MateView GT 34 英寸曲面带鱼屏', 2499.00, 100, 8, '华为', '3440×1440，165Hz，SoundBar 内置音响'),(40, '华为 FreeBuds Pro5', 1249.00, 100, 12, '华为', '智慧降噪 4.0，骨声纹支付，鸿蒙多设备流转'),(41, '华为 Watch GT6 Pro 46mm 钛金属', 2199.00, 100, 9, '华为', '卫星定位，心脏健康监测，两周超长续航'),(42, '华为 100W 氮化镓充电器', 199.00, 100, 5, '华为', '多口快充，手机笔记本通用，便携折叠插脚'),(43, '华为原装 Mate80 Pro 透明手机壳', 89.00, 100, 5, '华为', '高透防黄，轻薄全包，原厂开孔精准'),(44, '华为 FreeClip 开放式耳夹耳机', 899.00, 100, 12, '华为', '开放式不入耳，运动防掉，鸿蒙互联'),(45, '惠普 v222w 64GB 金属 U 盘', 69.00, 100, 2, '惠普', '金属迷你 U 盘，车载办公两用'),(46, '惠普暗影精灵 10 i7+RTX4060 游戏本', 6799.00, 100, 11, '惠普', '16 英寸电竞屏，满血独显，学生游戏本'),(47, '佳能 M50 Mark II 微单相机套机', 4599.00, 100, 6, '佳能', '入门微单，人像美颜，日常拍照 vlog'),(48, '金士顿 XS2000 1TB 移动固态硬盘', 499.00, 100, 2, '金士顿', '高速传输，金属外壳，便携随身存储'),(49, '金运 V20 直播声卡全套设备', 265.00, 100, 5, '金运', '手机电脑通用，K 歌直播降噪声卡套装'),(50, '机械大师笔记本散热支架铝合金', 129.00, 100, 10, '机械大师', '升降调节，镂空散热，保护颈椎'),(51, '机械革命蛟龙 16 Pro R9+4070', 7499.00, 100, 11, '机械革命', '16 英寸 2.5K 高刷屏，AMD 旗舰处理器，高性价比游戏本'),(52, '铠侠 U301 移动固态', 429.00, 100, 2, '铠侠', '原厂颗粒，稳定读写，小巧便携'),(53, '雷蛇毒蝰 V3 Pro 无线电竞鼠标', 999.00, 100, 14, '雷蛇', '超低延迟，8K 回报率，轻量化游戏鼠标'),(54, '雷蛇电竞桌面耳机架 RGB', 159.00, 100, 10, '雷蛇', 'RGB 灯光，USB 拓展，收纳耳机'),(55, '雷蛇北海巨妖 V3 X 头戴游戏耳机', 499.00, 100, 12, '雷蛇', '7.1 环绕声，轻量化头戴，电竞游戏耳机'),(56, '联想小新 Pad Pro 12.7 8+256G 大象灰', 1999.00, 100, 3, '联想', '2.9K 大屏，144Hz，JBL 四扬声器，学生网课平板'),(57, '联想拯救者 Y9000P 2026 i9+RTX4070', 9199.00, 100, 11, '联想', '16 英寸 2.5K 240Hz 电竞屏，满血 4070，霜刃 Pro 散热'),(58, '联想拯救者刃 9000K 2026 i9+4090', 14999.00, 100, 1, '联想', '旗舰游戏主机，水冷散热，4090 独显，4K 游戏渲染'),(59, '罗技 G915 X 无线机械键盘', 1049.00, 100, 13, '罗技', '超薄矮轴，RGB 动态背光，无线蓝牙双模'),(60, '罗技 GPW 四代 狗屁王 4 无线游戏鼠标', 869.00, 100, 14, '罗技', '83g 轻量化，25600DPI，无线快充，电竞旗舰'),(61, '罗技 MX Master 3S 无线办公鼠标', 799.00, 100, 14, '罗技', '人体工学静音，跨设备办公设计鼠标'),(62, '绿联 Type-C 全功能拓展坞 5合 1', 199.00, 100, 10, '绿联', 'HDMI、USB、TF 卡、PD 快充，笔记本拓展'),(63, '绿联 65W 氮化镓三口快充头', 129.00, 100, 10, '绿联', '手机笔记本平板通用，折叠便携多口快充'),(64, '漫步者 NeoBuds Pro3 圈铁降噪耳机', 699.00, 100, 12, '漫步者', '高性价比降噪，Hi-Res 金标，防水防尘'),(65, '漫步者电脑 2.0 桌面音响 R1700BT', 399.00, 100, 12, '漫步者', '蓝牙有线双模式，HiFi 桌面音箱，低音饱满'),(66, '马歇尔 Stanmore III 家用蓝牙音响', 2699.00, 100, 12, '马歇尔', '复古外观，大功率立体声，居家影音'),(67, '明基 PD2706U 27 英寸 4K 专业设计屏', 3299.00, 100, 8, '明基', '校色专业显示器，印刷设计调色专用'),(68, '努比亚 Z80 Ultra 16+1TB 深空黑', 4999.00, 100, 4, '努比亚', '35mm 主摄，屏下摄像，120W 快充游戏手机'),(69, '机械键盘电竞套装 x98 无线', 249.00, 100, 13, '前行者', '键鼠一套，RGB 背光，无线 2.4G 电竞办公套装'),(70, '荣耀 Magic8 Pro 12+512GB 金砂', 5299.00, 100, 4, '荣耀', '鹰眼抓拍，青海湖电池，MagicOS11，AI 智能交互'),(71, '荣耀 MagicPad 13 8+256G 钛金灰', 2499.00, 100, 3, '荣耀', '13 英寸大屏，类纸护眼，MagicOS，搭配智能触控笔'),(72, '荣耀 MagicBook X 14 Pro i5 512G', 4299.00, 100, 11, '荣耀', '14 英寸护眼屏，轻薄便携，多设备互联，学生本'),(73, '荣耀 Watch 5 Pro 幻夜黑', 1299.00, 100, 9, '荣耀', '长续航，跑步骑行专业运动算法'),(74, '三星 Galaxy S26 Ultra 16+1TB 雾黑', 6599.00, 100, 4, '三星', '2 亿像素主摄，Spen 手写笔，2K 高刷屏'),(75, '三星 T7 1TB 高速移动固态', 549.00, 100, 2, '三星', '金属防滑外壳，高速读写，便携随身'),(76, '森海塞尔 HD400Pro 头戴监听耳机', 1499.00, 100, 12, '森海塞尔', '专业录音监听，高保真原声，混音专用'),(77, '闪迪至尊超极速 2TB Type-C 移动固态', 619.00, 100, 2, '闪迪', '2000MB/s 读写，三防抗压，手机电脑双兼容'),(78, '闪迪 64GB 高速 Type-C 双接口 U 盘', 89.00, 100, 2, '闪迪', '手机电脑两用，USB3.2 高速读写'),(79, '索尼 WF-1000XM6 无线降噪耳机', 1699.00, 100, 12, '索尼', '行业顶级降噪，LDAC 高清音频，36 小时总续航'),(80, '索尼 ZV-E10 全画幅 vlog 相机', 8299.00, 100, 6, '索尼', '视频专用机身，自动对焦，直播短视频神器'),(81, '向日葵远程控制硬件开机插座', 129.00, 100, 10, '向日葵', '远程开机电脑，异地办公运维工具'),(82, '小米 17 Ultra 16GB+1TB 玄黑', 6399.00, 100, 4, '小米', '骁龙 8 Elite Gen1，徕卡影像，2K LTPO 曲面屏，澎湃 OS'),(83, '红米 K80 Ultra 16+1TB 暗影黑', 3299.00, 100, 4, '小米', '骁龙 8 Elite，2K 高刷屏，5500mAh 大电池，性价比旗舰'),(84, '小米平板 7 Pro 12.4 英寸 12+256G 深空灰', 2699.00, 100, 3, '小米', '澎湃 OS，144Hz 高刷屏，8 扬声器，办公学习两用'),(85, '小米 Book Pro 14 i7 1TB 2026 款', 6299.00, 100, 11, '小米', '3.2K 120Hz 原色屏，澎湃互联，全金属机身'),(86, '小米 27 英寸 4K MiniLED 显示器', 1599.00, 100, 8, '小米', 'MiniLED 分区调光，高色准，Type-C 一线通'),(87, '小米无线双模机械键盘 TKL 茶轴', 349.00, 100, 13, '小米', '87 键紧凑布局，2.4G + 蓝牙双连接'),(88, '小米无线办公静音鼠标 2', 79.00, 100, 14, '小米', '静音按键，2.4G 无线，长续航办公鼠标'),(89, '小米 Watch S5 Pro 钛金属版', 1499.00, 100, 9, '小米', '血氧心率监测，独立 eSIM，户外运动模式'),(90, '小米磁吸无线充电宝 10000mAh', 169.00, 100, 5, '小米', 'MagSafe 磁吸，20W 无线快充，轻薄随身'),(91, '小米 Watch5 大屏智能手环', 349.00, 100, 9, '小米', '轻薄大屏，睡眠血氧监测，长续航手环'),(92, '西部数据 My Passport 4TB 移动硬盘', 729.00, 100, 2, '西数', '2.5 英寸机械移动硬盘，大容量存储备份'),(93, '英菲克 PM6 无线可充电鼠标', 59.00, 100, 14, '英菲克', '人体工学，充电款，笔记本台式通用'),(94, '影石 Insta360 X4 全景运动相机', 3299.00, 100, 6, '影石', '8K 全景拍摄，防抖防水，骑行 vlog 专用'),(95, '影石 Flow 2 手持云台相机', 2499.00, 100, 6, '影石', '一体化 vlog 相机，自带防抖，便携随身拍'),(96, '樱桃 MX8.0 青轴有线机械键盘', 1299.00, 100, 13, '樱桃', '铝合金外壳，原厂樱桃轴，电竞办公通用'),(97, '一加 14 12+512GB 青釉', 4299.00, 100, 4, '一加', '第二代哈苏影像，120Hz 直屏，100W 快充，轻薄金属机身'),(98, '一加平板 3Pro 12.1 英寸 12+256G', 4399.00, 100, 3, '一加', '120Hz 原色屏，哈曼卡顿调音，多屏互联'),(99, '一加磁吸无线充电器 50W', 179.00, 100, 5, '一加', '适配一加全系旗舰，低温快充不发烫'),(100, '优篮子 CR3 三合一高速读卡器', 78.00, 100, 10, '优篮子', 'SD/TF 卡通用，USB3.0 高速读取相机素材');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`product_image` WRITE;
DELETE FROM `digital_device_store`.`product_image`;
INSERT INTO `digital_device_store`.`product_image` (`id`,`product_id`,`url`) VALUES (1, 1, '/images/VivoX200Pro_front.jpg'),(2, 1, '/images/VivoX200Pro_left.jpg'),(3, 1, '/images/VivoX200Pro_back.jpg'),(4, 2, '/images/iPhone17pm_front.jpg'),(5, 2, '/images/iPhone17pm_left.jpg'),(6, 3, '/images/iPhone17_front.jpg'),(7, 3, '/images/iPhone17_left.jpg'),(8, 4, '/images/iPadAirM4_front.jpg'),(9, 4, '/images/iPadAirM4_left.jpg'),(10, 4, '/images/iPadAirM4_back.jpg'),(11, 5, '/images/iPadPro11M4_front.jpg'),(12, 5, '/images/iPadPro11M4_left.jpg'),(13, 5, '/images/iPadPro11M4_back.jpg'),(14, 6, '/images/MacBookNeo13_front.jpg'),(15, 6, '/images/MacBookNeo13_left.jpg'),(16, 6, '/images/MacBookNeo13_back.jpg'),(17, 7, '/images/MacBookAirM3_15_front.jpg'),(18, 7, '/images/MacBookAirM3_15_left.jpg'),(19, 7, '/images/MacBookAirM3_15_back.jpg'),(20, 8, '/images/AirPodsPro2_inside.jpg'),(21, 8, '/images/AirPodsPro2_outside.jpg'),(22, 9, '/images/WatchS11_46_front.jpg'),(23, 9, '/images/WatchS11_46_left.jpg'),(24, 10, '/images/Apple20WCharger_front.jpg'),(25, 10, '/images/Apple20WCharger_left.jpg'),(26, 11, '/images/iPhone17pmCase_front.jpg'),(27, 11, '/images/iPhone17pmCase_left.jpg'),(28, 12, '/images/iPadMiniM4_front.jpg'),(29, 12, '/images/iPadMiniM4_left.jpg'),(30, 12, '/images/iPadMiniM4_back.jpg'),(31, 13, '/images/QCUltra_inside.jpg'),(32, 13, '/images/QCUltra_outside.jpg'),(33, 14, '/images/BOWFoldKeyboard_front.jpg'),(34, 14, '/images/BOWFoldKeyboard_left.jpg'),(35, 14, '/images/BOWFoldKeyboard_back.jpg'),(36, 15, '/images/MG27Q_front.jpg'),(37, 15, '/images/MG27Q_left.jpg'),(38, 15, '/images/MG27Q_back.jpg'),(39, 16, '/images/OppoFindX9Ultra_front.jpg'),(40, 16, '/images/OppoFindX9Ultra_left.jpg'),(41, 17, '/images/GTNeo7_front.jpg'),(42, 17, '/images/GTNeo7_left.jpg'),(43, 18, '/images/Q27G3S_front.jpg'),(44, 18, '/images/Q27G3S_left.jpg'),(45, 18, '/images/Q27G3S_back.jpg'),(46, 19, '/images/BelkinTB4Dock_front.jpg'),(47, 19, '/images/BelkinTB4Dock_left.jpg'),(48, 20, '/images/BaseusCarHolder_front.jpg'),(49, 20, '/images/BaseusCarHolder_left.jpg'),(50, 21, '/images/XPS13Plus2026_front.jpg'),(51, 21, '/images/XPS13Plus2026_left.jpg'),(52, 21, '/images/XPS13Plus2026_back.jpg'),(53, 22, '/images/OptiPlex7020_front.jpg'),(54, 22, '/images/OptiPlex7020_left.jpg'),(55, 22, '/images/OptiPlex7020_back.jpg'),(56, 23, '/images/U2724DE_front.jpg'),(57, 23, '/images/U2724DE_left.jpg'),(58, 24, '/images/Mini4Pro_front.jpg'),(59, 24, '/images/Mini4Pro_back.jpg'),(60, 25, '/images/Air3S_front.jpg'),(61, 25, '/images/Air3S_left.jpg'),(62, 26, '/images/OsmoMobile7_front.jpg'),(63, 26, '/images/OsmoMobile7_back.jpg'),(64, 27, '/images/K610W_front.jpg'),(65, 27, '/images/K610W_left.jpg'),(66, 28, '/images/FounderBSI16E0A_front.jpg'),(67, 28, '/images/FounderBSI16E0A_left.jpg'),(68, 29, '/images/Octopus4Controller_front.jpg'),(69, 29, '/images/Octopus4Controller_left.jpg'),(70, 30, '/images/F12Keyboard_front.jpg'),(71, 30, '/images/F12Keyboard_left.jpg'),(72, 31, '/images/TianXuan6_front.jpg'),(73, 31, '/images/TianXuan6_left.jpg'),(74, 31, '/images/TianXuan6_back.jpg'),(75, 32, '/images/ROGGenesis_front.jpg'),(76, 32, '/images/ROGGenesis_left.jpg'),(77, 33, '/images/VG27AQ3A_front.jpg'),(78, 33, '/images/VG27AQ3A_left.jpg'),(79, 34, '/images/WuyuePro14_front.jpg'),(80, 34, '/images/WuyuePro14_back.jpg'),(81, 35, '/images/Mate80Pro_front.jpg'),(82, 35, '/images/Mate80Pro_left.jpg'),(83, 36, '/images/HuaweiPura90_front.jpg'),(84, 36, '/images/HuaweiPura90_left.jpg'),(85, 37, '/images/MatePad14_2026_front.jpg'),(86, 37, '/images/MatePad14_2026_left.jpg'),(87, 37, '/images/MatePad14_2026_back.jpg'),(88, 38, '/images/MateBookXPro142_front.jpg'),(89, 38, '/images/MateBookXPro142_left.jpg'),(90, 39, '/images/MateViewGT34_front.jpg'),(91, 39, '/images/MateViewGT34_left.jpg'),(92, 40, '/images/FreeBudsPro4Plus_front.jpg'),(93, 40, '/images/FreeBudsPro4Plus_left.jpg'),(94, 41, '/images/WatchGT5Pro_front.jpg'),(95, 41, '/images/WatchGT5Pro_left.jpg'),(96, 42, '/images/Huawei100WGallium_front.jpg'),(97, 42, '/images/Huawei100WGallium_left.jpg'),(98, 43, '/images/Mate80ProCase_front.jpg'),(99, 43, '/images/Mate80ProCase_left.jpg'),(100, 44, '/images/FreeClip_front.jpg'),(101, 44, '/images/FreeClip_left.jpg'),(102, 45, '/images/V222W64G_front.jpg'),(103, 45, '/images/V222W64G_left.jpg'),(104, 45, '/images/V222W64G_back.jpg'),(105, 46, '/images/ShadowElf10_front.jpg'),(106, 46, '/images/ShadowElf10_left.jpg'),(107, 47, '/images/M50Mark2_front.jpg'),(108, 47, '/images/M50Mark2_back.jpg'),(109, 48, '/images/XS2000_1T_front.jpg'),(110, 48, '/images/XS2000_1T_left.jpg'),(111, 49, '/images/JinYunV20SoundCard_front.jpg'),(112, 49, '/images/JinYunV20SoundCard_left.jpg'),(113, 50, '/images/CoolStandAlu_front.jpg'),(114, 50, '/images/CoolStandAlu_left.jpg'),(115, 51, '/images/Jiaolong16Pro_front.jpg'),(116, 51, '/images/Jiaolong16Pro_back.jpg'),(117, 52, '/images/KioxiaU301_front.jpg'),(118, 52, '/images/KioxiaU301_left.jpg'),(119, 53, '/images/ViperV3Pro_front.jpg'),(120, 53, '/images/ViperV3Pro_left.jpg'),(121, 53, '/images/ViperV3Pro_back.jpg'),(122, 54, '/images/RazerHeadsetStand_front.jpg'),(123, 54, '/images/RazerHeadsetStand_left.jpg'),(124, 54, '/images/RazerHeadsetStand_back.jpg'),(125, 55, '/images/KrakenV4X_front.jpg'),(126, 55, '/images/KrakenV4X_left.jpg'),(127, 55, '/images/KrakenV4X_back.jpg'),(128, 56, '/images/LenovoPadPro127_front.jpg'),(129, 56, '/images/LenovoPadPro127_left.jpg'),(130, 56, '/images/LenovoPadPro127_back.jpg'),(131, 57, '/images/Y9000P2026_front.jpg'),(132, 57, '/images/Y9000P2026_left.jpg'),(133, 57, '/images/Y9000P2026_back.jpg'),(134, 58, '/images/Ren9000K2026_front.jpg'),(135, 58, '/images/Ren9000K2026_left.jpg'),(136, 58, '/images/Ren9000K2026_back.jpg'),(137, 59, '/images/G915X_front.jpg'),(138, 59, '/images/G915X_left.jpg'),(139, 59, '/images/G915X_back.jpg'),(140, 60, '/images/GPW4_front.jpg'),(141, 60, '/images/GPW4_left.jpg'),(142, 60, '/images/GPW4_back.jpg'),(143, 61, '/images/MXMaster3S_front.jpg'),(144, 61, '/images/MXMaster3S_left.jpg'),(145, 61, '/images/MXMaster3S_back.jpg'),(146, 62, '/images/Ugreen8in1Dock_front.jpg'),(147, 62, '/images/Ugreen8in1Dock_left.jpg'),(148, 62, '/images/Ugreen8in1Dock_back.jpg'),(149, 63, '/images/Ugreen65WGallium_front.jpg'),(150, 63, '/images/Ugreen65WGallium_left.jpg'),(151, 63, '/images/Ugreen65WGallium_back.jpg'),(152, 64, '/images/NeoBudsPro3_front.jpg'),(153, 64, '/images/NeoBudsPro3_left.jpg'),(154, 64, '/images/NeoBudsPro3_back.jpg'),(155, 65, '/images/R1700BTSpeaker_front.jpg'),(156, 65, '/images/R1700BTSpeaker_left.jpg'),(157, 65, '/images/R1700BTSpeaker_back.jpg'),(158, 66, '/images/Stanmore3_front.jpg'),(159, 66, '/images/Stanmore3_left.jpg'),(160, 66, '/images/Stanmore3_back.jpg'),(161, 67, '/images/PD2706U_front.jpg'),(162, 67, '/images/PD2706U_left.jpg'),(163, 67, '/images/PD2706U_back.jpg'),(164, 68, '/images/Z80Ultra_front.jpg'),(165, 68, '/images/Z80Ultra_left.jpg'),(166, 68, '/images/Z80Ultra_back.jpg'),(167, 69, '/images/KBMSCombo_front.jpg'),(168, 69, '/images/KBMSCombo_left.jpg'),(169, 69, '/images/KBMSCombo_back.jpg'),(170, 70, '/images/HonorMagic8Pro_front.jpg'),(171, 70, '/images/HonorMagic8Pro_left.jpg'),(172, 70, '/images/HonorMagic8Pro_back.jpg'),(173, 71, '/images/HonorMagicPad13_front.jpg'),(174, 71, '/images/HonorMagicPad13_left.jpg'),(175, 71, '/images/HonorMagicPad13_back.jpg'),(176, 72, '/images/MagicBookX14Pro_front.jpg'),(177, 72, '/images/MagicBookX14Pro_left.jpg'),(178, 72, '/images/MagicBookX14Pro_back.jpg'),(179, 73, '/images/Watch5Pro_front.jpg'),(180, 73, '/images/Watch5Pro_left.jpg'),(181, 73, '/images/Watch5Pro_back.jpg'),(182, 74, '/images/S26Ultra_front.jpg'),(183, 74, '/images/S26Ultra_left.jpg'),(184, 74, '/images/S26Ultra_back.jpg'),(185, 75, '/images/T7_1T_front.jpg'),(186, 75, '/images/T7_1T_left.jpg'),(187, 75, '/images/T7_1T_back.jpg'),(188, 76, '/images/HD400Pro_front.jpg'),(189, 76, '/images/HD400Pro_left.jpg'),(190, 76, '/images/HD400Pro_back.jpg'),(191, 77, '/images/Sandisk2TSSD_front.jpg'),(192, 77, '/images/Sandisk2TSSD_left.jpg'),(193, 77, '/images/Sandisk2TSSD_back.jpg'),(194, 78, '/images/Sandisk64GTypeCUdisk_front.jpg'),(195, 78, '/images/Sandisk64GTypeCUdisk_left.jpg'),(196, 78, '/images/Sandisk64GTypeCUdisk_back.jpg'),(197, 79, '/images/WF1000XM6_front.jpg'),(198, 79, '/images/WF1000XM6_left.jpg'),(199, 79, '/images/WF1000XM6_back.jpg'),(200, 80, '/images/ZVE1_front.jpg'),(201, 80, '/images/ZVE1_left.jpg'),(202, 80, '/images/ZVE1_back.jpg'),(203, 81, '/images/SunflowerWakeDongle_front.jpg'),(204, 81, '/images/SunflowerWakeDongle_left.jpg'),(205, 81, '/images/SunflowerWakeDongle_back.jpg'),(206, 82, '/images/Mi17Ultra_front.jpg'),(207, 82, '/images/Mi17Ultra_left.jpg'),(208, 82, '/images/Mi17Ultra_back.jpg'),(209, 83, '/images/RedmiK80Ultra_front.jpg'),(210, 83, '/images/RedmiK80Ultra_left.jpg'),(211, 83, '/images/RedmiK80Ultra_back.jpg'),(212, 84, '/images/MiPad7Pro_front.jpg'),(213, 84, '/images/MiPad7Pro_left.jpg'),(214, 84, '/images/MiPad7Pro_back.jpg'),(215, 85, '/images/MiBookPro16_front.jpg'),(216, 85, '/images/MiBookPro16_left.jpg'),(217, 85, '/images/MiBookPro16_back.jpg'),(218, 86, '/images/MiMonitor274K_front.jpg'),(219, 86, '/images/MiMonitor274K_left.jpg'),(220, 86, '/images/MiMonitor274K_back.jpg'),(221, 87, '/images/MiTKLKeyboard_front.jpg'),(222, 87, '/images/MiTKLKeyboard_left.jpg'),(223, 87, '/images/MiTKLKeyboard_back.jpg'),(224, 88, '/images/MiSilentMouse2_front.jpg'),(225, 88, '/images/MiSilentMouse2_left.jpg'),(226, 88, '/images/MiSilentMouse2_back.jpg'),(227, 89, '/images/WatchS5Pro_front.jpg'),(228, 89, '/images/WatchS5Pro_left.jpg'),(229, 89, '/images/WatchS5Pro_back.jpg'),(230, 90, '/images/MiMagPowerBank_front.jpg'),(231, 90, '/images/MiMagPowerBank_left.jpg'),(232, 90, '/images/MiMagPowerBank_back.jpg'),(233, 91, '/images/WatchFit4_front.jpg'),(234, 91, '/images/WatchFit4_left.jpg'),(235, 91, '/images/WatchFit4_back.jpg'),(236, 92, '/images/WD4TMyPassport_front.jpg'),(237, 92, '/images/WD4TMyPassport_left.jpg'),(238, 92, '/images/WD4TMyPassport_back.jpg'),(239, 93, '/images/PM6Mouse_front.jpg'),(240, 93, '/images/PM6Mouse_left.jpg'),(241, 93, '/images/PM6Mouse_back.jpg'),(242, 94, '/images/Insta360X4_front.jpg'),(243, 94, '/images/Insta360X4_left.jpg'),(244, 94, '/images/Insta360X4_back.jpg'),(245, 95, '/images/Flow2Camera_front.jpg'),(246, 95, '/images/Flow2Camera_left.jpg'),(247, 95, '/images/Flow2Camera_back.jpg'),(248, 96, '/images/MX80_front.jpg'),(249, 96, '/images/MX80_left.jpg'),(250, 96, '/images/MX80_back.jpg'),(251, 97, '/images/OnePlus14_front.jpg'),(252, 97, '/images/OnePlus14_left.jpg'),(253, 97, '/images/OnePlus14_back.jpg'),(254, 98, '/images/OnePlusPadPro_front.jpg'),(255, 98, '/images/OnePlusPadPro_left.jpg'),(256, 98, '/images/OnePlusPadPro_back.jpg'),(257, 99, '/images/OnePlus50WMagCharger_front.jpg'),(258, 99, '/images/OnePlus50WMagCharger_left.jpg'),(259, 99, '/images/OnePlus50WMagCharger_back.jpg'),(260, 100, '/images/CR3Reader_front.jpg'),(261, 100, '/images/CR3Reader_left.jpg'),(262, 100, '/images/CR3Reader_back.jpg'),(263, 55, '/images/KrakenV3X_front.jpg'),(264, 55, '/images/KrakenV3X_left.jpg'),(265, 80, '/images/ZVE10_front.jpg'),(266, 80, '/images/ZVE10_left.jpg'),(267, 85, '/images/MiBookPro14_front.jpg'),(268, 85, '/images/MiBookPro14_left.jpg'),(269, 91, '/images/Watch5_front.jpg'),(270, 91, '/images/Watch5_left.jpg'),(271, 91, '/images/Watch5_back.jpg');
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`review` WRITE;
DELETE FROM `digital_device_store`.`review`;
UNLOCK TABLES;
COMMIT;
BEGIN;
LOCK TABLES `digital_device_store`.`user` WRITE;
DELETE FROM `digital_device_store`.`user`;
INSERT INTO `digital_device_store`.`user` (`id`,`username`,`password`,`phone`,`email`,`role`) VALUES (1, 'admin', '$2a$10$SLxVRr3JoQgGNCAcH5PkLuJfGbjbeTEAIGgof61fDMC9aYybHdBWG', '13800000000', 'admin@store.com', 1),(2, 'zhangsan', '$2a$10$orKwO8IW1LHS8/LD0/Nr0.VPyxD1ppVZCoOSZZNs1kLYKy0CX67fm', '13811112222', 'zhangsan@qq.com', 0),(3, 'pig', '$2a$10$j/YffU9I4qDTY2nQU.Whfu/FD3wLby4nkOqSOMbLBkhUQl4TpG672', '13843838438', '13380481294@163.com', 0);
UNLOCK TABLES;
COMMIT;
