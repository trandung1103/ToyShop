<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Product, model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Toyo - All Products</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <%
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            String categoryName = request.getParameter("categoryName");
            int limit = 3;
            int pages = 1;
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                try {
                    pages = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    pages = 1;
                }
            }
            int offset = (pages - 1) * limit;

            // Lấy giá trị sort từ request
            String sortOrder = request.getParameter("sort");
            if (sortOrder == null || sortOrder.equals("default")) {
                sortOrder = "default";
            }

            // Gọi phương thức lấy sản phẩm theo thứ tự giá
            List<Product> productsByCategory;
            if ("asc".equals(sortOrder)) {
                productsByCategory = productDAO.getProductsByCategorySortedByPrice(categoryName, offset, limit, "ASC");
            } else if ("desc".equals(sortOrder)) {
                productsByCategory = productDAO.getProductsByCategorySortedByPrice(categoryName, offset, limit, "DESC");
            } else {
                productsByCategory = productDAO.getProductsByCategory1(categoryName, offset, limit);
            }

            // Tính tổng sản phẩm và số trang
            int totalProducts = productDAO.getTotalProductsByCategory(categoryName);
            int totalPages = (int) Math.ceil((double) totalProducts / limit);
        %>
    </head>
    <body>
        <header>
            <div class="header-container">
                <h1><a href="home.jsp" style="text-decoration: none; color: white;">Toyo</a></h1>
                <form action="users_search.jsp" method="get" class="search-form">
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
                    <a href="orderList.jsp"><i class="fa-solid fa-clipboard-list"></i></a>
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
            <h2 style="text-align: center;">Sản phẩm thuộc danh mục: <%= categoryName %></h2>

            <!-- Form chọn sắp xếp theo giá -->
            <form method="get" action="allProducts.jsp" style="text-align: center; margin-bottom: 20px;">
                <input type="hidden" name="categoryName" value="<%= categoryName %>">
                <label for="sort">Sắp xếp theo giá:</label>
                <select name="sort" id="sort" onchange="this.form.submit()">
                    <option value="default" <%= "default".equals(sortOrder) ? "selected" : "" %>>Mặc định</option>
                    <option value="asc" <%= "asc".equals(sortOrder) ? "selected" : "" %>>Tăng dần</option>
                    <option value="desc" <%= "desc".equals(sortOrder) ? "selected" : "" %>>Giảm dần</option>
                </select>
            </form>

            <br>
            <div class="product-group">
                <%
                    if (productsByCategory != null && !productsByCategory.isEmpty()) {
                        for (Product product : productsByCategory) {
                %>
                <div class="product">
                    <h4><%= product.getProduct_name() %></h4>
                    <img src="<%=product.getImage_url()%>" alt="alt"/>
                    <p>Giá: $<%= product.getProduct_price() %></p>
                    <p><%= product.getProduct_description() %></p>
                    <% if (product.getProduct_quantity() > 0) { %>
                    <p>Số lượng có sẵn: <%= product.getProduct_quantity() %></p>
                    <% } else { %>
                    <p style="color:red;">Hết hàng!!!</p>
                    <% } %>
                    <form action="CartServlet" method="post">
                        <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                        <input type="number" name="quantity" value="1" min="1" max="<%= product.getProduct_quantity() %>">
                        <% if (user == null) { %>
                        <a href="login.jsp">Thêm vào giỏ</a>
                        <% } else { if (product.getProduct_quantity() > 0) { %>
                        <button type="submit" name="action" value="add">
                            <i class="fa-solid fa-shopping-cart"></i>
                        </button>
                        <a style="text-decoration: none" href="productDetail.jsp?productId=<%= product.getProduct_id() %>">
                            <button type="button">
                                <i class="fa-solid fa-eye"></i> Chi tiết
                            </button>
                        </a>

                    </form>
                    <% } if ("admin".equals(user.getRole())) { %>
                    <form action="storage" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="updateProduct">
                        <input type="hidden" name="product_id" value="<%= product.getProduct_id() %>">
                        <button type="submit">Edit</button>
                    </form>
                    <% } } %>
                </div>
                <%
                        }
                    } else {
                %>
                <p>Không có sản phẩm nào trong danh mục này.</p>
                <%
                    }
                %>
            </div>

            <div class="pagination" style="text-align: center; margin-top: 20px;">
                <%
                    if (totalPages > 1) {
                        for (int i = 1; i <= totalPages; i++) {
                            if (i == pages) {
                %>
                <span><%= i %></span>
                <%
                            } else {
                %>
                <a href="allProducts.jsp?categoryName=<%= categoryName %>&sort=<%= sortOrder %>&page=<%= i %>"><%= i %></a>
                <%
                            }
                        }
                    }
                %>
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
        padding: 20px 0;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
    }

    .header-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
        max-width: 1200px;
        margin: auto;
        padding: 0 20px;
    }

    .header-container h1 {
        font-size: 32px;
        font-weight: bold;
        letter-spacing: 1px;
    }

    .search-form {
        display: flex;
        align-items: center;
    }

    .search-form input[type="text"] {
        padding: 10px;
        border: none;
        border-radius: 20px 0 0 20px;
        outline: none;
        width: 250px;
    }

    .search-form button {
        padding: 10px 15px;
        border: none;
        background-color: #66bb6a;
        border-radius: 0 20px 20px 0;
        cursor: pointer;
        transition: background-color 0.3s, transform 0.3s;
    }

    .search-form button:hover {
        background-color: #2980b9;
        transform: scale(1.05);
    }

    .auth-links {
        display: flex;
        align-items: center;
    }

    .auth-links a {
        text-decoration: none;
        color: #fff;
        font-size: 16px;
        margin-left: 15px;
        transition: color 0.3s, transform 0.3s;
    }

    .auth-links a:hover {
        color: #ffeb3b;
        transform: scale(1.1);
    }

    h2, h4 {
        margin: 0;
        font-size: 28px;
        font-weight: bold;
    }

    nav {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        position: fixed;
        top: 109px;
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
        margin: 0 15px;
    }

    nav a {
        text-decoration: none;
        color: #fff;
        padding: 5px 0;
        transition: color 0.3s, transform 0.3s;
    }

    nav a:hover {
        color: #ffeb3b;
        transform: scale(1.2);
    }

    main {
        flex: 1;
        padding: 210px 20px 20px 20px;
        background-color: #f4f4f4;
        max-width: 1200px;
        margin: auto;
    }
    /* CSS cho form sắp xếp theo giá */
    form {
        margin-bottom: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
    }

    label {
        font-size: 18px;
        font-weight: bold;
        color: #2980b9;
    }

    select {
        padding: 10px;
        border-radius: 5px;
        border: 2px solid #2980b9;
        background-color: #fff;
        color: #2980b9;
        font-size: 16px;
        outline: none;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    select:focus {
        border-color: #66bb6a;
        box-shadow: 0 0 5px rgba(102, 187, 106, 0.5);
    }

    option {
        background-color: #fff;
        color: #2980b9;
    }

    select:hover {
        cursor: pointer;
    }


    .product-group {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
    }

    .product {
        background-color: #fff;
        border-radius: 5px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
        text-align: center;
        transition: transform 0.3s;
    }

    .product:hover {
        transform: translateY(-5px);
    }
    .product img {
        max-width: 100%; /* Đảm bảo hình ảnh không vượt quá chiều rộng của khối */
        height: 150px; /* Thiết lập chiều cao cố định cho tất cả hình ảnh */
        object-fit: cover; /* Cắt hình ảnh để giữ tỷ lệ mà không bị biến dạng */
        border-radius: 5px; /* Bo tròn các góc của hình ảnh */
    }

    .pagination a {
        margin: 0 5px;
        text-decoration: none;
        padding: 5px 10px;
        background-color: #388e3c;
        color: #fff;
        border-radius: 3px;
        transition: background-color 0.3s;
    }

    .pagination a:hover {
        background-color: #66bb6a;
    }

    .pagination span {
        margin: 0 5px;
        padding: 5px 10px;
        background-color: #66bb6a;
        color: #fff;
        border-radius: 3px;
        font-weight: bold;
    }

    button{

        background-color: #2980b9;
        color: #fff;
    }

    footer {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: #fff;
        text-align: center;
        padding: 20px;
    }
</style>
