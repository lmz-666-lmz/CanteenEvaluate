-- ============================================================
-- 山海寻味录 v1.1 — 餐厅档案字段迁移
-- 适用：已执行过 v1.0 sql/canteen_db.sql 的现有数据库
-- 可重复执行：通过 information_schema 判断字段是否已存在
-- ============================================================
-- 用法：
--   mysql -u root -p canteen_db < sql/migrations/v1.1_add_restaurant_profile.sql
-- ============================================================

USE canteen_db;

-- ---------- 新增字段（幂等） ----------

SET @db = DATABASE();

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'location') = 0,
    'ALTER TABLE restaurants ADD COLUMN location VARCHAR(120) NULL COMMENT ''餐厅位置''',
    'SELECT ''location already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'open_time') = 0,
    'ALTER TABLE restaurants ADD COLUMN open_time VARCHAR(120) NULL COMMENT ''营业时间''',
    'SELECT ''open_time already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'tags') = 0,
    'ALTER TABLE restaurants ADD COLUMN tags VARCHAR(255) NULL COMMENT ''标签，英文逗号分隔''',
    'SELECT ''tags already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'description') = 0,
    'ALTER TABLE restaurants ADD COLUMN description VARCHAR(500) NULL COMMENT ''餐厅简介''',
    'SELECT ''description already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'avg_cost') = 0,
    'ALTER TABLE restaurants ADD COLUMN avg_cost DECIMAL(8,2) DEFAULT 15.00 COMMENT ''人均价格''',
    'SELECT ''avg_cost already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'status') = 0,
    'ALTER TABLE restaurants ADD COLUMN status TINYINT DEFAULT 1 COMMENT ''1=营业中 0=暂停营业''',
    'SELECT ''status already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = IF(
    (SELECT COUNT(*) FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = @db AND TABLE_NAME = 'restaurants' AND COLUMN_NAME = 'cover_color') = 0,
    'ALTER TABLE restaurants ADD COLUMN cover_color VARCHAR(30) DEFAULT ''#7C3AED'' COMMENT ''卡片主题色''',
    'SELECT ''cover_color already exists'' AS msg'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ---------- 示例餐厅档案数据（按名称更新，可重复执行） ----------

UPDATE restaurants SET
    location = '校园北侧 · 生活区入口',
    open_time = '06:30-21:00',
    tags = '早餐,性价比,家常',
    description = '主营早餐与家常小炒，窗口多、出餐快，适合日常用餐。',
    avg_cost = 12.00,
    status = 1,
    cover_color = '#6366F1'
WHERE name = '北门食堂';

UPDATE restaurants SET
    location = '校园南侧 · 宿舍区旁',
    open_time = '07:00-20:30',
    tags = '清淡,性价比,午餐',
    description = '南苑风味窗口集中，素菜与套餐选择丰富，环境整洁。',
    avg_cost = 14.00,
    status = 1,
    cover_color = '#10B981'
WHERE name = '南苑餐厅';

UPDATE restaurants SET
    location = '西区综合楼一层',
    open_time = '10:00-22:00',
    tags = '夜宵,麻辣,热门',
    description = '美食广场档口林立，涵盖面食、烧烤与特色小吃，晚间人气旺。',
    avg_cost = 18.00,
    status = 1,
    cover_color = '#F59E0B'
WHERE name = '西区美食广场';

UPDATE restaurants SET
    location = '东苑生活区中心',
    open_time = '06:30-20:00',
    tags = '早餐,清淡,快捷',
    description = '靠近教学楼，早餐与简餐方便，适合课间快速就餐。',
    avg_cost = 13.00,
    status = 1,
    cover_color = '#8B5CF6'
WHERE name = '东苑食堂';

UPDATE restaurants SET
    location = '行政楼附近',
    open_time = '11:00-13:30, 17:00-19:00',
    tags = '精品,服务,午餐',
    description = '教工餐厅也对学生开放，菜品精致、服务规范，适合小型聚餐。',
    avg_cost = 22.00,
    status = 1,
    cover_color = '#EC4899'
WHERE name = '教工餐厅';
