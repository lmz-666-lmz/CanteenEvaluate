package com.servlet;

import com.dao.UserDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User admin = userDAO.adminLogin(username, password);  // DAO内部使用PasswordUtil验证

        if (admin != null) {
            HttpSession session = request.getSession();
            // 安全：不将密码哈希存入Session
            admin.setPassword(null);
            session.setAttribute("adminUser", admin);
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog(username, "系统登录", "管理员登录后台成功");
            response.sendRedirect(request.getContextPath() + "/admin/DashboardStatsServlet");
        } else {
            request.setAttribute("msg", "管理员账号或密码错误");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
