package com.servlet;
import com.dao.UserDAO;
import com.entity.User;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");
        String confirmPwd = request.getParameter("confirmPwd");

        String errorMsg = "";
        if (username == null || username.trim().isEmpty()) errorMsg = "用户名不能为空";
        else if (nickname == null || nickname.trim().isEmpty()) errorMsg = "昵称不能为空";
        else if (password == null || password.trim().isEmpty()) errorMsg = "密码不能为空";
        else if (!password.equals(confirmPwd)) errorMsg = "两次密码不一致";
        else if (password.length() < 6) errorMsg = "密码至少6位";
        else if (!password.matches("^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{6,}$")) errorMsg = "密码需包含字母和数字";

        if (!errorMsg.isEmpty()) {
            request.setAttribute("errorMsg", errorMsg);
            request.setAttribute("username", username);
            request.setAttribute("nickname", nickname);
            try { request.getRequestDispatcher("register.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
            return;
        }

        UserDAO dao = new UserDAO();
        if (dao.checkUsernameExists(username)) {
            request.setAttribute("errorMsg", "用户名已存在");
            request.setAttribute("nickname", nickname);
            try { request.getRequestDispatcher("register.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
            return;
        }

        User newUser = new User();
        newUser.setUsername(username.trim());
        newUser.setPassword(password);  // addUser内部会使用PasswordUtil哈希
        newUser.setNickname(nickname.trim());

        if (dao.addUser(newUser)) {
            request.setAttribute("successMsg", "注册成功，请登录");
            try { request.getRequestDispatcher("login.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
        } else {
            request.setAttribute("errorMsg", "注册失败，请重试");
            try { request.getRequestDispatcher("register.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try { request.getRequestDispatcher("register.jsp").forward(request, response); } catch (Exception e) { e.printStackTrace(); }
    }
}
