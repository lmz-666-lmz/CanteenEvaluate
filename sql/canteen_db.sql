-- ============================================================
-- 山海寻味录 / CanteenEvaluate
-- Database Initialization Script
-- MySQL 8.0+  |  Character Set: utf8mb4
-- ============================================================
-- Usage:
--   mysql -u root -p < sql/canteen_db.sql
--   Or execute this file directly in DBeaver / Navicat / MySQL Workbench
-- ============================================================

-- 1. Create Database
CREATE DATABASE IF NOT EXISTS canteen_db
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE canteen_db;

-- ============================================================
-- 2. Tables
-- ============================================================

-- 2.1 用户表
CREATE TABLE IF NOT EXISTS users (
    id          INT           PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)   NOT NULL UNIQUE,
    password    VARCHAR(255)  NOT NULL,
    nickname    VARCHAR(50),
    role        INT           DEFAULT 0       COMMENT '0=普通用户 1=管理员',
    avatar      VARCHAR(255),
    create_time TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.2 餐厅表（v1.1 档案增强）
CREATE TABLE IF NOT EXISTS restaurants (
    id          INT           PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(100)  NOT NULL,
    location    VARCHAR(120)  NULL     COMMENT '餐厅位置',
    open_time   VARCHAR(120)  NULL     COMMENT '营业时间',
    tags        VARCHAR(255)  NULL     COMMENT '标签，英文逗号分隔',
    description VARCHAR(500)  NULL     COMMENT '餐厅简介',
    avg_cost    DECIMAL(8,2)  DEFAULT 15.00 COMMENT '人均价格',
    status      TINYINT       DEFAULT 1 COMMENT '1=营业中 0=暂停营业',
    cover_color VARCHAR(30)   DEFAULT '#7C3AED' COMMENT '卡片主题色'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.3 评价表
CREATE TABLE IF NOT EXISTS evaluations (
    id             INT           PRIMARY KEY AUTO_INCREMENT,
    user_id        INT           NOT NULL,
    restaurant_id  INT           NOT NULL,
    dish_name      VARCHAR(100),
    content        TEXT,
    taste_score    INT           DEFAULT 0,
    price_score    INT           DEFAULT 0,
    service_score  INT           DEFAULT 0,
    like_count     INT           DEFAULT 0,
    update_time    TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)       REFERENCES users(id)       ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.4 公告表
CREATE TABLE IF NOT EXISTS announcements (
    id          INT           PRIMARY KEY AUTO_INCREMENT,
    title       VARCHAR(200)  NOT NULL,
    content     TEXT,
    is_active   TINYINT       DEFAULT 1       COMMENT '1=显示 0=隐藏',
    sort_order  INT           DEFAULT 0,
    create_time TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    update_time TIMESTAMP     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.5 想吃清单表
CREATE TABLE IF NOT EXISTS wish_items (
    id              INT           PRIMARY KEY AUTO_INCREMENT,
    user_id         INT           NOT NULL,
    restaurant_id   INT,
    dish_name       VARCHAR(100),
    note            VARCHAR(255),
    status          INT           DEFAULT 0       COMMENT '0=待打卡 1=已完成',
    create_time     TIMESTAMP     DEFAULT CURRENT_TIMESTAMP,
    finish_time     TIMESTAMP     NULL,
    FOREIGN KEY (user_id)       REFERENCES users(id)       ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.6 系统操作日志表
CREATE TABLE IF NOT EXISTS sys_logs (
    id            INT           PRIMARY KEY AUTO_INCREMENT,
    username      VARCHAR(50),
    action_type   VARCHAR(100),
    action_detail TEXT,
    create_time   TIMESTAMP     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2.7 系统配置表（运行时配置，无需重启）
CREATE TABLE IF NOT EXISTS system_config (
    config_key   VARCHAR(100) PRIMARY KEY,
    config_value TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3. 幂等迁移：兼容 v1.0 → v1.1 升级
--    如果是从 v1.0 升级，restaurants 表已存在但缺少下列字段，
--    这些 ALTER 语句会自动补全。新数据库跳过（字段已存在）。
-- ============================================================

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

-- ============================================================
-- 4. Seed Data (Optional, idempotent via INSERT IGNORE / UPDATE)
-- ============================================================

-- 默认管理员账户（密码为 "admin123"，使用 PBKDF2 哈希）
-- 首次登录后请立即修改密码！
INSERT IGNORE INTO users (username, password, nickname, role) VALUES
('admin', '1000:382a4e4f4b434e5fbb18e0efdbb6219d0a49a13f4f50836e:ddad8f47d0f9dc3e20819bb6c9c5f5a4aed5a7bd50e20e33b1c7ba96aae3a2bf', '系统管理员', 1);

-- 示例餐厅数据（含 v1.1 档案字段）
INSERT IGNORE INTO restaurants (id, name, location, open_time, tags, description, avg_cost, status, cover_color) VALUES
(1, '北门食堂', '校园北侧 · 生活区入口', '06:30-21:00', '早餐,性价比,家常', '主营早餐与家常小炒，窗口多、出餐快，适合日常用餐。', 12.00, 1, '#6366F1'),
(2, '南苑餐厅', '校园南侧 · 宿舍区旁', '07:00-20:30', '清淡,性价比,午餐', '南苑风味窗口集中，素菜与套餐选择丰富，环境整洁。', 14.00, 1, '#10B981'),
(3, '西区美食广场', '西区综合楼一层', '10:00-22:00', '夜宵,麻辣,热门', '美食广场档口林立，涵盖面食、烧烤与特色小吃，晚间人气旺。', 18.00, 1, '#F59E0B'),
(4, '东苑食堂', '东苑生活区中心', '06:30-20:00', '早餐,清淡,快捷', '靠近教学楼，早餐与简餐方便，适合课间快速就餐。', 13.00, 1, '#8B5CF6'),
(5, '教工餐厅', '行政楼附近', '11:00-13:30, 17:00-19:00', '精品,服务,午餐', '教工餐厅也对学生开放，菜品精致、服务规范，适合小型聚餐。', 22.00, 1, '#EC4899');

-- v1.1 餐厅档案示例数据（按名称更新，幂等）
-- 如果 INSERT IGNORE 已经插入了新行，下面 UPDATE 更新为完整档案；
-- 如果是从 v1.0 升级且数据已存在，则补齐档案字段
UPDATE restaurants SET location = '校园北侧 · 生活区入口', open_time = '06:30-21:00', tags = '早餐,性价比,家常', description = '主营早餐与家常小炒，窗口多、出餐快，适合日常用餐。', avg_cost = 12.00, status = 1, cover_color = '#6366F1' WHERE name = '北门食堂';
UPDATE restaurants SET location = '校园南侧 · 宿舍区旁',   open_time = '07:00-20:30', tags = '清淡,性价比,午餐', description = '南苑风味窗口集中，素菜与套餐选择丰富，环境整洁。',     avg_cost = 14.00, status = 1, cover_color = '#10B981' WHERE name = '南苑餐厅';
UPDATE restaurants SET location = '西区综合楼一层',         open_time = '10:00-22:00', tags = '夜宵,麻辣,热门', description = '美食广场档口林立，涵盖面食、烧烤与特色小吃，晚间人气旺。', avg_cost = 18.00, status = 1, cover_color = '#F59E0B' WHERE name = '西区美食广场';
UPDATE restaurants SET location = '东苑生活区中心',         open_time = '06:30-20:00', tags = '早餐,清淡,快捷', description = '靠近教学楼，早餐与简餐方便，适合课间快速就餐。',         avg_cost = 13.00, status = 1, cover_color = '#8B5CF6' WHERE name = '东苑食堂';
UPDATE restaurants SET location = '行政楼附近',             open_time = '11:00-13:30, 17:00-19:00', tags = '精品,服务,午餐', description = '教工餐厅也对学生开放，菜品精致、服务规范，适合小型聚餐。', avg_cost = 22.00, status = 1, cover_color = '#EC4899' WHERE name = '教工餐厅';
