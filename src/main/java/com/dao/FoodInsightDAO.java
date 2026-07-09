package com.dao;

import com.entity.CampusStats;
import com.entity.Evaluation;
import com.entity.InsightCard;
import com.entity.TasteProfile;
import com.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class FoodInsightDAO {

    public CampusStats getCampusStats() {
        CampusStats stats = new CampusStats();
        String sql = "SELECT " +
                "(SELECT COUNT(*) FROM users) AS user_count, " +
                "(SELECT COUNT(*) FROM restaurants) AS restaurant_count, " +
                "(SELECT COUNT(*) FROM evaluations) AS evaluation_count, " +
                "(SELECT COUNT(DISTINCT dish_name) FROM evaluations WHERE dish_name IS NOT NULL AND TRIM(dish_name) <> '') AS dish_count, " +
                "(SELECT COALESCE(SUM(like_count),0) FROM evaluations) AS like_count, " +
                "(SELECT COUNT(DISTINCT user_id) FROM evaluations) AS active_user_count, " +
                "(SELECT COALESCE(AVG((taste_score + price_score + service_score) / 3.0),0) FROM evaluations) AS avg_score";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.setUserCount(rs.getInt("user_count"));
                stats.setRestaurantCount(rs.getInt("restaurant_count"));
                stats.setEvaluationCount(rs.getInt("evaluation_count"));
                stats.setDishCount(rs.getInt("dish_count"));
                stats.setLikeCount(rs.getInt("like_count"));
                stats.setActiveUserCount(rs.getInt("active_user_count"));
                stats.setAvgScore(rs.getDouble("avg_score"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        List<InsightCard> restaurants = getRestaurantTrends(1);
        if (!restaurants.isEmpty()) {
            stats.setTopRestaurant(restaurants.get(0).getTitle());
        }
        List<InsightCard> dishes = getDishTrends(1);
        if (!dishes.isEmpty()) {
            stats.setTopDish(dishes.get(0).getTitle());
        }
        return stats;
    }

    public List<InsightCard> getRestaurantTrends(int limit) {
        String sql = "SELECT r.id, r.name AS title, r.location, r.tags, r.avg_cost, r.status, r.cover_color, " +
                "COUNT(e.id) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, " +
                "COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, " +
                "COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) * 20 " +
                " + LOG10(COUNT(e.id) + 1) * 18 + COALESCE(SUM(e.like_count),0) * 1.4) AS heat_score " +
                "FROM restaurants r LEFT JOIN evaluations e ON e.restaurant_id = r.id " +
                "GROUP BY r.id, r.name, r.location, r.tags, r.avg_cost, r.status, r.cover_color " +
                "HAVING review_count > 0 " +
                "ORDER BY heat_score DESC, avg_score DESC LIMIT ?";
        return queryInsightCards(sql, limit, "restaurant");
    }

    /**
     * 首页今日饭点推荐：高分 / 性价比 / 人气
     */
    public List<InsightCard> getHomeMealRecommendations() {
        List<InsightCard> cards = new ArrayList<>();
        InsightCard highScore = querySingleHomeCard(
                "SELECT MIN(e.id) AS id, e.dish_name AS title, r.name AS subtitle, r.location, r.tags, " +
                "r.avg_cost, r.status, r.cover_color, COUNT(*) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, COALESCE(SUM(e.like_count),0) AS like_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) * 24 AS heat_score " +
                "FROM evaluations e JOIN restaurants r ON e.restaurant_id = r.id " +
                "WHERE e.dish_name IS NOT NULL AND TRIM(e.dish_name) <> '' " +
                "GROUP BY e.restaurant_id, r.name, e.dish_name, r.location, r.tags, r.avg_cost, r.status, r.cover_color " +
                "ORDER BY avg_score DESC, like_count DESC LIMIT 1",
                "highscore", "今日高分推荐", "综合评分领先，适合追求味道的同学");
        InsightCard value = querySingleHomeCard(
                "SELECT MIN(e.id) AS id, e.dish_name AS title, r.name AS subtitle, r.location, r.tags, " +
                "r.avg_cost, r.status, r.cover_color, COUNT(*) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COALESCE(AVG(e.price_score),0) * 10 - COALESCE(r.avg_cost, 15) * 0.5) AS heat_score " +
                "FROM evaluations e JOIN restaurants r ON e.restaurant_id = r.id " +
                "WHERE e.dish_name IS NOT NULL AND TRIM(e.dish_name) <> '' " +
                "GROUP BY e.restaurant_id, r.name, e.dish_name, r.location, r.tags, r.avg_cost, r.status, r.cover_color " +
                "ORDER BY price_avg DESC, r.avg_cost ASC, avg_score DESC LIMIT 1",
                "value", "性价比推荐", "价格评分高且人均友好，适合日常消费");
        InsightCard popular = querySingleHomeCard(
                "SELECT r.id, r.name AS title, r.location, r.tags, r.avg_cost, r.status, r.cover_color, " +
                "COUNT(e.id) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COUNT(e.id) * 3 + COALESCE(SUM(e.like_count),0) * 2) AS heat_score " +
                "FROM restaurants r JOIN evaluations e ON e.restaurant_id = r.id " +
                "GROUP BY r.id, r.name, r.location, r.tags, r.avg_cost, r.status, r.cover_color " +
                "ORDER BY review_count DESC, like_count DESC, avg_score DESC LIMIT 1",
                "popular", "人气餐厅推荐", "评价与点赞集中，适合跟风打卡");

        cards.add(highScore != null ? highScore : fallbackCard("highscore", "今日高分推荐", "招牌盖饭", "第一食堂", "综合评分领先，适合追求味道的同学"));
        cards.add(value != null ? value : fallbackCard("value", "性价比推荐", "实惠套餐", "生活区餐厅", "价格评分高且人均友好，适合日常消费"));
        cards.add(popular != null ? popular : fallbackCard("popular", "人气餐厅推荐", "热门窗口", "美食广场", "评价与点赞集中，适合跟风打卡"));
        return cards;
    }

    public List<InsightCard> getDishTrends(int limit) {
        String sql = "SELECT MIN(e.id) AS id, e.dish_name AS title, r.name AS subtitle, COUNT(*) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, " +
                "COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, " +
                "COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) * 22 " +
                " + LOG10(COUNT(*) + 1) * 16 + COALESCE(SUM(e.like_count),0) * 1.6) AS heat_score " +
                "FROM evaluations e JOIN restaurants r ON e.restaurant_id = r.id " +
                "WHERE e.dish_name IS NOT NULL AND TRIM(e.dish_name) <> '' " +
                "GROUP BY e.restaurant_id, r.name, e.dish_name " +
                "ORDER BY heat_score DESC, avg_score DESC LIMIT ?";
        return queryInsightCards(sql, limit, "dish");
    }

    public List<InsightCard> getCreatorTrends(int limit) {
        String sql = "SELECT u.id, COALESCE(NULLIF(u.nickname,''), u.username) AS title, u.username AS subtitle, " +
                "COUNT(e.id) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, " +
                "COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, " +
                "COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COUNT(e.id) * 7 + COALESCE(SUM(e.like_count),0) * 2 + " +
                " COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) * 12) AS heat_score " +
                "FROM users u JOIN evaluations e ON e.user_id = u.id " +
                "GROUP BY u.id, u.username, u.nickname " +
                "ORDER BY heat_score DESC, review_count DESC LIMIT ?";
        return queryInsightCards(sql, limit, "creator");
    }

    public List<Evaluation> getRecommendations(String mood, String budget, int limit) {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, u.nickname AS authorNickname, r.name AS restaurantName " +
                "FROM evaluations e " +
                "JOIN users u ON e.user_id = u.id " +
                "JOIN restaurants r ON e.restaurant_id = r.id " +
                "ORDER BY ((e.taste_score + e.price_score + e.service_score) / 3.0) DESC, e.like_count DESC, e.id DESC " +
                "LIMIT 180";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Evaluation eval = mapEvaluation(rs);
                applyRecommendation(eval, mood, budget);
                list.add(eval);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Collections.sort(list, new Comparator<Evaluation>() {
            @Override
            public int compare(Evaluation a, Evaluation b) {
                return Double.compare(b.getInsightScore(), a.getInsightScore());
            }
        });
        if (list.size() > limit) {
            return new ArrayList<>(list.subList(0, limit));
        }
        return list;
    }

    public TasteProfile getTasteProfile(int userId) {
        TasteProfile profile = new TasteProfile();
        String sql = "SELECT COUNT(*) AS total_count, COUNT(DISTINCT restaurant_id) AS restaurant_count, " +
                "COALESCE(SUM(like_count),0) AS like_count, " +
                "COALESCE(AVG((taste_score + price_score + service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(taste_score),0) AS taste_avg, " +
                "COALESCE(AVG(price_score),0) AS price_avg, " +
                "COALESCE(AVG(service_score),0) AS service_avg " +
                "FROM evaluations WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    profile.setTotalCount(rs.getInt("total_count"));
                    profile.setRestaurantCount(rs.getInt("restaurant_count"));
                    profile.setLikeCount(rs.getInt("like_count"));
                    profile.setAvgScore(rs.getDouble("avg_score"));
                    profile.setTasteAvg(rs.getDouble("taste_avg"));
                    profile.setPriceAvg(rs.getDouble("price_avg"));
                    profile.setServiceAvg(rs.getDouble("service_avg"));
                }
            }

            profile.setFavoriteRestaurant(querySingleText(conn,
                    "SELECT r.name FROM evaluations e JOIN restaurants r ON e.restaurant_id = r.id " +
                            "WHERE e.user_id = ? GROUP BY r.id, r.name " +
                            "ORDER BY COUNT(*) DESC, AVG((e.taste_score + e.price_score + e.service_score) / 3.0) DESC LIMIT 1",
                    userId));
            profile.setFavoriteDish(querySingleText(conn,
                    "SELECT dish_name FROM evaluations WHERE user_id = ? AND dish_name IS NOT NULL AND TRIM(dish_name) <> '' " +
                            "GROUP BY dish_name ORDER BY COUNT(*) DESC, AVG((taste_score + price_score + service_score) / 3.0) DESC LIMIT 1",
                    userId));
        } catch (Exception e) {
            e.printStackTrace();
        }

        profile.setRecentEvaluations(getUserRecentEvaluations(userId, 6));
        profile.setTopRestaurants(getUserRestaurantCards(userId, 4));
        applyPersona(profile);
        return profile;
    }

    public int[] getScoreBuckets() {
        int[] buckets = new int[5];
        String sql = "SELECT (taste_score + price_score + service_score) / 3.0 AS avg_score FROM evaluations";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                double avg = rs.getDouble("avg_score");
                int idx = (int) Math.ceil(avg) - 1;
                if (idx < 0) idx = 0;
                if (idx > 4) idx = 4;
                buckets[idx]++;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return buckets;
    }

    private List<InsightCard> queryInsightCards(String sql, int limit, String type) {
        List<InsightCard> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    InsightCard card = new InsightCard();
                    card.setRank(rank++);
                    card.setType(type);
                    card.setId(rs.getInt("id"));
                    card.setTitle(rs.getString("title"));
                    try { card.setSubtitle(rs.getString("subtitle")); } catch (SQLException ignored) {}
                    card.setReviewCount(rs.getInt("review_count"));
                    card.setAvgScore(rs.getDouble("avg_score"));
                    card.setTasteAvg(rs.getDouble("taste_avg"));
                    card.setPriceAvg(rs.getDouble("price_avg"));
                    card.setServiceAvg(rs.getDouble("service_avg"));
                    card.setLikeCount(rs.getInt("like_count"));
                    card.setHeatScore(rs.getDouble("heat_score"));
                    card.setLocation(getStringOrNull(rs, "location"));
                    card.setTags(getStringOrNull(rs, "tags"));
                    try { card.setAvgCost(rs.getDouble("avg_cost")); } catch (SQLException ignored) {}
                    try { card.setStatus(rs.getInt("status")); } catch (SQLException ignored) {}
                    card.setCoverColor(getStringOrNull(rs, "cover_color"));
                    card.setTrendLabel(makeTrendLabel(card));
                    card.setReason(makeReason(card));
                    list.add(card);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Evaluation> getUserRecentEvaluations(int userId, int limit) {
        List<Evaluation> list = new ArrayList<>();
        String sql = "SELECT e.*, u.nickname AS authorNickname, r.name AS restaurantName " +
                "FROM evaluations e JOIN users u ON e.user_id = u.id " +
                "JOIN restaurants r ON e.restaurant_id = r.id " +
                "WHERE e.user_id = ? ORDER BY e.id DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapEvaluation(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<InsightCard> getUserRestaurantCards(int userId, int limit) {
        List<InsightCard> list = new ArrayList<>();
        String sql = "SELECT r.id, r.name AS title, COUNT(e.id) AS review_count, " +
                "COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) AS avg_score, " +
                "COALESCE(AVG(e.taste_score),0) AS taste_avg, COALESCE(AVG(e.price_score),0) AS price_avg, " +
                "COALESCE(AVG(e.service_score),0) AS service_avg, COALESCE(SUM(e.like_count),0) AS like_count, " +
                "(COUNT(e.id) * 8 + COALESCE(AVG((e.taste_score + e.price_score + e.service_score) / 3.0),0) * 18) AS heat_score " +
                "FROM evaluations e JOIN restaurants r ON e.restaurant_id = r.id " +
                "WHERE e.user_id = ? GROUP BY r.id, r.name ORDER BY review_count DESC, avg_score DESC LIMIT ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                int rank = 1;
                while (rs.next()) {
                    InsightCard card = new InsightCard();
                    card.setRank(rank++);
                    card.setType("personal");
                    card.setId(rs.getInt("id"));
                    card.setTitle(rs.getString("title"));
                    card.setReviewCount(rs.getInt("review_count"));
                    card.setAvgScore(rs.getDouble("avg_score"));
                    card.setTasteAvg(rs.getDouble("taste_avg"));
                    card.setPriceAvg(rs.getDouble("price_avg"));
                    card.setServiceAvg(rs.getDouble("service_avg"));
                    card.setLikeCount(rs.getInt("like_count"));
                    card.setHeatScore(rs.getDouble("heat_score"));
                    card.setTrendLabel(makeTrendLabel(card));
                    card.setReason(makeReason(card));
                    list.add(card);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private String querySingleText(Connection conn, String sql, int userId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getString(1);
            }
        }
        return null;
    }

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
        eval.setUpdateTime(getStringOrNull(rs, "update_time"));
        eval.setAuthorNickname(getStringOrNull(rs, "authorNickname"));
        eval.setRestaurantName(getStringOrNull(rs, "restaurantName"));
        return eval;
    }

    private void applyRecommendation(Evaluation eval, String mood, String budget) {
        double avg = (eval.getTasteScore() + eval.getPriceScore() + eval.getServiceScore()) / 3.0;
        double score = avg * 20 + eval.getLikeCount() * 1.8;
        String text = safe(eval.getDishName()) + " " + safe(eval.getContent()) + " " + safe(eval.getRestaurantName());
        String reason = "综合评分稳定";

        if ("value".equals(mood) || "value".equals(budget)) {
            score += eval.getPriceScore() * 8;
            reason = "性价比评分突出";
        } else if ("comfort".equals(mood)) {
            if (containsAny(text, new String[]{"热", "汤", "面", "饭", "粥", "盖饭", "家常", "麻辣"})) score += 16;
            reason = "适合想吃热乎、踏实的一餐";
        } else if ("light".equals(mood)) {
            if (containsAny(text, new String[]{"清淡", "不腻", "蔬菜", "沙拉", "粥", "汤", "健康"})) score += 16;
            reason = "更偏清爽轻负担";
        } else if ("popular".equals(mood)) {
            score += eval.getLikeCount() * 3.2;
            reason = "同学点赞反馈更集中";
        } else if ("highscore".equals(mood)) {
            score += avg * 12;
            reason = "高分优先推荐";
        }

        if ("treat".equals(budget)) {
            score += eval.getTasteScore() * 5 + eval.getServiceScore() * 3;
            reason = "适合认真犒劳自己";
        } else if ("quick".equals(budget)) {
            if (containsAny(text, new String[]{"快", "方便", "窗口", "排队少", "打包"})) score += 12;
            reason = "适合赶时间时快速决策";
        }

        eval.setInsightScore(score);
        eval.setRecommendReason(reason);
    }

    private void applyPersona(TasteProfile profile) {
        if (profile.getTotalCount() == 0) {
            profile.setPersonaName("新晋探索者");
            profile.setPersonaDesc("还没有留下评价。先去发布第一条，系统会逐步生成你的专属味蕾画像。");
            profile.setStrongestDimension("待点亮");
            profile.getBadges().add("首评待解锁");
            return;
        }

        double taste = profile.getTasteAvg();
        double price = profile.getPriceAvg();
        double service = profile.getServiceAvg();
        if (taste >= price && taste >= service) {
            profile.setStrongestDimension("味道敏感度");
        } else if (price >= taste && price >= service) {
            profile.setStrongestDimension("性价比雷达");
        } else {
            profile.setStrongestDimension("体验感知力");
        }

        if (profile.getTotalCount() >= 12) {
            profile.setPersonaName("校园美食策展人");
            profile.setPersonaDesc("你的评价已经能形成稳定参考，适合带同学做食堂选择。");
        } else if (profile.getPriceAvg() >= 4.4) {
            profile.setPersonaName("性价比雷达");
            profile.setPersonaDesc("你很会发现价格友好、体验在线的窗口。");
        } else if (profile.getTasteAvg() >= 4.5) {
            profile.setPersonaName("味觉猎手");
            profile.setPersonaDesc("你对味道的判断更敏锐，容易发现真正好吃的菜。");
        } else if (profile.getServiceAvg() >= 4.5) {
            profile.setPersonaName("体验派同学");
            profile.setPersonaDesc("你会关注从排队、窗口服务到用餐心情的完整体验。");
        } else {
            profile.setPersonaName("稳健寻味人");
            profile.setPersonaDesc("你的评价比较均衡，能给后来者稳定可靠的参考。");
        }

        profile.getBadges().add("已发布 " + profile.getTotalCount() + " 条评价");
        if (profile.getRestaurantCount() >= 3) profile.getBadges().add("跨餐厅探索者");
        if (profile.getRestaurantCount() >= 6) profile.getBadges().add("地图点亮达人");
        if (profile.getAvgScore() >= 4.5) profile.getBadges().add("高分发现家");
        if (profile.getLikeCount() >= 5) profile.getBadges().add("被点赞的推荐官");
        if (profile.getTotalCount() >= 10) profile.getBadges().add("持续记录者");
    }

    private String makeTrendLabel(InsightCard card) {
        if (card.getRank() == 1) return "TOP 1";
        if (card.getAvgScore() >= 4.7) return "高分";
        if (card.getLikeCount() >= 10) return "高赞";
        if (card.getReviewCount() >= 5) return "热议";
        return "上榜";
    }

    private String makeReason(InsightCard card) {
        if (card.getPriceAvg() >= card.getTasteAvg() && card.getPriceAvg() >= card.getServiceAvg()) {
            return "性价比口碑更突出";
        }
        if (card.getTasteAvg() >= card.getServiceAvg()) {
            return "味道评分拉动热度";
        }
        return "服务体验带来好感";
    }

    private boolean containsAny(String text, String[] keys) {
        if (text == null) return false;
        for (String key : keys) {
            if (text.contains(key)) return true;
        }
        return false;
    }

    private int getIntOrZero(ResultSet rs, String column) {
        try { return rs.getInt(column); } catch (SQLException e) { return 0; }
    }

    private String getStringOrNull(ResultSet rs, String column) {
        try { return rs.getString(column); } catch (SQLException e) { return null; }
    }

    private String safe(String text) {
        return text == null ? "" : text;
    }

    private InsightCard querySingleHomeCard(String sql, String type, String recommendType, String defaultReason) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                InsightCard card = new InsightCard();
                card.setId(rs.getInt("id"));
                card.setType(type);
                card.setRecommendType(recommendType);
                card.setTitle(rs.getString("title"));
                try { card.setSubtitle(rs.getString("subtitle")); } catch (SQLException ignored) {}
                card.setReviewCount(rs.getInt("review_count"));
                card.setAvgScore(rs.getDouble("avg_score"));
                card.setTasteAvg(rs.getDouble("taste_avg"));
                card.setPriceAvg(rs.getDouble("price_avg"));
                card.setServiceAvg(rs.getDouble("service_avg"));
                card.setLikeCount(rs.getInt("like_count"));
                card.setHeatScore(rs.getDouble("heat_score"));
                card.setLocation(getStringOrNull(rs, "location"));
                card.setTags(getStringOrNull(rs, "tags"));
                try { card.setAvgCost(rs.getDouble("avg_cost")); } catch (SQLException ignored) {}
                try { card.setStatus(rs.getInt("status")); } catch (SQLException ignored) {}
                card.setCoverColor(getStringOrNull(rs, "cover_color"));
                card.setReason(defaultReason);
                return card;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private InsightCard fallbackCard(String type, String recommendType, String title, String subtitle, String reason) {
        InsightCard card = new InsightCard();
        card.setId(0);
        card.setType(type);
        card.setRecommendType(recommendType);
        card.setTitle(title);
        card.setSubtitle(subtitle);
        card.setReason(reason + "（示例推荐，发布更多评价后将自动更新）");
        card.setAvgScore(4.5);
        card.setAvgCost(15);
        card.setCoverColor("#7C3AED");
        return card;
    }
}
