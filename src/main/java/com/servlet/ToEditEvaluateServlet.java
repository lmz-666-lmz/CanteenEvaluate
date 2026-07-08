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
 * 跳转编辑评价页面 Servlet
 * 根据评价ID查询当前用户自己的评价数据，携带餐厅列表转发到编辑页
 * 仅能编辑本人发布的评价，防止越权
 */
@WebServlet("/ToEditEvaluateServlet")
public class ToEditEvaluateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("MyEvaluateServlet");
            return;
        }

        int evalId = Integer.parseInt(idStr);
        EvaluationDAO dao = new EvaluationDAO();
        // 双重校验：评价ID + 用户ID
        Evaluation eval = dao.getByIdAndUserId(evalId, currentUser.getId());

        if (eval == null) {
            response.sendRedirect("MyEvaluateServlet");
            return;
        }

        // 查询餐厅列表供编辑页下拉选择
        RestaurantDAO restDAO = new RestaurantDAO();
        List<Restaurant> restList = restDAO.getAllRestaurants();

        request.setAttribute("restaurantList", restList);
        request.setAttribute("eval", eval);
        request.getRequestDispatcher("editEvaluate.jsp").forward(request, response);
    }
}
