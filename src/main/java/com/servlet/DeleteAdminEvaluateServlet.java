package com.servlet;

import com.dao.EvaluationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 管理员删除评价
 */
@WebServlet("/admin/DeleteAdminEvaluateServlet")
public class DeleteAdminEvaluateServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.isEmpty()) {
            int id = Integer.parseInt(idStr);
            EvaluationDAO dao = new EvaluationDAO();
            boolean success = dao.deleteEvaluation(id);

            if (success) {
                request.setAttribute("msg", "评价删除成功");
                // 记录操作日志
                com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
                sysLogDAO.insertLog("管理员", "删除评价", "后台管理员删除ID为" + id + "的用户评价");
            } else {
                request.setAttribute("msg", "删除失败，请联系系统管理员");
            }
        }
        request.getRequestDispatcher("/admin/EvaluationManageServlet").forward(request, response);
    }
}
