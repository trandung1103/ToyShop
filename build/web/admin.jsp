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

                            // Đặt user vào session nếu tìm thấy
                            if (user != null) {
                                session.setAttribute("user", user);
                            }
                            break;
                        }
                    }
                }
            }

            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
        %>
    </head>
    <body>
        <header>
            <div class="header-container">
                <h1><a href="home.jsp">Toyo</a></h1>
                <form action="users_search.jsp" method="get" class="search-form">
                    <input type="text" name="query" placeholder="Tìm kiếm sản phẩm..." required>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
                <div class="auth-links">
                    <%
                    if (user == null) {
                    %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
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
            <div class="container text-center" style="margin-top: 100px;">
                <div class="row">
                    <div class="col-md-4">
                        <div class="icon-box" onclick="window.location.href = 'list_user.jsp'">
                            <i class="fas fa-user icon"></i>
                            <h5>Quản lý người dùng</h5>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="icon-box" onclick="window.location.href = 'storage.jsp'">
                            <i class="fa-solid fa-warehouse icon"></i>
                            <h5>Quản lý kho</h5>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="icon-box" onclick="window.location.href = 'allorder.jsp'">
                            <i class="fa-solid fa-file-invoice-dollar icon"></i>
                            <h5>Quản lý đơn hàng</h5>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <footer>
            <p>&copy; 2024 Toyo. All rights reserved.</p>
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

    h1,h2,h3,h4 {
        margin: 0;
        font-size: 28px;
        font-weight: bold;
    }

    a {
        text-decoration: none;
        color: white;
        margin: 5px;
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
        padding: 20px;
        display: flex;
        flex: 1;
        justify-content: center; 
        align-items: center; 
        flex-wrap:wrap-reverse; 
    }

    .icon-box {
        width: 500px; 
        height: 150px;
        background-color: #ffffff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
        margin: 20px;
        cursor: pointer;
        transition: transform 0.3s;
    }

    .icon-box:hover {
        transform: scale(1.05);
    }

    .icon {
        font-size: 50px;
        color: #3498db;
        margin-bottom: 10px;
    }

    footer {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: #fff;
        text-align: center;
        padding: 15px 0;
    }
</style>
