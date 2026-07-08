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
    <title>我的评价 — 山海寻味录</title>
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

    <!-- ========== Main Content ========== -->
    <main class="page-container" style="padding-top:var(--space-10);padding-bottom:var(--space-10);">

        <!-- Page Header -->
        <div class="page-header">
            <h1><span class="gradient-text">我的美食足迹</span></h1>
            <div class="page-size-select">
                每页展示
                <select id="pageSizeSelect" onchange="changePageSize()">
                    <option value="6"  ${pageSize == 6  ? 'selected' : ''}>6 条</option>
                    <option value="9"  ${pageSize == 9  ? 'selected' : ''}>9 条</option>
                    <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 条</option>
                    <option value="15" ${pageSize == 15 ? 'selected' : ''}>15 条</option>
                </select>
            </div>
        </div>

        <!-- Stats Banner -->
        <div class="stats-row">
            <div class="stat-card">
                <div>
                    <div class="stat-label">累计发表评价</div>
                    <div class="stat-value">${totalCount}<span>条记录</span></div>
                </div>
                <div class="stat-icon-large icon-blue">📋</div>
            </div>
            <div class="stat-card">
                <div>
                    <div class="stat-label">我的综合平均分</div>
                    <div class="stat-value">${avgScore}<span>/ 5.0 星</span></div>
                </div>
                <div class="stat-icon-large icon-purple">✨</div>
            </div>
        </div>

        <!-- Evaluation Cards -->
        <div class="eval-grid">
            <c:if test="${empty myEvaluations}">
                <div class="empty-state">
                    <div class="empty-icon">📝</div>
                    <p class="empty-text">目前还没有记录哦，快去探索并分享你的第一篇美食体验吧！</p>
                </div>
            </c:if>

            <c:forEach items="${myEvaluations}" var="eval">
                <div class="eval-card">
                    <div class="eval-card-header">
                        <span style="font-weight:600;display:flex;align-items:center;gap:6px;">
                            🏢 ${eval.restaurantName}
                        </span>
                        <span class="eval-card-dish">${eval.dishName}</span>
                    </div>

                    <div class="eval-card-body">${eval.content}</div>

                    <div class="eval-card-actions">
                        <a href="ToEditEvaluateServlet?id=${eval.id}"
                           class="btn btn-outline btn-sm">编辑</a>
                        <form action="DeleteEvaluateServlet" method="post"
                              style="display:inline-block;margin:0;">
                            <input type="hidden" name="id" value="${eval.id}">
                            <button type="submit" class="btn btn-danger-outline btn-sm"
                                    onclick="return confirm('确定要删除这条评价吗？删除后不可恢复。')">
                                删除
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 0}">
            <div class="pagination">
                <a href="MyEvaluateServlet?page=${currentPage - 1}&pageSize=${pageSize}"
                   class="page-btn ${currentPage == 1 ? 'disabled' : ''}">← 上一页</a>

                <div class="page-info">
                    第 <span>${currentPage}</span> 页 / 共 <span>${totalPages}</span> 页
                </div>

                <a href="MyEvaluateServlet?page=${currentPage + 1}&pageSize=${pageSize}"
                   class="page-btn ${currentPage >= totalPages ? 'disabled' : ''}">下一页 →</a>
            </div>
        </c:if>

    </main>

    <footer class="page-footer">
        © 2026 SHU.L.M.Z &nbsp;·&nbsp; 8224439@qq.com
    </footer>

<script>
    function changePageSize() {
        var newSize = document.getElementById('pageSizeSelect').value;
        window.location.href = 'MyEvaluateServlet?page=1&pageSize=' + newSize;
    }
</script>
</body>
</html>
