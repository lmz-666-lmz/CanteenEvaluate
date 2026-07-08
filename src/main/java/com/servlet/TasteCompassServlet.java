package com.servlet;

import com.dao.FoodInsightDAO;
import com.dao.WishDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/TasteCompassServlet")
public class TasteCompassServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String mood = request.getParameter("mood");
        String budget = request.getParameter("budget");
        if (mood == null || mood.trim().isEmpty()) mood = "balanced";
        if (budget == null || budget.trim().isEmpty()) budget = "any";

        FoodInsightDAO insightDAO = new FoodInsightDAO();
        request.setAttribute("mood", mood);
        request.setAttribute("budget", budget);
        request.setAttribute("campusStats", insightDAO.getCampusStats());
        request.setAttribute("recommendations", insightDAO.getRecommendations(mood, budget, 9));
        request.setAttribute("restaurantTrends", insightDAO.getRestaurantTrends(5));
        request.setAttribute("dishTrends", insightDAO.getDishTrends(5));

        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser != null) {
            request.setAttribute("openWishCount", new WishDAO().countOpen(currentUser.getId()));
        }

        request.getRequestDispatcher("tasteCompass.jsp").forward(request, response);
    }
}
