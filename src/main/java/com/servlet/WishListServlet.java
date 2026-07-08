package com.servlet;

import com.dao.RestaurantDAO;
import com.dao.WishDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/WishListServlet")
public class WishListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        WishDAO wishDAO = new WishDAO();
        boolean tableReady = wishDAO.isTableReady();
        request.setAttribute("tableReady", tableReady);
        request.setAttribute("restaurantList", new RestaurantDAO().getAllRestaurants());
        if (tableReady) {
            request.setAttribute("openItems", wishDAO.findByUser(currentUser.getId(), 0));
            request.setAttribute("doneItems", wishDAO.findByUser(currentUser.getId(), 1));
        }
        request.getRequestDispatcher("wishList.jsp").forward(request, response);
    }
}
