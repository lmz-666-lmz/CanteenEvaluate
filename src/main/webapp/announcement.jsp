<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    String nick = loginUser != null && loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty()
            ? loginUser.getNickname().trim() : null;
    String avatar = nick != null ? nick.substring(0,1).toUpperCase() : "U";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>站内公告 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .ann-page { max-width: 680px; margin: 0 auto; padding: 40px 24px 80px; }

        .ann-hero {
            text-align: center; padding: 32px 24px 28px; margin-bottom: 28px;
            background: #f9fafb; border: 1px solid #e5e7eb;
            border-radius: 14px;
        }
        .ann-hero-icon { font-size: 36px; margin-bottom: 8px; display: block; }
        .ann-hero h1 { font-size: 22px; font-weight: 700; color: #1a1a1a; margin: 0 0 4px; }
        .ann-hero p { font-size: 13px; color: #888; margin: 0; }

        .ann-timeline { position: relative; padding-left: 28px; }
        .ann-timeline::before {
            content: ''; position: absolute; left: 13px; top: 8px; bottom: 8px;
            width: 2px; background: #e5e7eb; border-radius: 1px;
        }

        .ann-card {
            background: #fff; border: 1px solid #e5e7eb; border-radius: 12px;
            padding: 22px 24px; margin-bottom: 16px; position: relative;
            transition: box-shadow 0.15s ease; box-shadow: 0 1px 2px rgba(0,0,0,0.03);
        }
        .ann-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.05); }
        .ann-card::before {
            content: ''; position: absolute; left: -19px; top: 26px;
            width: 8px; height: 8px; border-radius: 50%;
            background: #fff; border: 2px solid #10B981;
        }

        .ann-card-header { display: flex; align-items: flex-start; gap: 10px; margin-bottom: 10px; }
        .ann-card-icon {
            width: 36px; height: 36px; border-radius: 8px; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center; font-size: 18px;
            background: #ECFDF5;
        }
        .ann-card h3 { font-size: 16px; font-weight: 700; color: #1a1a1a; margin: 0; line-height: 1.4; flex: 1; }
        .ann-card .ann-time { font-size: 12px; color: #aaa; white-space: nowrap; flex-shrink: 0; display: flex; align-items: center; gap: 3px; }
        .ann-card .ann-body { font-size: 14px; color: #666; line-height: 1.75; margin: 0; padding-left: 46px; }

        .ann-empty {
            text-align: center; padding: 60px 20px;
            background: #fff; border-radius: 14px; border: 2px dashed #e5e7eb;
        }
        .ann-empty-icon { font-size: 48px; margin-bottom: 12px; opacity: 0.35; }
        .ann-empty p { font-size: 14px; color: #999; margin: 0; }

        @keyframes annFadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }
        .ann-card { animation: annFadeIn 0.4s ease forwards; }
        .ann-card:nth-child(1) { animation-delay: 0s; }
        .ann-card:nth-child(2) { animation-delay: 0.06s; }
        .ann-card:nth-child(3) { animation-delay: 0.12s; }
        .ann-card:nth-child(4) { animation-delay: 0.18s; }
        .ann-card:nth-child(5) { animation-delay: 0.24s; }

        @media (max-width: 600px) {
            .ann-page { padding: 24px 16px 64px; }
            .ann-hero { padding: 24px 16px 20px; }
            .ann-timeline { padding-left: 20px; }
            .ann-timeline::before { left: 9px; }
            .ann-card { padding: 18px 16px; }
            .ann-card::before { left: -14px; width: 6px; height: 6px; }
            .ann-card .ann-body { padding-left: 0; margin-top: 6px; }
            .ann-card-header { flex-wrap: wrap; }
        }
    </style>
</head>
<body>

<header class="top-nav">
    <div class="nav-container">
        <a href="index.jsp" class="brand">
            <img src="images/logo.svg" alt="Logo" onerror="this.style.display='none'">
            <span class="brand-name">山海寻味录</span>
        </a>
        <nav class="nav-pills">
            <a href="index.jsp">首页</a>
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
                        <span class="user-avatar"><%= avatar %></span>
                        <span class="user-menu-name"><%= nick %></span>
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

<main class="ann-page">
    <div class="ann-hero">
        <span class="ann-hero-icon">📢</span>
        <h1>站内公告</h1>
        <p>校园食堂相关通知与最新动态</p>
    </div>

    <c:choose>
        <c:when test="${empty announcements}">
            <div class="ann-empty">
                <div class="ann-empty-icon">📭</div>
                <p>暂无公告，敬请期待</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="ann-timeline">
                <c:forEach items="${announcements}" var="a" varStatus="loop">
                    <div class="ann-card">
                        <div class="ann-card-header">
                            <span class="ann-card-icon"><c:out value="${loop.index % 2 == 0 ? '📌' : '🔔'}"/></span>
                            <h3><c:out value="${a.title}"/></h3>
                            <span class="ann-time">🕐 <c:out value="${a.createTime}"/></span>
                        </div>
                        <p class="ann-body"><c:out value="${a.content}"/></p>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<footer class="page-footer">© 2026 SHU.L.M.Z · 8224439@qq.com</footer>
</body>
</html>
