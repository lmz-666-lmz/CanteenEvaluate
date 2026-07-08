<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.CampusStats" %>
<%
    User admin = (User) session.getAttribute("adminUser");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    CampusStats campusStats = (CampusStats) request.getAttribute("campusStats");
    if (campusStats == null) campusStats = new CampusStats();
    int[] scoreBuckets = (int[]) request.getAttribute("scoreBuckets");
    if (scoreBuckets == null) scoreBuckets = new int[]{0,0,0,0,0};
    int maxBucket = 1;
    for (int i = 0; i < scoreBuckets.length; i++) {
        if (scoreBuckets[i] > maxBucket) maxBucket = scoreBuckets[i];
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>数据洞察 · 山海寻味录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/admin-modern.css">
    <style>
        .insight-hero {
            background: linear-gradient(135deg, #0F766E 0%, #2563EB 52%, #7C3AED 100%);
            color: #fff;
            border-radius: var(--radius-2xl);
            padding: var(--space-8);
            margin-bottom: var(--space-8);
            box-shadow: var(--shadow-lg);
        }
        .insight-hero h1 { font-size: var(--text-3xl); margin-bottom: var(--space-2); }
        .insight-hero p { opacity: .88; max-width: 760px; }
        .insight-grid { display:grid; grid-template-columns: 1.2fr .8fr; gap:var(--space-5); margin-bottom:var(--space-8); }
        .insight-rank { display:flex; flex-direction:column; gap:10px; }
        .insight-row {
            display:grid; grid-template-columns:42px minmax(0,1fr) 86px; gap:12px; align-items:center;
            padding:12px; border-radius:var(--radius-lg); background:var(--color-bg-secondary);
        }
        .insight-row .num {
            width:32px; height:32px; display:flex; align-items:center; justify-content:center;
            border-radius:10px; background:var(--color-primary-50); color:var(--color-primary); font-weight:800;
        }
        .insight-row:first-child .num { background:#FEF3C7; color:#B45309; }
        .insight-row .title { font-weight:700; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .insight-row .sub { color:var(--color-text-tertiary); font-size:var(--text-xs); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .insight-row .score { text-align:right; font-weight:800; color:#B45309; }
        .bucket-list { display:flex; flex-direction:column; gap:14px; }
        .bucket-line { display:grid; grid-template-columns:52px minmax(0,1fr) 42px; gap:10px; align-items:center; }
        .bucket-line span { color:var(--color-text-secondary); font-size:var(--text-sm); font-weight:700; }
        .bucket-track { height:12px; border-radius:999px; background:var(--color-bg); overflow:hidden; }
        .bucket-fill { height:100%; border-radius:inherit; background:linear-gradient(90deg,#14B8A6,#4F46E5); }
        .ops-card {
            display:grid; grid-template-columns:repeat(3,1fr); gap:var(--space-4); margin-bottom:var(--space-8);
        }
        .ops-tile {
            background:#fff; border:1px solid var(--color-border); border-radius:var(--radius-xl);
            padding:var(--space-5); box-shadow:var(--shadow-sm);
        }
        .ops-tile b { display:block; font-size:var(--text-lg); margin-bottom:6px; }
        .ops-tile p { color:var(--color-text-secondary); font-size:var(--text-sm); }
        @media (max-width: 1024px) {
            .insight-grid, .ops-card { grid-template-columns:1fr; }
        }
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
            <a href="${pageContext.request.contextPath}/admin/FoodInsightServlet" class="active" data-page="FoodInsight"><span class="nav-icon">📊</span> 数据洞察</a>
            <a href="${pageContext.request.contextPath}/admin/LogManageServlet" data-page="LogManage"><span class="nav-icon">📜</span> 系统日志</a>
        </nav>
        <div class="sidebar-footer">
            <div class="sidebar-user">
                <div class="sidebar-user-avatar"><%= admin.getNickname() != null ? admin.getNickname().substring(0, 1).toUpperCase() : "A" %></div>
                <div class="sidebar-user-info"><div class="name"><%= admin.getNickname() %></div><div class="role">系统管理员</div></div>
            </div>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="sidebar-logout">⏻ 退出登录</a>
        </div>
    </aside>

    <main class="admin-main">
        <div class="topbar">
            <div class="topbar-breadcrumb">数据洞察 <span>/</span> <span>运营看板</span></div>
            <div class="topbar-actions"><span class="topbar-date" id="currentDate"></span></div>
        </div>

        <div class="page-content">
            <section class="insight-hero">
                <h1>食堂口碑数据洞察</h1>
                <p>把评价、点赞和评分转化成榜单、趋势和运营线索，帮助后台判断哪些餐厅、菜品和用户值得重点展示。</p>
            </section>

            <div class="stats-grid">
                <div class="stat-card"><div class="stat-icon blue">👥</div><div class="stat-info"><div class="stat-value"><%= campusStats.getUserCount() %></div><div class="stat-label">注册用户</div></div></div>
                <div class="stat-card"><div class="stat-icon green">🍴</div><div class="stat-info"><div class="stat-value"><%= campusStats.getRestaurantCount() %></div><div class="stat-label">餐厅/窗口</div></div></div>
                <div class="stat-card"><div class="stat-icon amber">💬</div><div class="stat-info"><div class="stat-value"><%= campusStats.getEvaluationCount() %></div><div class="stat-label">评价总数</div></div></div>
                <div class="stat-card"><div class="stat-icon red">❤</div><div class="stat-info"><div class="stat-value"><%= campusStats.getLikeCount() %></div><div class="stat-label">点赞总数</div></div></div>
            </div>

            <div class="ops-card">
                <div class="ops-tile"><b>首页推荐素材</b><p>当前榜首菜品：<%= campusStats.getTopDish() != null ? campusStats.getTopDish() : "暂无" %>，可用于公告或首页推荐。</p></div>
                <div class="ops-tile"><b>重点餐厅</b><p>当前热度最高餐厅：<%= campusStats.getTopRestaurant() != null ? campusStats.getTopRestaurant() : "暂无" %>，适合做专题展示。</p></div>
                <div class="ops-tile"><b>内容活跃度</b><p><%= campusStats.getActiveUserCount() %> 位用户贡献过评价，运营可围绕推荐官榜做激励。</p></div>
            </div>

            <section class="insight-grid">
                <div class="card">
                    <div class="card-header"><h3>餐厅热度排行</h3><span class="badge badge-info">Heat Score</span></div>
                    <div class="card-body">
                        <div class="insight-rank">
                            <c:forEach items="${restaurantTrends}" var="item">
                                <div class="insight-row">
                                    <div class="num">${item.rank}</div>
                                    <div><div class="title"><c:out value="${item.title}"/></div><div class="sub"><c:out value="${item.reason}"/> · ${item.reviewCount} 条评价 · ${item.likeCount} 赞</div></div>
                                    <div class="score"><fmt:formatNumber value="${item.heatScore}" pattern="#"/></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header"><h3>评分分布</h3><span class="badge badge-success">Quality</span></div>
                    <div class="card-body">
                        <div class="bucket-list">
                            <% for (int i = 4; i >= 0; i--) {
                                int count = scoreBuckets[i];
                                int width = (int) Math.max(4, Math.round(count * 100.0 / maxBucket));
                            %>
                            <div class="bucket-line">
                                <span><%= i + 1 %> 星</span>
                                <div class="bucket-track"><div class="bucket-fill" style="width:<%= width %>%;"></div></div>
                                <strong><%= count %></strong>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </section>

            <section class="insight-grid">
                <div class="card">
                    <div class="card-header"><h3>菜品热度排行</h3><span class="badge badge-warning">Dish</span></div>
                    <div class="card-body">
                        <div class="insight-rank">
                            <c:forEach items="${dishTrends}" var="item">
                                <div class="insight-row">
                                    <div class="num">${item.rank}</div>
                                    <div><div class="title"><c:out value="${item.title}"/></div><div class="sub"><c:out value="${item.subtitle}"/> · ${item.reviewCount} 条评价 · ${item.likeCount} 赞</div></div>
                                    <div class="score"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div class="card-header"><h3>推荐官排行</h3><span class="badge badge-primary">Creators</span></div>
                    <div class="card-body">
                        <div class="insight-rank">
                            <c:forEach items="${creatorTrends}" var="item">
                                <div class="insight-row">
                                    <div class="num">${item.rank}</div>
                                    <div><div class="title"><c:out value="${item.title}"/></div><div class="sub"><c:out value="${item.subtitle}"/> · ${item.reviewCount} 条评价</div></div>
                                    <div class="score">${item.likeCount}<small style="display:block;color:var(--color-text-tertiary);">赞</small></div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </section>
        </div>
        <div class="admin-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/admin/js/admin-modern.js"></script>
<script>
    (function() {
        var now = new Date();
        var options = { year:'numeric', month:'long', day:'numeric', weekday:'long' };
        document.getElementById('currentDate').textContent = now.toLocaleDateString('zh-CN', options);
    })();
</script>
</body>
</html>
