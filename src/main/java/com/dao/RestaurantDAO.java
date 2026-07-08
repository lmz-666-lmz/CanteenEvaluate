package com.dao;

import com.entity.Restaurant;
import com.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    // 查询所有餐厅
    public List<Restaurant> getAllRestaurants() {
        String sql = "SELECT * FROM restaurants ORDER BY id ASC";
        List<Restaurant> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Restaurant(rs.getInt("id"), rs.getString("name")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 新增餐厅
     */
    public boolean addRestaurant(Restaurant restaurant) {
        String sql = "INSERT INTO restaurants (name) VALUES (?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, restaurant.getName());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 查询所有餐厅（别名）
    public List<Restaurant> findAll() {
        return getAllRestaurants();
    }

    /**
     * 分页查询餐厅（支持搜索）
     */
    public List<Restaurant> findByPage(int page, int pageSize, String keyword) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM restaurants WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        sql.append(" ORDER BY id ASC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword.trim() + "%");
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Restaurant r = new Restaurant();
                    r.setId(rs.getInt("id"));
                    r.setName(rs.getString("name"));
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 获取餐厅总数（支持搜索过滤）
     */
    public int getCount(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM restaurants WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ?");
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(1, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 根据ID查询餐厅
     */
    public Restaurant findById(int id) {
        String sql = "SELECT * FROM restaurants WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Restaurant r = new Restaurant();
                    r.setId(rs.getInt("id"));
                    r.setName(rs.getString("name"));
                    return r;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 修改餐厅名称
     */
    public boolean updateRestaurant(Restaurant restaurant) {
        String sql = "UPDATE restaurants SET name=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setInt(2, restaurant.getId());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * 删除餐厅
     */
    public boolean deleteById(int id) {
        String sql = "DELETE FROM restaurants WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
