<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.CampusStats" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    CampusStats campusStats = (CampusStats) request.getAttribute("campusStats");
    String mood = (String) request.getAttribute("mood");
    String budget = (String) request.getAttribute("budget");
    if (campusStats == null) campusStats = new CampusStats();
    if (mood == null) mood = "balanced";
    if (budget == null) budget = "any";
    pageContext.setAttribute("_mood", mood);
    pageContext.setAttribute("_budget", budget);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>寻味雷达 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/feature-modern.css">
</head>
<body>
<header class="top-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
            <img src="${pageContext.request.contextPath}/images/logo.svg" alt="山海寻味录" onerror="this.style.display='none'">
            <span class="brand-name">山海寻味录</span>
        </a>
        <nav class="nav-pills">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/AllEvaluateServlet">全站评价</a>
            <a href="${pageContext.request.contextPath}/TasteCompassServlet" class="active">寻味雷达</a>
            <a href="${pageContext.request.contextPath}/TrendBoardServlet">热榜</a>
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
            <span class="feature-kicker">数据推荐 · 不用纠结吃什么</span>
            <div>
                <h1 class="feature-title">寻味雷达</h1>
                <p class="feature-subtitle">根据评分、点赞、评价文本和你的用餐情境，给出一组更像校园生活的推荐。</p>
            </div>
            <div class="segmented">
                <span class="segment-label">今天想要</span>
                <a class="segment ${_mood eq 'balanced' ? 'active' : ''}" href="TasteCompassServlet?mood=balanced&budget=${_budget}">综合灵感</a>
                <a class="segment ${_mood eq 'comfort' ? 'active' : ''}" href="TasteCompassServlet?mood=comfort&budget=${_budget}">热乎踏实</a>
                <a class="segment ${_mood eq 'light' ? 'active' : ''}" href="TasteCompassServlet?mood=light&budget=${_budget}">清爽轻负担</a>
                <a class="segment ${_mood eq 'value' ? 'active' : ''}" href="TasteCompassServlet?mood=value&budget=${_budget}">性价比</a>
                <a class="segment ${_mood eq 'popular' ? 'active' : ''}" href="TasteCompassServlet?mood=popular&budget=${_budget}">同学都在赞</a>
            </div>
            <div class="segmented">
                <span class="segment-label">场景</span>
                <a class="segment ${_budget eq 'any' ? 'active' : ''}" href="TasteCompassServlet?mood=${_mood}&budget=any">不限</a>
                <a class="segment ${_budget eq 'quick' ? 'active' : ''}" href="TasteCompassServlet?mood=${_mood}&budget=quick">赶时间</a>
                <a class="segment ${_budget eq 'value' ? 'active' : ''}" href="TasteCompassServlet?mood=${_mood}&budget=value">少花点</a>
                <a class="segment ${_budget eq 'treat' ? 'active' : ''}" href="TasteCompassServlet?mood=${_mood}&budget=treat">犒劳自己</a>
            </div>
        </div>
        <aside class="signal-panel">
            <div>
                <div class="signal-title">校园口碑均分</div>
                <div class="signal-number"><fmt:formatNumber value="<%= campusStats.getAvgScore() %>" pattern="#.0"/></div>
                <p class="signal-muted">已沉淀 <%= campusStats.getEvaluationCount() %> 条评价，覆盖 <%= campusStats.getDishCount() %> 个菜品。</p>
            </div>
            <div class="feature-actions">
                <a class="btn btn-primary" href="${pageContext.request.contextPath}/TrendBoardServlet">查看热榜</a>
                <% if (loginUser != null) { %>
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/TasteProfileServlet">我的画像</a>
                <% } %>
            </div>
        </aside>
    </section>

    <section class="metric-grid">
        <div class="metric-card"><div class="metric-label">评价数</div><div class="metric-value"><%= campusStats.getEvaluationCount() %></div><div class="metric-note">条真实评价</div></div>
        <div class="metric-card"><div class="metric-label">菜品池</div><div class="metric-value"><%= campusStats.getDishCount() %></div><div class="metric-note">个可选菜品</div></div>
        <div class="metric-card"><div class="metric-label">点赞数</div><div class="metric-value"><%= campusStats.getLikeCount() %></div><div class="metric-note">次同学认可</div></div>
        <div class="metric-card"><div class="metric-label">当前榜首</div><div class="metric-value" style="font-size:20px;"><%= campusStats.getTopDish() != null ? campusStats.getTopDish() : "待生成" %></div><div class="metric-note">最受欢迎菜品</div></div>
    </section>

    <div class="section-head">
        <div>
            <h2>今日推荐</h2>
            <p>按当前情境重新排序，越靠前越适合现在下手。</p>
        </div>
    </div>
    <section class="recommend-grid">
        <c:forEach items="${recommendations}" var="ev">
            <article class="recommend-card">
                <div class="recommend-top">
                    <div>
                        <div class="restaurant-chip"><c:out value="${ev.restaurantName}"/></div>
                        <div class="dish-title mt-2"><c:out value="${ev.dishName}"/></div>
                    </div>
                    <span class="heat-badge"><fmt:formatNumber value="${ev.insightScore}" pattern="#"/> 分</span>
                </div>
                <div class="score-row">
                    <div class="score-pill"><span>味道</span><strong>${ev.tasteScore}</strong></div>
                    <div class="score-pill"><span>价格</span><strong>${ev.priceScore}</strong></div>
                    <div class="score-pill"><span>服务</span><strong>${ev.serviceScore}</strong></div>
                </div>
                <p class="quote-text"><c:out value="${fn:length(ev.content) > 72 ? fn:substring(ev.content,0,72) : ev.content}"/><c:if test="${fn:length(ev.content) > 72}">...</c:if></p>
                <div class="reason-line"><c:out value="${ev.recommendReason}"/> · ${ev.likeCount} 人点赞</div>
                <% if (loginUser != null) { %>
                <form action="${pageContext.request.contextPath}/WishActionServlet" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="source" value="compass">
                    <input type="hidden" name="restaurantId" value="${ev.restaurantId}">
                    <input type="hidden" name="dishName" value="${ev.dishName}">
                    <input type="hidden" name="note" value="来自寻味雷达推荐">
                    <button type="submit" class="btn btn-outline btn-block">加入想吃清单</button>
                </form>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline btn-block">登录后收藏</a>
                <% } %>
            </article>
        </c:forEach>
        <c:if test="${empty recommendations}">
            <div class="empty-inline">还没有足够评价生成推荐，先发布几条评价就能点亮雷达。</div>
        </c:if>
    </section>

    <section class="rank-layout mt-8">
        <div class="rank-card">
            <h3>餐厅热信号</h3>
            <div class="rank-list">
                <c:forEach items="${restaurantTrends}" var="item">
                    <div class="rank-item">
                        <div class="rank-num">${item.rank}</div>
                        <div class="rank-main"><div class="rank-title"><c:out value="${item.title}"/></div><div class="rank-sub"><c:out value="${item.reason}"/></div></div>
                        <div class="rank-score"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/><small>${item.reviewCount}评</small></div>
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="rank-card">
            <h3>菜品热信号</h3>
            <div class="rank-list">
                <c:forEach items="${dishTrends}" var="item">
                    <div class="rank-item">
                        <div class="rank-num">${item.rank}</div>
                        <div class="rank-main"><div class="rank-title"><c:out value="${item.title}"/></div><div class="rank-sub"><c:out value="${item.subtitle}"/></div></div>
                        <div class="rank-score"><fmt:formatNumber value="${item.avgScore}" pattern="#.0"/><small>${item.likeCount}赞</small></div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</main>

<footer class="page-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</footer>
</body>
</html>
