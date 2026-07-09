package com.servlet;

import com.dao.FoodInsightDAO;
import com.dao.RestaurantDAO;
import com.entity.CampusStats;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/stats")
public class StatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-cache");

        FoodInsightDAO insightDAO = new FoodInsightDAO();
        RestaurantDAO restDAO = new RestaurantDAO();
        CampusStats s = insightDAO.getCampusStats();
        int rc = 0;
        try { rc = restDAO.getAllRestaurants().size(); } catch (Exception ignored) {}

        String json = String.format(
            "{\"users\":%d,\"restaurants\":%d,\"evals\":%d,\"active\":%d,\"avgScore\":%.1f,\"dishes\":%d}",
            s.getUserCount(), rc > 0 ? rc : s.getRestaurantCount(),
            s.getEvaluationCount(), s.getActiveUserCount(),
            s.getAvgScore(), s.getDishCount()
        );
        resp.getWriter().write(json);
    }
}
