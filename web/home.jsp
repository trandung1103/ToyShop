<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Product, model.Category, model.CartItem" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="dal.UserDAO, dal.ProductDAO, dal.CategoryDAO, dal.CartDAO" %>
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
            CategoryDAO categoryDAO = new CategoryDAO();
            List<CartItem> cartItems=new ArrayList<>();
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
                    <%CartDAO cartDAO = new CartDAO();
                    cartItems = cartDAO.getCart(user);%> 
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

        <nav>
            <ul>
                <li><a href="javascript:void(0);" onclick="scrollToElement('bestseller')">Sản phẩm bán chạy</a></li>
                <li><a href="javascript:void(0);" onclick="scrollToElement('newproduct')">Sản phẩm mới</a></li>

                <%
                    List<Category> cate = categoryDAO.getAll(); 
                %>

                <select onchange="scrollToElement(this.value);">
                    <option value="" disabled selected>Chọn danh mục</option>
                    <%
                        if (cate != null && !cate.isEmpty()) {
                            for (Category cg : cate) {
                    %>              
                    <option value="<%= cg.getName() %>"><%= cg.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </ul>
        </nav>




        <main>

            <div style="margin-top: 160px;"></div>

            <div class="category-box" id="bestseller">
                <br>
                <h2>Sản phẩm bán chạy</h2>
                <div  class="product-group">

                    <br>
                    <%                
                        List<Product> bestsold = productDAO.getBestSold(); 
                        if (bestsold != null && !bestsold.isEmpty()) {
                            for (Product product : bestsold) {
                    %>
                    <div class="product">
                        <h3><%= product.getProduct_name() %></h3>
                        <img class="product-image" src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" />                
                        <p>Giá: $<%= product.getProduct_price() %></p>
                        <p><%= product.getProduct_description() %></p>
                        <% if (product.getProduct_quantity() > 0) { %>
                        <p>Số lượng có sẵn: <%= product.getProduct_quantity() %></p>
                        <% } else { %>
                        <p style="color:red;">Hết hàng!!!</p>
                        <% } %>

                        <form action="CartServlet" method="post">
                            <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                            <%
                                if (cartItems != null && !cartItems.isEmpty() && user !=null){
                                for (CartItem item : cartItems) {
                                        if (product.getProduct_id() == item.getProduct().getProduct_id() ) {
                                
                            %>
                            <input type="number" name="quantity" value="1" min="0" max="<%= product.getProduct_quantity()-item.getProduct().getProduct_quantity() %>">
                            <%
                                        }
                                    }       
                                }
                                else{%>
                            <input type="number" name="quantity" value="1" min="0" max="<%= product.getProduct_quantity()%>">
                            <%}    
                            %>
                            <% if (user == null) { %>
                            <a style="color: #2980b9;" href="login.jsp">Thêm vào giỏ</a>
                            <% } else { if (product.getProduct_quantity() > 0) { %>
                            <a style="text-decoration: none" style="color: #2980b9;" href="productDetail.jsp?productId=<%= product.getProduct_id() %>">
                                <button type="button">
                                    <i class="fa-solid fa-eye"></i> Chi tiết
                                </button>
                            </a>
                            <button type="submit" name="action" value="add">
                                <i class="fa-solid fa-shopping-cart"></i>
                            </button>
                            <% } if ("admin".equals(user.getRole())) { %>
                            <a  href="admin_product.jsp?productId=<%= product.getProduct_id() %>">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                            <% } } %>
                        </form>

                    </div>
                    <% 
                            } 
                        }  %>
                </div>
                <br>
            </div>

            <div class="category-box" id="newproduct">
                <br>
                <h2>Sản phẩm mới nhất</h2>
                <div  class="product-group">

                    <br>
                    <%                
                        List<Product> newProducts = productDAO.getLastThreeProducts(); 
                        if (newProducts != null && !newProducts.isEmpty()) {
                            for (Product product : newProducts) {
                    %>
                    <div class="product">
                        <h3><%= product.getProduct_name() %></h3>
                        <img class="product-image" src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" />                
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
                            <a style="color: #2980b9;" href="login.jsp">Thêm vào giỏ</a>
                            <% } else { if (product.getProduct_quantity() > 0) { %>
                            <a style="color: #2980b9;" style="text-decoration: none" href="productDetail.jsp?productId=<%= product.getProduct_id() %>">
                                <button type="button">
                                    <i class="fa-solid fa-eye"></i> Chi tiết
                                </button>
                            </a>
                            <button type="submit" name="action" value="add">
                                <i class="fa-solid fa-shopping-cart"></i>
                            </button>
                            <% } if ("admin".equals(user.getRole())) { %>
                            <a  href="admin_product.jsp?productId=<%= product.getProduct_id() %>">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                            <% } } %>
                        </form>

                    </div>
                    <% 
                            } 
                        } else { 
                    %>
                    <p>Không có sản phẩm mới nào.</p>
                    <% } %>
                </div>
                <br>
            </div>


            <% for (Category cg : cate) { 
                List<Product> categoryProducts = productDAO.getProductsByCategory(cg.getName()); 
                if (categoryProducts != null && !categoryProducts.isEmpty()) {
            %>
            <div class="category-box" id="<%= cg.getName() %>">
                <br>
                <h3 ><%= cg.getName() %></h3>

                <div class="product-group">
                    <% 
                        int count = 0; 
                        for (Product product : categoryProducts) {
                            if (count < 3) { 
                    %>
                    <div class="product">
                        <h4><%= product.getProduct_name() %></h4>
                        <img class="product-image" src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" />
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
                            <a style="color: #2980b9;" href="login.jsp">Thêm vào giỏ</a>
                            <% } else { if (product.getProduct_quantity() > 0) { %>
                            <button type="submit" name="action" value="add">
                                <i class="fa-solid fa-shopping-cart"></i>
                            </button>
                            <a style="color: #2980b9;" style="text-decoration: none" href="productDetail.jsp?productId=<%= product.getProduct_id() %>">
                                <button type="button">
                                    <i class="fa-solid fa-eye"></i> Chi tiết
                                </button>
                            </a>
                            <% } if ("admin".equals(user.getRole())) { %>
                            <a href="admin_product.jsp?productId=<%= product.getProduct_id() %>">
                                <i class="fa-solid fa-pen-to-square"></i>
                            </a>
                            <% } } %>
                        </form>
                    </div>
                    <%
                            count++;
                            }
                        }
                    %>

                </div>
                <a href="allProducts.jsp?categoryName=<%= cg.getName() %>">Xem tất cả</a>
            </div>
            <% 
                } 
            } 
            %>
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

    nav {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        position: fixed;
        top: 60px; /* Đặt theo chiều cao của header */
        width: 100%;
        z-index: 999;
    }

    nav ul {
        list-style: none;
        padding: 10px 20px;
        margin-left: 30%;
        display: flex;
        flex-wrap: wrap;
    }

    nav li {
        margin-top: 2%;
        margin-right: 15px;
    }

    nav a {
        color: white;
        text-decoration: none;
        padding: 5px 10px;
        transition: background-color 0.3s;
    }

    nav a:hover {
        background-color: #2980b9;
    }
    select {
        padding: 8px;
        background-color: #fff;
        border: 1px solid #2980b9;
        border-radius: 5px;
        font-size: 16px;
        color: #2980b9;
        cursor: pointer;
        transition: background-color 0.3s, color 0.3s;
        width: 200px; /* Điều chỉnh kích thước của hộp chọn */
        margin: 10px 0; /* Khoảng cách trên dưới */
    }

    select:hover {
        background-color: #2980b9;
        color: white;
    }

    select:focus {
        outline: none;
        border-color: #66bb6a;
    }

    option {
        background-color: white; /* Màu nền của các tùy chọn */
        color: #2980b9; /* Màu chữ của các tùy chọn */
        padding: 8px; /* Padding cho mỗi tùy chọn */
    }

    option:hover {
        background-color: #2980b9;
        color: white;
    }


    main {
        padding: 20px;
        flex: 1;
    }

    .product-group {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin: 10px;
        background: linear-gradient(90deg, #2980b9, #66bb6a);
    }

    .product {
        background-color: #fff;
        border-radius: 5px;
        padding: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        flex: 1 1 calc(20% - 20px);
    }
    .product img {
        max-width: 100%; /* Đảm bảo hình ảnh không vượt quá chiều rộng của khối */
        height: 150px; /* Thiết lập chiều cao cố định cho tất cả hình ảnh */
        object-fit: cover; /* Cắt hình ảnh để giữ tỷ lệ mà không bị biến dạng */
        border-radius: 5px; /* Bo tròn các góc của hình ảnh */
    }


    .category-box {
        text-align: center;
        margin-top: 40px;
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        border-radius: 10px;
    }

    a{
        margin: 10px;
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

    .product button {
        background-color: #2980b9; /* Màu nền của nút */
        border: none; /* Không có viền */
        color: white; /* Màu chữ */
        padding: 10px; /* Padding cho nút */
        border-radius: 5px; /* Bo tròn các góc */
        cursor: pointer; /* Hiển thị con trỏ như một nút bấm */
        transition: background-color 0.3s, transform 0.3s; /* Hiệu ứng chuyển động */
    }

    .product button:hover {
        background-color: #66bb6a; /* Màu khi hover */
        transform: scale(1.05); /* Tăng kích thước khi hover */
    }

    a{
        text-decoration: none;
        color: white;
    }



    footer {
        background: linear-gradient(90deg, #2980b9, #66bb6a);
        color: #fff;
        text-align: center;
        padding: 15px 0;
    }
</style>
<script>
    function scrollToElement(id) {
        var element = document.getElementById(id);
        if (element) {
            var offset = 190;
            var elementPosition = element.getBoundingClientRect().top;
            var offsetPosition = elementPosition + window.pageYOffset - offset;

            window.scrollTo({
                top: offsetPosition,
                behavior: "smooth"
            });
        }
    }
</script>