-- ============================================================
-- 一次性索引迁移脚本（手动执行，切勿放入自动运行的 schema.sql）
-- 目标库：digital_device_store    适用：MySQL 8.x
-- 执行：  mysql -uroot -proot digital_device_store < sql/add_indexes.sql
--
-- 说明：MySQL 的 ADD INDEX / CREATE INDEX 不支持 IF NOT EXISTS，
--       本脚本按「只跑一次」设计；若重复执行会因索引已存在而报错，属正常现象。
-- ============================================================

-- 1) 订单表：用 (user_id, created_time) 复合索引一并覆盖
--    OrderServiceImpl.listByUser 的「WHERE user_id=? ORDER BY created_time DESC」，
--    避免 filesort；并新增 (created_time) 服务管理端 pageAll 的「ORDER BY created_time DESC」分页。
--    复合索引首列即 user_id，仍满足外键 fk_order_user，故可安全删除冗余的旧单列索引 idx_user_id。
ALTER TABLE `order`
    ADD INDEX `idx_order_user_created` (`user_id`, `created_time`),
    ADD INDEX `idx_order_created_time` (`created_time`),
    DROP INDEX `idx_user_id`;

-- 2) 商品表：商品名称全文索引（ngram 分词，支持中英文子串检索）
--    必须配合 ProductServiceImpl 改用 MATCH(name) AGAINST(... IN BOOLEAN MODE)，
--    否则该索引不会被使用；且代码改动后，若没有此索引，搜索接口会直接报错。
ALTER TABLE `product`
    ADD FULLTEXT INDEX `ft_product_name` (`name`) WITH PARSER ngram;

-- ------------------------------------------------------------
-- 验证（执行后可手动检查）：
-- SHOW INDEX FROM `order`;
-- SHOW INDEX FROM `product`;
-- EXPLAIN SELECT * FROM `order` WHERE user_id = 1 ORDER BY created_time DESC LIMIT 10;
-- EXPLAIN SELECT * FROM `product` WHERE MATCH(`name`) AGAINST('"iPhone"' IN BOOLEAN MODE);
-- ------------------------------------------------------------
