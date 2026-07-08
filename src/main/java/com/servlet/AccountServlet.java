package com.servlet;

import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 账号设置页面 Servlet
 * 检查登录状态后跳转到账号设置页
 */
@WebServlet("/AccountServlet")
public class AccountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            request.getRequestDispatcher("account.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
