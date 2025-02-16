<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.Product" %>
<%@ page import="model.Category" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page import="java.util.List" %>

<%
    Product product = (Product) request.getAttribute("product");
    CategoryDAO cate=new CategoryDAO();
    List<Category> cg=cate.getAll();
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Edit Product</title>
        <link rel="stylesheet" type="text/css" href="styles.css"> <!-- Liên kết đến file CSS -->
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                color: #333;
                margin: 0;
                padding: 20px;
            }

            h1 {
                color: #007BFF;
                text-align: center;
            }

            .form-container {
                max-width: 600px;
                margin: 0 auto;
                background-color: white;
                padding: 20px;
                border-radius: 5px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            label {
                display: block;
                margin: 10px 0 5px;
            }

            input[type="text"],
            input[type="number"],
            input[type="file"],
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box; /* Đảm bảo padding không làm tăng chiều rộng tổng */
            }

            button {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 10px 15px;
                cursor: pointer;
                border-radius: 4px;
                width: 100%;
                font-size: 16px; /* Tăng kích thước font cho nút */
            }

            button:hover {
                background-color: #0056b3;
            }

            /* Thêm khoảng cách giữa các trường */
            input[type="text"],
            input[type="number"],
            select {
                margin-bottom: 20px; /* Thay đổi khoảng cách giữa các trường */
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h1>Edit Product</h1>
            <form action="storage" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updateProduct">
                <input type="hidden" name="product_id" value="<%= product.getProduct_id() %>">

                <label for="productName">Product Name:</label>
                <input type="text" name="product_name" value="<%= product.getProduct_name() %>" required>

                <label for="productPrice">Price:</label>
                <input type="number" name="product_price" value="<%= product.getProduct_price() %>" required>

                <label for="productQuantity">Quantity:</label>
                <input type="number" name="product_quantity" value="<%= product.getProduct_quantity() %>" required>

                <label for="productDes">Description:</label>
                <input type="text" name="description" value="<%= product.getProduct_description() %>" required>

                <label for="productCategory">Category:</label>
                <select name="categoryID" id="id" required>
                    <option value="null">Chọn danh mục</option>
                    <%
                        for(Category ctg : cg) {
                    %>
                    <option value="<%= ctg.getId() %>"><%= ctg.getName() %></option>
                    <% } %>
                </select>

                <label for="productImage">Image URL:</label>
                <input type="file" name="imageFile" accept="image/*" required>

                <button type="submit">Update Product</button>
            </form>
        </div>
    </body>
</html>
