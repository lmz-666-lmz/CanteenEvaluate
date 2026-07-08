<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Announcement" %>
<%@ page import="com.util.HtmlUtil" %>
<%
    List<Announcement> announcementList = (List<Announcement>) request.getAttribute("announcementList");
    Announcement editAnnouncement = (Announcement) request.getAttribute("editAnnouncement");
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
    <title>公告管理 · 山海寻味录</title>
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
            <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" data-page="EvaluationManage"><span class="nav-icon">💬</span> 内容审核</a>
            <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" class="active" data-page="AnnouncementManage"><span class="nav-icon">📢</span> 公告管理</a>
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
            <div class="topbar-breadcrumb">控制台 <span>/</span> <span>公告管理</span></div>
            <div class="topbar-actions"><span class="topbar-date" id="currentDate"></span></div>
        </div>

        <div class="page-content">
            <div class="page-header flex-between">
                <div><h1>📢 公告管理</h1><p>管理系统公告，首页将展示活跃公告</p></div>
                <div style="display:flex;align-items:center;gap:var(--space-4);">
                    <div class="page-size-select">
                        每页
                        <select onchange="changePageSize(this.value)">
                            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 条</option>
                            <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 条</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 条</option>
                        </select>
                    </div>
                    <span class="badge badge-info"><%= totalCount %> 条公告</span>
                </div>
            </div>

            <!-- Add/Edit Form -->
            <div class="card" style="margin-bottom:var(--space-6);">
                <div class="card-header">
                    <h3><%= editAnnouncement != null ? "✏️ 编辑公告" : "➕ 新增公告" %></h3>
                    <% if (editAnnouncement != null) { %>
                    <a href="<%= request.getContextPath() %>/admin/AnnouncementManageServlet" class="btn btn-outline btn-sm">取消编辑</a>
                    <% } %>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin/AnnouncementManageServlet" method="post">
                        <input type="hidden" name="action" value="save">
                        <% if (editAnnouncement != null) { %>
                        <input type="hidden" name="id" value="<%= editAnnouncement.getId() %>">
                        <% } %>
                        <div class="form-group">
                            <label class="form-label">公告标题 <span class="required">*</span></label>
                            <input type="text" name="title" class="form-control" required placeholder="请输入公告标题" value="<%= editAnnouncement != null ? HtmlUtil.escape(editAnnouncement.getTitle()) : "" %>">
                        </div>
                        <div class="form-group">
                            <label class="form-label">公告内容 <span class="required">*</span></label>
                            <textarea name="content" class="form-control" required placeholder="请输入公告内容" style="min-height:100px;"><%= editAnnouncement != null ? HtmlUtil.escape(editAnnouncement.getContent()) : "" %></textarea>
                        </div>
                        <div class="form-inline">
                            <div class="form-group">
                                <label class="form-label">显示状态</label>
                                <select name="isActive" class="form-control">
                                    <option value="1" <%= editAnnouncement == null || editAnnouncement.getIsActive() == 1 ? "selected" : "" %>>显示</option>
                                    <option value="0" <%= editAnnouncement != null && editAnnouncement.getIsActive() == 0 ? "selected" : "" %>>隐藏</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">排序权重</label>
                                <input type="number" name="sortOrder" class="form-control" value="<%= editAnnouncement != null ? editAnnouncement.getSortOrder() : 0 %>" style="width:100px;">
                            </div>
                            <button type="submit" class="btn btn-primary"><%= editAnnouncement != null ? "保存修改" : "发布公告" %></button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Search Bar -->
            <div class="search-bar">
                <form action="<%= request.getContextPath() %>/admin/AnnouncementManageServlet" method="get" class="search-form">
                    <input type="text" name="keyword" value="<%= keyword %>" placeholder="搜索公告标题或内容..." class="search-input">
                    <button type="submit" class="btn btn-primary btn-sm">🔍 搜索</button>
                    <% if (!keyword.isEmpty()) { %>
                    <a href="<%= request.getContextPath() %>/admin/AnnouncementManageServlet" class="btn btn-outline btn-sm">✕ 清除</a>
                    <% } %>
                </form>
            </div>

            <!-- Table -->
            <div class="card">
                <div class="table-container">
                    <table>
                        <thead><tr><th>ID</th><th>标题</th><th>状态</th><th>排序</th><th>创建时间</th><th style="text-align:right;">操作</th></tr></thead>
                        <tbody>
                            <% if (announcementList != null && !announcementList.isEmpty()) {
                                for (Announcement a : announcementList) { %>
                            <tr>
                                <td><span class="cell-id">#<%= a.getId() %></span></td>
                                <td style="font-weight:600;"><%= HtmlUtil.escape(a.getTitle()) %></td>
                                <td>
                                    <% if (a.getIsActive() == 1) { %>
                                        <span class="badge badge-success">显示中</span>
                                    <% } else { %>
                                        <span class="badge badge-warning">已隐藏</span>
                                    <% } %>
                                </td>
                                <td><%= a.getSortOrder() %></td>
                                <td><span class="cell-time"><%= a.getCreateTime() %></span></td>
                                <td style="text-align:right;">
                                    <div class="btn-group" style="justify-content:flex-end;">
                                        <a href="?action=toggle&id=<%= a.getId() %>" class="btn btn-outline btn-sm"><%= a.getIsActive() == 1 ? "🙈 隐藏" : "👁 显示" %></a>
                                        <a href="?action=edit&id=<%= a.getId() %>" class="btn btn-outline btn-sm">✎ 编辑</a>
                                        <a href="?action=delete&id=<%= a.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定要删除该公告吗？')">✕ 删除</a>
                                    </div>
                                </td>
                            </tr>
                            <%  }
                            } else { %>
                            <tr><td colspan="6"><div class="empty-state"><div class="empty-icon">📢</div><p>暂无公告，请在上面发布</p></div></td></tr>
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

<script src="${pageContext.request.contextPath}/admin/js/admin-modern.js"></script>
<script>
    document.getElementById('currentDate').textContent = new Date().toLocaleDateString('zh-CN', { year:'numeric', month:'long', day:'numeric', weekday:'long' });
    function changePageSize(newSize) {
        window.location.href = 'AnnouncementManageServlet?page=1&pageSize=' + newSize + '&keyword=<%= keyword %>';
    }
</script>
</body>
</html>
