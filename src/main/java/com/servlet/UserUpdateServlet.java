package com.servlet;

import com.dao.UserDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/UserUpdateServlet")
public class UserUpdateServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String nickname = request.getParameter("nickname");

        User user = new User();
        user.setId(id);
        user.setUsername(username);
        user.setPassword(password);
        user.setNickname(nickname);

        UserDAO userDAO = new UserDAO();
        userDAO.updateUser(user);

        // 记录操作日志
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog("管理员", "修改用户", "后台管理员修改ID为" + id + "的用户账号，用户名：" + username);

        response.sendRedirect(request.getContextPath() + "/admin/UserListServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
