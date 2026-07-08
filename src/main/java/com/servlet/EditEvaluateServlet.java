package com.servlet;

import com.dao.EvaluationDAO;
import com.entity.Evaluation;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/EditEvaluateServlet")
public class EditEvaluateServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String dishName = request.getParameter("dishName");
        String content = request.getParameter("content");
        int tasteScore = Integer.parseInt(request.getParameter("tasteScore"));
        int priceScore = Integer.parseInt(request.getParameter("priceScore"));
        int serviceScore = Integer.parseInt(request.getParameter("serviceScore"));

        Evaluation eval = new Evaluation();
        eval.setId(id);
        eval.setUserId(currentUser.getId());  // 绑定当前用户，防止越权修改
        eval.setDishName(dishName);
        eval.setContent(content);
        eval.setTasteScore(tasteScore);
        eval.setPriceScore(priceScore);
        eval.setServiceScore(serviceScore);

        EvaluationDAO dao = new EvaluationDAO();
        dao.update(eval);

        // 记录操作日志
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog(currentUser.getUsername(), "修改评价", "用户修改个人评价，菜品名：" + dishName);

        // 修改完成返回我的评价列表
        response.sendRedirect("MyEvaluateServlet");
    }
}
