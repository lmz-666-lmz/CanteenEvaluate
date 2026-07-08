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

@WebServlet("/TasteProfileServlet")
public class TasteProfileServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        FoodInsightDAO insightDAO = new FoodInsightDAO();
        WishDAO wishDAO = new WishDAO();
        request.setAttribute("tasteProfile", insightDAO.getTasteProfile(currentUser.getId()));
        request.setAttribute("openWishCount", wishDAO.countOpen(currentUser.getId()));
        request.getRequestDispatcher("tasteProfile.jsp").forward(request, response);
    }
}
