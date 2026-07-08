package com.entity;

public class Announcement {
    private int id;
    private String title;
    private String content;
    private String createTime;
    private String updateTime;
    private int isActive;   // 1=显示 0=隐藏
    private int sortOrder;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getCreateTime() { return createTime; }
    public void setCreateTime(String createTime) { this.createTime = createTime; }
    public String getUpdateTime() { return updateTime; }
    public void setUpdateTime(String updateTime) { this.updateTime = updateTime; }
    public int getIsActive() { return isActive; }
    public void setIsActive(int isActive) { this.isActive = isActive; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }

    public Announcement() {}
}
