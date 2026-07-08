<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    Boolean tableReady = (Boolean) request.getAttribute("tableReady");
    if (tableReady == null) tableReady = Boolean.FALSE;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>想吃清单 — 山海寻味录</title>
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
            <a href="${pageContext.request.contextPath}/AddEvaluateServlet">发布评价</a>
            <a href="${pageContext.request.contextPath}/MyEvaluateServlet">我的评价</a>
            <a href="${pageContext.request.contextPath}/TasteProfileServlet">味蕾档案</a>
            <a href="${pageContext.request.contextPath}/WishListServlet" class="active">想吃清单</a>
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
    <section class="feature-hero">
        <div class="feature-panel">
            <span class="feature-kicker" style="background:#FFF7ED;color:#C2410C;">Wish List · 从种草到打卡</span>
            <div>
                <h1 class="feature-title">想吃清单</h1>
                <p class="feature-subtitle">把寻味雷达或同学评价里看到的菜先收起来，吃过后再一键打卡，形成自己的校园美食路线。</p>
            </div>
            <div class="feature-actions">
                <a href="${pageContext.request.contextPath}/TasteCompassServlet" class="btn btn-primary">继续发现</a>
                <a href="${pageContext.request.contextPath}/AddEvaluateServlet" class="btn btn-outline">吃完写评价</a>
            </div>
        </div>
        <aside class="signal-panel">
            <div class="signal-title">清单主人</div>
            <div class="signal-number" style="font-size:28px;"><%= loginUser != null ? loginUser.getNickname() : "" %></div>
            <p class="signal-muted">清单只和当前账号绑定，不影响全站评价。</p>
        </aside>
    </section>

    <% if (!tableReady) { %>
        <div class="setup-box">
            想吃清单需要先执行数据库脚本：<strong>sql/feature_v3_wishlist.sql</strong>。执行后刷新本页即可使用。
        </div>
    <% } else { %>
    <section class="wish-layout">
        <aside class="wish-card">
            <h3>新增想吃</h3>
            <form action="${pageContext.request.contextPath}/WishActionServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-group">
                    <label class="form-label">餐厅/窗口</label>
                    <select name="restaurantId" class="form-input">
                        <option value="">暂不指定</option>
                        <c:forEach items="${restaurantList}" var="rest">
                            <option value="${rest.id}"><c:out value="${rest.name}"/></option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label class="form-label">菜品或窗口关键词</label>
                    <input class="form-input" name="dishName" maxlength="80" required placeholder="例如：麻辣香锅 / 牛肉面">
                </div>
                <div class="form-group">
                    <label class="form-label">备注</label>
                    <textarea class="form-input" name="note" maxlength="200" placeholder="比如和谁一起吃、什么时候去"></textarea>
                </div>
                <button class="btn btn-primary btn-block" type="submit">加入清单</button>
            </form>
        </aside>
        <section class="wish-card">
            <h3>待打卡</h3>
            <div class="wish-list">
                <c:forEach items="${openItems}" var="item">
                    <article class="wish-item">
                        <div><div class="wish-title"><c:out value="${item.dishName}"/></div><div class="wish-meta"><c:out value="${empty item.restaurantName ? '未指定餐厅' : item.restaurantName}"/> · <c:out value="${item.createTime}"/></div></div>
                        <c:if test="${not empty item.note}"><p class="quote-text"><c:out value="${item.note}"/></p></c:if>
                        <div class="inline-form">
                            <form action="${pageContext.request.contextPath}/WishActionServlet" method="post"><input type="hidden" name="action" value="done"><input type="hidden" name="id" value="${item.id}"><button class="btn btn-primary btn-sm" type="submit">已吃过</button></form>
                            <form action="${pageContext.request.contextPath}/WishActionServlet" method="post"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${item.id}"><button class="btn btn-outline btn-sm" type="submit">移除</button></form>
                        </div>
                    </article>
                </c:forEach>
                <c:if test="${empty openItems}"><div class="empty-inline">现在没有待打卡，去寻味雷达加一点灵感。</div></c:if>
            </div>
        </section>
    </section>

    <section class="wish-card mt-8">
        <h3>已打卡</h3>
        <div class="wish-list">
            <c:forEach items="${doneItems}" var="item">
                <article class="wish-item done">
                    <div><div class="wish-title"><c:out value="${item.dishName}"/></div><div class="wish-meta"><c:out value="${empty item.restaurantName ? '未指定餐厅' : item.restaurantName}"/> · 完成于 <c:out value="${item.finishTime}"/></div></div>
                    <div class="inline-form">
                        <form action="${pageContext.request.contextPath}/WishActionServlet" method="post"><input type="hidden" name="action" value="reopen"><input type="hidden" name="id" value="${item.id}"><button class="btn btn-outline btn-sm" type="submit">重新加入待打卡</button></form>
                        <form action="${pageContext.request.contextPath}/WishActionServlet" method="post"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${item.id}"><button class="btn btn-outline btn-sm" type="submit">删除</button></form>
                    </div>
                </article>
            </c:forEach>
            <c:if test="${empty doneItems}"><div class="empty-inline">还没有完成项。</div></c:if>
        </div>
    </section>
    <% } %>
</main>
<footer class="page-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</footer>
</body>
</html>
