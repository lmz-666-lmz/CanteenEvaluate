package com.servlet;

import com.dao.EvaluationDAO;
import com.dao.RestaurantDAO;
import com.entity.Evaluation;
import com.entity.Restaurant;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 发布评价 Servlet
 * GET: 返回发布评价页面，携带餐厅列表供选择
 * POST: 接收表单提交，封装实体写入数据库，记录操作日志
 */
@WebServlet("/AddEvaluateServlet")
public class AddEvaluateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 检查登录状态
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 查询所有餐厅供下拉选择
        RestaurantDAO restDAO = new RestaurantDAO();
        List<Restaurant> restList = restDAO.getAllRestaurants();
        request.setAttribute("restaurantList", restList);

        request.getRequestDispatcher("addEvaluate.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 获取表单参数
        String restIdStr = request.getParameter("restaurantId");
        String dishName = request.getParameter("dishName");
        String content = request.getParameter("content");

        if (restIdStr == null || restIdStr.trim().isEmpty()) {
            response.sendRedirect("AddEvaluateServlet");
            return;
        }
        int restaurantId = Integer.parseInt(restIdStr);

        // 评分默认5分，容错处理
        int tasteScore = 5, priceScore = 5, serviceScore = 5;
        try {
            if (request.getParameter("tasteScore") != null)
                tasteScore = Integer.parseInt(request.getParameter("tasteScore"));
            if (request.getParameter("priceScore") != null)
                priceScore = Integer.parseInt(request.getParameter("priceScore"));
            if (request.getParameter("serviceScore") != null)
                serviceScore = Integer.parseInt(request.getParameter("serviceScore"));
        } catch (NumberFormatException e) {
            System.out.println("评分格式转换失败，使用默认值5分");
        }

        // 封装实体
        Evaluation eval = new Evaluation();
        eval.setUserId(currentUser.getId());
        eval.setRestaurantId(restaurantId);
        eval.setDishName(dishName.trim());
        eval.setContent(content.trim());
        eval.setTasteScore(tasteScore);
        eval.setPriceScore(priceScore);
        eval.setServiceScore(serviceScore);

        // 写入数据库
        EvaluationDAO dao = new EvaluationDAO();
        dao.add(eval);

        // 记录操作日志
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog(currentUser.getUsername(), "发布评价", "用户发布菜品评价，菜品名：" + dishName.trim());

        // 提交成功跳转全站评价页，防止F5重复提交
        response.sendRedirect("AllEvaluateServlet");
    }
}
