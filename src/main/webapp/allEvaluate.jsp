<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="com.entity.User" %>
<%@ page import="com.util.HtmlUtil" %>
<%@ page import="java.net.URLEncoder" %>
<%
    // ---- 所有业务变量在此统一准备 ----
    User loginUser = (User) session.getAttribute("loginUser");
    String currentSort = (String) request.getAttribute("currentSort");
    String filterRest = (String) request.getAttribute("filterRest");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages  = (Integer) request.getAttribute("totalPages");
    Integer totalCount  = (Integer) request.getAttribute("totalCount");
    Integer pageSize    = (Integer) request.getAttribute("pageSize");
    if (currentSort == null) currentSort = "newest";
    if (currentPage == null) currentPage = 1;
    if (totalPages  == null) totalPages  = 1;
    if (pageSize    == null) pageSize    = 9;

    String restParam = "";
    if (filterRest != null && !filterRest.isEmpty()) {
        try { restParam = "&restaurant=" + URLEncoder.encode(filterRest, "UTF-8"); } catch (Exception ex) {}
    }

    // 暴露给EL使用
    pageContext.setAttribute("_sort", currentSort);
    pageContext.setAttribute("_rest", filterRest);
    pageContext.setAttribute("_page", currentPage);
    pageContext.setAttribute("_pages", totalPages);
    pageContext.setAttribute("_size", pageSize);
    pageContext.setAttribute("_total", totalCount);
    pageContext.setAttribute("_rparam", restParam);
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>全站评价 · 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/eval-v3.css">
</head>
<body>

<!-- Top Nav -->
<header class="top-nav">
    <div class="nav-container">
        <a href="${pageContext.request.contextPath}/index.jsp" class="brand">
            <img src="${pageContext.request.contextPath}/images/logo.svg" alt="Logo" onerror="this.style.display='none'">
            <span class="brand-name">山海寻味录</span>
        </a>
        <nav class="nav-pills">
            <a href="${pageContext.request.contextPath}/index.jsp">首页</a>
            <a href="${pageContext.request.contextPath}/AllEvaluateServlet" class="active">全站评价</a>
            <a href="${pageContext.request.contextPath}/TasteCompassServlet">寻味雷达</a>
            <a href="${pageContext.request.contextPath}/TrendBoardServlet">热榜</a>
            <a href="${pageContext.request.contextPath}/AddEvaluateServlet">发布评价</a>
            <a href="${pageContext.request.contextPath}/MyEvaluateServlet">我的评价</a>
            <a href="${pageContext.request.contextPath}/TasteProfileServlet">味蕾档案</a>
        </nav>
        <div class="nav-actions">
            <% if (loginUser == null) { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary btn-sm">登录探索</a>
            <% } else { %>
                <details class="user-menu">
                    <summary class="user-menu-trigger">
                        <span class="user-avatar"><%= HtmlUtil.escape(loginUser.getNickname() != null && !loginUser.getNickname().trim().isEmpty() ? loginUser.getNickname().trim().substring(0, 1).toUpperCase() : "U") %></span>
                        <span class="user-menu-name"><%= HtmlUtil.escape(loginUser.getNickname()) %></span>
                        <span class="user-menu-caret">▾</span>
                    </summary>
                    <div class="user-menu-panel">
                        <a href="${pageContext.request.contextPath}/TasteProfileServlet">🎯 味蕾档案</a>
                        <a href="${pageContext.request.contextPath}/WishListServlet">✅ 想吃清单</a>
                        <a href="${pageContext.request.contextPath}/AccountServlet">⚙️ 账户设置</a>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="danger">⏻ 退出登录</a>
                    </div>
                </details>
            <% } %>
        </div>
    </div>
</header>

<!-- Layout -->
<div class="ev3-layout">

    <!-- Sidebar -->
    <aside class="ev3-sidebar">
        <div class="ev3-side-title">🍴 餐厅导航</div>
        <a href="AllEvaluateServlet?sort=${_sort}" class="ev3-side-item ${empty _rest ? 'active' : ''}">
            <span>全部餐厅</span><em><%= totalCount %></em>
        </a>
        <c:forEach items="${restaurantList}" var="r">
            <c:url value="AllEvaluateServlet" var="rUrl">
                <c:param name="sort" value="${_sort}"/>
                <c:param name="restaurant" value="${r.name}"/>
            </c:url>
            <a href="${rUrl}" class="ev3-side-item ${r.name eq _rest ? 'active' : ''}">
                <span>${r.name}</span><em>›</em>
            </a>
        </c:forEach>
    </aside>

    <!-- Content -->
    <main class="ev3-content">

        <!-- Sort + PageSize -->
        <div class="ev3-topbar">
            <div class="ev3-sorts">
                <a href="AllEvaluateServlet?sort=newest${_rparam}&pageSize=${_size}" class="ev3-sort ${_sort eq 'newest' ? 'on' : ''}">🕐 最新</a>
                <a href="AllEvaluateServlet?sort=highest${_rparam}&pageSize=${_size}" class="ev3-sort ${_sort eq 'highest' ? 'on' : ''}">⭐ 最高分</a>
                <a href="AllEvaluateServlet?sort=most_liked${_rparam}&pageSize=${_size}" class="ev3-sort ${_sort eq 'most_liked' ? 'on' : ''}">👍 最多赞</a>
            </div>
            <div class="ev3-pagesize">
                每页
                <select onchange="changePS(this.value)">
                    <option value="9"  ${_size == 9  ? 'selected' : ''}>9 条</option>
                    <option value="15" ${_size == 15 ? 'selected' : ''}>15 条</option>
                    <option value="24" ${_size == 24 ? 'selected' : ''}>24 条</option>
                </select>
            </div>
        </div>

        <!-- Section Header -->
        <div class="ev3-sec-head">
            <h2><%= filterRest != null ? HtmlUtil.escape(filterRest) : "全部餐厅" %></h2>
            <span>共 <%= totalCount %> 条评价</span>
        </div>

        <!-- Empty -->
        <c:if test="${empty evalPageList}">
            <div class="ev3-empty-inline">
                <p style="font-size:40px;margin-bottom:12px;">🍽️</p>
                <p>这里还是片美食荒原，<a href="AddEvaluateServlet">去发布第一条评价</a></p>
            </div>
        </c:if>

        <!-- Cards -->
        <c:if test="${not empty evalPageList}">
            <div class="ev3-grid">
                <c:forEach items="${evalPageList}" var="ev" varStatus="st">
                    <div class="ev3-card ${(_sort eq 'highest' or _sort eq 'most_liked') && _page == 1 && st.index < 3 ? 'hot' : ''}">
                        <c:if test="${_page == 1 && st.index == 0}"><span class="ev3-medal">🥇</span></c:if>
                        <c:if test="${_page == 1 && st.index == 1}"><span class="ev3-medal">🥈</span></c:if>
                        <c:if test="${_page == 1 && st.index == 2}"><span class="ev3-medal">🥉</span></c:if>
                        <div class="ev3-card-top">
                            <span class="ev3-avatar">${fn:substring(ev.authorNickname,0,1)}</span>
                            <div class="ev3-author">
                                <b>${ev.authorNickname}</b>
                                <small>@ ${ev.restaurantName}</small>
                            </div>
                            <span class="ev3-dish">${ev.dishName}</span>
                        </div>
                        <div class="ev3-scores">
                            <div class="ev3-dim"><span>味道</span><span class="ev3-stars"><c:forEach begin="1" end="5" var="i"><i class="${i <= ev.tasteScore ? 'on' : ''}">★</i></c:forEach></span></div>
                            <div class="ev3-dim"><span>价格</span><span class="ev3-stars"><c:forEach begin="1" end="5" var="i"><i class="${i <= ev.priceScore ? 'on' : ''}">★</i></c:forEach></span></div>
                            <div class="ev3-dim"><span>服务</span><span class="ev3-stars"><c:forEach begin="1" end="5" var="i"><i class="${i <= ev.serviceScore ? 'on' : ''}">★</i></c:forEach></span></div>
                            <c:set var="avg" value="${(ev.tasteScore + ev.priceScore + ev.serviceScore) / 3.0}"/>
                            <span class="ev3-avg"><fmt:formatNumber value="${avg}" pattern="#.0"/></span>
                        </div>
                        <c:if test="${not empty ev.content}"><p class="ev3-body">${ev.content}</p></c:if>
                        <div class="ev3-foot">
                            <button class="ev3-like ${ev.likedByCurrentUser ? 'liked' : ''}" onclick="doLike(${ev.id},this)" <%= loginUser == null ? "disabled" : "" %>>
                                <i class="h-on">♥</i><i class="h-off">♡</i><span>${ev.likeCount}</span>
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <div class="ev3-pager">
            <span class="ev3-pager-info">第 <%= currentPage %> / <%= totalPages %> 页，共 <%= totalCount %> 条</span>
            <div class="ev3-pager-btns">
                <% if (currentPage > 1) { %>
                    <a href="AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize=<%= pageSize %>&page=1" class="ev3-page-btn">««</a>
                    <a href="AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize=<%= pageSize %>&page=<%= currentPage - 1 %>" class="ev3-page-btn">«</a>
                <% } %>
                <% for (int i = Math.max(1, currentPage - 2); i <= Math.min(totalPages, currentPage + 2); i++) { %>
                    <a href="AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize=<%= pageSize %>&page=<%= i %>"
                       class="ev3-page-btn <%= i == currentPage ? "active" : "" %>"><%= i %></a>
                <% } %>
                <% if (currentPage < totalPages) { %>
                    <a href="AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize=<%= pageSize %>&page=<%= currentPage + 1 %>" class="ev3-page-btn">»</a>
                    <a href="AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize=<%= pageSize %>&page=<%= totalPages %>" class="ev3-page-btn">»»</a>
                <% } %>
            </div>
        </div>
        <% } %>

    </main>
</div>

<footer class="page-footer">© 2026 SHU.L.M.Z 版权所有 · 山海寻味录</footer>

<script src="${pageContext.request.contextPath}/js/modern-app.js"></script>
<script>
function changePS(v){ location.href='AllEvaluateServlet?sort=<%= currentSort %><%= restParam %>&pageSize='+v+'&page=1'; }
function doLike(id,btn){
    if(btn.disabled){ModernToast.show('请先登录','warning');return}
    ModernHttp.post('LikeEvaluationServlet',{evalId:id},function(err,res){
        if(err){ModernToast.show('网络错误','error');return}
        try{var d=JSON.parse(res);if(d.success){
            btn.querySelector('span').textContent=d.likeCount;
            d.isLiked?btn.classList.add('liked'):btn.classList.remove('liked')
        }else{ModernToast.show(d.message||'失败','warning')}
        }catch(e){ModernToast.show('操作失败','error')}
    })
}
</script>
</body>
</html>
