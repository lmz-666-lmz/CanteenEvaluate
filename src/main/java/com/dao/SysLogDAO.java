package com.dao;

import com.entity.SysLog;
import com.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SysLogDAO {

    /**
     * 插入操作日志
     */
    public void insertLog(String username, String actionType, String detail) {
        String sql = "INSERT INTO sys_logs(username, action_type, action_detail, create_time) VALUES(?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            pstmt.setString(2, actionType);
            pstmt.setString(3, detail);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取所有日志（按时间倒序）
     */
    public List<SysLog> getAllLogs() {
        return findByPage(1, Integer.MAX_VALUE, null);
    }

    /**
     * 分页查询日志（支持搜索用户名/操作类型）
     */
    public List<SysLog> findByPage(int page, int pageSize, String keyword) {
        List<SysLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM sys_logs WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR action_type LIKE ?)");
        }
        sql.append(" ORDER BY create_time DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                pstmt.setString(paramIndex++, like);
                pstmt.setString(paramIndex++, like);
            }
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    SysLog log = new SysLog();
                    log.setId(rs.getInt("id"));
                    log.setUsername(rs.getString("username"));
                    log.setAction_type(rs.getString("action_type"));
                    log.setAction_detail(rs.getString("action_detail"));
                    log.setCreate_time(rs.getTimestamp("create_time"));
                    list.add(log);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取日志总数（支持搜索过滤）
     */
    public int getCount(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM sys_logs WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR action_type LIKE ?)");
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
