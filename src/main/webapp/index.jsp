<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Announcement" %>
<%@ page import="java.util.List" %>
<%
    if (!Boolean.TRUE.equals(request.getAttribute("homeLoaded"))) {
        request.getRequestDispatcher("HomeServlet").forward(request, response);
        return;
    }
    User loginUser = (User) session.getAttribute("loginUser");
    String displayName = loginUser != null && loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty()
            ? loginUser.getNickname().trim() : "同学";
    String avatarText = displayName.length() > 0 ? displayName.substring(0, 1).toUpperCase() : "U";
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>首页 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
</head>
<body>

    <header class="top-nav">
        <div class="nav-container">
            <a href="HomeServlet" class="brand">
                <img src="images/logo.svg" alt="山海寻味录" onerror="this.style.display='none'">
                <span class="brand-name">山海寻味录</span>
            </a>
            <nav class="nav-pills">
                <a href="HomeServlet" class="active">首页</a>
                <a href="AllEvaluateServlet">全站评价</a>
                <a href="TasteCompassServlet">寻味雷达</a>
                <a href="TrendBoardServlet">热榜</a>
                <a href="AddEvaluateServlet">发布评价</a>
                <a href="MyEvaluateServlet">我的评价</a>
                <a href="TasteProfileServlet">味蕾档案</a>
            </nav>
            <div class="nav-actions">
                <% if (loginUser == null) { %>
                    <a href="login.jsp" class="btn btn-primary btn-sm">登录探索</a>
                <% } else { %>
                    <details class="user-menu">
                        <summary class="user-menu-trigger">
                            <span class="user-avatar"><%= com.util.HtmlUtil.escape(avatarText) %></span>
                            <span class="user-menu-name"><%= com.util.HtmlUtil.escape(displayName) %></span>
                            <span class="user-menu-caret">▾</span>
                        </summary>
                        <div class="user-menu-panel">
                            <a href="TasteProfileServlet">🎯 味蕾档案</a>
                            <a href="WishListServlet">✅ 想吃清单</a>
                            <a href="AnnouncementServlet">📢 站内公告</a>
                            <a href="AccountServlet">⚙️ 账户设置</a>
                            <a href="LogoutServlet" class="danger">⏻ 退出登录</a>
                        </div>
                    </details>
                <% } %>
            </div>
        </div>
    </header>

    <% if (announcements != null && !announcements.isEmpty()) { %>
    <section class="announce-ticker">
        <div class="announce-ticker-inner">
            <span class="announce-ticker-icon">📢</span>
            <div class="announce-ticker-track" id="announceTrack">
                <% for (int i = 0; i < announcements.size(); i++) {
                    Announcement a = announcements.get(i);
                %>
                <a href="AnnouncementServlet" class="announce-ticker-item">
                    <span class="announce-ticker-dot"></span>
                    <strong><%= com.util.HtmlUtil.escape(a.getTitle()) %></strong>
                    <span class="announce-ticker-sep">—</span>
                    <span><%= com.util.HtmlUtil.escape(a.getContent()) %></span>
                </a>
                <% } %>
                <% for (int i = 0; i < announcements.size(); i++) {
                    Announcement a = announcements.get(i);
                %>
                <a href="AnnouncementServlet" class="announce-ticker-item" aria-hidden="true">
                    <span class="announce-ticker-dot"></span>
                    <strong><%= com.util.HtmlUtil.escape(a.getTitle()) %></strong>
                    <span class="announce-ticker-sep">—</span>
                    <span><%= com.util.HtmlUtil.escape(a.getContent()) %></span>
                </a>
                <% } %>
            </div>
        </div>
    </section>
    <% } %>

    <main class="home-main">
        <div class="hero-section hero-section-v11">
            <div class="hero-content">
                <% if (loginUser == null) { %>
                    <span class="hero-kicker">校园食堂 · 智能推荐平台</span>
                    <h1 class="hero-title">发现校园<span class="gradient-text">好味道</span></h1>
                    <p class="hero-subtitle">浏览真实评价、开启寻味雷达、查看美食热榜，让每一餐都有靠谱参考。</p>
                    <div class="hero-cta-group">
                        <a href="AllEvaluateServlet" class="btn btn-primary btn-lg">查看评价</a>
                        <a href="TasteCompassServlet" class="btn btn-outline btn-lg">开启寻味雷达</a>
                        <a href="TrendBoardServlet" class="btn btn-ghost btn-lg">查看热榜</a>
                    </div>
                <% } else { %>
                    <span class="hero-kicker">欢迎回来</span>
                    <h1 class="hero-title">你好，<span class="username-color"><%= com.util.HtmlUtil.escape(displayName) %></span></h1>
                    <p class="hero-subtitle">今天想吃点什么？看看饭点推荐，或直接去寻味雷达找灵感。</p>
                    <div class="hero-cta-group">
                        <a href="AllEvaluateServlet" class="btn btn-primary btn-lg">查看评价</a>
                        <a href="TasteCompassServlet" class="btn btn-outline btn-lg">开启寻味雷达</a>
                        <a href="TrendBoardServlet" class="btn btn-ghost btn-lg">查看热榜</a>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- 今日饭点推荐 -->
        <section class="home-meal-section">
            <div class="section-head-inline">
                <div>
                    <h2>今日饭点推荐</h2>
                    <p>基于真实评价数据，为你精选三类就餐灵感</p>
                </div>
                <a href="TasteCompassServlet" class="btn btn-outline btn-sm">更多推荐 →</a>
            </div>
            <div class="meal-rec-grid">
                <c:forEach items="${mealRecommendations}" var="card">
                    <article class="meal-rec-card" style="--card-accent: ${empty card.coverColor ? '#7C3AED' : card.coverColor};">
                        <div class="meal-rec-head">
                            <span class="meal-rec-type">${card.recommendType}</span>
                            <c:if test="${card.fallback}"><span class="badge badge-muted">示例</span></c:if>
                        </div>
                        <h3 class="meal-rec-title"><c:out value="${card.title}"/></h3>
                        <p class="meal-rec-sub"><c:out value="${empty card.subtitle ? '热门餐厅' : card.subtitle}"/></p>
                        <div class="meal-rec-meta">
                            <span>⭐ <fmt:formatNumber value="${card.avgScore}" pattern="#.0"/></span>
                            <c:if test="${card.avgCost > 0}"><span>💰 约 ¥<fmt:formatNumber value="${card.avgCost}" pattern="#"/></span></c:if>
                            <c:if test="${card.reviewCount > 0}"><span>💬 ${card.reviewCount} 评</c:if>
                        </div>
                        <p class="meal-rec-reason"><c:out value="${card.reason}"/></p>
                        <a href="AllEvaluateServlet" class="meal-rec-link">去看看评价 →</a>
                    </article>
                </c:forEach>
            </div>
        </section>

        <!-- 最火档口 -->
        <section class="home-restaurant-section">
            <div class="section-head-inline">
                <div>
                    <h2>最火档口</h2>
                    <p>大家最爱去的前 3 家</p>
                </div>
                <a href="AllEvaluateServlet" class="btn btn-outline btn-sm">查看全部 →</a>
            </div>
            <div class="restaurant-card-grid">
                <c:forEach items="${restaurantList}" var="r">
                    <article class="restaurant-profile-card" style="--card-accent: ${empty r.coverColor ? '#7C3AED' : r.coverColor};">
                        <div class="rpc-cover">
                            <h3><c:out value="${r.name}"/></h3>
                            <span class="rpc-status ${r.open ? 'open' : 'closed'}"><c:out value="${r.statusLabel}"/></span>
                        </div>
                        <div class="rpc-body">
                            <div class="rpc-row"><span>📍</span><span><c:out value="${r.displayLocation}"/></span></div>
                            <div class="rpc-row"><span>🕐</span><span><c:out value="${r.displayOpenTime}"/></span></div>
                            <div class="rpc-row"><span>💰</span><span><c:out value="${r.displayAvgCost}"/></span></div>
                            <div class="rpc-tags">
                                <c:forEach items="${r.tagArray}" var="tag">
                                    <span class="badge badge-tag"><c:out value="${tag}"/></span>
                                </c:forEach>
                                <c:if test="${empty r.tagArray or fn:length(r.tagArray) == 0}">
                                    <span class="badge badge-muted">标签待补充</span>
                                </c:if>
                            </div>
                            <p class="rpc-desc"><c:out value="${r.displayDescription}"/></p>
                            <c:url value="AllEvaluateServlet" var="restUrl">
                                <c:param name="restaurant" value="${r.name}"/>
                            </c:url>
                            <a href="${restUrl}" class="btn btn-outline btn-sm btn-block">查看评价</a>
                        </div>
                    </article>
                </c:forEach>
                <c:if test="${empty restaurantList}">
                    <div class="empty-state-card">
                        <div class="empty-icon">🍴</div>
                        <p>暂无餐厅数据，请管理员在后台添加</p>
                    </div>
                </c:if>
            </div>
        </section>

        <section class="home-features">
            <div class="feature-grid-v2">
                <a href="AllEvaluateServlet" class="feature-item-v2">
                    <span class="feature-item-icon">📋</span>
                    <span class="feature-item-title">全站评价</span>
                    <span class="feature-item-desc">浏览所有美食点评</span>
                </a>
                <a href="TasteCompassServlet" class="feature-item-v2">
                    <span class="feature-item-icon">🧭</span>
                    <span class="feature-item-title">寻味雷达</span>
                    <span class="feature-item-desc">智能推荐好味道</span>
                </a>
                <a href="TrendBoardServlet" class="feature-item-v2">
                    <span class="feature-item-icon">🔥</span>
                    <span class="feature-item-title">美食热榜</span>
                    <span class="feature-item-desc">大家都在吃什么</span>
                </a>
                <a href="AddEvaluateServlet" class="feature-item-v2">
                    <span class="feature-item-icon">✍️</span>
                    <span class="feature-item-title">发布评价</span>
                    <span class="feature-item-desc">记录美食发现</span>
                </a>
            </div>
        </section>
    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z 版权所有 &nbsp;|&nbsp; 联系邮箱：8224439@qq.com
    </footer>

</body>
</html>
