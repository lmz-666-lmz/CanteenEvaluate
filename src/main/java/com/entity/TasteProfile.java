package com.entity;

import java.util.ArrayList;
import java.util.List;

public class TasteProfile {
    private int totalCount;
    private int restaurantCount;
    private int likeCount;
    private double avgScore;
    private double tasteAvg;
    private double priceAvg;
    private double serviceAvg;
    private String favoriteRestaurant;
    private String favoriteDish;
    private String personaName;
    private String personaDesc;
    private String strongestDimension;
    private final List<String> badges = new ArrayList<>();
    private List<Evaluation> recentEvaluations = new ArrayList<>();
    private List<InsightCard> topRestaurants = new ArrayList<>();

    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public int getRestaurantCount() { return restaurantCount; }
    public void setRestaurantCount(int restaurantCount) { this.restaurantCount = restaurantCount; }
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    public double getAvgScore() { return avgScore; }
    public void setAvgScore(double avgScore) { this.avgScore = avgScore; }
    public double getTasteAvg() { return tasteAvg; }
    public void setTasteAvg(double tasteAvg) { this.tasteAvg = tasteAvg; }
    public double getPriceAvg() { return priceAvg; }
    public void setPriceAvg(double priceAvg) { this.priceAvg = priceAvg; }
    public double getServiceAvg() { return serviceAvg; }
    public void setServiceAvg(double serviceAvg) { this.serviceAvg = serviceAvg; }
    public String getFavoriteRestaurant() { return favoriteRestaurant; }
    public void setFavoriteRestaurant(String favoriteRestaurant) { this.favoriteRestaurant = favoriteRestaurant; }
    public String getFavoriteDish() { return favoriteDish; }
    public void setFavoriteDish(String favoriteDish) { this.favoriteDish = favoriteDish; }
    public String getPersonaName() { return personaName; }
    public void setPersonaName(String personaName) { this.personaName = personaName; }
    public String getPersonaDesc() { return personaDesc; }
    public void setPersonaDesc(String personaDesc) { this.personaDesc = personaDesc; }
    public String getStrongestDimension() { return strongestDimension; }
    public void setStrongestDimension(String strongestDimension) { this.strongestDimension = strongestDimension; }
    public List<String> getBadges() { return badges; }
    public List<Evaluation> getRecentEvaluations() { return recentEvaluations; }
    public void setRecentEvaluations(List<Evaluation> recentEvaluations) { this.recentEvaluations = recentEvaluations; }
    public List<InsightCard> getTopRestaurants() { return topRestaurants; }
    public void setTopRestaurants(List<InsightCard> topRestaurants) { this.topRestaurants = topRestaurants; }
}
