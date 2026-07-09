<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>登录 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .auth-wrapper {
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 24px; background: #f0f2f5;
        }
        .auth-container {
            display: grid; grid-template-columns: 1fr 1fr;
            max-width: 880px; width: 100%; min-height: 540px;
            background: #fff; border-radius: 14px; overflow: hidden;
            box-shadow: 0 2px 20px rgba(0,0,0,0.06);
        }
        .auth-left {
            background: linear-gradient(160deg, #4f46e5 0%, #7c3aed 40%, #a855f7 100%);
            padding: 48px 36px; display: flex; flex-direction: column; justify-content: space-between;
            color: #fff; position: relative; overflow: hidden;
        }
        .auth-left::before {
            content: ''; position: absolute; top: -80px; right: -60px;
            width: 260px; height: 260px; border-radius: 50%;
            background: rgba(255,255,255,0.06); pointer-events: none;
        }
        .auth-left::after {
            content: ''; position: absolute; bottom: -40px; left: -30px;
            width: 160px; height: 160px; border-radius: 50%;
            background: rgba(255,255,255,0.04); pointer-events: none;
        }
        .auth-left * { position: relative; z-index: 1; }
        .auth-left-logo { display: flex; align-items: center; gap: 10px; }
        .auth-left-logo img { width: 38px; height: 38px; border-radius: 10px; background: #fff; padding: 2px; }
        .auth-left-logo span { font-size: 18px; font-weight: 700; }
        .auth-left-stats { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .auth-stat {
            background: rgba(255,255,255,0.1); border-radius: 10px; padding: 14px 16px;
            transition: transform 0.2s;
        }
        .auth-stat:hover { transform: translateY(-2px); background: rgba(255,255,255,0.15); }
        .auth-stat-num { font-size: 26px; font-weight: 800; line-height: 1; }
        .auth-stat-label { font-size: 11px; color: rgba(255,255,255,0.65); margin-top: 4px; }
        .auth-left-quote { font-size: 13px; color: rgba(255,255,255,0.55); line-height: 1.6; }
        .auth-left-quote strong { color: rgba(255,255,255,0.85); }

        .auth-right { padding: 48px 40px; display: flex; flex-direction: column; justify-content: center; }
        .auth-right h2 { font-size: 22px; font-weight: 700; color: #1a1a1a; margin-bottom: 4px; }
        .auth-right .sub { font-size: 13px; color: #999; margin-bottom: 24px; }

        .stat-loading { opacity: 0.5; animation: pulse 1.5s infinite; }
        @keyframes pulse { 0%,100%{opacity:0.5} 50%{opacity:1} }
        @keyframes countUp { from { opacity:0; transform:translateY(4px); } to { opacity:1; transform:translateY(0); } }
        .stat-loaded { animation: countUp 0.4s ease forwards; }

        @media (max-width: 768px) {
            .auth-container { grid-template-columns: 1fr; max-width: 420px; }
            .auth-left { padding: 28px 24px; min-height: auto; }
            .auth-left-stats { display: none; }
            .auth-left-quote { display: none; }
            .auth-right { padding: 32px 24px; }
        }
    </style>
</head>
<body class="auth-wrapper">

<div class="auth-container">
    <div class="auth-left">
        <div class="auth-left-logo">
            <img src="images/logo.svg" alt="Logo" onerror="this.style.display='none'">
            <span>山海寻味录</span>
        </div>
        <div class="auth-left-stats" id="authStats">
            <div class="auth-stat stat-loading"><div class="auth-stat-num">--</div><div class="auth-stat-label">注册用户</div></div>
            <div class="auth-stat stat-loading"><div class="auth-stat-num">--</div><div class="auth-stat-label">入驻餐厅</div></div>
            <div class="auth-stat stat-loading"><div class="auth-stat-num">--</div><div class="auth-stat-label">全站评价</div></div>
            <div class="auth-stat stat-loading"><div class="auth-stat-num">--</div><div class="auth-stat-label">活跃推荐官</div></div>
        </div>
        <p class="auth-left-quote">把今天吃到的<strong>好味道</strong>，<br>留给下一位同学。</p>
    </div>

    <div class="auth-right">
        <h2 onclick="titleClick()" style="cursor:pointer;" title="连点 3 次切换管理员">登录账号</h2>
        <p class="sub">继续探索校园食堂的真实评价</p>

        <% if (request.getAttribute("successMsg") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("successMsg") %></div>
        <% } %>
        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMsg") %></div>
        <% } %>

        <div id="userLoginPanel">
            <form action="LoginServlet" method="post" onsubmit="return validateUserLogin()">
                <div class="form-group">
                    <label class="form-label" for="username">用户名</label>
                    <input type="text" id="username" name="username" class="form-input"
                           placeholder="请输入学号 / 账号" autocomplete="username"
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                    <div id="uTipErr" class="form-error">用户名不能为空</div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="password">密码</label>
                    <input type="password" id="password" name="password" class="form-input"
                           placeholder="请输入登录密码" autocomplete="current-password">
                    <div id="pTipErr" class="form-error">密码不能为空</div>
                </div>
                <div class="form-group">
                    <label class="form-label" for="verifyCode">验证码</label>
                    <div class="verify-row">
                        <input type="text" id="verifyCode" name="verifyCode" class="form-input"
                               maxlength="4" placeholder="4 位验证码" autocomplete="off" style="flex:1;">
                        <button type="button" class="verify-img-box" onclick="refreshVerifyCode()" title="点击刷新">
                            <img id="verifyCodeImg" src="VerifyCodeServlet" alt="验证码">
                        </button>
                    </div>
                    <div id="vTipErr" class="form-error">验证码不能为空</div>
                </div>
                <button type="submit" class="btn btn-primary btn-block mt-4">立即登录</button>
            </form>
            <a href="AllEvaluateServlet" class="btn btn-outline btn-block mt-4">游客模式浏览</a>
            <div class="link-group">没有账号？<a href="register.jsp">立即注册</a> · <a href="index.jsp">返回首页</a></div>
        </div>

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
            <div class="link-group"><a href="javascript:switchLoginMode()">返回用户登录</a></div>
        </div>
    </div>
</div>

<footer class="page-footer" style="position:fixed;bottom:0;left:0;right:0;background:transparent;color:#bbb;">&copy; 2026 SHU.L.M.Z &middot; 8224439@qq.com</footer>

<script>
function countUp(el, target, duration) {
    var start = 0;
    var step = Math.ceil(target / (duration / 16));
    var timer = setInterval(function(){
        start += step;
        if (start >= target) { start = target; clearInterval(timer); }
        el.textContent = start;
    }, 16);
}

fetch('api/stats').then(function(r){return r.json()}).then(function(d){
    var el = document.getElementById('authStats');
    if(!el) return;
    el.innerHTML =
        '<div class="auth-stat stat-loaded"><div class="auth-stat-num" data-target="'+d.users+'">0</div><div class="auth-stat-label">注册用户</div></div>'+
        '<div class="auth-stat stat-loaded"><div class="auth-stat-num" data-target="'+d.restaurants+'">0</div><div class="auth-stat-label">入驻餐厅</div></div>'+
        '<div class="auth-stat stat-loaded"><div class="auth-stat-num" data-target="'+d.evals+'">0</div><div class="auth-stat-label">全站评价</div></div>'+
        '<div class="auth-stat stat-loaded"><div class="auth-stat-num" data-target="'+d.active+'">0</div><div class="auth-stat-label">活跃推荐官</div></div>';
    var nums = el.querySelectorAll('.auth-stat-num');
    nums.forEach(function(n, i){
        var target = parseInt(n.getAttribute('data-target')) || 0;
        setTimeout(function(){ countUp(n, target, 1200); }, i * 150);
    });
}).catch(function(){});

function validateUserLogin() {
    var u = document.getElementById('username').value.trim();
    var p = document.getElementById('password').value;
    var v = document.getElementById('verifyCode').value.trim();
    document.getElementById('uTipErr').style.display = u === '' ? 'block' : 'none';
    document.getElementById('pTipErr').style.display = p === '' ? 'block' : 'none';
    document.getElementById('vTipErr').style.display = v === '' ? 'block' : 'none';
    return u !== '' && p !== '' && v !== '';
}
function validateAdminLogin() {
    var au = document.getElementById('adminUser').value.trim();
    var ap = document.getElementById('adminPwd').value;
    document.getElementById('auTipErr').style.display = au === '' ? 'block' : 'none';
    document.getElementById('apTipErr').style.display = ap === '' ? 'block' : 'none';
    return au !== '' && ap !== '';
}
function refreshVerifyCode() {
    document.getElementById('verifyCodeImg').src = 'VerifyCodeServlet?' + new Date().getTime();
}
var _c = 0;
function titleClick() { _c++; if (_c >= 3) { switchLoginMode(); _c = 0; } }
function switchLoginMode() {
    var u = document.getElementById('userLoginPanel');
    var a = document.getElementById('adminLoginPanel');
    if (a.style.display === 'none') { u.style.display = 'none'; a.style.display = 'block'; }
    else { a.style.display = 'none'; u.style.display = 'block'; }
}
</script>
</body>
</html>
