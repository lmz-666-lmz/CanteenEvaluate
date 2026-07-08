package com.servlet;

import com.dao.EvaluationDAO;
import com.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 用户端删除自己的评价
 */
@WebServlet("/DeleteEvaluateServlet")
public class DeleteEvaluateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        User currentUser = (User) request.getSession().getAttribute("loginUser");

        if (currentUser == null) {
            response.getWriter().write("error: 未登录，请先登录");
            return;
        }

        try {
            int evalId = Integer.parseInt(request.getParameter("id"));
            EvaluationDAO dao = new EvaluationDAO();
            boolean isDeleted = dao.delete(evalId, currentUser.getId());

            if (isDeleted) {
                // 记录操作日志
                com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
                sysLogDAO.insertLog(currentUser.getUsername(), "删除评价", "用户自主删除ID为" + evalId + "的个人评价");
                response.sendRedirect(request.getContextPath() + "/MyEvaluateServlet");
            } else {
                response.getWriter().write("error: 删除失败，只能删除自己的评价");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("error: 参数格式不正确");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error: 服务器内部异常");
        }
    }
}
