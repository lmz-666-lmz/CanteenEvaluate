<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账号设置 — 山海寻味录</title>
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
                <a href="MyEvaluateServlet">我的评价</a>
                <a href="TasteProfileServlet">味蕾档案</a>
            </nav>

            <div class="nav-actions">
                <details class="user-menu">
                    <summary class="user-menu-trigger">
                        <span class="user-avatar"><%= loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty() ? loginUser.getNickname().trim().substring(0, 1).toUpperCase() : "U" %></span>
                        <span class="user-menu-name"><%= loginUser.getNickname() %></span>
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

    <!-- ========== Main Content ========== -->
    <main class="page-narrow">

        <!-- Profile Card -->
        <div class="card mb-6">
            <h3 class="section-heading">
                <span>👤</span> <span class="gradient-text">个人资料设置</span>
            </h3>
            <div class="form-group">
                <label class="form-label">当前显示的系统昵称</label>
                <input type="text" id="nickname" value="<%= loginUser.getNickname() %>"
                       class="form-input" placeholder="请输入新的昵称">
            </div>
            <button type="button" class="btn btn-primary btn-block"
                    onclick="updateNickname()">保存新昵称</button>
        </div>

        <!-- Password Card -->
        <div class="card">
            <h3 class="section-heading">
                <span>🔒</span> 账号安全中心
            </h3>
            <div class="form-group">
                <label class="form-label">旧密码</label>
                <input type="password" id="oldPwd" class="form-input"
                       placeholder="请输入当前使用的密码">
            </div>
            <div class="form-group">
                <label class="form-label">新密码</label>
                <input type="password" id="newPwd" class="form-input"
                       placeholder="至少 6 位，必须包含字母和数字">
            </div>
            <div class="form-group">
                <label class="form-label">确认新密码</label>
                <input type="password" id="confirmPwd" class="form-input"
                       placeholder="请再次输入新密码进行核对">
            </div>
            <button type="button" class="btn btn-danger-outline btn-block"
                    onclick="updatePassword()">确认修改密码</button>
        </div>

    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </footer>

<script src="js/modern-app.js"></script>
<script>
    function updateNickname() {
        var nick = document.getElementById('nickname').value.trim();
        if (!nick) {
            ModernToast.show('昵称不能为空', 'warning');
            return;
        }
        ModernHttp.post('UpdateProfileServlet', { action: 'updateNickname', nickname: nick }, function (err, res) {
            if (err) {
                ModernToast.show('网络错误，请稍后再试', 'error');
                return;
            }
            if (res === 'success') {
                ModernToast.show('昵称修改成功！', 'success');
                setTimeout(function () { location.reload(); }, 800);
            } else {
                ModernToast.show(res, 'error');
            }
        });
    }

    function updatePassword() {
        var oldPwd     = document.getElementById('oldPwd').value;
        var newPwd     = document.getElementById('newPwd').value;
        var confirmPwd = document.getElementById('confirmPwd').value;
        var pwdRegex   = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/;

        if (!pwdRegex.test(newPwd)) {
            ModernToast.show('密码需至少6位，且必须包含字母和数字！', 'warning');
            return;
        }
        if (newPwd !== confirmPwd) {
            ModernToast.show('两次输入的新密码不一致！', 'warning');
            return;
        }

        ModernHttp.post('UpdateProfileServlet', { action: 'updatePwd', oldPwd: oldPwd, newPwd: newPwd }, function (err, res) {
            if (err) {
                ModernToast.show('网络错误，请稍后再试', 'error');
                return;
            }
            if (res === 'success') {
                ModernToast.show('密码修改成功，即将跳转登录页…', 'success');
                setTimeout(function () { window.location.href = 'login.jsp'; }, 1000);
            } else {
                ModernToast.show(res, 'error');
            }
        });
    }
</script>
</body>
</html>
