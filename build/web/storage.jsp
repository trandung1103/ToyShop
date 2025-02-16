<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="model.Category" %>
<%@ page import="model.Product" %>

<%
    int pageSize = 5; // Số sản phẩm trên mỗi trang
    int page1 = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1; // Trang hiện tại
    CategoryDAO categoryDAO = new CategoryDAO();
    ProductDAO productDAO = new ProductDAO();
    List<Category> categories = categoryDAO.getAll();
    List<Product> products = productDAO.getProductsByPage(page1, pageSize); // Lấy sản phẩm theo trang
    int count = productDAO.getTotalCount();
    int totalPages = productDAO.getTotalPage(pageSize); // Tổng số trang
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Categories and Products</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <div class="button-back">
            <a href="home.jsp"><button type="submit">Quay về trang chủ</button></a>
            <a href="admin.jsp"><button type="submit">Quay về trang admin</button></a>
        </div>

        <h1>Danh mục</h1>

        <!-- Add Category Form -->
        <h2>Thêm danh mục</h2>
        <form action="storage" method="post">
            <input type="hidden" name="action" value="addCategory">
            <input type="text" name="category_name" required placeholder="Category Name">
            <button type="submit">Thêm danh mục</button>
        </form>

        <h2>Categories</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>Tên danh mục</th>
                    <th>Số lượng sản phẩm trong danh mục</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Category category : categories) {
                        int count1 = categoryDAO.getTotalCountByCategory(category.getName());
                %>
                <tr>
                    <td><%= category.getName() %></td>
                    <td><%= count1 %></td>
                    <td>
                        <form action="storage" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="deleteCategory">
                            <input type="hidden" name="categoryId" value="<%= category.getId() %>">
                            <button type="submit">Delete</button>
                        </form>
                        <a href="allProducts.jsp?categoryName=<%=category.getName()%>&page=1">
                            <button type="button">View Products</button>
                        </a>
                        <br>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <h1>Sản phẩm</h1>

        <table border="1">
            <thead>
                <tr>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Sold</th>
                    <th>Category</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <h1>Có tất cả <%=count%> sản phẩm</h1><a href="add_product.jsp"><button type="submit">Thêm sản phẩm</button></a>
            <br><br>
            <form action="search.jsp" method="get" class="search-form" >
                <input type="text" name="query" placeholder="Tìm kiếm sản phẩm..." required>
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <%
                for (Product product : products) {
            %>
            <tr>
                <td><%= product.getProduct_name() %></td>
                <td><%= product.getProduct_price() %></td>
                <td><%= product.getProduct_quantity() %></td>
                <td><%= product.getSold_quantity() %></td>
                <%
                    Product pr=productDAO.getProductBycatgeoryId(product.getCategoryID());
                %>
                <td><%= pr.getCategoryID()  %></td>
                <td><img src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" style="width: 100px; height: auto;"></td>
                <td>
                    <form action="storage" method="get" style="display:inline;">
                        <input type="hidden" name="action" value="updateProduct">
                        <input type="hidden" name="product_id" value="<%= product.getProduct_id() %>">
                        <button type="submit">Edit</button>
                    </form>
                    <form action="storage" method="post" style="display:inline;">
                        <input type="hidden" name="action" value="deleteProduct">
                        <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                        <button type="submit">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>

    <!-- Phân trang -->
    <div class="pagination">
        <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="storage.jsp?page=<%= i %>"><%= i %></a>
        <% } %>
    </div>
</body>
</html>


<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4; /* Màu nền nhẹ */
        color: #333; /* Màu chữ chính */
    }

    h1, h2 {
        color: #007BFF; /* Màu xanh biển cho tiêu đề */
    }

    table {
        width: 100%;
        border-collapse: collapse; /* Gộp các đường viền */
        margin: 20px 0; /* Khoảng cách phía trên và dưới */
    }

    th, td {
        padding: 10px; /* Khoảng cách bên trong ô */
        text-align: left; /* Căn trái cho văn bản */
        border: 1px solid #ddd; /* Đường viền nhạt */
    }

    th {
        background-color: #007BFF; /* Màu nền cho tiêu đề bảng */
        color: white; /* Màu chữ trắng */
    }

    tr:nth-child(even) {
        background-color: #f2f2f2; /* Màu nền cho các hàng chẵn */
    }

    tr:hover {
        background-color: #e1e1e1; /* Màu nền khi di chuột qua hàng */
    }

    button {
        background-color: #007BFF; /* Màu nền cho nút */
        color: white; /* Màu chữ trắng */
        border: none; /* Không có đường viền */
        padding: 8px 12px; /* Khoảng cách bên trong nút */
        cursor: pointer; /* Con trỏ chuột khi di chuột qua */
    }

    button:hover {
        background-color: #0056b3; /* Màu nền khi di chuột qua nút */
    }

    form {
        display: inline; /* Hiển thị form ở cùng một dòng */
    }

    input[type="text"] {
        padding: 8px; /* Khoảng cách bên trong ô nhập liệu */
        margin-right: 5px; /* Khoảng cách bên phải */
        border: 1px solid #ccc; /* Đường viền nhạt */
        border-radius: 4px; /* Bo góc */
    }

    .pagination {
        display: flex; /* Sử dụng flexbox để căn chỉnh các phần tử */
        justify-content: center; /* Căn giữa các phần tử */
        margin: 20px 0; /* Khoảng cách phía trên và dưới */
    }

    .pagination a {
        display: block; /* Đảm bảo mỗi liên kết chiếm không gian riêng */
        padding: 10px 15px; /* Khoảng cách bên trong liên kết */
        margin: 0 5px; /* Khoảng cách giữa các liên kết */
        text-decoration: none; /* Xóa gạch chân */
        color: white; /* Màu chữ trắng */
        background-color: #007BFF; /* Màu nền cho liên kết */
        border-radius: 5px; /* Bo góc */
        transition: background-color 0.3s; /* Hiệu ứng chuyển màu nền khi di chuột */
    }

    .pagination a:hover {
        background-color: #0056b3; /* Màu nền khi di chuột qua liên kết */
    }

    .pagination a.active {
        background-color: #0056b3; /* Màu nền cho liên kết đang hoạt động */
        cursor: default; /* Hiển thị con trỏ mặc định */
    }

    .button-back{

        display: flex;
        gap: 10px;
    }

</style>