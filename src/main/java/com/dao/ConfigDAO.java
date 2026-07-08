package com.dao;

import com.util.DBUtil;
import java.sql.*;

/**
 * 系统配置数据访问
 * 从 system_config 表读取运行时配置，支持动态调整而无需重启
 *
 * 当前支持的配置项：
 *   page_size      — 后台列表默认每页条数（默认10）
 *   site_name      — 网站名称
 *   admin_email    — 管理员联系邮箱
 */
public class ConfigDAO {

    // 缓存，避免每次请求都查数据库
    private static final java.util.Map<String, String> cache = new java.util.concurrent.ConcurrentHashMap<>();
    private static long lastRefreshTime = 0;
    private static final long CACHE_TTL = 60_000; // 60秒缓存

    private static void refreshIfNeeded() {
        long now = System.currentTimeMillis();
        if (now - lastRefreshTime < CACHE_TTL && !cache.isEmpty()) return;
        // 批量加载所有配置到缓存
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("SELECT config_key, config_value FROM system_config");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                cache.put(rs.getString("config_key"), rs.getString("config_value"));
            }
            lastRefreshTime = now;
        } catch (Exception e) {
            // 表不存在时静默fallback，使用默认值
        }
    }

    /**
     * 读取配置值，不存在则返回默认值
     */
    public static String getConfig(String key, String defaultValue) {
        refreshIfNeeded();
        return cache.getOrDefault(key, defaultValue);
    }

    /**
     * 读取整数配置
     */
    public static int getInt(String key, int defaultValue) {
        String val = getConfig(key, null);
        if (val != null) {
            try { return Integer.parseInt(val); } catch (NumberFormatException e) {}
        }
        return defaultValue;
    }

    /**
     * 更新配置值（不存在则插入），同时更新缓存
     */
    public static void setConfig(String key, String value) {
        String sql = "INSERT INTO system_config (config_key, config_value) VALUES (?, ?) " +
                     "ON DUPLICATE KEY UPDATE config_value = VALUES(config_value)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, key);
            ps.setString(2, value);
            ps.executeUpdate();
            cache.put(key, value);  // 立即更新缓存
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /** 强制刷新缓存（外部修改DB后调用） */
    public static void refreshCache() {
        cache.clear();
        lastRefreshTime = 0;
    }
}
