package com.entity;

public class CampusStats {
    private int userCount;
    private int restaurantCount;
    private int evaluationCount;
    private int dishCount;
    private int likeCount;
    private int activeUserCount;
    private double avgScore;
    private String topRestaurant;
    private String topDish;

    public int getUserCount() { return userCount; }
    public void setUserCount(int userCount) { this.userCount = userCount; }
    public int getRestaurantCount() { return restaurantCount; }
    public void setRestaurantCount(int restaurantCount) { this.restaurantCount = restaurantCount; }
    public int getEvaluationCount() { return evaluationCount; }
    public void setEvaluationCount(int evaluationCount) { this.evaluationCount = evaluationCount; }
    public int getDishCount() { return dishCount; }
    public void setDishCount(int dishCount) { this.dishCount = dishCount; }
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public int getActiveUserCount() { return activeUserCount; }
    public void setActiveUserCount(int activeUserCount) { this.activeUserCount = activeUserCount; }
    public double getAvgScore() { return avgScore; }
    public void setAvgScore(double avgScore) { this.avgScore = avgScore; }
    public String getTopRestaurant() { return topRestaurant; }
    public void setTopRestaurant(String topRestaurant) { this.topRestaurant = topRestaurant; }
    public String getTopDish() { return topDish; }
    public void setTopDish(String topDish) { this.topDish = topDish; }
}
