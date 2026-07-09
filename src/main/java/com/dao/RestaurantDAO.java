package com.dao;

import com.entity.Restaurant;
import com.util.DBUtil;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDAO {

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setId(rs.getInt("id"));
        r.setName(rs.getString("name"));
        r.setLocation(getStringOrNull(rs, "location"));
        r.setOpenTime(getStringOrNull(rs, "open_time"));
        r.setTags(getStringOrNull(rs, "tags"));
        r.setDescription(getStringOrNull(rs, "description"));
        try {
            BigDecimal cost = rs.getBigDecimal("avg_cost");
            if (cost != null) {
                r.setAvgCost(cost);
            }
        } catch (SQLException ignored) {}
        try {
            r.setStatus(rs.getInt("status"));
        } catch (SQLException ignored) {}
        r.setCoverColor(getStringOrNull(rs, "cover_color"));
        if (r.getCoverColor() == null || r.getCoverColor().trim().isEmpty()) {
            r.setCoverColor("#7C3AED");
        }
        return r;
    }

    private String getStringOrNull(ResultSet rs, String column) {
        try {
            return rs.getString(column);
        } catch (SQLException e) {
            return null;
        }
    }

    public List<Restaurant> getAllRestaurants() {
        String sql = "SELECT * FROM restaurants ORDER BY id ASC";
        List<Restaurant> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean addRestaurant(Restaurant restaurant) {
        String sql = "INSERT INTO restaurants (name, location, open_time, tags, description, avg_cost, status, cover_color) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getLocation());
            pstmt.setString(3, restaurant.getOpenTime());
            pstmt.setString(4, restaurant.getTags());
            pstmt.setString(5, restaurant.getDescription());
            if (restaurant.getAvgCost() != null) {
                pstmt.setBigDecimal(6, restaurant.getAvgCost());
            } else {
                pstmt.setBigDecimal(6, new BigDecimal("15.00"));
            }
            pstmt.setInt(7, restaurant.getStatus());
            pstmt.setString(8, restaurant.getCoverColor() != null ? restaurant.getCoverColor() : "#7C3AED");
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Restaurant> findAll() {
        return getAllRestaurants();
    }

    public List<Restaurant> findByPage(int page, int pageSize, String keyword) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM restaurants WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR location LIKE ? OR tags LIKE ?)");
        }
        sql.append(" ORDER BY id ASC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, like);
                ps.setString(paramIndex++, like);
                ps.setString(paramIndex++, like);
            }
            ps.setInt(paramIndex++, pageSize);
            ps.setInt(paramIndex++, (page - 1) * pageSize);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRestaurant(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getCount(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM restaurants WHERE 1=1");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (name LIKE ? OR location LIKE ? OR tags LIKE ?)");
        }
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                ps.setString(1, like);
                ps.setString(2, like);
                ps.setString(3, like);
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Restaurant findById(int id) {
        String sql = "SELECT * FROM restaurants WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRestaurant(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateRestaurant(Restaurant restaurant) {
        String sql = "UPDATE restaurants SET name=?, location=?, open_time=?, tags=?, description=?, " +
                     "avg_cost=?, status=?, cover_color=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, restaurant.getName());
            pstmt.setString(2, restaurant.getLocation());
            pstmt.setString(3, restaurant.getOpenTime());
            pstmt.setString(4, restaurant.getTags());
            pstmt.setString(5, restaurant.getDescription());
            if (restaurant.getAvgCost() != null) {
                pstmt.setBigDecimal(6, restaurant.getAvgCost());
            } else {
                pstmt.setBigDecimal(6, new BigDecimal("15.00"));
            }
            pstmt.setInt(7, restaurant.getStatus());
            pstmt.setString(8, restaurant.getCoverColor() != null ? restaurant.getCoverColor() : "#7C3AED");
            pstmt.setInt(9, restaurant.getId());
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

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
