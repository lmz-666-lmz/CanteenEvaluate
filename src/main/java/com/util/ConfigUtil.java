package com.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * 系统配置工具类
 * 从 classpath:db.properties 读取数据库配置，支持外部化配置
 */
public class ConfigUtil {

    private static final Properties props = new Properties();

    static {
        try (InputStream in = ConfigUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                props.load(in);
            } else {
                // 回退到硬编码默认值（开发环境兼容）
                props.setProperty("db.driver", "com.mysql.cj.jdbc.Driver");
                props.setProperty("db.url", "jdbc:mysql://localhost:3306/canteen_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai");
                props.setProperty("db.user", "YOUR_DB_USERNAME");
                props.setProperty("db.password", "YOUR_DB_PASSWORD");
                System.err.println("[ConfigUtil] 未找到 db.properties，使用默认配置");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }

    public static String get(String key, String defaultValue) {
        return props.getProperty(key, defaultValue);
    }
}
