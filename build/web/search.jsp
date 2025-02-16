<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="model.Product" %>

<%
    String query = request.getParameter("query");
    ProductDAO productDAO = new ProductDAO();
    List<Product> products = productDAO.searchProducts(query);
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Kết quả tìm kiếm</title>
        <link rel="stylesheet" type="text/css" href="styles.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f4f4;
                color: #333;
                padding: 20px;
            }

            h1 {
                color: #007BFF;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
                background-color: white;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            th, td {
                padding: 10px;
                text-align: left;
                border: 1px solid #ddd;
            }

            th {
                background-color: #007BFF;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #e1e1e1;
            }

            button {
                background-color: #007BFF;
                color: white;
                border: none;
                padding: 8px 12px;
                cursor: pointer;
                margin-top: 20px;
            }

            button:hover {
                background-color: #0056b3;
            }

            .back-button {
                margin: 20px 0;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <h1>Kết quả tìm kiếm cho: <%= query %></h1>



        <table>
            <thead>
                <tr>
                    <th>Tên sản phẩm</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Đã bán</th>
                    <th>Danh mục</th>
                    <th>Hình ảnh</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (products.isEmpty()) {
                %>
                <tr>
                    <td colspan="6">Không tìm thấy sản phẩm nào.</td>
                </tr>
                <%
                    } else {
                        for (Product product : products) {
                %>
                <tr>
                    <td><%= product.getProduct_name() %></td>
                    <td><%= product.getProduct_price() %></td>
                    <td><%= product.getProduct_quantity() %></td>
                    <td><%= product.getSold_quantity() %></td>
                    <td><%= product.getCategoryID() %></td>
                    <td><img src="<%= product.getImage_url() %>" alt="<%= product.getProduct_name() %>" style="width: 100px; height: auto;"></td>
                    <td>
                        <form action="storage" method="get" style="display:inline;">
                            <input type="hidden" name="action" value="updateProduct">
                            <input type="hidden" name="product_id" value="<%= product.getProduct_id() %>">
                            <button type="submit">Sửa</button>
                        </form>
                        <form action="storage" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="deleteProduct">
                            <input type="hidden" name="productId" value="<%= product.getProduct_id() %>">
                            <button type="submit">Xóa</button>
                        </form>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
        <div class="back-button">
            <a href="storage.jsp">
                <button>Quay về kho</button>
            </a>
        </div>
    </body>
</html>
