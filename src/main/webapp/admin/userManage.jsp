<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.util.HtmlUtil" %>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
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
    <title>用户管理 · 山海寻味录</title>
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
            <a href="<%= request.getContextPath() %>/admin/UserListServlet" class="active" data-page="UserList"><span class="nav-icon">👥</span> 用户管理</a>
            <a href="<%= request.getContextPath() %>/admin/RestaurantListServlet" data-page="RestaurantList"><span class="nav-icon">🍴</span> 餐厅管理</a>
            <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" data-page="EvaluationManage"><span class="nav-icon">💬</span> 内容审核</a>
            <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" data-page="AnnouncementManage"><span class="nav-icon">📢</span> 公告管理</a>
            <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" data-page="FoodInsight"><span class="nav-icon">📊</span> 数据洞察</a>
            <a href="${pageContext.request.contextPath}/admin/LogManageServlet" data-page="LogManage"><span class="nav-icon">📜</span> 系统日志</a>
        </nav>
        <div class="sidebar-footer">
            <%
                User sidebarUser = (User) session.getAttribute("adminUser");
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
            <div class="topbar-breadcrumb">控制台 <span>/</span> <span>用户管理</span></div>
            <div class="topbar-actions"><span class="topbar-date" id="currentDate"></span></div>
        </div>

        <div class="page-content">
            <div class="page-header flex-between">
                <div>
                    <h1>👥 用户管理</h1>
                    <p>管理系统注册用户，支持修改信息和账户注销</p>
                </div>
                <div style="display:flex;align-items:center;gap:var(--space-4);">
                    <div class="page-size-select">
                        每页
                        <select onchange="changePageSize(this.value)">
                            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 条</option>
                            <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 条</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 条</option>
                        </select>
                    </div>
                    <span class="badge badge-primary"><%= totalCount %> 个用户</span>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="search-bar">
                <form action="<%= request.getContextPath() %>/admin/UserListServlet" method="get" class="search-form">
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="搜索用户名或昵称..." class="search-input">
                    <button type="submit" class="btn btn-primary btn-sm">🔍 搜索</button>
                    <% if (!keyword.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/admin/UserListServlet" class="btn btn-outline btn-sm">✕ 清除</a>
                    <% } %>
                </form>
            </div>

            <div class="card">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>用户ID</th>
                                <th>登录账号</th>
                                <th>用户昵称</th>
                                <th>角色</th>
                                <th style="text-align:right;">操作</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (userList != null && !userList.isEmpty()) {
                                for (User user : userList) { %>
                            <tr>
                                <td><span class="cell-id">#<%= user.getId() %></span></td>
                                <td class="cell-user"><%= HtmlUtil.escape(user.getUsername()) %></td>
                                <td><%= HtmlUtil.escape(user.getNickname()) %></td>
                                <td>
                                    <% if (user.getRole() != null && user.getRole() == 1) { %>
                                        <span class="badge badge-primary">管理员</span>
                                    <% } else { %>
                                        <span class="badge badge-success">普通用户</span>
                                    <% } %>
                                </td>
                                <td style="text-align:right;">
                                    <div class="btn-group" style="justify-content:flex-end;">
                                        <button class="btn btn-outline btn-sm" onclick="openEdit('<%= user.getId() %>', '<%= HtmlUtil.escape(user.getUsername()).replace("'","\\'") %>', '<%= HtmlUtil.escape(user.getNickname()).replace("'","\\'") %>')">✎ 修改</button>
                                        <button class="btn btn-danger btn-sm" onclick="confirmDelete('<%= request.getContextPath() %>/admin/UserDeleteServlet?id=<%= user.getId() %>', '注销该用户将同步删除其所有评价数据，且无法恢复。')">✕ 注销</button>
                                    </div>
                                </td>
                            </tr>
                            <%  }
                            } else { %>
                            <tr><td colspan="5"><div class="empty-state"><div class="empty-icon">👥</div><p>暂无注册用户</p></div></td></tr>
                            <% } %>
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

<!-- Edit Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <div class="modal-header"><h3>修改用户信息</h3><button class="modal-close" onclick="AdminModal.close('editModal')">×</button></div>
        <form action="<%= request.getContextPath() %>/admin/UserUpdateServlet" method="post">
            <input type="hidden" name="id" id="editId">
            <div class="modal-body">
                <div class="form-group"><label class="form-label">登录账号</label><input type="text" name="username" id="editUsername" class="form-control" required></div>
                <div class="form-group"><label class="form-label">登录密码 <span class="optional">（留空则不修改）</span></label><input type="password" name="password" class="form-control" placeholder="不修改请留空"></div>
                <div class="form-group"><label class="form-label">用户昵称</label><input type="text" name="nickname" id="editNickname" class="form-control" required></div>
            </div>
            <div class="modal-footer"><button type="button" class="btn btn-outline" onclick="AdminModal.close('editModal')">取消</button><button type="submit" class="btn btn-primary">保存修改</button></div>
        </form>
    </div>
</div>

<script src="${pageContext.request.contextPath}/admin/js/admin-modern.js"></script>
<script>
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('zh-CN', { year:'numeric', month:'long', day:'numeric', weekday:'long' });
    function changePageSize(newSize) {
        window.location.href = 'UserListServlet?page=1&pageSize=' + newSize + '&keyword=<%= keyword %>';
    }
    function openEdit(id, username, nickname) {
        document.getElementById('editId').value = id;
        document.getElementById('editUsername').value = username;
        document.getElementById('editNickname').value = nickname;
        AdminModal.open('editModal');
    }
    function confirmDelete(url, message) { showConfirm(message, function() { window.location.href = url; }); }
</script>
</body>
</html>
