<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Product, model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.UserDAO, dal.ProductDAO, dal.CategoryDAO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Toyo - Home</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <%
            // Kiểm tra xem session có người dùng chưa
            User user = (User) session.getAttribute("user");

            // Nếu session chưa có, kiểm tra trong cookie
            if (user == null) {
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if ("username".equals(cookie.getName())) {
                            String username = cookie.getValue();
                            UserDAO userDAO = new UserDAO();
                            user = userDAO.getUserByName(username);

                            if (user != null) {
                                session.setAttribute("user", user);
                            }
                            break;
                        }
                    }
                }
            }

            ProductDAO productDAO = new ProductDAO();
            String query = request.getParameter("query");
            List<Product> products = productDAO.searchProducts(query);
        %>
    </head>
    <body>
        <header>
            <div class="header-container">
                <h1>Toyo</h1>
                <form action="users_search.jsp" method="get" class="search-form">
                    <input type="text" name="query" placeholder="Tìm kiếm sản phẩm..." required>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
                <div class="auth-links">
                    <%
                    if (user == null) {
                    %>
                    <a href="login.jsp">Đăng nhập</a>
                    <a href="register.jsp">Đăng ký</a>
                    <% } else { %>
                    <a href="user.jsp"><i class="fa-solid fa-user"></i><%= user.getDisplayName() %></a>
                    <a href="cart.jsp"><i class="fa-solid fa-shopping-cart"></i></a>
                    <a href="orderList.jsp"><i class="fa-solid fa-clipboard-list"></i></a>
                        <% if ("admin".equals(user.getRole())) { %>
                    <a href="admin.jsp"><i class="fa-solid fa-gears"></i></a>
                        <% } %>
                    <a href="logout"><i class="fa-solid fa-right-from-bracket"></i></a>  
                        <% } %>
                </div>
            </div>
        </header>

        <main>
            <h1 style="text-align: center; margin: 20px 0;">Kết quả tìm kiếm cho: <%= query %></h1>

            <div class="product-container">
                <%
                    if (products.isEmpty()) {
                %>
                <p style="text-align: center;">Không tìm thấy sản phẩm nào.</p>
                <%
                    } else {
                        for (Product product : products) {
                %>
                <div class="product">
                    <h3 style="color: #2980b9;"><%= product.getProduct_name() %></h3>
                    <img class="product-image" src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" />
                    <p>Giá: <%= product.getProduct_price() %> VNĐ</p>
                    <p><%= product.getProduct_description() %></p>
                    <% if (product.getProduct_quantity() > 0) { %>
                    <p>Số lượng có sẵn: <%= product.getProduct_quantity() %></p>
                    <% } else { %>
                    <p style="color:red;">Hết hàng!!!</p>
                    <% } %>

                    <form action="CartServlet" method="post">
                        <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                        <input type="number" name="quantity" value="1" min="1" max="<%= product.getProduct_quantity() %>" style="width: 60px; margin-right: 10px;"> <!-- Thay đổi kích thước input -->

                        <% if (user == null) { %>
                        <a class="button" href="login.jsp">Thêm vào giỏ</a>
                        <% } else { 
                        if (product.getProduct_quantity() > 0) { %>
                        <a style="font-size: 10px;" class="button" href="productDetail.jsp?productId=<%= product.getProduct_id() %>">
                            <button type="button"><i class="fa-solid fa-eye"></i> Chi tiết</button>
                        </a>
                        <button type="submit" name="action" value="add">
                            <i class="fa-solid fa-shopping-cart"></i>
                        </button>
                        <% } 
                        if ("admin".equals(user.getRole())) { %>
                        <a class="button" href="admin_product.jsp?productId=<%= product.getProduct_id() %>">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </a>
                        <% } 
                    } %>
                    </form>

                </div>
                <%
                        }
                    }
                %>
            </div>

            <div class="back-button" style="text-align: center; margin: 30px 0;">
                <a href="home.jsp">
                    <button>Quay về cửa hàng</button>
                </a>
            </div>
        </main>

        <footer>
            <p>© 2024 Cửa hàng của chúng tôi. Tất cả quyền được bảo lưu.</p>
        </footer>
    </body>
</html>

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #f4f4f4;
        display: flex;
        flex-direction: column;
        min-height: 100vh;
    }

    header {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: #fff;
        padding: 15px 0;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    .header-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: auto;
        padding: 0 20px;
    }

    h1, h2, h3, h4 {
        margin: 0;
        font-size: 28px;
        font-weight: bold;
    }

    .search-form {
        display: flex;
        align-items: center;
        background-color: #fff;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }

    .search-form input[type="text"] {
        padding: 8px;
        border: none;
        border-radius: 5px 0 0 5px;
    }

    .search-form button {
        padding: 8px 12px;
        background-color: #2980b9;
        border: none;
        color: #fff;
        cursor: pointer;
        border-radius: 0 5px 5px 0;
    }

    main {
        padding: 80px 20px;
        flex: 1;
        background-color: #f9f9f9;
    }

    .product-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        justify-content: center;
        margin: 20px auto;
        max-width: 1200px;
    }

    .product {
        background-color: #fff;
        border-radius: 10px;
        padding: 15px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s;
        width: calc(25% - 20px); /* Căn chỉnh với số lượng sản phẩm hiển thị */
        margin: 10px;
    }

    .product:hover {
        transform: translateY(-5px);
    }

    .product-image {
        max-width: 100%;
        height: auto;
        border-radius: 10px;
    }

    .back-button {
        text-align: center;
        margin: 30px 0;
    }
    /* Cải thiện giao diện nút bấm */
    button {
        background-color: #2980b9; /* Màu nền cho nút */
        color: #fff; /* Màu chữ */
        padding: 10px 15px; /* Khoảng cách bên trong */
        border: none; /* Bỏ viền */
        border-radius: 5px; /* Bo góc */
        cursor: pointer; /* Hiển thị con trỏ khi di chuột */
        transition: background-color 0.3s; /* Hiệu ứng chuyển màu */
        font-size: 16px; /* Kích thước chữ */
    }

    button:hover {
        background-color: #1a6f8b; /* Màu khi di chuột lên nút */
    }

    /* Cải thiện giao diện liên kết */
    a {
        margin: 5px;
        color: #fff; /* Màu chữ cho liên kết */
        text-decoration: none; /* Bỏ gạch chân */
        transition: color 0.3s; /* Hiệu ứng chuyển màu */
        font-weight: bold; /* Đậm chữ */
    }

    a:hover {
        color: #1a6f8b; /* Màu khi di chuột lên liên kết */
    }

/*     Thêm một chút khoảng cách cho các nút bấm trong form 
    form button, form a {
        margin-right: 10px;  Khoảng cách giữa các nút 
    }*/

    /* Cải thiện giao diện cho các nút trong sản phẩm */
    .product form {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-top: 10px; /* Khoảng cách giữa mô tả và form */
    }


    footer {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: #fff;
        text-align: center;
        padding: 15px 0;
    }
</style>
