package com.servlet;
import com.dao.UserDAO;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String inputCode = request.getParameter("verifyCode");
        String sessionCode = (String) request.getSession().getAttribute("verifyCode");

        if (inputCode == null || sessionCode == null || !inputCode.equalsIgnoreCase(sessionCode)) {
            request.setAttribute("errorMsg", "验证码错误");
            request.setAttribute("username", username);
            try { request.getRequestDispatcher("login.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
            return;
        }

        UserDAO dao = new UserDAO();
        User user = dao.login(username, password);  // DAO内部已使用PasswordUtil验证

        if (user != null) {
            // 检查是否为管理员（管理员应通过AdminLoginServlet登录）
            if (user.getRole() != null && user.getRole() == 1) {
                request.setAttribute("errorMsg", "管理员请通过管理员入口登录");
                request.setAttribute("username", username);
                try { request.getRequestDispatcher("login.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
                return;
            }
            request.getSession().removeAttribute("verifyCode");
            // 安全：不将密码哈希存入Session
            user.setPassword(null);
            request.getSession().setAttribute("loginUser", user);
            com.dao.SysLogDAO sysLogDAO = new com.dao.SysLogDAO();
            sysLogDAO.insertLog(username, "系统登录", "普通用户登录成功");
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("errorMsg", "用户名或密码错误");
            request.setAttribute("username", username);
            try { request.getRequestDispatcher("login.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}
