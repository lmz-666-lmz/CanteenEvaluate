package com.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 管理员权限过滤器
 * 拦截 /admin/ 开头的后台资源，校验管理员登录状态
 * 未登录的管理员将被强制跳转到登录页
 */
@WebFilter("/admin/*")
public class AdminFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        // 从Session中获取管理员登录信息
        Object adminUser = session.getAttribute("adminUser");

        // 未登录：重定向到登录页
        if (adminUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 已登录：放行
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
