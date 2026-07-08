package com.servlet;

import com.dao.RestaurantDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/RestaurantDeleteServlet")
public class RestaurantDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        RestaurantDAO restaurantDAO = new RestaurantDAO();
        restaurantDAO.deleteById(id);

        // 记录操作日志
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog("管理员", "删除餐厅", "后台管理员删除ID为" + id + "的餐厅");

        response.sendRedirect(request.getContextPath() + "/admin/RestaurantListServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
