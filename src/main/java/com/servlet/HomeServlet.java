package com.servlet;

import com.dao.AnnouncementDAO;
import com.dao.FoodInsightDAO;
import com.dao.RestaurantDAO;
import com.entity.InsightCard;
import com.entity.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        FoodInsightDAO insightDAO = new FoodInsightDAO();

        List<Restaurant> allRestaurants = restaurantDAO.getAllRestaurants();
        // 首页只展示最火的 3 家
        List<Restaurant> restaurantList = allRestaurants.size() > 3
                ? allRestaurants.subList(0, 3) : allRestaurants;
        List<InsightCard> mealRecommendations = insightDAO.getHomeMealRecommendations();

        try {
            AnnouncementDAO annDAO = new AnnouncementDAO();
            request.setAttribute("announcements", annDAO.getActiveAnnouncements());
        } catch (Exception e) {
            request.setAttribute("announcements", null);
        }

        request.setAttribute("restaurantList", restaurantList);
        request.setAttribute("mealRecommendations", mealRecommendations);
        request.setAttribute("homeLoaded", Boolean.TRUE);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
