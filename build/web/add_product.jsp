<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dal.CategoryDAO" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="model.Category" %>
<%@ page import="model.Product" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Add Product</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                color: #333;
                margin: 0;
                padding: 0;
            }

            header {
                text-align: center;
                margin: 20px 0;
                background-color: #3498db;
                color: white;
                padding: 20px 0;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            }

            main {
                display: flex;
                justify-content: center;
                align-items: center;
                height: calc(100vh - 120px);
            }

            .container {
                width: 100%;
                max-width: 600px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                padding: 20px;
            }

            .form-group {
                display: flex;
                justify-content: space-between;
                margin-bottom: 15px;
            }

            label {
                flex: 1;
                margin-right: 10px;
                text-align: right;
            }

            input[type="text"],
            input[type="number"],
            textarea {
                flex: 2;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 4px;
                transition: border-color 0.3s;
                width: 100%;
            }

            input[type="text"]:focus,
            input[type="number"]:focus,
            textarea:focus {
                border-color: #3498db;
                outline: none;
            }

            button {
                background-color: #e67e22;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
                width: 100%;
            }

            button:hover {
                background-color: #d35400;
            }

            footer {
                text-align: center;
                margin-top: 20px;
                background-color: #3498db;
                color: white;
                padding: 10px 0;
            }

            .back-home {
                margin-top: 15px;
                text-align: center;
            }

        </style>
    </head>
    <body>
        <header>
            <h1>Add New Product</h1>
        </header>

        <main>
            <%
                CategoryDAO categoryDAO=new CategoryDAO();
                List<Category> categories = categoryDAO.getAll();
            %>

            <div class="container">
                <form action="AddProduct" method="post" enctype="multipart/form-data" style="display:inline;">
                    <h1 style="text-align: center;">Thêm sản phẩm mới</h1>
                    <input type="hidden" name="action" value="addProduct">
                    <input type="text" name="product_name" required placeholder="Product Name"><br><br>
                    <input type="number" name="product_price" required placeholder="Price"><br><br>
                    <input type="number" name="product_quantity" required placeholder="Quantity"><br><br>
                    <input type="text" name="description" required placeholder="Description"><br>
                    <br>
                    <select name="categoryId" id="id">
                        <%
                            for(Category cg : categories) {
                        %>
                        <option value="<%= cg.getId() %>"><%= cg.getName() %></option>
                        <% } %>
                    </select>

                    <br><br>
                    <input type="file" name="imageFile" accept="image/*" required>
                    <br><br>
                    <button type="submit">Add Product</button>
                </form>
                <div class="back-home">
                    <a href="home.jsp" style="text-decoration: none; color: white;">
                        <button>Back Home</button>
                    </a>
                </div>
            </div>
        </main>

        <footer>
            <p>&copy; 2024 Toyo. All rights reserved.</p>
        </footer>
    </body>
</html>
