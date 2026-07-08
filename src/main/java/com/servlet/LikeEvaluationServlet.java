package com.servlet;

import com.dao.EvaluationDAO;
import com.entity.User;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 评价点赞/取消点赞 Servlet
 * AJAX 接口，返回 JSON 格式结果
 */
@WebServlet("/LikeEvaluationServlet")
public class LikeEvaluationServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        User currentUser = (User) request.getSession().getAttribute("loginUser");
        if (currentUser == null) {
            response.getWriter().write("{\"success\":false,\"message\":\"\\u8bf7\\u5148\\u767b\\u5f55\"}");
            return;
        }

        try {
            int evalId = Integer.parseInt(request.getParameter("evalId"));
            EvaluationDAO dao = new EvaluationDAO();
            int newCount = dao.toggleLike(evalId, currentUser.getId());

            if (newCount >= 0) {
                boolean isLiked = dao.isLikedByUser(evalId, currentUser.getId());
                response.getWriter().write("{\"success\":true,\"likeCount\":" + newCount + ",\"isLiked\":" + isLiked + "}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"\\u64cd\\u4f5c\\u5931\\u8d25\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false,\"message\":\"\\u53c2\\u6570\\u9519\\u8bef\"}");
        }
    }
}
