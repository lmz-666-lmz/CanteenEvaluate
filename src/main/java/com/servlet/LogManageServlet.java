package com.servlet;

import com.dao.SysLogDAO;
import com.entity.SysLog;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/LogManageServlet")
public class LogManageServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // 分页参数
        int page = 1;
        int pageSize = com.dao.ConfigDAO.getInt("page_size", 15);
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        if (pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) pageSize = Integer.parseInt(pageSizeParam);

        String keyword = request.getParameter("keyword");

        SysLogDAO dao = new SysLogDAO();
        List<SysLog> logList = dao.findByPage(page, pageSize, keyword);
        int totalCount = dao.getCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("logList", logList);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/logManage.jsp").forward(request, response);
    }
}
