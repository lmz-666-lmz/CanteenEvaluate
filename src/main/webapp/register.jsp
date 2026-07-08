<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>注册 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
</head>
<body class="auth-page">

    <main class="auth-shell auth-shell-register">
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
                <span class="auth-kicker">加入校园美食社区</span>
                <h1>创建账号，开始记录你的食堂口味地图。</h1>
                <p>发布评价、沉淀偏好、收藏想吃清单。</p>
            </div>

            <div class="auth-preview auth-preview-stack">
                <div class="auth-mini-eval">
                    <span class="auth-mini-avatar">北</span>
                    <div>
                        <strong>北门食堂 · 鸡排饭</strong>
                        <small>口味 4.7 · 环境 4.5 · 服务 4.6</small>
                    </div>
                </div>
                <div class="auth-mini-eval">
                    <span class="auth-mini-avatar auth-mini-avatar-teal">燕</span>
                    <div>
                        <strong>山海餐厅 · 番茄牛腩面</strong>
                        <small>今日热度上升 23%</small>
                    </div>
                </div>
                <div class="auth-mini-eval">
                    <span class="auth-mini-avatar auth-mini-avatar-amber">味</span>
                    <div>
                        <strong>味蕾档案</strong>
                        <small>注册后生成你的个人口味标签</small>
                    </div>
                </div>
            </div>

            <div class="auth-quick-grid" aria-hidden="true">
                <span>发布评价</span>
                <span>想吃清单</span>
                <span>味蕾档案</span>
            </div>
        </section>

        <section class="auth-card">
            <div class="auth-card-head">
                <span class="auth-kicker">新同学入场</span>
                <h2 class="auth-title">
                    <span class="gradient-text">创建新账号</span>
                </h2>
                <p class="auth-lead">用几秒钟建立你的校园美食身份。</p>
            </div>

            <%-- Server error --%>
            <% if (request.getAttribute("errorMsg") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("errorMsg") %></div>
            <% } %>

            <form action="RegisterServlet" method="post" onsubmit="return validateRegister()">
                <%-- Username --%>
                <div class="form-group">
                    <label class="form-label" for="regUser">登录用户名</label>
                    <input type="text" id="regUser" name="username" class="form-input"
                           placeholder="仅允许数字、字母组合（推荐使用学号）"
                           autocomplete="username"
                           value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>"
                           onblur="checkUsername()">
                    <div id="ruErr" class="form-error">用户名不能为空，仅支持字母与数字</div>
                    <div id="ruOk" class="form-success">✓ 用户名格式合法</div>
                </div>

                <%-- Nickname --%>
                <div class="form-group">
                    <label class="form-label" for="nickname">
                        显示昵称 <span class="required">*</span>
                    </label>
                    <input type="text" id="nickname" name="nickname" class="form-input"
                           placeholder="食堂评价展示的昵称"
                           autocomplete="nickname"
                           value="<%= request.getAttribute("nickname") != null ? request.getAttribute("nickname") : "" %>">
                    <div id="rnErr" class="form-error">显示昵称不能为空</div>
                </div>

                <%-- Password --%>
                <div class="form-group">
                    <label class="form-label" for="regPwd">登录密码</label>
                    <input type="password" id="regPwd" name="password" class="form-input"
                           placeholder="至少 6 位，需同时包含数字 + 字母"
                           autocomplete="new-password"
                           oninput="checkPwdFormat()">
                    <div id="rpErr" class="form-error">密码长度 ≥ 6 位，必须同时包含数字与英文字母</div>
                    <div id="rpOk" class="form-success">✓ 密码格式合规</div>
                </div>

                <%-- Confirm password --%>
                <div class="form-group">
                    <label class="form-label" for="regConfirmPwd">确认密码</label>
                    <input type="password" id="regConfirmPwd" name="confirmPwd" class="form-input"
                           placeholder="再次输入相同密码"
                           autocomplete="new-password"
                           oninput="checkConfirmPwd()">
                    <div id="rcErr" class="form-error">两次输入密码不一致</div>
                    <div id="rcOk" class="form-success">✓ 两次密码输入一致</div>
                </div>

                <button type="submit" class="btn btn-primary btn-block mt-4">立即注册</button>
            </form>

            <div class="link-group">
                已有账号？<a href="login.jsp">返回登录</a> &nbsp;·&nbsp; <a href="index.jsp">返回首页</a>
            </div>
        </section>
    </main>

    <div class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </div>

<script>
    var userReg = /^[A-Za-z0-9]+$/;
    var pwdReg  = /^(?=.*[A-Za-z])(?=.*\d).{6,}$/;

    function checkUsername() {
        var u = document.getElementById('regUser').value.trim();
        document.getElementById('ruErr').style.display = (u === '' || !userReg.test(u)) ? 'block' : 'none';
        document.getElementById('ruOk').style.display  = (u !== '' && userReg.test(u)) ? 'block' : 'none';
    }

    function checkPwdFormat() {
        var pwd = document.getElementById('regPwd').value;
        var ok = pwdReg.test(pwd);
        document.getElementById('rpErr').style.display = ok ? 'none' : 'block';
        document.getElementById('rpOk').style.display  = ok ? 'block' : 'none';
    }

    function checkConfirmPwd() {
        var pwd  = document.getElementById('regPwd').value;
        var cpwd = document.getElementById('regConfirmPwd').value;
        var match = cpwd !== '' && pwd === cpwd;
        document.getElementById('rcErr').style.display = match ? 'none' : 'block';
        document.getElementById('rcOk').style.display  = match ? 'block' : 'none';
    }

    function validateRegister() {
        var u  = document.getElementById('regUser').value.trim();
        var n  = document.getElementById('nickname').value.trim();
        var p  = document.getElementById('regPwd').value;
        var cp = document.getElementById('regConfirmPwd').value;
        var pass = true;

        if (u === '' || !userReg.test(u)) {
            document.getElementById('ruErr').style.display = 'block';
            document.getElementById('ruOk').style.display = 'none';
            pass = false;
        }
        document.getElementById('rnErr').style.display = n === '' ? 'block' : 'none';
        if (n === '') {
            pass = false;
        }
        if (!pwdReg.test(p)) {
            document.getElementById('rpErr').style.display = 'block';
            document.getElementById('rpOk').style.display = 'none';
            pass = false;
        }
        if (cp === '' || p !== cp) {
            document.getElementById('rcErr').style.display = 'block';
            document.getElementById('rcOk').style.display = 'none';
            pass = false;
        }
        return pass;
    }
</script>
</body>
</html>
