package com.dao;

import com.entity.User;
import com.util.DBUtil;
import com.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // 用户登录
    public User login(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedPwd = rs.getString("password");
                    // 使用 PasswordUtil 验证密码（兼容旧明文和新哈希格式）
                    if (!PasswordUtil.verify(password, storedPwd)) {
                        return null;
                    }
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(storedPwd);
                    user.setNickname(rs.getString("nickname"));
                    user.setRole(rs.getObject("role") != null ? rs.getInt("role") : 0);
                    user.setAvatar(rs.getString("avatar"));
                    user.setCreateTime(rs.getString("create_time"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 管理员登录验证
    public User adminLogin(String username, String password) {
        String sql = "SELECT * FROM users WHERE username=? AND role=1";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, username);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String storedPwd = rs.getString("password");
                    if (!PasswordUtil.verify(password, storedPwd)) {
                        return null;
                    }
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(storedPwd);
                    user.setNickname(rs.getString("nickname"));
                    user.setRole(rs.getInt("role"));
                    user.setAvatar(rs.getString("avatar"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 修改昵称
    public void updateNickname(int userId, String newNickname) {
        String sql = "UPDATE users SET nickname = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newNickname);
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 修改密码（使用哈希）
    public void updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.hash(newPassword));
            ps.setInt(2, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 检查用户名是否已存在
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 注册新用户（密码哈希存储）
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, nickname) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtil.hash(user.getPassword()));
            ps.setString(3, user.getNickname());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== 分页 + 搜索 ====================

    /**
     * 分页查询用户列表（支持搜索）
     */
    public List<User> findUsersByPage(int page, int pageSize, String keyword) {
        List<User> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR nickname LIKE ?)");
        }
        sql.append(" ORDER BY id ASC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, like);
                ps.setString(paramIndex++, like);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setNickname(rs.getString("nickname"));
                    user.setRole(rs.getObject("role") != null ? rs.getInt("role") : 0);
                    user.setAvatar(rs.getString("avatar"));
                    user.setCreateTime(rs.getString("create_time"));
                    list.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取用户总数（支持搜索过滤）
     */
    public int getUserCount(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR nickname LIKE ?)");
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

    // 查询所有用户（兼容旧调用）
    public List<User> findAllUsers() {
        return findUsersByPage(1, Integer.MAX_VALUE, null);
    }

    // 修改用户信息
    public boolean updateUser(User user) {
        int row = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql;
            if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
                sql = "UPDATE users SET username=?, nickname=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user.getUsername());
                pstmt.setString(2, user.getNickname());
                pstmt.setInt(3, user.getId());
            } else {
                sql = "UPDATE users SET username=?, password=?, nickname=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, user.getUsername());
                pstmt.setString(2, PasswordUtil.hash(user.getPassword()));
                pstmt.setString(3, user.getNickname());
                pstmt.setInt(4, user.getId());
            }
            row = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
        return row > 0;
    }

    // 删除用户
    public boolean deleteUserById(int id) {
        int row = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM users WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            row = pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, null);
        }
        return row > 0;
    }

    // 根据ID查询用户
    public User findUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setNickname(rs.getString("nickname"));
                    user.setRole(rs.getObject("role") != null ? rs.getInt("role") : 0);
                    user.setAvatar(rs.getString("avatar"));
                    return user;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== 仪表盘统计 ====================

    /**
     * 获取系统统计数据
     * @return [用户数, 餐厅数, 评价数, 日志数]
     */
    public int[] getDashboardStats() {
        int[] stats = new int[4];
        String sql = "SELECT " +
            "(SELECT COUNT(*) FROM users) AS user_count, " +
            "(SELECT COUNT(*) FROM restaurants) AS rest_count, " +
            "(SELECT COUNT(*) FROM evaluations) AS eval_count, " +
            "(SELECT COUNT(*) FROM sys_logs) AS log_count";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats[0] = rs.getInt("user_count");
                stats[1] = rs.getInt("rest_count");
                stats[2] = rs.getInt("eval_count");
                stats[3] = rs.getInt("log_count");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}
