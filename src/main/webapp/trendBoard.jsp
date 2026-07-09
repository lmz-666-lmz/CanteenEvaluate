<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.CampusStats" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    CampusStats campusStats = (CampusStats) request.getAttribute("campusStats");
    if (campusStats == null) campusStats = new CampusStats();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>美食热榜 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature-modern.css">
</head>
<body>
<header class="top-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand"><img src="${pageContext.request.contextPath}/images/logo.svg" alt="山海寻味录" onerror="this.style.display='none'"><span class="brand-name">山海寻味录</span></a>
        <nav class="nav-pills">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/AllEvaluateServlet">全站评价</a>
            <a href="${pageContext.request.contextPath}/TasteCompassServlet">寻味雷达</a>
            <a href="${pageContext.request.contextPath}/TrendBoardServlet" class="active">热榜</a>
            <a href="${pageContext.request.contextPath}/AddEvaluateServlet">发布评价</a>
            <a href="${pageContext.request.contextPath}/MyEvaluateServlet">我的评价</a>
            <a href="${pageContext.request.contextPath}/TasteProfileServlet">味蕾档案</a>
        </nav>
        <div class="nav-actions">
            <% if (loginUser == null) { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-sm">登录探索</a>
            <% } else {
                String nick = loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty() ? loginUser.getNickname().trim() : "同学";
                String avatar = nick.substring(0, 1).toUpperCase();
            %>
                <details class="user-menu">
                    <summary class="user-menu-trigger">
                        <span class="user-avatar"><%= avatar %></span>
                        <span class="user-menu-name"><%= nick %></span>
                        <span class="user-menu-caret">▾</span>
                    </summary>
                    <div class="user-menu-panel">
                        <a href="${pageContext.request.contextPath}/TasteProfileServlet">🎯 味蕾档案</a>
                        <a href="${pageContext.request.contextPath}/WishListServlet">✅ 想吃清单</a>
                        <a href="${pageContext.request.contextPath}/AnnouncementServlet">📢 站内公告</a>
                        <a href="${pageContext.request.contextPath}/AccountServlet">⚙️ 账户设置</a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="danger">⏻ 退出登录</a>
                    </div>
                </details>
            <% } %>
        </div>
    </div>
</header>

<main class="feature-shell">
    <section class="feature-hero">
        <div class="feature-panel">
            <span class="feature-kicker" style="background:#EFF6FF;color:#1D4ED8;">校园口碑 · 实时热榜</span>
            <div>
                <h1 class="feature-title">美食热榜</h1>
                <p class="feature-subtitle">把“评分、评论量、点赞”合成热度指数，生成餐厅榜、菜品榜和推荐官榜，让好吃的东西被看见。</p>
            </div>
            <div class="feature-actions">
                <a href="${pageContext.request.contextPath}/TasteCompassServlet" class="btn btn-primary">去寻味雷达</a>
                <% if (loginUser != null) { %><a href="${pageContext.request.contextPath}/TasteProfileServlet" class="btn btn-outline">我的味蕾档案</a><% } %>
            </div>
        </div>
        <aside class="signal-panel">
            <div class="signal-title">当前最热菜品</div>
            <div class="signal-number" style="font-size:28px;color:#B45309;"><%= campusStats.getTopDish() != null ? campusStats.getTopDish() : "待生成" %></div>
            <p class="signal-muted">榜单会随着新增评价和点赞变化，适合做首页推荐与后台运营参考。</p>
        </aside>
    </section>

    <section class="metric-grid">
        <div class="metric-card"><div class="metric-label">注册用户</div><div class="metric-value"><%= campusStats.getUserCount() %></div><div class="metric-note">潜在评价者</div></div>
        <div class="metric-card"><div class="metric-label">餐厅/窗口</div><div class="metric-value"><%= campusStats.getRestaurantCount() %></div><div class="metric-note">已入驻系统</div></div>
        <div class="metric-card"><div class="metric-label">全站评价</div><div class="metric-value"><%= campusStats.getEvaluationCount() %></div><div class="metric-note">热榜数据来源</div></div>
        <div class="metric-card"><div class="metric-label">活跃评价者</div><div class="metric-value"><%= campusStats.getActiveUserCount() %></div><div class="metric-note">贡献过评价</div></div>
    </section>

    <section class="rank-layout">
        <div class="rank-card">
            <h3>餐厅热榜</h3>
            <div class="rank-list">
                <c:forEach items="${restaurantTrends}" var="item">
                    <div class="rank-item rank-item-${item.rank <= 3 ? item.rank : 'default'}">
                        <div class="rank-num rank-num-${item.rank <= 3 ? item.rank : 'default'}">${item.rank}</div>
                        <div class="rank-main">
                            <div class="rank-title"><c:out value="${item.title}"/></div>
                            <div class="rank-sub">${item.trendLabel} · <c:out value="${item.reason}"/></div>
                            <div class="rank-tags">
                                <c:forEach items="${item.tagArray}" var="tag"><span class="badge badge-tag"><c:out value="${tag}"/></span></c:forEach>
                            </div>
                        </div>
                        <div class="rank-score">
                            <strong><fmt:formatNumber value="${item.heatScore}" pattern="#"/></strong>
                            <small>热度</small>
                            <span class="rank-avg"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/> 分 · ${item.reviewCount}评</span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="rank-card">
            <h3>菜品热榜</h3>
            <div class="rank-list">
                <c:forEach items="${dishTrends}" var="item">
                    <div class="rank-item">
                        <div class="rank-num">${item.rank}</div>
                        <div class="rank-main"><div class="rank-title"><c:out value="${item.title}"/></div><div class="rank-sub"><c:out value="${item.subtitle}"/> · ${item.likeCount}赞</div></div>
                        <div class="rank-score"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/><small>${item.reviewCount}评</small></div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="rank-card">
            <h3>推荐官榜</h3>
            <div class="rank-list">
                <c:forEach items="${creatorTrends}" var="item">
                    <div class="rank-item">
                        <div class="rank-num">${item.rank}</div>
                        <div class="rank-main"><div class="rank-title"><c:out value="${item.title}"/></div><div class="rank-sub"><c:out value="${item.subtitle}"/> · ${item.likeCount}赞</div></div>
                        <div class="rank-score"><fmt:formatNumber value="${item.heatScore}" pattern="#"/><small>热度</small></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>
<footer class="page-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</footer>
</body>
</html>
