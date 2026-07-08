<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.entity.Evaluation" %>
<%
    User admin = (User) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    // 统计数据由 DashboardStatsServlet 设置
    Integer statsUserCount = (Integer) request.getAttribute("statsUserCount");
    Integer statsRestCount = (Integer) request.getAttribute("statsRestCount");
    Integer statsEvalCount = (Integer) request.getAttribute("statsEvalCount");
    Integer statsLogCount = (Integer) request.getAttribute("statsLogCount");
    List<Evaluation> recentEvaluations = (List<Evaluation>) request.getAttribute("recentEvaluations");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理控制台 · 山海寻味录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-modern.css">
</head>
<body>
<div class="admin-layout">
    <!-- ========== Sidebar ========== -->
    <aside class="admin-sidebar">
        <div class="sidebar-brand">
            <img src="${pageContext.request.contextPath}/images/logo.svg" alt="Logo">
            <div class="sidebar-brand-text">
                <h2>山海寻味录</h2>
                <span>管理员后台</span>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="sidebar-nav-label">主菜单</div>
            <a href="<%= request.getContextPath() %>/admin/DashboardStatsServlet" class="active" data-page="DashboardStats">
                <span class="nav-icon">🏠</span> 控制台
            </a>
            <a href="<%= request.getContextPath() %>/admin/UserListServlet" data-page="UserList">
                <span class="nav-icon">👥</span> 用户管理
            </a>
            <a href="<%= request.getContextPath() %>/admin/RestaurantListServlet" data-page="RestaurantList">
                <span class="nav-icon">🍴</span> 餐厅管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" data-page="EvaluationManage">
                <span class="nav-icon">💬</span> 内容审核
            </a>
            <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" data-page="AnnouncementManage">
                <span class="nav-icon">📢</span> 公告管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" data-page="FoodInsight">
                <span class="nav-icon">📊</span> 数据洞察
            </a>
            <a href="${pageContext.request.contextPath}/admin/LogManageServlet" data-page="LogManage">
                <span class="nav-icon">📜</span> 系统日志
            </a>
        </nav>
        <div class="sidebar-footer">
            <div class="sidebar-user">
                <div class="sidebar-user-avatar"><%= admin.getNickname() != null ? admin.getNickname().substring(0, 1).toUpperCase() : "A" %></div>
                <div class="sidebar-user-info">
                    <div class="name"><%= admin.getNickname() %></div>
                    <div class="role">系统管理员</div>
                </div>
            </div>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="sidebar-logout">⏻ 退出登录</a>
        </div>
    </aside>

    <!-- ========== Main Content ========== -->
    <main class="admin-main">
        <div class="topbar">
            <div class="topbar-breadcrumb">
                控制台 <span style="margin:0 6px;color:var(--color-text-tertiary);">/</span> <span>概览</span>
            </div>
            <div class="topbar-actions">
                <span class="topbar-date" id="currentDate"></span>
            </div>
        </div>

        <div class="page-content">
            <!-- Welcome Banner -->
            <div class="welcome-banner">
                <h1>👋 欢迎回来，<%= admin.getNickname() %></h1>
                <p>以下是系统的运行概况，请及时处理待审核内容</p>
                <span class="date-badge" id="welcomeDate"></span>
            </div>

            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">👥</div>
                    <div class="stat-info">
                        <div class="stat-value"><%= statsUserCount != null ? statsUserCount : "0" %></div>
                        <div class="stat-label">注册用户</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">🍴</div>
                    <div class="stat-info">
                        <div class="stat-value"><%= statsRestCount != null ? statsRestCount : "0" %></div>
                        <div class="stat-label">入驻餐厅</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber">💬</div>
                    <div class="stat-info">
                        <div class="stat-value"><%= statsEvalCount != null ? statsEvalCount : "0" %></div>
                        <div class="stat-label">评价总数</div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">📜</div>
                    <div class="stat-info">
                        <div class="stat-value"><%= statsLogCount != null ? statsLogCount : "0" %></div>
                        <div class="stat-label">操作日志</div>
                    </div>
                </div>
            </div>

            <!-- Recent Evaluations -->
            <% if (recentEvaluations != null && !recentEvaluations.isEmpty()) { %>
            <div class="card" style="margin-bottom:var(--space-8);">
                <div class="card-header">
                    <h3>📋 最新评价</h3>
                    <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" class="btn btn-outline btn-sm">查看全部</a>
                </div>
                <div class="card-body" style="padding:0;">
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>用户</th>
                                    <th>餐厅</th>
                                    <th>菜品</th>
                                    <th>综合评分</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Evaluation e : recentEvaluations) {
                                    double avgScore = (e.getTasteScore() + e.getPriceScore() + e.getServiceScore()) / 3.0;
                                %>
                                <tr>
                                    <td><%= e.getAuthorNickname() != null ? e.getAuthorNickname() : e.getUsername() %></td>
                                    <td><%= e.getRestaurantName() %></td>
                                    <td><%= e.getDishName() %></td>
                                    <td><span class="cell-scores">⭐ <%= String.format("%.1f", avgScore) %></span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Management Modules -->
            <div class="page-header">
                <div>
                    <h1>管理模块</h1>
                    <p>选择下方模块进入对应管理页面</p>
                </div>
            </div>
            <div class="menu-grid">
                <a href="<%= request.getContextPath() %>/admin/UserListServlet" class="menu-card">
                    <div class="menu-icon users">👥</div>
                    <h3>用户管理</h3>
                    <p>查看、修改用户账号信息，注销违规账户</p>
                </a>
                <a href="<%= request.getContextPath() %>/admin/RestaurantListServlet" class="menu-card">
                    <div class="menu-icon restaurants">🍴</div>
                    <h3>餐厅管理</h3>
                    <p>新增、修改、删除系统中的餐厅及档口信息</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/EvaluationManageServlet" class="menu-card">
                    <div class="menu-icon content">💬</div>
                    <h3>内容审核</h3>
                    <p>全局查看评价列表，一键删除违规评价内容</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/AnnouncementManageServlet" class="menu-card">
                    <div class="menu-icon logs">📢</div>
                    <h3>公告管理</h3>
                    <p>发布和管理系统公告，首页滚动展示</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" class="menu-card">
                    <div class="menu-icon restaurants">📊</div>
                    <h3>数据洞察</h3>
                    <p>查看餐厅热度、菜品排行、推荐官榜与评分分布</p>
                </a>
                <a href="${pageContext.request.contextPath}/admin/LogManageServlet" class="menu-card">
                    <div class="menu-icon logs">📜</div>
                    <h3>系统日志</h3>
                    <p>监控关键操作记录，查看登录历史与审计日志</p>
                </a>
            </div>
        </div>

        <div class="admin-footer">
            © 2026 SHU.L.M.Z 版权所有 · 山海寻味录 · 联系邮箱：8224439@qq.com
        </div>
    </main>
</div>

<style>
.welcome-banner {
    background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 50%, #A855F7 100%);
    border-radius: var(--radius-xl);
    padding: var(--space-8);
    color: white;
    margin-bottom: var(--space-8);
    position: relative;
    overflow: hidden;
}
.welcome-banner h1 { font-size:1.75rem;font-weight:700;margin-bottom:var(--space-2);position:relative;z-index:1; }
.welcome-banner p { opacity:0.85;font-size:var(--text-base);position:relative;z-index:1; }
.date-badge {
    display:inline-block;background:rgba(255,255,255,0.15);backdrop-filter:blur(8px);
    padding:6px 14px;border-radius:999px;font-size:var(--text-sm);margin-top:var(--space-3);
    position:relative;z-index:1;
}
</style>

<script src="${pageContext.request.contextPath}/admin/js/admin-modern.js"></script>
<script>
    (function() {
        var now = new Date();
        var options = { year:'numeric', month:'long', day:'numeric', weekday:'long' };
        var dateStr = now.toLocaleDateString('zh-CN', options);
        document.getElementById('currentDate').textContent = dateStr;
        document.getElementById('welcomeDate').textContent = '📅 ' + dateStr;
    })();
</script>
</body>
</html>
