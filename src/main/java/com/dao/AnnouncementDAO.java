package com.dao;

import com.entity.Announcement;
import com.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDAO {

    /**
     * 获取所有活跃公告（按排序权重排列）
     */
    public List<Announcement> getActiveAnnouncements() {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT * FROM announcements WHERE is_active = 1 ORDER BY sort_order DESC, create_time DESC, id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapAnnouncement(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 分页查询所有公告（管理端，含搜索）
     */
    public List<Announcement> findByPage(int page, int pageSize, String keyword) {
        List<Announcement> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM announcements WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR content LIKE ?)");
        }
        sql.append(" ORDER BY sort_order ASC, create_time DESC LIMIT ? OFFSET ?");

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
                    list.add(mapAnnouncement(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getCount(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM announcements WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (title LIKE ? OR content LIKE ?)");
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
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * 新增公告
     */
    public boolean add(Announcement ann) {
        String sql = "INSERT INTO announcements (title, content, is_active, sort_order) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ann.getTitle());
            ps.setString(2, ann.getContent());
            ps.setInt(3, ann.getIsActive());
            ps.setInt(4, ann.getSortOrder());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 更新公告
     */
    public boolean update(Announcement ann) {
        String sql = "UPDATE announcements SET title=?, content=?, is_active=?, sort_order=?, update_time=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, ann.getTitle());
            ps.setString(2, ann.getContent());
            ps.setInt(3, ann.getIsActive());
            ps.setInt(4, ann.getSortOrder());
            ps.setInt(5, ann.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 删除公告
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM announcements WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 根据ID查询公告
     */
    public Announcement findById(int id) {
        String sql = "SELECT * FROM announcements WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapAnnouncement(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Announcement mapAnnouncement(ResultSet rs) throws SQLException {
        Announcement a = new Announcement();
        a.setId(rs.getInt("id"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setCreateTime(rs.getString("create_time"));
        a.setUpdateTime(rs.getString("update_time"));
        a.setIsActive(rs.getInt("is_active"));
        a.setSortOrder(rs.getInt("sort_order"));
        return a;
    }
}
