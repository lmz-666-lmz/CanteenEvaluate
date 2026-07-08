package com.servlet;

import com.dao.RestaurantDAO;
import com.entity.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/RestaurantAddServlet")
public class RestaurantAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        boolean flag = restaurantDAO.addRestaurant(restaurant);

        if (flag) {
            // 记录操作日志
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog("管理员", "添加餐厅", "后台管理员新增餐厅，名称：" + name);
            response.sendRedirect(request.getContextPath() + "/admin/RestaurantListServlet?addSuccess=1");
        } else {
            request.setAttribute("msg", "餐厅名称已存在或添加失败");
            request.getRequestDispatcher("/admin/RestaurantListServlet").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
