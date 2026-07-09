<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <title>发布评价 — 山海寻味录</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/modern-style.css">
    <style>
        .add-page { max-width: 680px; margin: 0 auto; padding: 32px 24px 64px; }

        /* Score picker */
        .score-section { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 24px; }
        .score-col { text-align: center; }
        .score-col-label { font-size: 12px; font-weight: 700; color: #888; margin-bottom: 8px; }
        .score-btns { display: flex; gap: 6px; justify-content: center; flex-wrap: wrap; }
        .score-btn {
            width: 42px; height: 48px; border-radius: 8px; border: 1.5px solid #e5e5e5;
            background: #fff; cursor: pointer; font-size: 20px; line-height: 1;
            transition: all 0.18s ease; padding: 0; display: flex; flex-direction: column;
            align-items: center; justify-content: center; gap: 1px;
        }
        .score-btn:hover { border-color: #bbb; transform: translateY(-2px); box-shadow: 0 2px 6px rgba(0,0,0,0.06); }
        .score-btn.active { border-color: #6366F1; background: #EEF2FF; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); transform: translateY(-1px); }
        .score-btn.active.taste { border-color: #F59E0B; background: #FFFBEB; box-shadow: 0 0 0 3px rgba(245,158,11,0.1); }
        .score-btn.active.price { border-color: #10B981; background: #ECFDF5; box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
        .score-btn.active.service { border-color: #6366F1; background: #EEF2FF; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
        .score-btn span { font-size: 9px; font-weight: 600; color: #888; }
        .score-btn.active span { color: #555; }

        /* Preview card */
        .preview-card {
            background: #fff; border: 1px solid #eee; border-radius: 12px;
            padding: 20px 24px; display: flex; align-items: center; gap: 20px;
            transition: all 0.3s ease;
        }
        .preview-big {
            font-size: 48px; font-weight: 800; line-height: 1;
            background: linear-gradient(135deg, #F59E0B, #D97706);
            -webkit-background-clip: text; background-clip: text;
            -webkit-text-fill-color: transparent;
            min-width: 70px; text-align: center;
        }
        .preview-bars { flex: 1; display: flex; flex-direction: column; gap: 6px; }
        .preview-bar-row { display: flex; align-items: center; gap: 8px; font-size: 12px; font-weight: 600; color: #666; }
        .preview-bar-label { width: 28px; text-align: right; }
        .preview-bar-track { flex: 1; height: 8px; border-radius: 4px; background: #f3f4f6; overflow: hidden; }
        .preview-bar-fill { height: 100%; border-radius: inherit; transition: width 0.35s cubic-bezier(0.16, 1, 0.3, 1); }
        .bar-taste { background: #F59E0B; }
        .bar-price { background: #10B981; }
        .bar-service { background: #6366F1; }
        .preview-label { font-size: 11px; color: #aaa; text-align: center; margin-top: 2px; }
        .preview-desc { font-size: 14px; font-weight: 700; color: #333; text-align: center; margin-top: 4px; }

        /* Restaurant picker */
        .rest-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 8px; }
        .rest-opt { position: relative; }
        .rest-opt input { display: none; }
        .rest-opt label {
            display: flex; flex-direction: column; align-items: center; gap: 4px;
            padding: 14px 10px; border-radius: 10px; border: 1.5px solid #e5e5e5;
            cursor: pointer; transition: all 0.15s; text-align: center; background: #fff;
            font-size: 14px; font-weight: 600; color: #333;
        }
        .rest-opt label:hover { border-color: #bbb; background: #fafafa; }
        .rest-opt label small { font-size: 11px; color: #999; font-weight: 400; }
        .rest-opt input:checked + label { border-color: #6366F1; background: #EEF2FF; box-shadow: 0 0 0 3px rgba(99,102,241,0.08); }

        @media (max-width: 768px) {
            .score-section { grid-template-columns: 1fr; gap: 16px; }
            .score-btn { width: 36px; height: 42px; font-size: 18px; }
            .score-btn span { font-size: 8px; }
            .preview-card { flex-direction: column; text-align: center; }
            .rest-grid { grid-template-columns: repeat(2, 1fr); }
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
            <a href="AddEvaluateServlet" class="active">发布评价</a>
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

<main class="add-page">
    <div style="margin-bottom:28px;">
        <h1 style="font-size:24px;font-weight:700;color:#1a1a1a;margin:0;">✍️ 发布评价</h1>
        <p style="font-size:14px;color:#999;margin:4px 0 0;">分享真实体验，帮更多同学找到好吃的</p>
    </div>

    <form action="AddEvaluateServlet" method="post" id="evalForm">
        <!-- Restaurant -->
        <div class="card mb-5">
            <div class="card-header"><h3>🍴 选择餐厅</h3></div>
            <div class="card-body">
                <div class="rest-grid">
                    <c:forEach items="${restaurantList}" var="rest">
                        <div class="rest-opt">
                            <input type="radio" name="restaurantId" value="${rest.id}" id="rest_${rest.id}" required>
                            <label for="rest_${rest.id}">
                                <c:out value="${rest.name}"/>
                                <c:if test="${not empty rest.location}"><small><c:out value="${rest.location}"/></small></c:if>
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- Dish name -->
        <div class="card mb-5">
            <div class="card-header"><h3>🍜 菜品名称</h3></div>
            <div class="card-body">
                <input type="text" name="dishName" class="form-input" style="font-size:15px;"
                       placeholder="例如：林渝炸鸡腿 — 琵琶腿" required>
            </div>
        </div>

        <!-- Scores -->
        <div class="card mb-5">
            <div class="card-header"><h3>⭐ 评分</h3></div>
            <div class="card-body">
                <div class="score-section">
                    <div class="score-col">
                        <div class="score-col-label">😋 味道</div>
                        <div class="score-btns" data-name="tasteScore">
                            <button type="button" class="score-btn active taste" data-val="5">😍<span>超赞</span></button>
                            <button type="button" class="score-btn" data-val="4">😊<span>好吃</span></button>
                            <button type="button" class="score-btn" data-val="3">😐<span>还行</span></button>
                            <button type="button" class="score-btn" data-val="2">😕<span>一般</span></button>
                            <button type="button" class="score-btn" data-val="1">🤢<span>避雷</span></button>
                        </div>
                        <input type="hidden" name="tasteScore" value="5">
                    </div>
                    <div class="score-col">
                        <div class="score-col-label">💰 价格</div>
                        <div class="score-btns" data-name="priceScore">
                            <button type="button" class="score-btn" data-val="5">🤑<span>超值</span></button>
                            <button type="button" class="score-btn" data-val="4">👍<span>合适</span></button>
                            <button type="button" class="score-btn active price" data-val="3">🤔<span>略贵</span></button>
                            <button type="button" class="score-btn" data-val="2">😒<span>不值</span></button>
                            <button type="button" class="score-btn" data-val="1">💸<span>血亏</span></button>
                        </div>
                        <input type="hidden" name="priceScore" value="3">
                    </div>
                    <div class="score-col">
                        <div class="score-col-label">🤝 服务</div>
                        <div class="score-btns" data-name="serviceScore">
                            <button type="button" class="score-btn" data-val="5">🥰<span>极好</span></button>
                            <button type="button" class="score-btn" data-val="4">😄<span>不错</span></button>
                            <button type="button" class="score-btn active service" data-val="3">🙂<span>正常</span></button>
                            <button type="button" class="score-btn" data-val="2">😐<span>冷淡</span></button>
                            <button type="button" class="score-btn" data-val="1">😤<span>恶劣</span></button>
                        </div>
                        <input type="hidden" name="serviceScore" value="3">
                    </div>
                </div>

                <!-- Dynamic preview -->
                <div class="preview-card" id="scorePreview">
                    <div>
                        <div class="preview-big" id="avgScore">3.3</div>
                        <div class="preview-label">综合评分</div>
                    </div>
                    <div class="preview-bars">
                        <div class="preview-bar-row">
                            <span class="preview-bar-label">味道</span>
                            <div class="preview-bar-track"><div class="preview-bar-fill bar-taste" id="tasteBar" style="width:100%"></div></div>
                        </div>
                        <div class="preview-bar-row">
                            <span class="preview-bar-label">价格</span>
                            <div class="preview-bar-track"><div class="preview-bar-fill bar-price" id="priceBar" style="width:60%"></div></div>
                        </div>
                        <div class="preview-bar-row">
                            <span class="preview-bar-label">服务</span>
                            <div class="preview-bar-track"><div class="preview-bar-fill bar-service" id="serviceBar" style="width:60%"></div></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="card mb-5">
            <div class="card-header"><h3>💬 评价内容</h3></div>
            <div class="card-body">
                <textarea name="content" class="form-input" rows="5" style="font-size:15px;"
                          placeholder="分享一下真实的用餐体验——味道怎么样？份量够吗？排队快不快？" required></textarea>
            </div>
        </div>

        <button type="submit" class="btn btn-primary btn-lg btn-block" style="padding:14px;font-size:16px;">
            发布评价
        </button>
    </form>
</main>

<footer class="page-footer">© 2026 SHU.L.M.Z · 8224439@qq.com</footer>

<script>
(function(){
    document.querySelectorAll('.score-btns').forEach(function(group){
        var name = group.dataset.name;
        var hidden = document.querySelector('input[name="'+name+'"]');
        group.querySelectorAll('button').forEach(function(btn){
            btn.addEventListener('click', function(){
                group.querySelectorAll('button').forEach(function(b){ b.classList.remove('active'); });
                btn.classList.add('active');
                if(name==='tasteScore') btn.classList.add('taste');
                else if(name==='priceScore') btn.classList.add('price');
                else btn.classList.add('service');
                hidden.value = btn.dataset.val;
                updatePreview();
            });
        });
    });

    function updatePreview(){
        var t = parseInt(document.querySelector('input[name="tasteScore"]').value)||5;
        var p = parseInt(document.querySelector('input[name="priceScore"]').value)||3;
        var s = parseInt(document.querySelector('input[name="serviceScore"]').value)||3;
        var avg = ((t+p+s)/3).toFixed(1);
        document.getElementById('avgScore').textContent = avg;
        document.getElementById('tasteBar').style.width = (t*20)+'%';
        document.getElementById('priceBar').style.width = (p*20)+'%';
        document.getElementById('serviceBar').style.width = (s*20)+'%';
    }
})();
</script>
</body>
</html>
