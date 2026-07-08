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
    if (pageSize == null) pageSize = 15;
    if (keyword == null) keyword = "";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系统日志 · 山海寻味录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-modern.css">
    <style>
        .log-tag { display:inline-block;padding:3px 10px;border-radius:999px;font-size:var(--text-xs);font-weight:600;letter-spacing:0.01em; }
        .log-tag.login  { background:#EFF6FF; color:#3B82F6; }
        .log-tag.logout { background:#FEF2F2; color:#EF4444; }
        .log-tag.create { background:#ECFDF5; color:#10B981; }
        .log-tag.update { background:#FFFBEB; color:#F59E0B; }
        .log-tag.delete { background:#FEF2F2; color:#DC2626; }
        .log-tag.view   { background:#F1F5F9; color:#64748B; }
        .log-tag.other  { background:#F8FAFC; color:#475569; }
    </style>
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
            <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" data-page="EvaluationManage"><span class="nav-icon">💬</span> 内容审核</a>
            <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" data-page="AnnouncementManage"><span class="nav-icon">📢</span> 公告管理</a>
            <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" data-page="FoodInsight"><span class="nav-icon">📊</span> 数据洞察</a>
            <a href="${pageContext.request.contextPath}/admin/LogManageServlet" class="active" data-page="LogManage"><span class="nav-icon">📜</span> 系统日志</a>
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
            <div class="topbar-breadcrumb">控制台 <span>/</span> <span>系统日志</span></div>
            <div class="topbar-actions"><span class="topbar-date" id="currentDate"></span></div>
        </div>

        <div class="page-content">
            <div class="page-header flex-between">
                <div><h1>📜 系统日志</h1><p>监控关键操作记录与登录历史，用于安全审计</p></div>
                <div style="display:flex;align-items:center;gap:var(--space-4);">
                    <div class="page-size-select">
                        每页
                        <select onchange="changePageSize(this.value)">
                            <option value="15" <%= pageSize == 15 ? "selected" : "" %>>15 条</option>
                            <option value="30" <%= pageSize == 30 ? "selected" : "" %>>30 条</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 条</option>
                        </select>
                    </div>
                    <span class="badge badge-info"><%= totalCount %> 条记录</span>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="search-bar">
                <form action="<%= request.getContextPath() %>/admin/LogManageServlet" method="get" class="search-form">
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="搜索用户名或操作类型..." class="search-input">
                    <button type="submit" class="btn btn-primary btn-sm">🔍 搜索</button>
                    <% if (!keyword.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/admin/LogManageServlet" class="btn btn-outline btn-sm">✕ 清除</a>
                    <% } %>
                </form>
            </div>

            <div class="card">
                <div class="table-container">
                    <table>
                        <thead><tr><th>日志ID</th><th>操作账号</th><th>操作类型</th><th>详细信息</th><th>记录时间</th></tr></thead>
                        <tbody>
                            <c:forEach items="${logList}" var="log">
                                <tr>
                                    <td><span class="cell-id">#${log.id}</span></td>
                                    <td style="font-weight:600;">${log.username}</td>
                                    <td>
                                        <c:set var="actionType" value="${log.action_type}" />
                                        <c:choose>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'login') or fn:containsIgnoreCase(actionType, '登录')}"><span class="log-tag login">🔑 ${log.action_type}</span></c:when>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'logout') or fn:containsIgnoreCase(actionType, '退出')}"><span class="log-tag logout">🚪 ${log.action_type}</span></c:when>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'create') or fn:containsIgnoreCase(actionType, 'add') or fn:containsIgnoreCase(actionType, '添加') or fn:containsIgnoreCase(actionType, '新增')}"><span class="log-tag create">➕ ${log.action_type}</span></c:when>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'update') or fn:containsIgnoreCase(actionType, 'edit') or fn:containsIgnoreCase(actionType, '修改')}"><span class="log-tag update">✎ ${log.action_type}</span></c:when>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'delete') or fn:containsIgnoreCase(actionType, 'remove') or fn:containsIgnoreCase(actionType, '删除') or fn:containsIgnoreCase(actionType, '注销')}"><span class="log-tag delete">🗑 ${log.action_type}</span></c:when>
                                            <c:when test="${fn:containsIgnoreCase(actionType, 'view') or fn:containsIgnoreCase(actionType, 'list') or fn:containsIgnoreCase(actionType, '查询') or fn:containsIgnoreCase(actionType, '查看')}"><span class="log-tag view">👁 ${log.action_type}</span></c:when>
                                            <c:otherwise><span class="log-tag other">📋 ${log.action_type}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${log.action_detail}</td>
                                    <td><span class="cell-time">${log.create_time}</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty logList}">
                                <tr><td colspan="5"><div class="empty-state"><div class="empty-icon">📜</div><p>暂无任何系统日志记录</p></div></td></tr>
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
        window.location.href = 'LogManageServlet?page=1&pageSize=' + newSize + '&keyword=<%= keyword %>';
    }
</script>
</body>
</html>
