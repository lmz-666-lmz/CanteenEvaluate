<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>注册 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .auth-wrapper {
            min-height: 100vh; display: flex; align-items: center; justify-content: center;
            padding: 24px; background: #f0f2f5;
        }
        .auth-container {
            display: grid; grid-template-columns: 1fr 1fr;
            max-width: 880px; width: 100%; min-height: 560px;
            background: #fff; border-radius: 14px; overflow: hidden;
            box-shadow: 0 2px 20px rgba(0,0,0,0.06);
        }
        .auth-left {
            background: linear-gradient(160deg, #059669 0%, #10b981 40%, #34d399 100%);
            padding: 48px 36px; display: flex; flex-direction: column; justify-content: space-between;
            color: #fff; position: relative; overflow: hidden;
        }
        .auth-left::before {
            content: ''; position: absolute; top: -60px; right: -50px;
            width: 240px; height: 240px; border-radius: 50%;
            background: rgba(255,255,255,0.06); pointer-events: none;
        }
        .auth-left * { position: relative; z-index: 1; }
        .auth-left-logo { display: flex; align-items: center; gap: 10px; }
        .auth-left-logo img { width: 38px; height: 38px; border-radius: 10px; background: #fff; padding: 2px; }
        .auth-left-logo span { font-size: 18px; font-weight: 700; }
        .auth-left-features { display: flex; flex-direction: column; gap: 20px; }
        .auth-feat { display: flex; align-items: flex-start; gap: 14px; }
        .auth-feat-num {
            width: 40px; height: 40px; border-radius: 50%;
            background: rgba(255,255,255,0.2); color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 17px; font-weight: 700; flex-shrink: 0;
            border: 2px solid rgba(255,255,255,0.3);
        }
        .auth-feat h4 { font-size: 15px; font-weight: 700; margin: 0; line-height: 1.3; }
        .auth-feat p { font-size: 12px; color: rgba(255,255,255,0.7); margin: 2px 0 0; line-height: 1.5; }
        .auth-left-quote { font-size: 13px; color: rgba(255,255,255,0.55); line-height: 1.6; padding-top: 8px; border-top: 1px solid rgba(255,255,255,0.12); }

        .auth-right { padding: 48px 40px; display: flex; flex-direction: column; justify-content: center; }
        .auth-right h2 { font-size: 22px; font-weight: 700; color: #1a1a1a; margin-bottom: 4px; }
        .auth-right .sub { font-size: 13px; color: #999; margin-bottom: 24px; }

        @media (max-width: 768px) {
            .auth-container { grid-template-columns: 1fr; max-width: 420px; }
            .auth-left { padding: 28px 24px; min-height: auto; }
            .auth-left-features { display: none; }
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
        <div class="auth-left-features">
            <div class="auth-feat">
                <span class="auth-feat-num">1</span>
                <div><h4>记录真实味道</h4><p>从口味、价格、服务三个维度评价每一餐</p></div>
            </div>
            <div class="auth-feat">
                <span class="auth-feat-num">2</span>
                <div><h4>发现个人口味</h4><p>味蕾档案自动分析你的偏好，帮你找到最爱</p></div>
            </div>
            <div class="auth-feat">
                <span class="auth-feat-num">3</span>
                <div><h4>收藏想吃清单</h4><p>种草心仪菜品，按计划打卡，形成美食地图</p></div>
            </div>
        </div>
        <p class="auth-left-quote">加入山海寻味录，<br>和同学们一起探索校园里的每一份好味道。</p>
    </div>

    <div class="auth-right">
        <h2>创建账号</h2>
        <p class="sub">注册后即可发布评价、使用全部功能</p>

        <% if (request.getAttribute("errorMsg") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("errorMsg") %></div>
        <% } %>

        <form action="RegisterServlet" method="post" onsubmit="return validateReg()">
            <div class="form-group">
                <label class="form-label" for="username">用户名</label>
                <input type="text" id="username" name="username" class="form-input"
                       placeholder="3-20 位字母或数字" autocomplete="username"
                       value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
                <div id="uTipErr" class="form-error">请输入 3-20 位用户名</div>
            </div>
            <div class="form-group">
                <label class="form-label" for="nickname">昵称</label>
                <input type="text" id="nickname" name="nickname" class="form-input"
                       placeholder="给自己取个好听的名字吧">
            </div>
            <div class="form-group">
                <label class="form-label" for="password">密码</label>
                <input type="password" id="password" name="password" class="form-input"
                       placeholder="至少 6 位，包含字母和数字" autocomplete="new-password">
                <div id="pTipErr" class="form-error">密码需至少 6 位，包含字母和数字</div>
            </div>
            <div class="form-group">
                <label class="form-label" for="confirmPwd">确认密码</label>
                <input type="password" id="confirmPwd" name="confirmPwd" class="form-input"
                       placeholder="请再次输入密码" autocomplete="new-password">
                <div id="cpTipErr" class="form-error">两次密码不一致</div>
            </div>
            <button type="submit" class="btn btn-primary btn-block mt-4">立即注册</button>
        </form>

        <div class="link-group">已有账号？<a href="login.jsp">去登录</a> &middot; <a href="index.jsp">返回首页</a></div>
    </div>
</div>

<footer class="page-footer" style="position:fixed;bottom:0;left:0;right:0;background:transparent;color:#bbb;">&copy; 2026 SHU.L.M.Z &middot; 8224439@qq.com</footer>

<script>
function validateReg() {
    var u = document.getElementById('username').value.trim();
    var p = document.getElementById('password').value;
    var cp = document.getElementById('confirmPwd').value;
    var uOk = u.length >= 3 && u.length <= 20 && /^[a-zA-Z0-9_一-龥]+$/.test(u);
    var pOk = p.length >= 6 && /[A-Za-z]/.test(p) && /\d/.test(p);
    document.getElementById('uTipErr').style.display = uOk ? 'none' : 'block';
    document.getElementById('pTipErr').style.display = pOk ? 'none' : 'block';
    document.getElementById('cpTipErr').style.display = (p === cp && p !== '') ? 'none' : 'block';
    return uOk && pOk && p === cp;
}
</script>
</body>
</html>
