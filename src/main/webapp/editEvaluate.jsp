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
    <style>
        .score-section { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 24px; }
        .score-col { text-align: center; }
        .score-col-label { font-size: 13px; font-weight: 700; color: #555; margin-bottom: 10px; }
        .score-btns { display: flex; gap: 6px; justify-content: center; flex-wrap: wrap; }
        .score-btn {
            width: 44px; height: 50px; border-radius: 10px; border: 1.5px solid #e5e5e5;
            background: #fff; cursor: pointer; font-size: 20px; line-height: 1;
            transition: all 0.18s ease; padding: 0; display: flex; flex-direction: column;
            align-items: center; justify-content: center; gap: 2px;
        }
        .score-btn:hover { border-color: #bbb; transform: translateY(-2px); box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
        .score-btn.active { border-color: #6366F1; background: #EEF2FF; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); transform: translateY(-1px); }
        .score-btn.active.taste { border-color: #F59E0B; background: #FFFBEB; box-shadow: 0 0 0 3px rgba(245,158,11,0.1); }
        .score-btn.active.price { border-color: #10B981; background: #ECFDF5; box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
        .score-btn.active.service { border-color: #6366F1; background: #EEF2FF; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
        .score-btn span { font-size: 9px; font-weight: 600; color: #888; }
        .score-btn.active span { color: #555; }
        @media (max-width: 768px) {
            .score-section { grid-template-columns: 1fr; gap: 18px; }
            .score-btn { width: 38px; height: 44px; font-size: 18px; }
        }
    </style>
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
                        <a href="AnnouncementServlet">📢 站内公告</a>
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

                <div class="score-section">
                    <div class="score-col">
                        <div class="score-col-label">😋 味道</div>
                        <div class="score-btns" data-name="tasteScore">
                            <button type="button" class="score-btn taste" data-val="5">😍<span>超赞</span></button>
                            <button type="button" class="score-btn" data-val="4">😊<span>好吃</span></button>
                            <button type="button" class="score-btn" data-val="3">😐<span>还行</span></button>
                            <button type="button" class="score-btn" data-val="2">😕<span>一般</span></button>
                            <button type="button" class="score-btn" data-val="1">🤢<span>避雷</span></button>
                        </div>
                        <input type="hidden" name="tasteScore" value="${eval.tasteScore}">
                    </div>
                    <div class="score-col">
                        <div class="score-col-label">💰 价格</div>
                        <div class="score-btns" data-name="priceScore">
                            <button type="button" class="score-btn" data-val="5">🤑<span>超值</span></button>
                            <button type="button" class="score-btn" data-val="4">👍<span>合适</span></button>
                            <button type="button" class="score-btn" data-val="3">🤔<span>略贵</span></button>
                            <button type="button" class="score-btn" data-val="2">😒<span>不值</span></button>
                            <button type="button" class="score-btn" data-val="1">💸<span>血亏</span></button>
                        </div>
                        <input type="hidden" name="priceScore" value="${eval.priceScore}">
                    </div>
                    <div class="score-col">
                        <div class="score-col-label">🤝 服务</div>
                        <div class="score-btns" data-name="serviceScore">
                            <button type="button" class="score-btn" data-val="5">🥰<span>极好</span></button>
                            <button type="button" class="score-btn" data-val="4">😄<span>不错</span></button>
                            <button type="button" class="score-btn" data-val="3">🙂<span>正常</span></button>
                            <button type="button" class="score-btn" data-val="2">😐<span>冷淡</span></button>
                            <button type="button" class="score-btn" data-val="1">😤<span>恶劣</span></button>
                        </div>
                        <input type="hidden" name="serviceScore" value="${eval.serviceScore}">
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

<script>
// Init score buttons to match existing values
document.querySelectorAll('.score-btns').forEach(function(group) {
    var name = group.getAttribute('data-name');
    var input = document.querySelector('input[name="'+name+'"]');
    var currentVal = input ? parseInt(input.value) : 3;
    group.querySelectorAll('.score-btn').forEach(function(btn) {
        var val = parseInt(btn.getAttribute('data-val'));
        if (val === currentVal) {
            btn.classList.add('active');
            if (name === 'tasteScore') btn.classList.add('taste');
            if (name === 'priceScore') btn.classList.add('price');
            if (name === 'serviceScore') btn.classList.add('service');
        }
    });
});

// Score button interaction
document.querySelectorAll('.score-btns').forEach(function(group) {
    group.addEventListener('click', function(e) {
        var btn = e.target.closest('.score-btn');
        if (!btn) return;
        var name = group.getAttribute('data-name');
        var input = document.querySelector('input[name="'+name+'"]');
        var val = btn.getAttribute('data-val');
        if (input) input.value = val;
        group.querySelectorAll('.score-btn').forEach(function(b) {
            b.classList.remove('active','taste','price','service');
        });
        btn.classList.add('active');
        if (name === 'tasteScore') btn.classList.add('taste');
        if (name === 'priceScore') btn.classList.add('price');
        if (name === 'serviceScore') btn.classList.add('service');
    });
});
</script>
</body>
</html>
