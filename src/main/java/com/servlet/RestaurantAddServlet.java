package com.servlet;

import com.dao.RestaurantDAO;
import com.entity.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/admin/RestaurantAddServlet")
public class RestaurantAddServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        Restaurant restaurant = buildRestaurantFromRequest(request);

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        boolean flag = restaurantDAO.addRestaurant(restaurant);

        if (flag) {
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog("管理员", "添加餐厅", "后台管理员新增餐厅，名称：" + restaurant.getName());
            response.sendRedirect(request.getContextPath() + "/admin/RestaurantListServlet?addSuccess=1");
        } else {
            request.setAttribute("msg", "餐厅添加失败，请检查数据库字段是否已迁移");
            request.getRequestDispatcher("/admin/RestaurantListServlet").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    static Restaurant buildRestaurantFromRequest(HttpServletRequest request) {
        Restaurant restaurant = new Restaurant();
        restaurant.setName(trim(request.getParameter("name")));
        restaurant.setLocation(trim(request.getParameter("location")));
        restaurant.setOpenTime(trim(request.getParameter("openTime")));
        restaurant.setTags(trim(request.getParameter("tags")));
        restaurant.setDescription(trim(request.getParameter("description")));
        restaurant.setCoverColor(trim(request.getParameter("coverColor")));
        if (restaurant.getCoverColor() == null || restaurant.getCoverColor().isEmpty()) {
            restaurant.setCoverColor("#7C3AED");
        }
        restaurant.setAvgCost(parseCost(request.getParameter("avgCost")));
        restaurant.setStatus(parseStatus(request.getParameter("status")));
        return restaurant;
    }

    private static String trim(String value) {
        return value == null ? null : value.trim();
    }

    private static BigDecimal parseCost(String value) {
        if (value == null || value.trim().isEmpty()) {
            return new BigDecimal("15.00");
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return new BigDecimal("15.00");
        }
    }

    private static int parseStatus(String value) {
        if ("0".equals(value)) {
            return 0;
        }
        return 1;
    }
}
