<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Product Detail</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <%
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
    %>
    <body>
        <header>
            <div class="header-container">
                <h1><a href="home.jsp" style="text-decoration: none; color: white;">Toyo</a></h1>
                <form action="user_search.jsp" method="get" class="search-form">
                    <input type="text" name="query" placeholder="Tìm kiếm sản phẩm..." required>
                    <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
                <div class="auth-links">
                    <%
                    User user = (User) session.getAttribute("user");
                    if (user == null) {
                    %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                    <% } else { %>
                    <a href="user.jsp"><i class="fa-solid fa-user"></i><%= user.getDisplayName() %></a>
                    <a href="cart.jsp"><i class="fa-solid fa-shopping-cart"></i></a>
                    <a href="order_detail.jsp"><i class="fa-solid fa-clipboard-list"></i></a>
                        <% if ("admin".equals(user.getRole())) { %>
                    <a href="admin.jsp"><i class="fa-solid fa-gears"></i></a>
                        <% } %>
                    <a href="logout.jsp"><i class="fa-solid fa-right-from-bracket"></i></a>
                        <% } %>
                </div>
            </div>
        </header>

        <nav>
            <ul>
                <%
                    List<Category> cate = categoryDAO.getAll(); 
                    if (cate != null && !cate.isEmpty()){
                        for (Category cg : cate) {
                %>              
                <li><a href="allProducts.jsp?categoryName=<%=cg.getName()%>"><%=cg.getName()%></a></li>
                    <%
                            }
                        }
                    %>
            </ul>
        </nav>

        <main>
            <%
              int productId = Integer.parseInt(request.getParameter("productId"));
          
              Product product = productDAO.getProductById(productId);
          
              String categoryName = product.getCategoryID();
              List<Product> productsByCategory = productDAO.getProductsByCategory(categoryName);
            %>

            <div class="centered-product-box">
                <h2 class="product-title"><%= product.getProduct_name() %></h2>
                <img class="product-image" src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" />
                <p class="price">Giá: $<%= product.getProduct_price() %></p>
                <p class="description">Mô tả: <%= product.getProduct_description() %></p>
                <p class="stock">Số lượng có sẵn: <%= product.getProduct_quantity() > 0 ? product.getProduct_quantity() : "Hết hàng!!!" %></p>

                <form action="CartServlet" method="post" class="add-to-cart-form">
                    <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                    <input type="number" name="quantity" value="1" min="1" max="<%= product.getProduct_quantity() %>" class="quantity-input">
                    <button type="submit" name="action" value="add" class="add-to-cart">
                        <i class="fa-solid fa-shopping-cart"></i> Thêm vào giỏ
                    </button>
                </form>
            </div>


            
            <div class="category-box">
                <h3 style="color: #fff">Sản phẩm cùng thể loại</h3>
                <div class="product-group">
                    <%
                        int count = 0;
                        for (Product relatedProduct : productsByCategory) {
                            if (relatedProduct.getProduct_id() != productId && count < 3) { // Tránh hiển thị sản phẩm hiện tại
                    %>
                    <div class="product">
                        <h4><%= relatedProduct.getProduct_name() %></h4>
                        <img src="<%= relatedProduct.getImage_url() %>" />
                        <p>Giá: $<%= relatedProduct.getProduct_price() %></p>
                        <form action="CartServlet" method="post">
                            <input type="hidden" name="productId" value="<%= relatedProduct.getProduct_id() %>">
                            <input type="number" name="quantity" value="1" min="1" max="<%= relatedProduct.getProduct_quantity() %>">
                            <button type="submit" name="action" value="add">
                                <i class="fa-solid fa-shopping-cart"></i> Thêm vào giỏ
                            </button>
                        </form>
                    </div>
                    <%
                        count++;
                            }
                        }
                    %>
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
        background: linear-gradient(90deg, #0066cc, #66bb6a); /* Adjusted color */
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
        background-color: #0066cc; /* Adjusted color */
        border: none;
        color: #fff;
        cursor: pointer;
        border-radius: 0 5px 5px 0;
    }

    nav {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        position: fixed;
        top: 60px;
        width: 100%;
        z-index: 999;
    }

    nav ul {
        list-style: none;
        padding: 10px 20px;
        margin-left: 25%;
        display: flex;
        flex-wrap: wrap;
    }

    nav li {
        margin-right: 15px;
    }

    nav a {
        color: white;
        text-decoration: none;
        padding: 5px 10px;
        transition: background-color 0.3s;
    }

    nav a:hover {
        background-color: #66bb6a; /* Adjusted color */
    }
    .auth-links a {
        display: inline-flex; /* Đặt là inline-flex để căn giữa các biểu tượng */
        align-items: center; /* Căn giữa theo chiều dọc */
        color: white; /* Màu chữ mặc định */
        text-decoration: none; /* Không có gạch chân */
        margin-left: 15px; /* Khoảng cách giữa các biểu tượng */
        transition: color 0.3s, transform 0.3s; /* Hiệu ứng chuyển động */
    }

    .auth-links a i {
        font-size: 20px; /* Kích thước biểu tượng */
        margin-right: 5px; /* Khoảng cách giữa biểu tượng và tên */
    }

    .auth-links a:hover {
        color: #66bb6a; /* Màu khi hover */
        transform: scale(1.1); /* Tăng kích thước khi hover */
    }

    main {
        margin-top: 120px;
        padding: 20px;
        flex: 1;
        background-color: #f9f9f9;
    }

    .product-detail {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin-bottom: 20px;
    }

    .product-detail img {
        max-width: 100%;
        border-radius: 8px;
    }

    .category-box {
        text-align: center;
        margin-top: 40px;
        background: #2980b9;
        border-radius: 10px;
        padding: 20px;
    }

    .product-group {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
    }

    .product {
        background: #fff;
        margin: 10px;
        border-radius: 5px;
        padding: 15px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        transition: transform 0.2s;
    }
    .product:hover {
        transform: scale(1.05);
    }

    .price {
        font-size: 20px;
        color: #333;
    }

    .description, .stock {
        font-size: 16px;
        color: #666;
    }

    .quantity-input {
        width: 50px;
        margin-right: 10px;
    }

    .add-to-cart {
        background-color: #2e7d32; /* Màu nền của nút */
        color: white; /* Màu chữ */
        padding: 10px 15px; /* Đệm cho nút */
        border: none; /* Không có viền */
        border-radius: 5px; /* Bo tròn góc */
        cursor: pointer; /* Con trỏ chuột khi hover */
        font-size: 16px; /* Kích thước chữ */
        transition: background-color 0.3s, transform 0.3s; /* Hiệu ứng chuyển đổi */
        display: flex; /* Để sử dụng icon bên trong */
        align-items: center; /* Căn giữa icon và chữ */
        justify-content: center; /* Căn giữa nội dung */
    }

    .add-to-cart:hover {
        background-color: #66bb6a; /* Màu nền khi hover */
        transform: scale(1.05); /* Tăng kích thước một chút khi hover */
    }

    .add-to-cart i {
        margin-right: 5px; /* Khoảng cách giữa icon và chữ */
    }
    .add-to-cart-form {
        display: flex; /* Sắp xếp các phần tử trong hàng */
        align-items: center; /* Căn giữa theo chiều dọc */
        background-color: #fff; /* Màu nền của form */
        border: 1px solid #ddd; /* Viền mỏng cho form */
        border-radius: 5px; /* Bo tròn góc */
        padding: 10px; /* Đệm cho form */
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1); /* Hiệu ứng đổ bóng */
        margin-top: 10px; /* Khoảng cách trên form */
    }

    .add-to-cart-form input[type="number"] {
        width: 60px; /* Chiều rộng cho trường số */
        padding: 5px; /* Đệm cho trường */
        border: 1px solid #ccc; /* Viền cho trường */
        border-radius: 3px; /* Bo tròn góc cho trường */
        margin-right: 10px; /* Khoảng cách bên phải */
    }

    .add-to-cart-form button {
        background-color: #0066cc;
        color: white; /* Màu chữ */
        padding: 10px 15px; /* Đệm cho nút */
        border: none; /* Không có viền */
        border-radius: 5px; /* Bo tròn góc */
        cursor: pointer; /* Con trỏ chuột khi hover */
        font-size: 16px; /* Kích thước chữ */
        transition: background-color 0.3s, transform 0.3s; /* Hiệu ứng chuyển đổi */
    }

    .add-to-cart-form button:hover {
        background-color: #66bb6a; /* Màu nền khi hover */
        transform: scale(1.05); /* Tăng kích thước một chút khi hover */
    }

    .add-to-cart-form i {
        margin-right: 5px; /* Khoảng cách giữa icon và chữ */
    }



    .product img {
        max-width: 150px; /* Kích thước tối đa là 150px (hoặc điều chỉnh theo ý bạn) */
        height: auto; /* Đảm bảo tỷ lệ khung hình của hình ảnh */
        border-radius: 8px; /* Để có góc bo tròn như bạn đã làm */
    }

    .centered-product-box {
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        margin: 20px auto;
        max-width: 400px;
        text-align: center;
    }

    .centered-product-box img {
        width: 200px;
        height: 200px;
        object-fit: cover;
        border-radius: 8px;
        margin-bottom: 15px;
    }

    .centered-product-box .add-to-cart-form {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
        width: 100%;
    }

    .centered-product-box .quantity-input {
        width: 60px;
        padding: 5px;
        text-align: center;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    .centered-product-box .add-to-cart {
        background-color: #0066cc;
        border: none;
        color: white;
        padding: 10px 15px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.2s;
        width: 100%;
    }

    .centered-product-box .add-to-cart:hover {
        background-color: #66bb6a;
        transform: scale(1.05);
    }


    footer {
        text-align: center;
        padding: 20px;
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: white;
    }
</style>
