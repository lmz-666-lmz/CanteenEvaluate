package com.servlet;

import com.dao.UserDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/UserListServlet")
public class UserListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 分页参数
        int page = 1;
        int pageSize = com.dao.ConfigDAO.getInt("page_size", 10);
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        if (pageParam != null && !pageParam.isEmpty()) page = Integer.parseInt(pageParam);
        if (pageSizeParam != null && !pageSizeParam.isEmpty()) pageSize = Integer.parseInt(pageSizeParam);

        String keyword = request.getParameter("keyword");

        UserDAO userDAO = new UserDAO();
        List<User> userList = userDAO.findUsersByPage(page, pageSize, keyword);
        int totalCount = userDAO.getUserCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("userList", userList);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("/admin/userManage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
