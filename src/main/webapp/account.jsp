<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    if (loginUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String nick = loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty() ? loginUser.getNickname().trim() : "同学";
    String avatar = nick.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>账号设置 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .account-layout { display: grid; grid-template-columns: 260px minmax(0, 1fr); gap: var(--space-6); align-items: flex-start; }
        .account-sidebar-card {
            background: var(--color-surface); border: 1px solid var(--color-border-light);
            border-radius: var(--radius-2xl); padding: var(--space-6); text-align: center;
            box-shadow: var(--shadow-sm);
        }
        .account-avatar-large {
            width: 72px; height: 72px; border-radius: 50%; margin: 0 auto var(--space-4);
            background: linear-gradient(135deg, var(--brand-500), var(--accent-500));
            color: #fff; font-size: 28px; font-weight: 800;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 16px rgba(99,102,241,0.3);
        }
        .account-username { font-size: var(--text-lg); font-weight: 700; color: var(--color-text); }
        .account-role {
            display: inline-block; margin-top: var(--space-2); padding: 3px 10px;
            border-radius: var(--radius-full); font-size: 11px; font-weight: 600;
            background: <%= loginUser.getRole() == 1 ? "#FEF3C7" : "#EEF2FF" %>;
            color: <%= loginUser.getRole() == 1 ? "#92400E" : "#4338CA" %>;
        }
        .account-sidebar-links { margin-top: var(--space-6); display: flex; flex-direction: column; gap: 4px; }
        .account-sidebar-links a {
            display: flex; align-items: center; gap: 8px; padding: 10px 14px;
            border-radius: var(--radius-lg); font-size: var(--text-sm); font-weight: 600;
            color: var(--color-text-secondary); text-decoration: none; transition: all var(--transition-fast);
        }
        .account-sidebar-links a:hover { background: var(--gray-50); color: var(--color-text); }
        .account-section-card {
            background: var(--color-surface); border: 1px solid var(--color-border-light);
            border-radius: var(--radius-2xl); padding: var(--space-8); box-shadow: var(--shadow-sm);
            margin-bottom: var(--space-5);
        }
        .account-section-card h3 { font-size: var(--text-lg); font-weight: 700; margin-bottom: var(--space-6); display: flex; align-items: center; gap: var(--space-2); }
        @media (max-width: 768px) {
            .account-layout { grid-template-columns: 1fr; }
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

    <main class="page-container" style="padding-top:var(--space-10);padding-bottom:var(--space-10);">
        <div class="page-header">
            <div>
                <h1>⚙️ <span class="gradient-text">账户设置</span></h1>
                <p>管理你的个人资料和账号安全</p>
            </div>
        </div>

        <div class="account-layout">
            <!-- Sidebar -->
            <aside>
                <div class="account-sidebar-card">
                    <div class="account-avatar-large"><%= avatar %></div>
                    <div class="account-username"><%= nick %></div>
                    <div class="account-role"><%= loginUser.getRole() == 1 ? "🔧 管理员" : "🍜 美食探索者" %></div>
                    <div style="margin-top:var(--space-3);font-size:var(--text-xs);color:var(--color-text-tertiary);">
                        @<%= loginUser.getUsername() %>
                    </div>
                    <div class="account-sidebar-links">
                        <a href="MyEvaluateServlet">📋 我的评价</a>
                        <a href="TasteProfileServlet">🎯 味蕾档案</a>
                        <a href="WishListServlet">✅ 想吃清单</a>
                    </div>
                </div>
            </aside>

            <!-- Main Content -->
            <div>
                <!-- Nickname -->
                <div class="account-section-card">
                    <h3>👤 修改昵称</h3>
                    <div class="form-group">
                        <label class="form-label">显示昵称</label>
                        <input type="text" id="nickname" value="<%= loginUser.getNickname() != null ? loginUser.getNickname() : "" %>"
                               class="form-input" placeholder="给自己取个好听的名字吧">
                        <div class="form-hint">这个昵称会显示在你的评价和档案中</div>
                    </div>
                    <button type="button" class="btn btn-primary" onclick="updateNickname()">💾 保存昵称</button>
                </div>

                <!-- Password -->
                <div class="account-section-card">
                    <h3>🔒 修改密码</h3>
                    <div class="form-group">
                        <label class="form-label">当前密码</label>
                        <input type="password" id="oldPwd" class="form-input" placeholder="请输入当前使用的密码">
                    </div>
                    <div class="form-group">
                        <label class="form-label">新密码</label>
                        <input type="password" id="newPwd" class="form-input" placeholder="至少 6 位，包含字母和数字">
                    </div>
                    <div class="form-group">
                        <label class="form-label">确认新密码</label>
                        <input type="password" id="confirmPwd" class="form-input" placeholder="请再次输入新密码">
                    </div>
                    <button type="button" class="btn btn-danger-outline" onclick="updatePassword()">🔐 修改密码</button>
                </div>
            </div>
        </div>
    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </footer>

<script src="js/modern-app.js"></script>
<script>
    function updateNickname() {
        var nick = document.getElementById('nickname').value.trim();
        if (!nick) { ModernToast.show('昵称不能为空', 'warning'); return; }
        ModernHttp.post('UpdateProfileServlet', { action: 'updateNickname', nickname: nick }, function (err, res) {
            if (err) { ModernToast.show('网络错误，请稍后再试', 'error'); return; }
            if (res === 'success') {
                ModernToast.show('昵称修改成功！', 'success');
                setTimeout(function () { location.reload(); }, 800);
            } else { ModernToast.show(res, 'error'); }
        });
    }
    function updatePassword() {
        var oldPwd = document.getElementById('oldPwd').value;
        var newPwd = document.getElementById('newPwd').value;
        var confirmPwd = document.getElementById('confirmPwd').value;
        if (!/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$/.test(newPwd)) {
            ModernToast.show('密码需至少6位，且必须包含字母和数字', 'warning'); return;
        }
        if (newPwd !== confirmPwd) {
            ModernToast.show('两次输入的新密码不一致', 'warning'); return;
        }
        ModernHttp.post('UpdateProfileServlet', { action: 'updatePwd', oldPwd: oldPwd, newPwd: newPwd }, function (err, res) {
            if (err) { ModernToast.show('网络错误，请稍后再试', 'error'); return; }
            if (res === 'success') {
                ModernToast.show('密码修改成功，即将跳转登录页…', 'success');
                setTimeout(function () { window.location.href = 'login.jsp'; }, 1000);
            } else { ModernToast.show(res, 'error'); }
        });
    }
</script>
</body>
</html>
