package com.entity;

import java.sql.Timestamp;

public class SysLog {
    private int id;
    private String username;
    private String action_type;
    private String action_detail;
    private Timestamp create_time;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getAction_type() { return action_type; }
    public void setAction_type(String action_type) { this.action_type = action_type; }
    public String getAction_detail() { return action_detail; }
    public void setAction_detail(String action_detail) { this.action_detail = action_detail; }
    public Timestamp getCreate_time() { return create_time; }
    public void setCreate_time(Timestamp create_time) { this.create_time = create_time; }
}
