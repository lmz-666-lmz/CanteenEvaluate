package com.dao;

import com.entity.WishItem;
import com.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class WishDAO {

    public boolean isTableReady() {
        String sql = "SELECT 1 FROM wish_items LIMIT 1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public List<WishItem> findByUser(int userId, int status) {
        List<WishItem> list = new ArrayList<>();
        String sql = "SELECT w.*, r.name AS restaurantName FROM wish_items w " +
                "LEFT JOIN restaurants r ON w.restaurant_id = r.id " +
                "WHERE w.user_id = ? AND w.status = ? ORDER BY w.create_time DESC, w.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapWishItem(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countOpen(int userId) {
        String sql = "SELECT COUNT(*) FROM wish_items WHERE user_id = ? AND status = 0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            return 0;
        }
        return 0;
    }

    public boolean add(WishItem item) {
        String sql = "INSERT INTO wish_items (user_id, restaurant_id, dish_name, note, status) VALUES (?, ?, ?, ?, 0)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getUserId());
            if (item.getRestaurantId() > 0) {
                ps.setInt(2, item.getRestaurantId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, item.getDishName());
            ps.setString(4, item.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(int id, int userId, int status) {
        String sql = "UPDATE wish_items SET status = ?, finish_time = CASE WHEN ? = 1 THEN CURRENT_TIMESTAMP ELSE NULL END " +
                "WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, status);
            ps.setInt(3, id);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(int id, int userId) {
        String sql = "DELETE FROM wish_items WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private WishItem mapWishItem(ResultSet rs) throws Exception {
        WishItem item = new WishItem();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setRestaurantId(rs.getInt("restaurant_id"));
        item.setRestaurantName(rs.getString("restaurantName"));
        item.setDishName(rs.getString("dish_name"));
        item.setNote(rs.getString("note"));
        item.setStatus(rs.getInt("status"));
        item.setCreateTime(rs.getString("create_time"));
        item.setFinishTime(rs.getString("finish_time"));
        return item;
    }
}
