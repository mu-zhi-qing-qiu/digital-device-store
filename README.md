# 数码设备商城 (Digital Device Store)

一个前后端分离的数码设备电商示例项目。后端基于 **Spring Boot 3 + MyBatis-Plus + MySQL**，前端基于 **Vue 3 + Vite + Element Plus + Tailwind CSS**，覆盖商品浏览、搜索、购物车、下单、订单管理、商品评价，以及面向管理员的商品 / 分类 / 用户 / 订单后台管理。

---

## 功能特性

**用户端**
- 注册 / 登录（密码 BCrypt 加密，HMAC-SHA256 自签 Token，有效期 7 天）
- 首页推荐、商品列表、分类筛选、关键字搜索（MySQL 全文索引 ngram 分词）
- 商品详情、多图展示、商品评价
- 购物车（增删改）、下单结算、个人订单列表、个人资料

**管理端**（角色 `role = 1`）
- 商品管理（增删改、图片）
- 分类管理（支持多级分类）
- 用户管理
- 订单管理（分页查看、修改订单状态）

---

## 技术栈

### 后端
| 技术 | 版本 | 说明 |
| --- | --- | --- |
| Java | 17 | 语言版本 |
| Spring Boot | 3.4.5 | Web / Validation |
| MyBatis-Plus | 3.5.9 | ORM、分页（+ `mybatis-plus-jsqlparser`） |
| MySQL Connector/J | 9.1.0 | JDBC 驱动 |
| spring-security-crypto | （随 Boot） | 仅用于 BCrypt 加密，未启用完整 Spring Security |
| Lombok | （随 Boot） | 简化样板代码 |
| Maven | 3.6+ | 构建工具 |

### 前端
| 技术 | 版本 | 说明 |
| --- | --- | --- |
| Vue | 3.5 | 渐进式框架（Composition API） |
| Vite | 6 | 构建 / 开发服务器 |
| Vue Router | 4.5 | 路由（含登录 / 管理员路由守卫） |
| Pinia | 2.3 | 状态管理（用户登录态） |
| Element Plus | 2.9 | UI 组件库（+ 图标） |
| Tailwind CSS | 4 | 原子化样式（`@tailwindcss/vite`） |
| axios | 1.7 | HTTP 请求（统一拦截 Token / 错误） |

### 数据库
- **MySQL 8.x**（必须 8.x：搜索依赖 `ngram` 全文解析器与 `FULLTEXT` 索引）

---

## 项目目录结构

```
DigitalDeviceStore/
├── pom.xml                          # 后端 Maven 配置
├── sql/
│   └── add_indexes.sql             # 索引创建脚本（需手动执行）
├── src/main/
│   ├── java/com/example/store/
│   │   ├── DigitalDeviceStoreApplication.java   # 启动入口
│   │   ├── common/                 # 通用：统一返回 Result、鉴权、异常
│   │   │   ├── auth/               #   TokenService（签发/校验 Token）、AuthContext
│   │   │   └── exception/          #   BizException、全局异常处理
│   │   ├── config/                 # 配置：鉴权拦截器、CORS、MyBatis-Plus、种子数据
│   │   ├── controller/             # 接口层：user/product/category/cart/order/review
│   │   ├── service/ (+ impl/)      # 业务层
│   │   ├── mapper/                 # MyBatis-Plus Mapper
│   │   ├── entity/                 # 实体（对应数据库表）
│   │   ├── dto/                    # 请求 DTO
│   │   └── vo/                     # 返回 VO
│   └── resources/
│       ├── application.yml         # 数据源 / 端口 / MyBatis-Plus 配置
│       ├── schema.sql              # 全量建表 DDL（启动时自动执行）
│       ├── mapper/                 # 自定义 SQL XML
│       └── static/images/          # 商品图片（经 /images 静态访问）
└── frontend/
    ├── package.json
    ├── vite.config.js              # 端口 5173，/api 与 /images 代理到 :8080
    └── src/
        ├── main.js                 # 应用入口
        ├── App.vue
        ├── api/                    # axios 封装与各模块接口
        ├── router/                 # 路由与守卫
        ├── stores/                 # Pinia（用户态）
        ├── components/             # 通用组件（布局 / 商品卡 / UI）
        ├── views/                  # 页面（含 admin/ 后台页面）
        ├── utils/                  # 格式化 / 图片工具
        └── styles/                 # 全局样式
```

> 说明：仓库内的 `.m2/` 为已缓存的 Maven 依赖（便于离线构建），`target/`、`node_modules/`、`*.docx` 已在 `.gitignore` 中忽略。

---

## 数据库设计

库名：`digital_device_store`，共 9 张表（InnoDB / utf8mb4）：

| 表 | 说明 |
| --- | --- |
| `user` | 用户（`role`：0 普通用户 / 1 管理员），`username` 唯一 |
| `category` | 商品分类，`parent_id` 自关联支持多级分类 |
| `product` | 商品（名称、价格、库存、品牌、描述、分类） |
| `product_image` | 商品图片（一对多） |
| `cart` | 购物车（每用户一条，`uk_user_id`） |
| `cart_item` | 购物车项（`uk_cart_product` 防重复） |
| `order` | 订单（`status`：0 待付款 / 1 已付款 / 2 已发货 / 3 已完成 / 4 已取消） |
| `order_item` | 订单详情（`purchase_price` 为下单时价格快照） |
| `review` | 商品评价（`rating` 1–5） |

`sql/add_indexes.sql` 在建表基础上追加的索引（**必须手动执行**）：
- `order(user_id, created_time)` 复合索引 + `order(created_time)` 索引（优化「我的订单」与后台订单分页排序，并删除冗余的 `idx_user_id`）
- `product(name)` 的 **`FULLTEXT ... WITH PARSER ngram`** 全文索引（**商品搜索接口依赖此索引，未创建会导致搜索报错**）
- 
`sql/20260701114147.sql` 为数据库填充数据（**必须手动执行**） 否则前端首页、商品列表、搜索等功能会无数据。
---

## 环境需求

| 依赖 | 版本要求 |
| --- | --- |
| JDK | 17+ |
| Maven | 3.6+ |
| MySQL | **8.x**（需 `ngram` 全文解析器支持） |
| Node.js | 18+（Vite 6 要求，推荐 20+ / 22） |

默认数据源配置见 `src/main/resources/application.yml`：

```yaml
url: jdbc:mysql://localhost:3306/digital_device_store
username: root
password: root
```

如本地 MySQL 账号 / 密码 / 端口不同，请先修改该文件。

---

## 启动方式

### 1. 准备数据库

后端启动时**会**自动建库（连接串含 `createDatabaseIfNotExist=true`）并自动执行 `schema.sql`（`spring.sql.init.mode=always`）。
但 `sql/add_indexes.sql` 是一次性迁移脚本，**不会**随启动自动执行，而商品搜索依赖其中的全文索引。

> **推荐做法：先手动执行 `schema.sql` 建表，再手动执行一遍 `sql/add_indexes.sql` 建索引，然后再启动后端。**

```bash
# (1) 创建数据库（若已存在可跳过）
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS digital_device_store DEFAULT CHARSET utf8mb4;"

# (2) 手动执行建表脚本
mysql -uroot -proot digital_device_store < src/main/resources/schema.sql

# (3) 手动执行索引脚本（一次性，重复执行会因索引已存在而报错，属正常现象）
mysql -uroot -proot digital_device_store < sql/add_indexes.sql
```

> 注意执行顺序：`add_indexes.sql` 会基于 `schema.sql` 已建好的表追加 / 调整索引，务必先 `schema.sql` 后 `add_indexes.sql`。

### 2. 启动后端（端口 8080）

```bash
# 在项目根目录
mvn spring-boot:run
# 或：打包后运行
mvn clean package
java -jar target/digital-device-store-1.0.0.jar
```

启动时会通过 `DataInitializer` 幂等写入种子用户（密码经 BCrypt 加密）。

### 3. 启动前端（端口 5173）

```bash
cd frontend
npm install
npm run dev
```

打开浏览器访问 **http://localhost:5173** 。
开发模式下 Vite 已将 `/api` 与 `/images` 代理到后端 `http://localhost:8080`，无需额外跨域配置。

前端生产构建：

```bash
cd frontend
npm run build      # 输出到 frontend/dist
npm run preview    # 本地预览构建产物
```

---

## 默认账号

由 `DataInitializer` 在首次启动时创建：

| 用户名 | 密码 | 角色 |
| --- | --- | --- |
| `admin` | `123456` | 管理员（可访问 `/admin` 后台） |
| `zhangsan` | `123456` | 普通用户 |

---

## 接口与鉴权

- 所有后端接口前缀为 `/api`，统一返回结构 `{ code, message, data }`（`code = 200` 为成功）。
- 鉴权采用请求头 `Authorization: Bearer <token>`，由 `AuthInterceptor` 拦截 `/api/**`。

| 模块 | 基础路径 | 访问级别 |
| --- | --- | --- |
| 用户 User | `/api/user` | 注册 / 登录公开；分页、删除需管理员 |
| 商品 Product | `/api/product` | `GET` 公开；增删改需管理员 |
| 分类 Category | `/api/category` | `GET` 公开；增删改需管理员 |
| 购物车 Cart | `/api/cart` | 需登录 |
| 订单 Order | `/api/order` | 下单 / 我的订单需登录；`admin/page`、改状态需管理员 |
| 评价 Review | `/api/review` | 按商品查询公开；发表需登录；删除需管理员 |

---

## 常见问题

- **搜索接口报错 / 搜不到商品**：通常是未执行 `sql/add_indexes.sql`，导致缺少 `product(name)` 的 `FULLTEXT(ngram)` 索引。补执行该脚本即可。
- **`add_indexes.sql` 执行报「索引已存在 / Duplicate key name」**：该脚本设计为只跑一次，重复执行报错属正常现象，可忽略。
- **启动连接数据库失败**：检查 MySQL 是否运行、版本是否为 8.x，以及 `application.yml` 中的账号 / 密码 / 端口是否正确。
- **图片无法显示**：商品图片来自后端 `src/main/resources/static/images/`，经 `/images/**` 访问；开发时需保证后端已启动（前端通过代理转发）。
