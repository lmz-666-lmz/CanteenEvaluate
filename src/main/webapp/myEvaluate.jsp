<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.entity.User" %>
<%
    User loginUser = (User) session.getAttribute("loginUser");
    String nick = loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty() ? loginUser.getNickname().trim() : "同学";
    String avatar = nick.substring(0, 1).toUpperCase();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的评价 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        /* My Evaluate v1.1 extras */
        .my-eval-header {
            display: flex; justify-content: space-between; align-items: flex-end;
            margin-bottom: var(--space-8); gap: var(--space-4); flex-wrap: wrap;
        }
        .my-eval-header h1 { font-size: var(--text-2xl); font-weight: 700; letter-spacing: -0.02em; margin: 0; }
        .my-eval-header p { font-size: var(--text-base); color: var(--color-text-secondary); margin-top: 4px; }

        .my-eval-card {
            background: var(--color-surface); border: 1px solid var(--color-border-light);
            border-radius: var(--radius-2xl); padding: var(--space-6);
            transition: all var(--transition-slow); box-shadow: var(--shadow-xs);
            display: flex; flex-direction: column; gap: var(--space-4);
        }
        .my-eval-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-lg); border-color: var(--color-border); }

        .my-eval-card-top {
            display: flex; justify-content: space-between; align-items: flex-start; gap: var(--space-3);
        }
        .my-eval-rest { font-weight: 700; font-size: var(--text-base); color: var(--color-text); }
        .my-eval-dish {
            display: inline-block; padding: 3px 10px; border-radius: var(--radius-full);
            background: var(--brand-50); color: var(--brand-700); font-size: var(--text-xs); font-weight: 600;
        }
        .my-eval-score-badge {
            display: flex; flex-direction: column; align-items: center;
            background: linear-gradient(135deg, #FFFBEB, #FEF3C7); color: #B45309;
            padding: 6px 12px; border-radius: var(--radius-md); font-weight: 800;
            font-size: 20px; line-height: 1.1; flex-shrink: 0;
            box-shadow: 0 1px 4px rgba(245,158,11,0.15);
        }
        .my-eval-score-badge small { font-size: 10px; font-weight: 600; color: #92400E; }

        .my-eval-scores-row {
            display: flex; gap: var(--space-4); font-size: var(--text-sm); color: var(--color-text-secondary);
            padding: var(--space-2) 0; border-top: 1px solid var(--color-border-light); border-bottom: 1px solid var(--color-border-light);
        }
        .my-eval-scores-row span { display: flex; align-items: center; gap: 3px; font-weight: 600; }
        .my-eval-scores-row strong { color: var(--color-text); }
        .my-eval-body {
            color: var(--color-text-secondary); font-size: var(--text-base); line-height: var(--leading-relaxed);
            background: var(--gray-50); padding: var(--space-4); border-radius: var(--radius-md);
        }
        .my-eval-actions { display: flex; justify-content: flex-end; gap: var(--space-2); }

        /* Quick links */
        .my-eval-quick-links { display: flex; gap: var(--space-3); flex-wrap: wrap; margin-bottom: var(--space-8); }
        .quick-link-card {
            flex: 1; min-width: 160px; padding: var(--space-5); border-radius: var(--radius-xl);
            background: var(--color-surface); border: 1px solid var(--color-border-light);
            text-decoration: none; transition: all var(--transition-base);
            display: flex; align-items: center; gap: var(--space-3); box-shadow: var(--shadow-xs);
        }
        .quick-link-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); border-color: var(--brand-200); }
        .quick-link-icon { width: 44px; height: 44px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
        .quick-link-text strong { display: block; color: var(--color-text); font-size: var(--text-sm); font-weight: 700; }
        .quick-link-text small  { color: var(--color-text-tertiary); font-size: var(--text-xs); }

        @media (max-width: 768px) {
            .my-eval-quick-links { flex-direction: column; }
            .my-eval-scores-row { flex-wrap: wrap; gap: var(--space-2); }
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
                <a href="MyEvaluateServlet" class="active">我的评价</a>
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

        <!-- Header -->
        <div class="my-eval-header">
            <div>
                <h1><span class="gradient-text">我的美食足迹</span></h1>
                <p>Hi <%= nick %>，这是你的评价记录</p>
            </div>
            <div class="page-size-select">
                每页
                <select id="pageSizeSelect" onchange="changePageSize()">
                    <option value="6"  ${pageSize == 6  ? 'selected' : ''}>6 条</option>
                    <option value="9"  ${pageSize == 9  ? 'selected' : ''}>9 条</option>
                    <option value="12" ${pageSize == 12 ? 'selected' : ''}>12 条</option>
                    <option value="15" ${pageSize == 15 ? 'selected' : ''}>15 条</option>
                </select>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="my-eval-quick-links">
            <a href="AddEvaluateServlet" class="quick-link-card">
                <div class="quick-link-icon icon-emerald">✍️</div>
                <div class="quick-link-text"><strong>写评价</strong><small>记录新的美食体验</small></div>
            </a>
            <a href="TasteProfileServlet" class="quick-link-card">
                <div class="quick-link-icon icon-purple">🎯</div>
                <div class="quick-link-text"><strong>味蕾档案</strong><small>查看口味画像</small></div>
            </a>
            <a href="WishListServlet" class="quick-link-card">
                <div class="quick-link-icon icon-amber">✅</div>
                <div class="quick-link-text"><strong>想吃清单</strong><small>管理心愿单</small></div>
            </a>
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
                    <div class="stat-label">综合平均分</div>
                    <div class="stat-value">
                        <fmt:formatNumber value="${avgScore}" pattern="#.0"/><span>/ 5.0</span>
                    </div>
                </div>
                <div class="stat-icon-large icon-purple">⭐</div>
            </div>
        </div>

        <!-- Evaluation Cards -->
        <div class="eval-grid">
            <c:if test="${empty myEvaluations}">
                <div class="empty-state">
                    <div class="empty-icon">📝</div>
                    <p class="empty-text">还没有评价记录</p>
                    <p style="color:var(--color-text-secondary);margin-bottom:var(--space-6);">去发布第一条评价，开启你的美食探索之旅！</p>
                    <a href="AddEvaluateServlet" class="btn btn-primary">去发布评价</a>
                </div>
            </c:if>

            <c:forEach items="${myEvaluations}" var="eval">
                <div class="my-eval-card">
                    <div class="my-eval-card-top">
                        <div>
                            <div class="my-eval-rest">🏢 <c:out value="${eval.restaurantName}"/></div>
                            <div style="margin-top:6px;">
                                <span class="my-eval-dish"><c:out value="${eval.dishName}"/></span>
                            </div>
                        </div>
                        <c:set var="avg" value="${(eval.tasteScore + eval.priceScore + eval.serviceScore) / 3.0}"/>
                        <div class="my-eval-score-badge">
                            <fmt:formatNumber value="${avg}" pattern="#.0"/>
                            <small>综合</small>
                        </div>
                    </div>

                    <div class="my-eval-scores-row">
                        <span>😋 味道 <strong>${eval.tasteScore}</strong></span>
                        <span>💰 价格 <strong>${eval.priceScore}</strong></span>
                        <span>🤝 服务 <strong>${eval.serviceScore}</strong></span>
                        <c:if test="${eval.likeCount > 0}">
                            <span style="margin-left:auto;">❤️ <strong>${eval.likeCount}</strong> 赞</span>
                        </c:if>
                    </div>

                    <div class="my-eval-body"><c:out value="${eval.content}"/></div>

                    <div class="my-eval-actions">
                        <a href="ToEditEvaluateServlet?id=${eval.id}" class="btn btn-outline btn-sm">✎ 编辑</a>
                        <form action="DeleteEvaluateServlet" method="post" style="display:inline-block;margin:0;">
                            <input type="hidden" name="id" value="${eval.id}">
                            <button type="submit" class="btn btn-danger-outline btn-sm"
                                    onclick="return confirm('确定要删除这条评价吗？删除后不可恢复。')">✕ 删除</button>
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
                <div class="page-info">第 <span>${currentPage}</span> 页 / 共 <span>${totalPages}</span> 页</div>
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
