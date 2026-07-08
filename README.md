<p align="center">
  <img src="https://img.shields.io/badge/version-1.0-blue?style=flat-square" alt="Version 1.0">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License MIT">
  <img src="https://img.shields.io/badge/Java-1.8-brightgreen?style=flat-square&logo=openjdk" alt="Java 8">
  <img src="https://img.shields.io/badge/Tomcat-8.5-yellow?style=flat-square&logo=apache-tomcat" alt="Tomcat 8.5">
  <img src="https://img.shields.io/badge/MySQL-8.0+-4479A1?style=flat-square&logo=mysql" alt="MySQL 8.0+">
</p>

<h1 align="center">🍜 山海寻味录 — CanteenEvaluate</h1>

<p align="center">
  <strong>一个面向高校学生的食堂美食评价与智能推荐平台</strong>
  <br>
  基于 JSP + Servlet + MySQL 的 Java Web 全栈项目
</p>

---

## 📑 目录

- [快速开始](#-快速开始)
- [系统概述](#-系统概述)
- [分层架构](#-系统分层架构)
- [业务模块](#-业务模块)
- [核心特性](#-核心特性)
- [技术栈](#-技术栈)
- [项目结构](#-项目结构)
- [部署说明](#-部署说明)
- [安全提示](#-安全提示)

---

## 🚀 快速开始

### 环境要求

| 工具 | 版本 |
|------|------|
| JDK | 1.8+ |
| Apache Tomcat | 8.5+ |
| MySQL | 8.0+ |
| IDE | Eclipse / IntelliJ IDEA |

### 1. 克隆项目

```bash
git clone https://github.com/lmz-666-lmz/CanteenEvaluate.git
cd CanteenEvaluate
```

### 2. 初始化数据库

数据库初始化文件：**`sql/canteen_db.sql`**

在 MySQL 命令行或 DBeaver 中执行该文件即可：

```bash
# 方式一：MySQL 命令行
mysql -u root -p < sql/canteen_db.sql

# 方式二：在 DBeaver / Navicat / MySQL Workbench 中
# 直接打开 sql/canteen_db.sql 并执行
```

执行后会创建 `canteen_db` 数据库及以下 7 张表：

| 表名 | 说明 |
|------|------|
| `users` | 用户表（含管理员） |
| `restaurants` | 餐厅表 |
| `evaluations` | 评价表（三维评分 + 点赞） |
| `announcements` | 公告表 |
| `wish_items` | 想吃清单表 |
| `sys_logs` | 系统操作日志表 |
| `system_config` | 运行时配置表 |

> 脚本中已包含默认管理员账户 `admin` 和示例餐厅数据。

### 3. 配置数据库连接

复制示例配置文件并填入你的数据库信息：

```bash
cp src/main/resources/db.properties.example src/main/resources/db.properties
```

编辑 `src/main/resources/db.properties`，将用户名和密码替换为你的 MySQL 账号：

```properties
db.driver=com.mysql.cj.jdbc.Driver
db.url=jdbc:mysql://localhost:3306/canteen_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
db.user=YOUR_DB_USERNAME
db.password=YOUR_DB_PASSWORD
```

> ⚠️ **`db.properties` 已在 `.gitignore` 中排除，不要把真实数据库密码上传到 GitHub！**

### 4. 部署到 Tomcat

**方式一：Eclipse 部署**
1. 在 Eclipse 中导入项目：`File → Import → Existing Projects into Workspace`
2. 配置 Tomcat 8.5 Runtime：`Window → Preferences → Server → Runtime Environments`
3. 右键项目 → `Run As → Run on Server` → 选择 Tomcat 8.5

**方式二：手动部署**
```bash
# 将项目打成 WAR 包放入 Tomcat webapps 目录
cp CanteenEvaluate.war $TOMCAT_HOME/webapps/
# 启动 Tomcat
$TOMCAT_HOME/bin/startup.sh    # Linux / macOS
$TOMCAT_HOME/bin/startup.bat   # Windows
```

### 5. 访问系统

启动后访问 http://localhost:8080/CanteenEvaluate

| 入口 | 地址 |
|------|------|
| 用户端首页 | `http://localhost:8080/CanteenEvaluate/index.jsp` |
| 登录页 | `http://localhost:8080/CanteenEvaluate/login.jsp` |
| 管理后台 | 登录页连续点击标题 3 次切换到管理员登录面板 |

**默认管理员账号**（由 `sql/canteen_db.sql` 自动创建）：

| 字段 | 值 |
|------|-----|
| 用户名 | `admin` |
| 密码 | `admin123` |

> ⚠️ **首次登录后必须立即修改管理员密码！**

---

## 📖 系统概述

山海寻味录是一个面向高校学生的食堂美食评价与智能推荐平台，采用 JSP + Servlet 经典 MVC 架构，帮助同学发现校园美食、记录个人口味、做出更好的就餐决策。

**核心能力**：三维评分体系（口味 / 价格 / 服务）、基于心情与预算的寻味推荐引擎、多维度热榜排行、个人味蕾画像分析、想吃清单管理、后台数据洞察。

---

## 🏗 系统分层架构

### 前端展示层 (Presentation Layer)

| 技术 | 用途 |
|------|------|
| JSP + JSTL | 服务端页面渲染，支持 EL 表达式 |
| CSS3 自定义样式 | `modern-style.css` 全局样式、`feature-modern.css` 功能页样式 |
| 原生 JavaScript | 表单校验、交互逻辑、验证码刷新 |
| Google Fonts (Inter) | 现代化字体排版 |

### 业务逻辑层 (Service Layer)

| 技术 | 用途 |
|------|------|
| Java Servlet | 请求分发、业务编排，30+ 个 Servlet 覆盖全部功能 |
| DAO 模式 | 数据访问对象封装，原生 JDBC 直连 |
| Filter 过滤器 | 管理员权限拦截 (`AdminFilter`) |

### 数据与基础设施层 (Infrastructure Layer)

- **数据库**：MySQL 8.0+，`utf8mb4` 字符集，支持 emoji
- **连接池**：DBUtil 单例管理数据库连接
- **密码安全**：PasswordUtil 加盐哈希存储
- **配置管理**：ConfigUtil 读取 `db.properties`，DBUtil 提供回退默认值，支持环境切换
- **运行时配置**：`system_config` 表支持动态参数调整，无需重启

---

## 📦 业务模块

| 领域模块 | 前端页面 | 后端 Servlet | 核心职责 |
|:---|:---|:---|:---|
| **Auth** 鉴权 | `login.jsp`, `register.jsp` | `LoginServlet`, `RegisterServlet`, `LogoutServlet`, `VerifyCodeServlet` | 注册、登录、验证码、游客模式、管理员登录 |
| **Feed** 评价流 | `allEvaluate.jsp` | `AllEvaluateServlet` | 全站评价浏览，支持排序（最新/最热/高分）、餐厅筛选、分页 |
| **Compass** 寻味雷达 | `tasteCompass.jsp` | `TasteCompassServlet` | 基于心情（想吃暖的/清爽/热门/高分/性价比）与预算（日常/犒劳/赶时间）的智能菜品推荐 |
| **TrendBoard** 热榜 | `trendBoard.jsp` | `TrendBoardServlet` | 餐厅热度榜、菜品热度榜、创作者榜，含热度分算法 |
| **Evaluate** 评价 | `addEvaluate.jsp`, `editEvaluate.jsp` | `AddEvaluateServlet`, `EditEvaluateServlet`, `ToEditEvaluateServlet` | 发布/编辑评价，三维评分（口味/价格/服务），AI 洞察评分 |
| **MyEvaluate** 我的 | `myEvaluate.jsp` | `MyEvaluateServlet`, `DeleteEvaluateServlet`, `LikeEvaluationServlet` | 管理自己的评价，点赞互动 |
| **Profile** 味蕾档案 | `tasteProfile.jsp` | `TasteProfileServlet` | 个人口味画像：人格标签、维度强弱、成就徽章、统计雷达 |
| **WishList** 想吃清单 | `wishList.jsp` | `WishListServlet`, `WishActionServlet` | 心愿单增删改查，标记已完成 |
| **Account** 账户 | `account.jsp` | `AccountServlet`, `UpdateProfileServlet` | 个人资料编辑、昵称修改 |
| **Admin** 后台 | `admin/adminIndex.jsp` | `DashboardStatsServlet`, `AdminLoginServlet` 等 | 全量数据管理、统计看板、内容审核 |
| **Admin-Users** 用户管理 | `admin/userManage.jsp` | `UserListServlet`, `UserUpdateServlet`, `UserDeleteServlet` | 用户 CRUD |
| **Admin-Restaurant** 餐厅管理 | `admin/restaurantManage.jsp` | `RestaurantListServlet`, `RestaurantAddServlet`, `RestaurantUpdateServlet`, `RestaurantDeleteServlet` | 餐厅 CRUD |
| **Admin-Review** 内容审核 | `admin/evaluationManage.jsp` | `EvaluationManageServlet`, `DeleteAdminEvaluateServlet` | 评价审核、违规删除 |
| **Admin-Announce** 公告 | `admin/announcementManage.jsp` | `AnnouncementManageServlet` | 公告发布与管理、首页跑马灯 |
| **Admin-Insight** 数据洞察 | `admin/foodInsight.jsp` | `AdminFoodInsightServlet` | 评分分布直方图、校园统计概览 |
| **Admin-Log** 系统日志 | `admin/logManage.jsp` | `LogManageServlet` | 操作日志查看与审计 |

---

## ✨ 核心特性

### 🍜 三维评分体系
- 每份评价包含**口味**、**价格**、**服务**三个维度的 1-5 分评分
- 综合评价分自动计算，支持按综合分排序浏览
- 评分分布直方图可视化（管理后台数据洞察）

### 🧭 寻味雷达 — 智能推荐引擎
- **心情模式**：想吃暖的 / 清爽健康 / 跟风热门 / 高分优先 / 性价比
- **预算模式**：日常消费 / 犒劳自己 / 赶时间快速决策
- 基于 NLP 关键词匹配 + 加权评分算法的规则引擎
- 每条推荐附带推荐理由，帮助快速判断

### 📊 美食热榜 — 多维度排行
- **餐厅热度榜**：综合评分 ×20 + 评价数对数 ×18 + 点赞数 ×1.4 的热度算法
- **菜品热度榜**：加权侧重菜品维度
- **创作者榜**：评价数量、获赞数、平均分三维加权
- 每项附带趋势标签（TOP 1 / 高分 / 高赞 / 热议）

### 🎯 味蕾档案 — 个人口味画像
- **人格标签系统**：新晋探索者 / 味觉猎手 / 性价比雷达 / 体验派同学 / 校园美食策展人
- **最强维度识别**：味道敏感度 / 性价比雷达 / 体验感知力
- **成就徽章**：跨餐厅探索者、地图点亮达人、高分发现家、持续记录者等
- 个人统计数据：评价数、餐厅覆盖面、获赞总数、平均评分

### ✅ 想吃清单
- 收藏心仪菜品到个人心愿单
- 支持添加备注，标记已完成
- 快速导航到对应餐厅查看详情

### 🛡 管理后台
- **控制台面板**：用户数 / 餐厅数 / 评价数 / 日志数的 3×3 统计卡片
- **用户管理**：查看、编辑、删除用户
- **餐厅管理**：餐厅增删改查
- **内容审核**：评价列表管理，支持违规删除
- **公告管理**：发布/编辑/删除公告，首页跑马灯展示
- **数据洞察**：评分分布柱状图、校园统计概览
- **系统日志**：操作审计日志

### 🎨 交互细节
- 游客模式：无需登录即可浏览全站评价
- 公告跑马灯：首页无缝循环滚动展示活跃公告
- 管理员入口彩蛋：登录页连续点击标题 3 次切换管理员登录面板
- 验证码刷新：点击图片刷新，防止暴力登录
- 响应式导航：用户菜单下拉面板，登录态感知

---

## 🛠 技术栈

| 层级 | 技术 | 版本 |
|:---|:---|:---|
| 后端语言 | Java | 1.8 |
| Web 容器 | Apache Tomcat | 8.5 |
| 前端模板 | JSP + JSTL + EL | 2.x |
| 数据库 | MySQL | 8.0+ |
| JDBC 驱动 | MySQL Connector/J | 8.0+ |
| 样式方案 | 原生 CSS3（自定义设计系统） | — |
| 字体 | Google Fonts - Inter | — |
| 构建方式 | Eclipse Dynamic Web Project | — |
| 版本控制 | Git | — |

---

## 📁 项目结构

```
CanteenEvaluate/
├── src/main/java/com/
│   ├── dao/                           # 数据访问层 (8 个 DAO)
│   │   ├── AnnouncementDAO.java       # 公告数据操作
│   │   ├── ConfigDAO.java             # 系统配置操作
│   │   ├── EvaluationDAO.java         # 评价数据操作（分页/排序/筛选）
│   │   ├── FoodInsightDAO.java        # 数据洞察引擎（热度算法/推荐/画像）
│   │   ├── RestaurantDAO.java         # 餐厅数据操作
│   │   ├── SysLogDAO.java             # 系统日志操作
│   │   ├── UserDAO.java               # 用户数据操作
│   │   └── WishDAO.java               # 想吃清单数据操作
│   ├── entity/                        # 实体类 (9 个)
│   │   ├── Announcement.java          # 公告实体
│   │   ├── CampusStats.java           # 校园统计数据
│   │   ├── Evaluation.java            # 评价实体（含洞察评分/推荐理由）
│   │   ├── InsightCard.java           # 排行榜卡片（热度分/趋势标签）
│   │   ├── Restaurant.java            # 餐厅实体
│   │   ├── SysLog.java                # 系统日志实体
│   │   ├── TasteProfile.java          # 味蕾画像（人格/徽章/维度）
│   │   ├── User.java                  # 用户实体
│   │   └── WishItem.java              # 想吃清单项
│   ├── filter/                        # 过滤器
│   │   └── AdminFilter.java           # 管理员权限拦截
│   ├── servlet/                       # 控制器层 (30+ 个 Servlet)
│   │   ├── AccountServlet.java        # 账户页面
│   │   ├── AddEvaluateServlet.java    # 发布评价
│   │   ├── AdminLoginServlet.java     # 管理员登录
│   │   ├── AdminFoodInsightServlet.java # 数据洞察
│   │   ├── AllEvaluateServlet.java    # 全站评价流
│   │   ├── AnnouncementManageServlet.java # 公告管理
│   │   ├── DashboardStatsServlet.java # 后台统计面板
│   │   ├── DeleteEvaluateServlet.java # 删除评价
│   │   ├── EditEvaluateServlet.java   # 编辑评价
│   │   ├── EvaluationManageServlet.java # 内容审核
│   │   ├── LikeEvaluationServlet.java # 点赞评价
│   │   ├── LoginServlet.java          # 用户登录
│   │   ├── LogManageServlet.java      # 日志管理
│   │   ├── LogoutServlet.java         # 退出登录
│   │   ├── MyEvaluateServlet.java     # 我的评价
│   │   ├── RegisterServlet.java       # 用户注册
│   │   ├── RestaurantAddServlet.java  # 添加餐厅
│   │   ├── RestaurantDeleteServlet.java # 删除餐厅
│   │   ├── RestaurantListServlet.java # 餐厅列表
│   │   ├── RestaurantUpdateServlet.java # 更新餐厅
│   │   ├── TasteCompassServlet.java   # 寻味雷达推荐
│   │   ├── TasteProfileServlet.java   # 味蕾档案
│   │   ├── ToEditEvaluateServlet.java # 编辑页跳转
│   │   ├── TrendBoardServlet.java     # 美食热榜
│   │   ├── UpdateProfileServlet.java  # 更新个人资料
│   │   ├── UserDeleteServlet.java     # 删除用户
│   │   ├── UserListServlet.java       # 用户列表
│   │   ├── UserUpdateServlet.java     # 更新用户
│   │   ├── VerifyCodeServlet.java     # 图形验证码
│   │   ├── WishListServlet.java       # 想吃清单
│   │   └── WishActionServlet.java     # 清单操作
│   └── util/                          # 工具类 (4 个)
│       ├── ConfigUtil.java            # 配置文件读取
│       ├── DBUtil.java                # 数据库连接管理
│       ├── HtmlUtil.java              # HTML 转义防 XSS
│       └── PasswordUtil.java          # 密码加盐哈希
├── src/main/resources/
│   ├── db.properties                   # 数据库连接配置（已 gitignore）
│   └── db.properties.example           # 数据库配置模板
├── src/main/webapp/                   # 前端页面
│   ├── index.jsp                      # 首页（公告跑马灯 + 功能卡片）
│   ├── login.jsp                      # 登录/管理员登录（双面板）
│   ├── register.jsp                   # 用户注册
│   ├── allEvaluate.jsp                # 全站评价（排序/筛选/分页）
│   ├── tasteCompass.jsp               # 寻味雷达（心情/预算推荐）
│   ├── trendBoard.jsp                 # 美食热榜（三榜切换）
│   ├── addEvaluate.jsp                # 发布评价
│   ├── editEvaluate.jsp               # 编辑评价
│   ├── myEvaluate.jsp                 # 我的评价
│   ├── tasteProfile.jsp               # 味蕾档案
│   ├── wishList.jsp                   # 想吃清单
│   ├── account.jsp                    # 账户设置
│   ├── css/
│   │   ├── modern-style.css           # 全局现代化样式系统
│   │   ├── feature-modern.css         # 功能页卡片/排行样式
│   │   ├── eval-v3.css                # 评价模块专属样式
│   │   └── style.css                  # 基础样式
│   ├── images/
│   │   └── logo.svg                   # 原创站点 Logo
│   ├── js/
│   │   └── modern-app.js              # 前端工具函数（Toast/Modal/AJAX）
│   └── admin/                         # 管理后台 (7 个页面)
│       ├── js/
│       │   └── admin-modern.js        # 后台工具函数
│       ├── adminIndex.jsp             # 控制台面板
│       ├── userManage.jsp             # 用户管理
│       ├── restaurantManage.jsp       # 餐厅管理
│       ├── evaluationManage.jsp       # 内容审核
│       ├── announcementManage.jsp     # 公告管理
│       ├── foodInsight.jsp            # 数据洞察
│       ├── logManage.jsp              # 系统日志
│       └── css/
│           └── admin-modern.css       # 后台专属样式
├── sql/
│   └── canteen_db.sql                 # 数据库初始化脚本
├── .gitignore
└── README.md
```

---

## 🚢 部署说明

### 开发环境

1. 在 MySQL 中执行 `sql/canteen_db.sql` 初始化数据库
2. Eclipse 导入项目，确保 Tomcat 8.5 Runtime 已配置
3. 将 `mysql-connector-java-8.x.jar` 放入 `WebContent/WEB-INF/lib/`
4. 复制 `db.properties.example` → `db.properties` 并填入你的数据库信息
5. `Run on Server` 启动

### 生产环境

```bash
# 1. 准备环境
#    - 安装 JDK 8、Tomcat 8.5、MySQL 8.0
#    - 执行 sql/canteen_db.sql 初始化数据库

# 2. 导出 WAR 包
#    Eclipse: 右键项目 → Export → WAR file

# 3. 部署到 Tomcat
cp CanteenEvaluate.war $TOMCAT_HOME/webapps/

# 4. 启动 Tomcat
$TOMCAT_HOME/bin/startup.sh

# 5. 访问
# http://your-server:8080/CanteenEvaluate
```

### Tomcat 调优建议

```xml
<!-- $TOMCAT_HOME/conf/server.xml -->
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           maxThreads="200"
           minSpareThreads="25"
           enableLookups="false"
           URIEncoding="UTF-8" />
```

---

## 🔒 安全提示

```text
⚠️  db.properties 中的数据库密码请勿提交到 Git（已在 .gitignore 中排除）
⚠️  生产环境部署前务必修改 db.properties 中的默认密码
⚠️  管理员密码通过 PasswordUtil 加盐哈希存储，数据库不存明文
⚠️  所有用户输入均通过 HtmlUtil.escape() 转义，防止 XSS 攻击
⚠️  管理后台通过 AdminFilter 拦截未授权请求
⚠️  验证码机制防止暴力登录
⚠️  定期备份 canteen_db 数据库
```

### 密码安全

- 密码使用 `PasswordUtil` 加盐哈希存储，数据库不存明文
- 管理员与普通用户通过 `role` 字段区分，前后端双重校验
- `AdminFilter` 拦截 `/admin/*` 路径，未登录管理员自动重定向

### 输入安全

- JSP 输出统一使用 `HtmlUtil.escape()` 转义，杜绝 XSS
- SQL 查询使用 `PreparedStatement` 参数化，防止 SQL 注入
- 文件上传限制类型与大小

---

## 📄 版本历史

| 版本 | 日期 | 核心变更 |
|:---|:---|:---|
| **V1.0** | 2026-07 | 🍜 正式发布 — 山海寻味录：用户注册登录（验证码 + 游客模式）；全站评价浏览（排序/筛选/分页）；三维评分（口味/价格/服务）发布与编辑；寻味雷达智能推荐引擎（心情 × 预算双维度）；美食热榜（餐厅/菜品/创作者三榜 + 热度算法）；味蕾档案人格画像（6 种标签 + 成就徽章）；想吃清单管理；管理后台（控制台/用户/餐厅/评价/公告/数据洞察/操作日志）；管理员登录彩蛋入口；首页公告跑马灯；数据库初始化脚本 `sql/canteen_db.sql`（7 张表 + 种子数据）；原创 SVG Logo；db.properties.example 配置模板；.gitignore 敏感信息防护 |

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

---

## 📝 开源协议

本项目基于 MIT 协议开源。详见 [LICENSE](LICENSE) 文件。

---

<p align="center">
  <sub>Made with ❤️ for Shanhai University students 🍜</sub>
</p>
