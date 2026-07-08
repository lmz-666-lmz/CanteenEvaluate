package com.servlet;

import com.dao.FoodInsightDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/FoodInsightServlet")
public class AdminFoodInsightServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FoodInsightDAO insightDAO = new FoodInsightDAO();
        request.setAttribute("campusStats", insightDAO.getCampusStats());
        request.setAttribute("restaurantTrends", insightDAO.getRestaurantTrends(8));
        request.setAttribute("dishTrends", insightDAO.getDishTrends(8));
        request.setAttribute("creatorTrends", insightDAO.getCreatorTrends(8));
        request.setAttribute("scoreBuckets", insightDAO.getScoreBuckets());
        request.getRequestDispatcher("/admin/foodInsight.jsp").forward(request, response);
    }
}
