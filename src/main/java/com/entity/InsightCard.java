package com.entity;

public class InsightCard {
    private int id;
    private int rank;
    private String type;
    private String title;
    private String subtitle;
    private String reason;
    private String trendLabel;
    private int reviewCount;
    private int likeCount;
    private double avgScore;
    private double tasteAvg;
    private double priceAvg;
    private double serviceAvg;
    private double heatScore;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    public String getTrendLabel() { return trendLabel; }
    public void setTrendLabel(String trendLabel) { this.trendLabel = trendLabel; }
    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }
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
    public double getHeatScore() { return heatScore; }
    public void setHeatScore(double heatScore) { this.heatScore = heatScore; }
}
