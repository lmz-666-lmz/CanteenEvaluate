package com.servlet;

import com.dao.UserDAO;
import com.dao.EvaluationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import com.entity.Evaluation;

/**
 * 仪表盘统计 Servlet
 * 为 adminIndex.jsp 提供真实统计数据
 */
@WebServlet("/admin/DashboardStatsServlet")
public class DashboardStatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        int[] stats = userDAO.getDashboardStats();

        request.setAttribute("statsUserCount", stats[0]);
        request.setAttribute("statsRestCount", stats[1]);
        request.setAttribute("statsEvalCount", stats[2]);
        request.setAttribute("statsLogCount", stats[3]);

        // 获取最近5条评价供快捷查看
        EvaluationDAO evalDAO = new EvaluationDAO();
        List<Evaluation> recentEvals = evalDAO.findByPage(1, 5, null);
        request.setAttribute("recentEvaluations", recentEvals);

        request.getRequestDispatcher("/admin/adminIndex.jsp").forward(request, response);
    }
}
