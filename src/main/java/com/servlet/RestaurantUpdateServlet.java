package com.servlet;

import com.dao.RestaurantDAO;
import com.entity.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/RestaurantUpdateServlet")
public class RestaurantUpdateServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");

        Restaurant restaurant = new Restaurant();
        restaurant.setId(id);
        restaurant.setName(name);

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        restaurantDAO.updateRestaurant(restaurant);

        // 记录操作日志
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog("管理员", "修改餐厅", "后台管理员修改ID为" + id + "的餐厅名称：" + name);

        response.sendRedirect(request.getContextPath() + "/admin/RestaurantListServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
