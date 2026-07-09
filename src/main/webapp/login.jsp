<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>登录 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
</head>
<body class="auth-page">

    <main class="auth-shell">
        <section class="auth-visual" aria-label="山海寻味录">
            <a href="index.jsp" class="auth-brand">
                <span class="auth-logo">
                    <img src="images/logo.svg" alt="山海寻味录" onerror="this.style.display='none'">
                    <span class="auth-logo-fallback">SHU</span>
                </span>
                <span>
                    <strong>山海寻味录</strong>
                    <small>Campus Taste Notes</small>
                </span>
            </a>

            <div class="auth-hero-copy">
                <span class="auth-kicker">学生食堂评价平台</span>
                <h1>把今天吃到的好味道，留给下一位同学。</h1>
                <p>查看真实评价、记录个人口味、发现校园热门菜品。</p>
            </div>

            <div class="auth-preview">
                <div class="auth-preview-head">
                    <span>今日热度</span>
                    <strong>4.8</strong>
                </div>
                <div class="auth-score-row">
                    <span>菜品口味</span>
                    <div class="auth-score-bar"><i style="width:92%"></i></div>
                </div>
                <div class="auth-score-row">
                    <span>就餐环境</span>
                    <div class="auth-score-bar"><i style="width:78%"></i></div>
                </div>
                <div class="auth-score-row">
                    <span>服务体验</span>
                    <div class="auth-score-bar"><i style="width:84%"></i></div>
                </div>
            </div>

            <div class="auth-quick-grid" aria-hidden="true">
                <span>全站评价</span>
                <span>寻味雷达</span>
                <span>美食热榜</span>
            </div>
        </section>

        <section class="auth-card">
            <div class="auth-card-head">
                <span class="auth-kicker">欢迎回来</span>
                <h2 class="auth-title" onclick="titleClick()" title="连续点击标题 3 次切换管理员登录">
                    <span class="gradient-text">登录账号</span>
                </h2>
                <p class="auth-lead">继续探索校园食堂的真实评价。</p>
            </div>

            <%-- Server-side message --%>
            <% if (request.getAttribute("successMsg") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("successMsg") %></div>
            <% } %>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("errorMsg") %></div>
            <% } %>

            <%-- ========== User Login Panel ========== --%>
            <div id="userLoginPanel">
                <form action="LoginServlet" method="post" onsubmit="return validateUserLogin()">
                    <div class="form-group">
                        <label class="form-label" for="username">用户名</label>
                        <input type="text" id="username" name="username" class="form-input"
                               placeholder="请输入学号 / 账号"
                               autocomplete="username"
                               value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                        <div id="uTipErr" class="form-error">用户名不能为空</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">密码</label>
                        <input type="password" id="password" name="password" class="form-input"
                               placeholder="请输入登录密码"
                               autocomplete="current-password">
                        <div id="pTipErr" class="form-error">密码不能为空</div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="verifyCode">验证码</label>
                        <div class="verify-row">
                            <input type="text" id="verifyCode" name="verifyCode" class="form-input"
                                   maxlength="4" placeholder="输入 4 位验证码" autocomplete="off">
                            <button type="button" class="verify-img-box" onclick="refreshVerifyCode()" title="点击刷新验证码">
                                <img id="verifyCodeImg" src="VerifyCodeServlet" alt="验证码">
                            </button>
                        </div>
                        <div id="vTipErr" class="form-error">验证码不能为空</div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block mt-4">立即登录</button>
                </form>

                <a href="AllEvaluateServlet" class="btn btn-guest btn-block mt-4">游客模式浏览</a>

                <div class="link-group">
                    没有账号？<a href="register.jsp">立即注册</a> &nbsp;·&nbsp; <a href="index.jsp">返回首页</a>
                </div>
            </div>

            <%-- ========== Admin Login Panel ========== --%>
            <div id="adminLoginPanel" style="display:none;">
                <div class="admin-mode-badge">系统管理入口</div>
                <h3 class="auth-subtitle">管理员登录</h3>
                <form action="AdminLoginServlet" method="post" onsubmit="return validateAdminLogin()">
                    <div class="form-group">
                        <label class="form-label" for="adminUser">管理员账号</label>
                        <input type="text" id="adminUser" name="username" class="form-input"
                               placeholder="请输入管理权限账号" autocomplete="username">
                        <div id="auTipErr" class="form-error">管理员账号不能为空</div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="adminPwd">管理员密码</label>
                        <input type="password" id="adminPwd" name="password" class="form-input"
                               placeholder="请输入管理员密码" autocomplete="current-password">
                        <div id="apTipErr" class="form-error">管理员密码不能为空</div>
                    </div>

                    <button type="submit" class="btn btn-dark btn-block mt-4">管理员授权登录</button>

                    <% if (request.getAttribute("msg") != null) { %>
                        <div class="alert alert-error mt-4"><%= request.getAttribute("msg") %></div>
                    <% } %>
                </form>

                <div class="link-group">
                    <a href="javascript:switchLoginMode()">返回用户登录</a>
                </div>
            </div>
        </section>
    </main>

    <div class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </div>

<script>
    // —— User login validation ——
    function validateUserLogin() {
        var u = document.getElementById('username').value.trim();
        var p = document.getElementById('password').value;
        var v = document.getElementById('verifyCode').value.trim();
        var ok = true;

        document.getElementById('uTipErr').style.display = u === '' ? 'block' : 'none';
        document.getElementById('pTipErr').style.display = p === '' ? 'block' : 'none';
        document.getElementById('vTipErr').style.display = v === '' ? 'block' : 'none';

        if (u === '' || p === '' || v === '') ok = false;
        return ok;
    }

    // —— Admin login validation ——
    function validateAdminLogin() {
        var au = document.getElementById('adminUser').value.trim();
        var ap = document.getElementById('adminPwd').value;
        var ok = true;

        document.getElementById('auTipErr').style.display = au === '' ? 'block' : 'none';
        document.getElementById('apTipErr').style.display = ap === '' ? 'block' : 'none';

        if (au === '' || ap === '') ok = false;
        return ok;
    }

    // —— Refresh captcha ——
    function refreshVerifyCode() {
        document.getElementById('verifyCodeImg').src = 'VerifyCodeServlet?' + new Date().getTime();
    }

    // —— Title click counter → admin switch (Easter egg) ——
    var _clickCount = 0;
    function titleClick() {
        _clickCount++;
        if (_clickCount >= 3) {
            switchLoginMode();
            _clickCount = 0;
        }
    }

    // —— Toggle user / admin panel ——
    function switchLoginMode() {
        var userPanel = document.getElementById('userLoginPanel');
        var adminPanel = document.getElementById('adminLoginPanel');
        if (adminPanel.style.display === 'none') {
            userPanel.style.display = 'none';
            adminPanel.style.display = 'block';
        } else {
            adminPanel.style.display = 'none';
            userPanel.style.display = 'block';
        }
    }
</script>
</body>
</html>
