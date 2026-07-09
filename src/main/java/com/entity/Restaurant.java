package com.entity;

import java.math.BigDecimal;

public class Restaurant {
    private int id;
    private String name;
    private String location;
    private String openTime;
    private String tags;
    private String description;
    private BigDecimal avgCost;
    private int status = 1;
    private String coverColor = "#7C3AED";

    public Restaurant() {}

    public Restaurant(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getOpenTime() { return openTime; }
    public void setOpenTime(String openTime) { this.openTime = openTime; }

    public String getTags() { return tags; }
    public void setTags(String tags) { this.tags = tags; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getAvgCost() { return avgCost; }
    public void setAvgCost(BigDecimal avgCost) { this.avgCost = avgCost; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getCoverColor() { return coverColor; }
    public void setCoverColor(String coverColor) { this.coverColor = coverColor; }

    public boolean isOpen() {
        return status == 1;
    }

    public String getStatusLabel() {
        return status == 1 ? "营业中" : "暂停营业";
    }

    public String[] getTagArray() {
        if (tags == null || tags.trim().isEmpty()) {
            return new String[0];
        }
        String[] parts = tags.split(",");
        java.util.List<String> list = new java.util.ArrayList<>();
        for (String part : parts) {
            String trimmed = part.trim();
            if (!trimmed.isEmpty()) {
                list.add(trimmed);
            }
        }
        return list.toArray(new String[0]);
    }

    public String getDisplayLocation() {
        return location != null && !location.trim().isEmpty() ? location.trim() : "位置待补充";
    }

    public String getDisplayOpenTime() {
        return openTime != null && !openTime.trim().isEmpty() ? openTime.trim() : "营业时间待更新";
    }

    public String getDisplayDescription() {
        return description != null && !description.trim().isEmpty() ? description.trim() : "暂无简介，欢迎同学补充评价。";
    }

    public String getDisplayAvgCost() {
        if (avgCost == null) {
            return "约 ¥15";
        }
        return "约 ¥" + avgCost.stripTrailingZeros().toPlainString();
    }
}
