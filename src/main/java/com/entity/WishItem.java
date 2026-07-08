package com.entity;

public class WishItem {
    private int id;
    private int userId;
    private int restaurantId;
    private String restaurantName;
    private String dishName;
    private String note;
    private int status;
    private String createTime;
    private String finishTime;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }
    public String getDishName() { return dishName; }
    public void setDishName(String dishName) { this.dishName = dishName; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
    public String getFinishTime() { return finishTime; }
    public void setFinishTime(String finishTime) { this.finishTime = finishTime; }
}
