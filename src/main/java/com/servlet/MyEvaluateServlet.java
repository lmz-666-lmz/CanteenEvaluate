package com.servlet;

import com.dao.EvaluationDAO;
import com.entity.Evaluation;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 我的评价页面 Servlet
 * 查询当前用户的评价记录，含分页和统计
 */
@WebServlet("/MyEvaluateServlet")
public class MyEvaluateServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 验证登录状态
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        EvaluationDAO dao = new EvaluationDAO();

        // 查询个人统计数据
        double[] stats = dao.getUserStats(currentUser.getId());
        int totalCount = (int) stats[0];
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("avgScore", String.format("%.1f", stats[1] != 0 ? stats[1] : 0.0));

        // 分页参数，默认每页6条
        int currentPage = 1;
        int pageSize = 6;

        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");

        if (pageParam != null && !pageParam.isEmpty()) {
            currentPage = Integer.parseInt(pageParam);
        }
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
            pageSize = Integer.parseInt(pageSizeParam);
        }

        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 边界校验
        if (currentPage < 1) currentPage = 1;
        if (totalPages > 0 && currentPage > totalPages) currentPage = totalPages;

        // DB端分页查询（不加载全部数据到内存）
        List<Evaluation> pagedList = dao.getMyEvaluations(currentUser.getId(), currentPage, pageSize);

        request.setAttribute("myEvaluations", pagedList);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("pageSize", pageSize);

        try {
            request.getRequestDispatcher("myEvaluate.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
