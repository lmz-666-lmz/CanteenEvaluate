package com.entity;

public class Evaluation {
    private int id;
    private int userId;
    private int restaurantId;
    private String dishName;
    private String content;

    private int tasteScore;
    private int priceScore;
    private int serviceScore;
    private String username;

    // 联表查询字段
    private String authorNickname;
    private String restaurantName;

    // v2.0 新增字段
    private int likeCount;
    private String updateTime;
    private boolean likedByCurrentUser;
    private double insightScore;
    private String recommendReason;

    // --- Getter / Setter ---
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getTasteScore() { return tasteScore; }
    public void setTasteScore(int tasteScore) { this.tasteScore = tasteScore; }
    public int getPriceScore() { return priceScore; }
    public void setPriceScore(int priceScore) { this.priceScore = priceScore; }
    public int getServiceScore() { return serviceScore; }
    public void setServiceScore(int serviceScore) { this.serviceScore = serviceScore; }

    public String getAuthorNickname() { return authorNickname; }
    public void setAuthorNickname(String authorNickname) { this.authorNickname = authorNickname; }
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public String getUpdateTime() { return updateTime; }
    public void setUpdateTime(String updateTime) { this.updateTime = updateTime; }
    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { this.likedByCurrentUser = likedByCurrentUser; }
    public double getInsightScore() { return insightScore; }
    public void setInsightScore(double insightScore) { this.insightScore = insightScore; }
    public String getRecommendReason() { return recommendReason; }
    public void setRecommendReason(String recommendReason) { this.recommendReason = recommendReason; }

    public Evaluation() {}
}
