package com.servlet;
import com.dao.UserDAO;
import com.entity.User;
import com.util.PasswordUtil;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");
        User currentUser = (User) request.getSession().getAttribute("loginUser");

        if (currentUser == null) {
            response.getWriter().write("error: 未登录");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        if ("updateNickname".equals(action)) {
            String nickname = request.getParameter("nickname");
            if (nickname == null || nickname.trim().isEmpty()) {
                response.getWriter().write("昵称不能为空");
                return;
            }
            dao.updateNickname(currentUser.getId(), nickname.trim());
            currentUser.setNickname(nickname.trim());

            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog(currentUser.getUsername(), "修改昵称", "成功修改个人昵称为：" + nickname.trim());
            response.getWriter().write("success");
        } else if ("updatePwd".equals(action)) {
            String oldPwd = request.getParameter("oldPwd");
            String newPwd = request.getParameter("newPwd");

            // 验证旧密码（使用PasswordUtil）
            if (!PasswordUtil.verify(oldPwd, currentUser.getPassword())) {
                response.getWriter().write("旧密码错误");
                return;
            }
            if (newPwd.length() < 6 || !newPwd.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$")) {
                response.getWriter().write("新密码至少6位且包含字母和数字");
                return;
            }

            dao.updatePassword(currentUser.getId(), newPwd);  // DAO内部使用PasswordUtil哈希
            String hashedPwd = PasswordUtil.hash(newPwd);
            currentUser.setPassword(hashedPwd);
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog(currentUser.getUsername(), "修改密码", "成功修改了登录密码");
            response.getWriter().write("success");
        }
    }
}
