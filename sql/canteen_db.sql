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

-- 2.2 餐厅表
CREATE TABLE IF NOT EXISTS restaurants (
    id   INT          PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
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
-- 3. Seed Data (Optional)
-- ============================================================

-- 默认管理员账户（密码为 "admin123"，使用 PBKDF2 哈希）
-- 首次登录后请立即修改密码！
INSERT IGNORE INTO users (username, password, nickname, role) VALUES
('admin', '1000:382a4e4f4b434e5fbb18e0efdbb6219d0a49a13f4f50836e:ddad8f47d0f9dc3e20819bb6c9c5f5a4aed5a7bd50e20e33b1c7ba96aae3a2bf', '系统管理员', 1);

-- 示例餐厅数据
INSERT IGNORE INTO restaurants (name) VALUES
('北门食堂'),
('南苑餐厅'),
('西区美食广场'),
('东苑食堂'),
('教工餐厅');
