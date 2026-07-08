<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalCount = (Integer) request.getAttribute("totalCount");
    Integer pageSize = (Integer) request.getAttribute("pageSize");
    String keyword = (String) request.getAttribute("keyword");
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (pageSize == null) pageSize = 10;
    if (keyword == null) keyword = "";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>内容审核 · 山海寻味录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-modern.css">
</head>
<body>
<div class="admin-layout">
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/images/logo.svg" alt="Logo">
            <div class="sidebar-brand-text"><h2>山海寻味录</h2><span>管理员后台</span></div>
        </div>
        <nav class="sidebar-nav">
            <div class="sidebar-nav-label">主菜单</div>
            <a href="<%= request.getContextPath() %>/admin/DashboardStatsServlet" data-page="DashboardStats"><span class="nav-icon">🏠</span> 控制台</a>
            <a href="<%= request.getContextPath() %>/admin/UserListServlet" data-page="UserList"><span class="nav-icon">👥</span> 用户管理</a>
            <a href="<%= request.getContextPath() %>/admin/RestaurantListServlet" data-page="RestaurantList"><span class="nav-icon">🍴</span> 餐厅管理</a>
            <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" class="active" data-page="EvaluationManage"><span class="nav-icon">💬</span> 内容审核</a>
            <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" data-page="AnnouncementManage"><span class="nav-icon">📢</span> 公告管理</a>
            <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" data-page="FoodInsight"><span class="nav-icon">📊</span> 数据洞察</a>
            <a href="${pageContext.request.contextPath}/admin/LogManageServlet" data-page="LogManage"><span class="nav-icon">📜</span> 系统日志</a>
        </nav>
        <div class="sidebar-footer">
            <%
                com.entity.User sidebarUser = (com.entity.User) session.getAttribute("adminUser");
                String nickname = sidebarUser != null ? sidebarUser.getNickname() : "Admin";
            %>
            <div class="sidebar-user">
                <div class="sidebar-user-avatar"><%= nickname.substring(0, 1).toUpperCase() %></div>
                <div class="sidebar-user-info"><div class="name"><%= nickname %></div><div class="role">系统管理员</div></div>
            </div>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="sidebar-logout">⏻ 退出登录</a>
        </div>
    </aside>

    <main class="admin-main">
        <div class="topbar">
            <div class="topbar-breadcrumb">控制台 <span>/</span> <span>内容审核</span></div>
            <div class="topbar-actions"><span class="topbar-date" id="currentDate"></span></div>
        </div>

        <div class="page-content">
            <div class="page-header flex-between">
                <div><h1>💬 评价内容审核</h1><p>全局查看所有评价，及时处理违规内容</p></div>
                <div style="display:flex;align-items:center;gap:var(--space-4);">
                    <div class="page-size-select">
                        每页
                        <select onchange="changePageSize(this.value)">
                            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 条</option>
                            <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 条</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 条</option>
                        </select>
                    </div>
                    <span class="badge badge-warning"><%= totalCount %> 条评价</span>
                </div>
            </div>

            <c:if test="${not empty requestScope.msg}">
                <div class="alert alert-success">✅ ${requestScope.msg}</div>
            </c:if>

            <!-- Search Bar -->
            <div class="search-bar">
                <form action="<%= request.getContextPath() %>/admin/EvaluationManageServlet" method="get" class="search-form">
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="搜索用户名、菜品名或餐厅名..." class="search-input">
                    <button type="submit" class="btn btn-primary btn-sm">🔍 搜索</button>
                    <% if (!keyword.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/admin/EvaluationManageServlet" class="btn btn-outline btn-sm">✕ 清除</a>
                    <% } %>
                </form>
            </div>

            <div class="card">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>ID</th><th>发布用户</th><th>所属餐厅</th><th>菜品名称</th><th>评价内容</th><th>评分</th><th style="text-align:right;">操作</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${evaluations}" var="eval">
                                <tr>
                                    <td><span class="cell-id">#${eval.id}</span></td>
                                    <td class="cell-user">${eval.username}</td>
                                    <td>${eval.restaurantName}</td>
                                    <td>${eval.dishName}</td>
                                    <td><span class="cell-content" title="${eval.content}">${eval.content}</span></td>
                                    <td><span class="cell-scores">口味 ${eval.tasteScore} / 价格 ${eval.priceScore} / 服务 ${eval.serviceScore}</span></td>
                                    <td style="text-align:right;">
                                        <button class="btn btn-danger btn-sm" onclick="confirmDelete('${pageContext.request.contextPath}/admin/DeleteAdminEvaluateServlet?id=${eval.id}', '确定要删除这条评价吗？此操作不可恢复！')">✕ 删除</button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty evaluations}">
                                <tr><td colspan="7"><div class="empty-state"><div class="empty-icon">💬</div><p>当前系统没有任何评价数据</p></div></td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pagination -->
            <% if (totalPages > 1) { %>
            <div class="pagination-bar">
                <div class="pagination-info">共 <strong><%= totalCount %></strong> 条，第 <strong><%= currentPage %></strong>/<strong><%= totalPages %></strong> 页</div>
                <div class="pagination-btns">
                    <% if (currentPage > 1) { %>
                    <a href="?page=1&pageSize=<%= pageSize %>&keyword=<%= keyword %>" class="page-btn">««</a>
                    <a href="?page=<%= currentPage - 1 %>&pageSize=<%= pageSize %>&keyword=<%= keyword %>" class="page-btn">«</a>
                    <% } %>
                    <% for (int i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) { %>
                    <a href="?page=<%= i %>&pageSize=<%= pageSize %>&keyword=<%= keyword %>" class="page-btn <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                    <% } %>
                    <% if (currentPage < totalPages) { %>
                    <a href="?page=<%= currentPage + 1 %>&pageSize=<%= pageSize %>&keyword=<%= keyword %>" class="page-btn">»</a>
                    <a href="?page=<%= totalPages %>&pageSize=<%= pageSize %>&keyword=<%= keyword %>" class="page-btn">»»</a>
                    <% } %>
                </div>
            </div>
            <% } %>
        </div>

        <div class="admin-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录 · 联系邮箱：8224439@qq.com</div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/admin/js/admin-modern.js"></script>
<script>
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('zh-CN', { year:'numeric', month:'long', day:'numeric', weekday:'long' });
    function changePageSize(newSize) {
        window.location.href = 'EvaluationManageServlet?page=1&pageSize=' + newSize + '&keyword=<%= keyword %>';
    }
    function confirmDelete(url, message) { showConfirm(message, function() { window.location.href = url; }); }
</script>
</body>
</html>
