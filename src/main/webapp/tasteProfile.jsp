<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.TasteProfile" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    TasteProfile profile = (TasteProfile) request.getAttribute("tasteProfile");
    if (profile == null) profile = new TasteProfile();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>味蕾档案 — 山海寻味录</title>
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
            <a href="${pageContext.request.contextPath}/TrendBoardServlet">热榜</a>
            <a href="${pageContext.request.contextPath}/MyEvaluateServlet">我的评价</a>
            <a href="${pageContext.request.contextPath}/TasteProfileServlet" class="active">味蕾档案</a>
        </nav>
        <div class="nav-actions">
            <%
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
                    <a href="${pageContext.request.contextPath}/AccountServlet">⚙️ 账户设置</a>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="danger">⏻ 退出登录</a>
                </div>
            </details>
        </div>
    </div>
</header>

<main class="feature-shell">
    <section class="profile-grid">
        <div class="profile-card">
            <span class="feature-kicker">Personal Taste OS</span>
            <div class="persona-name"><%= profile.getPersonaName() != null ? profile.getPersonaName() : "味蕾档案" %></div>
            <p class="feature-subtitle"><%= profile.getPersonaDesc() != null ? profile.getPersonaDesc() : "继续发布评价，系统会生成更准确的校园口味画像。" %></p>
            <div class="badge-row">
                <c:forEach items="${tasteProfile.badges}" var="badge">
                    <span class="taste-badge"><c:out value="${badge}"/></span>
                </c:forEach>
            </div>
            <div class="feature-actions mt-6">
                <a href="${pageContext.request.contextPath}/AddEvaluateServlet" class="btn btn-primary">发布新评价</a>
                <a href="${pageContext.request.contextPath}/WishListServlet" class="btn btn-outline">管理想吃清单</a>
            </div>
        </div>
        <div class="profile-card">
            <h3 style="font-size:17px;font-weight:800;margin-bottom:18px;">味蕾指标</h3>
            <div class="progress-stack">
                <div class="progress-line"><span>味道</span><div class="progress-track"><div class="progress-bar" style="width:<%= Math.min(100, profile.getTasteAvg() * 20) %>%;"></div></div><strong><fmt:formatNumber value="<%= profile.getTasteAvg() %>" pattern="#.0"/></strong></div>
                <div class="progress-line"><span>价格</span><div class="progress-track"><div class="progress-bar" style="width:<%= Math.min(100, profile.getPriceAvg() * 20) %>%;"></div></div><strong><fmt:formatNumber value="<%= profile.getPriceAvg() %>" pattern="#.0"/></strong></div>
                <div class="progress-line"><span>服务</span><div class="progress-track"><div class="progress-bar" style="width:<%= Math.min(100, profile.getServiceAvg() * 20) %>%;"></div></div><strong><fmt:formatNumber value="<%= profile.getServiceAvg() %>" pattern="#.0"/></strong></div>
            </div>
            <section class="metric-grid mt-6" style="grid-template-columns:repeat(2,1fr);margin-bottom:0;">
                <div class="metric-card"><div class="metric-label">评价数</div><div class="metric-value"><%= profile.getTotalCount() %></div></div>
                <div class="metric-card"><div class="metric-label">探索餐厅</div><div class="metric-value"><%= profile.getRestaurantCount() %></div></div>
                <div class="metric-card"><div class="metric-label">常去餐厅</div><div class="metric-value" style="font-size:18px;"><%= profile.getFavoriteRestaurant() != null ? profile.getFavoriteRestaurant() : "待生成" %></div></div>
                <div class="metric-card"><div class="metric-label">常评菜品</div><div class="metric-value" style="font-size:18px;"><%= profile.getFavoriteDish() != null ? profile.getFavoriteDish() : "待生成" %></div></div>
            </section>
        </div>
    </section>

    <section class="rank-layout mt-8">
        <div class="rank-card">
            <h3>我的餐厅偏好</h3>
            <div class="rank-list">
                <c:forEach items="${tasteProfile.topRestaurants}" var="item">
                    <div class="rank-item"><div class="rank-num">${item.rank}</div><div class="rank-main"><div class="rank-title"><c:out value="${item.title}"/></div><div class="rank-sub"><c:out value="${item.reason}"/></div></div><div class="rank-score"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/><small>${item.reviewCount}评</small></div></div>
                </c:forEach>
                <c:if test="${empty tasteProfile.topRestaurants}"><div class="empty-inline">发布评价后会生成你的餐厅偏好。</div></c:if>
            </div>
        </div>
        <div class="rank-card" style="grid-column:span 2;">
            <h3>最近评价切片</h3>
            <div class="recommend-grid" style="grid-template-columns:repeat(2,minmax(0,1fr));">
                <c:forEach items="${tasteProfile.recentEvaluations}" var="ev">
                    <article class="recommend-card" style="min-height:190px;">
                        <div><div class="restaurant-chip"><c:out value="${ev.restaurantName}"/></div><div class="dish-title mt-2"><c:out value="${ev.dishName}"/></div></div>
                        <div class="score-row"><div class="score-pill"><span>味</span><strong>${ev.tasteScore}</strong></div><div class="score-pill"><span>价</span><strong>${ev.priceScore}</strong></div><div class="score-pill"><span>服</span><strong>${ev.serviceScore}</strong></div></div>
                        <p class="quote-text"><c:out value="${fn:length(ev.content) > 48 ? fn:substring(ev.content,0,48) : ev.content}"/><c:if test="${fn:length(ev.content) > 48}">...</c:if></p>
                    </article>
                </c:forEach>
                <c:if test="${empty tasteProfile.recentEvaluations}"><div class="empty-inline">暂无评价记录。</div></c:if>
            </div>
        </div>
    </section>
</main>
<footer class="page-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</footer>
</body>
</html>
