package com.servlet;

import com.dao.UserDAO;
import com.entity.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/UserDeleteServlet")
public class UserDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));
        UserDAO userDAO = new UserDAO();

        // 查询目标用户信息
        User targetUser = userDAO.findUserById(id);

        // 禁止删除管理员账号
        if (targetUser != null && targetUser.getRole() != null && targetUser.getRole() == 1) {
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog("管理员", "非法删除拦截", "尝试删除管理员账号ID:" + id + "，已被系统拦截");
            response.getWriter().println("<script>alert('禁止删除管理员账号，只能删除普通用户');location.href='" + request.getContextPath() + "/admin/UserListServlet'</script>");
            return;
        }

        // 仅删除普通用户
        userDAO.deleteUserById(id);
        com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
        sysLogDAO.insertLog("管理员", "删除用户", "后台管理员删除ID为" + id + "的普通用户");

        response.sendRedirect(request.getContextPath() + "/admin/UserListServlet");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
