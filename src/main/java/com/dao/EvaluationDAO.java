package com.dao;

import com.entity.Evaluation;
import com.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvaluationDAO {

    // 1. 查询我的评价（DB端分页）
    public List<Evaluation> getMyEvaluations(int userId, int page, int pageSize) {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, r.name as restaurantName FROM evaluations e " +
                     "JOIN restaurants r ON e.restaurant_id = r.id " +
                     "WHERE e.user_id = ? ORDER BY e.id DESC " +
                     "LIMIT ? OFFSET ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, pageSize);
            ps.setInt(3, (page - 1) * pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEvaluation(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 兼容旧调用（不分页，用于小数据量场景）
    public List<Evaluation> getMyEvaluations(int userId) {
        return getMyEvaluations(userId, 1, Integer.MAX_VALUE);
    }

    // 2. 查询所有评价
    public List<Evaluation> getAllEvaluations() {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, u.nickname as authorNickname, r.name as restaurantName " +
                     "FROM evaluations e " +
                     "JOIN users u ON e.user_id = u.id " +
                     "JOIN restaurants r ON e.restaurant_id = r.id " +
                     "ORDER BY e.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapEvaluationWithUser(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * 查询所有评价（支持排序：newest/highest/most_liked）
     */
    public List<Evaluation> getAllEvaluationsBySort(String sortBy) {
        List<Evaluation> list = new ArrayList<>();
        String orderClause;
        if ("highest".equals(sortBy)) {
            orderClause = "(e.taste_score + e.price_score + e.service_score) / 3.0 DESC, e.id DESC";
        } else if ("most_liked".equals(sortBy)) {
            orderClause = "e.like_count DESC, e.id DESC";
        } else {
            orderClause = "e.id DESC";
        }
        String sql = "SELECT e.*, u.nickname as authorNickname, r.name as restaurantName " +
                     "FROM evaluations e " +
                     "JOIN users u ON e.user_id = u.id " +
                     "JOIN restaurants r ON e.restaurant_id = r.id " +
                     "ORDER BY " + orderClause;
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapEvaluationWithUser(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 3. 新增评价
    public void add(Evaluation eval) {
        String sql = "INSERT INTO evaluations (user_id, restaurant_id, dish_name, content, taste_score, price_score, service_score) " +
                     "VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eval.getUserId());
            ps.setInt(2, eval.getRestaurantId());
            ps.setString(3, eval.getDishName());
            ps.setString(4, eval.getContent());
            ps.setInt(5, eval.getTasteScore());
            ps.setInt(6, eval.getPriceScore());
            ps.setInt(7, eval.getServiceScore());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 4. 删除评价（双重校验：评价ID + 用户ID）
    public boolean delete(int evalId, int userId) {
        String sql = "DELETE FROM evaluations WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evalId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ==================== 管理端分页查询 ====================

    /**
     * 管理端分页查询所有评价（支持搜索用户名/菜品名）
     */
    public List<Evaluation> findByPage(int page, int pageSize, String keyword) {
        List<Evaluation> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT e.*, u.username, u.nickname AS authorNickname, r.name AS restaurantName " +
            "FROM evaluations e " +
            "JOIN users u ON e.user_id = u.id " +
            "JOIN restaurants r ON e.restaurant_id = r.id " +
            "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR e.dish_name LIKE ? OR r.name LIKE ?) ");
        }
        sql.append("ORDER BY e.id DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (keyword != null && !keyword.trim().isEmpty()) {
                String like = "%" + keyword.trim() + "%";
                pstmt.setString(paramIndex++, like);
                pstmt.setString(paramIndex++, like);
                pstmt.setString(paramIndex++, like);
            }
            pstmt.setInt(paramIndex++, pageSize);
            pstmt.setInt(paramIndex++, (page - 1) * pageSize);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Evaluation eval = mapEvaluationWithUser(rs);
                    eval.setUsername(rs.getString("username"));
                    list.add(eval);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * 管理端获取评价总数（支持搜索）
     */
    public int getCount(String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM evaluations e " +
            "JOIN users u ON e.user_id = u.id " +
            "JOIN restaurants r ON e.restaurant_id = r.id " +
            "WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR e.dish_name LIKE ? OR r.name LIKE ?)");
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

    /**
     * 管理端获取所有评价（兼容旧版）
     */
    public List<Evaluation> getAllAdminEvaluations() {
        return findByPage(1, Integer.MAX_VALUE, null);
    }

    /**
     * 管理端通过ID删除评价
     */
    public boolean deleteEvaluation(int id) {
        String sql = "DELETE FROM evaluations WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 根据ID和用户ID获取评价
    public Evaluation getByIdAndUserId(int id, int userId) {
        String sql = "SELECT * FROM evaluations WHERE id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapEvaluation(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // 更新评价
    public boolean update(Evaluation eval) {
        String sql = "UPDATE evaluations SET dish_name=?, content=?, taste_score=?, price_score=?, " +
                     "service_score=?, update_time=CURRENT_TIMESTAMP WHERE id=? AND user_id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, eval.getDishName());
            ps.setString(2, eval.getContent());
            ps.setInt(3, eval.getTasteScore());
            ps.setInt(4, eval.getPriceScore());
            ps.setInt(5, eval.getServiceScore());
            ps.setInt(6, eval.getId());
            ps.setInt(7, eval.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 用户统计
    public double[] getUserStats(int userId) {
        double[] stats = new double[]{0, 0.0};
        String sql = "SELECT COUNT(id) AS total_count, AVG((taste_score + price_score + service_score) / 3.0) AS avg_score " +
                     "FROM evaluations WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats[0] = rs.getInt("total_count");
                    stats[1] = rs.getDouble("avg_score");
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return stats;
    }

    // ==================== 点赞功能 ====================

    /**
     * 切换点赞状态：已点赞则取消，未点赞则点赞
     * @return 操作后的点赞数，-1表示操作失败
     */
    public int toggleLike(int evalId, int userId) {
        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);

            // 检查是否已点赞
            String checkSql = "SELECT id FROM evaluation_likes WHERE eval_id = ? AND user_id = ?";
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setInt(1, evalId);
                checkPs.setInt(2, userId);
                try (ResultSet rs = checkPs.executeQuery()) {
                    if (rs.next()) {
                        // 已点赞 → 取消
                        String delSql = "DELETE FROM evaluation_likes WHERE eval_id = ? AND user_id = ?";
                        try (PreparedStatement delPs = conn.prepareStatement(delSql)) {
                            delPs.setInt(1, evalId);
                            delPs.setInt(2, userId);
                            delPs.executeUpdate();
                        }
                        // 更新计数 -1
                        String updSql = "UPDATE evaluations SET like_count = GREATEST(like_count - 1, 0) WHERE id = ?";
                        try (PreparedStatement updPs = conn.prepareStatement(updSql)) {
                            updPs.setInt(1, evalId);
                            updPs.executeUpdate();
                        }
                        conn.commit();
                        return getLikeCount(conn, evalId);
                    } else {
                        // 未点赞 → 点赞
                        String insSql = "INSERT INTO evaluation_likes (eval_id, user_id) VALUES (?, ?)";
                        try (PreparedStatement insPs = conn.prepareStatement(insSql)) {
                            insPs.setInt(1, evalId);
                            insPs.setInt(2, userId);
                            insPs.executeUpdate();
                        }
                        String updSql = "UPDATE evaluations SET like_count = like_count + 1 WHERE id = ?";
                        try (PreparedStatement updPs = conn.prepareStatement(updSql)) {
                            updPs.setInt(1, evalId);
                            updPs.executeUpdate();
                        }
                        conn.commit();
                        return getLikeCount(conn, evalId);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return -1;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    private int getLikeCount(Connection conn, int evalId) throws SQLException {
        String sql = "SELECT like_count FROM evaluations WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evalId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("like_count");
            }
        }
        return 0;
    }

    /**
     * 检查用户是否已点赞某评价
     */
    public boolean isLikedByUser(int evalId, int userId) {
        String sql = "SELECT id FROM evaluation_likes WHERE eval_id = ? AND user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, evalId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    /**
     * 获取评价点赞状态（用于列表展示，带当前用户标记）
     */
    public List<Evaluation> getAllEvaluationsWithLikeStatus(int currentUserId) {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, u.nickname as authorNickname, r.name as restaurantName, " +
                     "(SELECT COUNT(*) FROM evaluation_likes el WHERE el.eval_id = e.id AND el.user_id = ?) AS liked " +
                     "FROM evaluations e " +
                     "JOIN users u ON e.user_id = u.id " +
                     "JOIN restaurants r ON e.restaurant_id = r.id " +
                     "ORDER BY e.id DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, currentUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Evaluation eval = mapEvaluationWithUser(rs);
                    eval.setLikedByCurrentUser(rs.getInt("liked") > 0);
                    list.add(eval);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==================== Helper methods ====================

    private Evaluation mapEvaluation(ResultSet rs) throws SQLException {
        Evaluation eval = new Evaluation();
        eval.setId(rs.getInt("id"));
        eval.setUserId(rs.getInt("user_id"));
        eval.setRestaurantId(rs.getInt("restaurant_id"));
        eval.setDishName(rs.getString("dish_name"));
        eval.setContent(rs.getString("content"));
        eval.setTasteScore(rs.getInt("taste_score"));
        eval.setPriceScore(rs.getInt("price_score"));
        eval.setServiceScore(rs.getInt("service_score"));
        eval.setLikeCount(getIntOrZero(rs, "like_count"));
        eval.setUpdateTime(rs.getString("update_time"));
        try { eval.setRestaurantName(rs.getString("restaurantName")); } catch (SQLException ignored) {}
        return eval;
    }

    private Evaluation mapEvaluationWithUser(ResultSet rs) throws SQLException {
        Evaluation eval = mapEvaluation(rs);
        try { eval.setAuthorNickname(rs.getString("authorNickname")); } catch (SQLException ignored) {}
        try { eval.setRestaurantName(rs.getString("restaurantName")); } catch (SQLException ignored) {}
        return eval;
    }

    private int getIntOrZero(ResultSet rs, String column) {
        try { return rs.getInt(column); } catch (SQLException e) { return 0; }
    }
}
