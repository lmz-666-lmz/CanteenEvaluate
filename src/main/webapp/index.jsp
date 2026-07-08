<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.entity.Announcement" %>
<%@ page import="com.dao.AnnouncementDAO" %>
<%@ page import="java.util.List" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    String displayName = loginUser != null && loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty()
            ? loginUser.getNickname().trim() : "同学";
    String avatarText = displayName.length() > 0 ? displayName.substring(0, 1).toUpperCase() : "U";
    // 加载活跃公告（容错处理）
    List<Announcement> announcements = null;
    try {
        AnnouncementDAO annDAO = new AnnouncementDAO();
        announcements = annDAO.getActiveAnnouncements();
    } catch (Exception e) {
        announcements = null;
    }
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

    <!-- ========== Top Navigation ========== -->
    <header class="top-nav">
        <div class="nav-container">
            <a href="index.jsp" class="brand">
                <img src="images/logo.svg" alt="山海寻味录" onerror="this.style.display='none'">
                <span class="brand-name">山海寻味录</span>
            </a>

            <nav class="nav-pills">
                <a href="index.jsp" class="active">首页</a>
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
                            <a href="AccountServlet">⚙️ 账户设置</a>
                            <a href="LogoutServlet" class="danger">⏻ 退出登录</a>
                        </div>
                    </details>
                <% } %>
            </div>
        </div>
    </header>

    <!-- ========== Announcement Ticker ========== -->
    <% if (announcements != null && !announcements.isEmpty()) { %>
    <section class="announce-ticker">
        <div class="announce-ticker-inner">
            <span class="announce-ticker-icon">📢</span>
            <div class="announce-ticker-track" id="announceTrack">
                <% for (int i = 0; i < announcements.size(); i++) {
                    Announcement a = announcements.get(i);
                %>
                <a href="TasteCompassServlet" class="announce-ticker-item">
                    <span class="announce-ticker-dot"></span>
                    <strong><%= com.util.HtmlUtil.escape(a.getTitle()) %></strong>
                    <span class="announce-ticker-sep">—</span>
                    <span><%= com.util.HtmlUtil.escape(a.getContent()) %></span>
                </a>
                <% } %>
                <!-- clone for seamless loop -->
                <% for (int i = 0; i < announcements.size(); i++) {
                    Announcement a = announcements.get(i);
                %>
                <a href="TasteCompassServlet" class="announce-ticker-item" aria-hidden="true">
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

    <!-- ========== Hero Section ========== -->
    <main class="home-main">
        <div class="hero-section">
            <% if (loginUser == null) { %>
                <h1 class="hero-title">山海大学<span class="gradient-text">寻味录</span></h1>
                <p class="hero-subtitle">发现校园美食，分享你的味蕾体验</p>
                <a href="login.jsp" class="btn btn-primary btn-lg hero-cta">登录探索</a>
            <% } else { %>
                <h1 class="hero-title">你好，<span class="gradient-text"><%= com.util.HtmlUtil.escape(displayName) %></span></h1>
                <p class="hero-subtitle">今天想在山海大学吃点什么？</p>
            <% } %>
        </div>

        <!-- Feature Cards -->
        <section class="home-features">
            <div class="feature-grid">
                <a href="AllEvaluateServlet" class="feature-card feature-card-lg">
                    <div class="feature-card-inner">
                        <div class="feature-icon icon-blue">📋</div>
                        <div class="feature-card-text">
                            <h3>全站评价</h3>
                            <p>浏览所有人的美食点评</p>
                        </div>
                    </div>
                </a>
                <a href="TasteCompassServlet" class="feature-card">
                    <div class="feature-icon icon-emerald">🧭</div>
                    <h3>寻味雷达</h3>
                </a>
                <a href="TrendBoardServlet" class="feature-card">
                    <div class="feature-icon icon-amber">📊</div>
                    <h3>美食热榜</h3>
                </a>
                <a href="AddEvaluateServlet" class="feature-card feature-card-lg">
                    <div class="feature-card-inner">
                        <div class="feature-icon icon-purple">✨</div>
                        <div class="feature-card-text">
                            <h3>发布评价</h3>
                            <p>记录你的美食发现</p>
                        </div>
                    </div>
                </a>
                <a href="MyEvaluateServlet" class="feature-card">
                    <div class="feature-icon icon-amber">📁</div>
                    <h3>我的评价</h3>
                </a>
                <a href="TasteProfileServlet" class="feature-card">
                    <div class="feature-icon icon-blue">🎯</div>
                    <h3>味蕾档案</h3>
                </a>
                <a href="WishListServlet" class="feature-card">
                    <div class="feature-icon icon-emerald">✅</div>
                    <h3>想吃清单</h3>
                </a>
            </div>
        </section>
    </main>

    <!-- ========== Footer ========== -->
    <footer class="page-footer">
        © 2026 SHU.L.M.Z 版权所有 &nbsp;|&nbsp; 联系邮箱：8224439@qq.com
    </footer>

</body>
</html>
