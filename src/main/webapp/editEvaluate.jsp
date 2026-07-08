<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.entity.User" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改评价 — 山海寻味录</title>
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
                <a href="AddEvaluateServlet">发布评价</a>
                <a href="MyEvaluateServlet" class="active">我的评价</a>
                <a href="TasteProfileServlet">味蕾档案</a>
            </nav>

            <div class="nav-actions">
                <%
                    User eu = (User) session.getAttribute("loginUser");
                    String nick = eu.getNickname() != null && !eu.getNickname().trim().isEmpty() ? eu.getNickname().trim() : "同学";
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
                ✏️ <span class="gradient-text">修改历史评价</span>
            </h2>

            <form action="EditEvaluateServlet" method="post">
                <input type="hidden" name="id" value="${eval.id}">

                <div class="form-group">
                    <label class="form-label">
                        所属餐厅 <span class="optional">（评价发布后不可更改）</span>
                    </label>
                    <select class="form-input" disabled>
                        <c:forEach items="${restaurantList}" var="rest">
                            <option value="${rest.id}" ${rest.id == eval.restaurantId ? 'selected' : ''}>${rest.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">填写档口或菜品名称 <span class="required">*</span></label>
                    <input type="text" name="dishName" class="form-input"
                           value="${eval.dishName}" required>
                </div>

                <div class="score-group">
                    <div>
                        <label class="form-label">味道评分</label>
                        <select name="tasteScore" class="form-input" required>
                            <option value="5" ${eval.tasteScore == 5 ? 'selected' : ''}>⭐⭐⭐⭐⭐ 绝绝子</option>
                            <option value="4" ${eval.tasteScore == 4 ? 'selected' : ''}>⭐⭐⭐⭐ 还不错</option>
                            <option value="3" ${eval.tasteScore == 3 ? 'selected' : ''}>⭐⭐⭐ 一般般</option>
                            <option value="2" ${eval.tasteScore == 2 ? 'selected' : ''}>⭐⭐ 避雷</option>
                            <option value="1" ${eval.tasteScore == 1 ? 'selected' : ''}>⭐ 难吃</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">价格评分</label>
                        <select name="priceScore" class="form-input" required>
                            <option value="5" ${eval.priceScore == 5 ? 'selected' : ''}>⭐⭐⭐⭐⭐ 物超所值</option>
                            <option value="4" ${eval.priceScore == 4 ? 'selected' : ''}>⭐⭐⭐⭐ 价格适中</option>
                            <option value="3" ${eval.priceScore == 3 ? 'selected' : ''}>⭐⭐⭐ 有点贵</option>
                            <option value="2" ${eval.priceScore == 2 ? 'selected' : ''}>⭐⭐ 不划算</option>
                            <option value="1" ${eval.priceScore == 1 ? 'selected' : ''}>⭐ 纯大冤种</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">服务评分</label>
                        <select name="serviceScore" class="form-input" required>
                            <option value="5" ${eval.serviceScore == 5 ? 'selected' : ''}>⭐⭐⭐⭐⭐ 态度极好</option>
                            <option value="4" ${eval.serviceScore == 4 ? 'selected' : ''}>⭐⭐⭐⭐ 态度良好</option>
                            <option value="3" ${eval.serviceScore == 3 ? 'selected' : ''}>⭐⭐⭐ 正常</option>
                            <option value="2" ${eval.serviceScore == 2 ? 'selected' : ''}>⭐⭐ 态度冷淡</option>
                            <option value="1" ${eval.serviceScore == 1 ? 'selected' : ''}>⭐ 态度恶劣</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">评价内容 <span class="required">*</span></label>
                    <textarea name="content" class="form-input" rows="5" required>${eval.content}</textarea>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-lg">保存修改并返回</button>
            </form>
        </div>
    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </footer>

</body>
</html>
