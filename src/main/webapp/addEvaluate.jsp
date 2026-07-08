<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布评价 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
</head>
<body>

    <!-- ========== Top Navigation ========== -->
    <header class="top-nav">
        <div class="nav-container">
            <a href="index.jsp" class="brand">
                <img src="images/logo.svg" alt="Logo"
                     onerror="this.style.display='none'">
                <span class="brand-name">山海寻味录</span>
            </a>

            <nav class="nav-pills">
                <a href="index.jsp">首页</a>
                <a href="AllEvaluateServlet">全站评价</a>
                <a href="TasteCompassServlet">寻味雷达</a>
                <a href="TrendBoardServlet">热榜</a>
                <a href="AddEvaluateServlet" class="active">发布评价</a>
                <a href="MyEvaluateServlet">我的评价</a>
                <a href="TasteProfileServlet">味蕾档案</a>
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
                        <a href="TasteProfileServlet">🎯 味蕾档案</a>
                        <a href="WishListServlet">✅ 想吃清单</a>
                        <a href="AccountServlet">⚙️ 账户设置</a>
                        <a href="LogoutServlet" class="danger">⏻ 退出登录</a>
                    </div>
                </details>
            </div>
        </div>
    </header>

    <!-- ========== Form Content ========== -->
    <main class="page-narrow">
        <div class="card">
            <h2 class="auth-title" style="margin-bottom:var(--space-10);">
                ✍️ <span class="gradient-text">记录美食体验</span>
            </h2>

            <form action="AddEvaluateServlet" method="post">
                <div class="form-group">
                    <label class="form-label">选择餐厅 <span class="required">*</span></label>
                    <select name="restaurantId" class="form-input" required>
                        <option value="" disabled selected>请选择所属餐厅…</option>
                        <c:forEach items="${restaurantList}" var="rest">
                            <option value="${rest.id}">${rest.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">填写档口或菜品名称 <span class="required">*</span></label>
                    <input type="text" name="dishName" class="form-input"
                           placeholder="例如：林渝炸鸡腿 — 琵琶腿" required>
                </div>

                <div class="score-group">
                    <div>
                        <label class="form-label">味道评分</label>
                        <select name="tasteScore" class="form-input" required>
                            <option value="5">⭐⭐⭐⭐⭐ 绝绝子</option>
                            <option value="4">⭐⭐⭐⭐ 还不错</option>
                            <option value="3">⭐⭐⭐ 一般般</option>
                            <option value="2">⭐⭐ 避雷</option>
                            <option value="1">⭐ 难吃</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">价格评分</label>
                        <select name="priceScore" class="form-input" required>
                            <option value="5">⭐⭐⭐⭐⭐ 物超所值</option>
                            <option value="4">⭐⭐⭐⭐ 价格适中</option>
                            <option value="3">⭐⭐⭐ 有点贵</option>
                            <option value="2">⭐⭐ 不划算</option>
                            <option value="1">⭐ 纯大冤种</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">服务评分</label>
                        <select name="serviceScore" class="form-input" required>
                            <option value="5">⭐⭐⭐⭐⭐ 态度极好</option>
                            <option value="4">⭐⭐⭐⭐ 态度良好</option>
                            <option value="3">⭐⭐⭐ 正常</option>
                            <option value="2">⭐⭐ 态度冷淡</option>
                            <option value="1">⭐ 态度恶劣</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">评价内容 <span class="required">*</span></label>
                    <textarea name="content" class="form-input" placeholder="分享一下真实的用餐体验吧，您的评价能帮助更多同学！" required></textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg">立即发布评价</button>
            </form>
        </div>
    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </footer>

</body>
</html>
