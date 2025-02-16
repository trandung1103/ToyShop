<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.CartItem, model.Product" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page session="true" %>
<%@ page import="dal.CartDAO" %>
<%@ page import="dal.ProductDAO" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Giỏ hàng - Toyo</title>
        <link rel="stylesheet" href="css/cart.css?v=1.2">
    </head>
    <body>
        <div class="content-wrapper">
            <header>
                <h1 style="color: #f4f4f4">Thanh toán</h1>
            </header>
            <main>
                <%
                User user = (User) session.getAttribute("user");
                ProductDAO productDAO = new ProductDAO();
                ArrayList<Product> products = (ArrayList<Product>) productDAO.getAll();
                double totalAmount = 0.0;

                if (user != null) {
                    CartDAO cartDAO = new CartDAO();
                    List<CartItem> cartItems = cartDAO.getCart(user);

                    if (cartItems != null && !cartItems.isEmpty()) {
                %>
                <table>
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Giá (VND)</th>
                            <th>Số lượng</th>
                            <th>Tổng giá (VND)</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (CartItem item : cartItems) {
                            for (Product product : products) {
                                if (product.getProduct_id() == item.getProduct().getProduct_id()) {
                                    double itemTotal = item.getProduct().getProduct_price() * item.getQuantity();
                                    totalAmount += itemTotal;
                        %>
                        <tr>
                            <input type="hidden" name="productId" value="<%= item.getProduct().getProduct_id() %>" readonly style="border: none;">
                            
                            <td><input type="text" name="prdname" value="<%= item.getProduct().getProduct_name() %>" readonly style="border: none;"></td>
                            <td><%= item.getProduct().getProduct_price() %></td>
                            <td>
                                <input type="number" name="quantity" value="<%= item.getQuantity() %>" readonly style="border: none;">
                            </td>
                            <td><%= itemTotal %></td>
                        </tr>
                        <%
                                }
                            }
                        }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan="3"><strong>Tổng giá trị hóa đơn:</strong></td>
                            <td><%= totalAmount %></td>
                        </tr>
                    </tfoot>
                </table>
                <form action="CheckoutServlet" method="post">
                    <div class="form-group">
                        <label for="buyerName">Tên người mua:</label>
                        <input type="text" name="buyerName" id="buyerName" class="input-field" required>
                    </div>
                    <div class="form-group">
                        <label for="phoneNumber">Số điện thoại:</label>
                        <input type="text" name="phoneNumber" id="phoneNumber" class="input-field" required>
                    </div>
                    <div class="form-group">
                        <label for="address">Địa chỉ:</label>
                        <input type="text" name="address" id="address" class="input-field" required>
                    </div>
                    <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
                    <input type="hidden" name="user_id" value="<%= user.getId() %>">
                    <button type="submit" name="action" value="confirm">Xác nhận thanh toán</button>
                </form>

                <%
                    } else {
                %>
                <p>Giỏ hàng của bạn đang trống.</p>                
                <a href="home.jsp">Tiếp tục mua sắm</a>
                <%                    
                    }
                } else {
                %>
                <p>Vui lòng <a href="login.jsp">đăng nhập</a> để xem giỏ hàng.</p>
                <%
                }
                %>
            </main>
        </div>
        <footer>
            <p>&copy; 2024 Toyo. All rights reserved.</p>
        </footer>
    </body>
</html>


<style>
    /* Tổng thể */
    body {
        font-family: Arial, sans-serif; /* Font chữ cho toàn bộ trang */
        margin: 0; /* Xóa lề mặc định */
        padding: 0; /* Xóa padding mặc định */
        background-color: #f4f4f4; /* Màu nền của trang */
    }

    .content-wrapper {
        max-width: 800px; /* Chiều rộng tối đa của khung nội dung */
        margin: 0 auto; /* Căn giữa nội dung */
        padding: 20px; /* Padding xung quanh nội dung */
        background-color: white; /* Màu nền của khung nội dung */
        border-radius: 10px; /* Bo góc cho khung nội dung */
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* Đổ bóng cho khung nội dung */
    }

    /* Header */
    header {
        text-align: center; /* Căn giữa văn bản trong header */
        margin-bottom: 20px; /* Khoảng cách dưới header */
    }

    h1 {
        color: #2980b9; /* Màu sắc tiêu đề */
    }

    /* Bảng */
    table {
        width: 100%; /* Chiều rộng của bảng 100% */
        border-collapse: collapse; /* Gộp các đường biên */
        margin-bottom: 20px; /* Khoảng cách dưới bảng */
    }

    th, td {
        border: 1px solid #ddd; /* Đường biên cho các ô */
        padding: 12px; /* Padding cho các ô */
        text-align: left; /* Căn trái văn bản trong các ô */
    }

    th {
        background-color: #2980b9; /* Màu nền cho hàng tiêu đề */
        color: white; /* Màu chữ cho hàng tiêu đề */
    }

    /* Input */
    input[type="text"],
    input[type="number"] {
        width: 100%; /* Chiều rộng của input 100% */
        padding: 10px; /* Padding cho input */
        border: 1px solid #ddd; /* Đường biên cho input */
        border-radius: 5px; /* Bo góc cho input */
        box-sizing: border-box; /* Bao gồm padding và border vào chiều rộng */
    }

    /* Hiệu ứng khi focus vào input */
    input[type="text"]:focus,
    input[type="number"]:focus {
        border-color: #2980b9; /* Đổi màu đường biên khi focus */
        outline: none; /* Xóa viền mặc định khi focus */
        box-shadow: 0 0 5px rgba(41, 128, 185, 0.5); /* Đổ bóng khi focus */
    }

    /* Nút bấm */
    button {
        background-color: #2980b9; /* Màu nền của nút */
        color: white; /* Màu chữ của nút */
        padding: 10px 15px; /* Padding cho nút */
        border: none; /* Xóa đường biên cho nút */
        border-radius: 5px; /* Bo góc cho nút */
        cursor: pointer; /* Chỉ con trỏ khi hover */
        transition: background-color 0.3s; /* Hiệu ứng chuyển màu nền khi hover */
    }

    /* Hiệu ứng hover cho nút */
    button:hover {
        background-color: #66bb6a; /* Đổi màu nền khi hover */
    }
    
    form{
        display: flex;
        gap: 10px;
        flex-direction: column;
    }
    /* Form nhóm */
    .form-group {
        margin-bottom: 15px; /* Khoảng cách giữa các trường nhập liệu */
    }

    /* Nút bấm */
    button {
        display: inline-block; /* Hiển thị nút bấm như một khối */
        width: 100%; /* Chiều rộng nút bấm 100% */
    }


    /* Footer */
    footer {
        text-align: center; /* Căn giữa văn bản trong footer */
        padding: 10px; /* Padding cho footer */
        background-color: #2980b9; /* Màu nền của footer */
        color: white; /* Màu chữ của footer */
        position: relative; /* Đặt footer ở vị trí tương đối */
        bottom: 0; /* Đưa footer xuống dưới cùng */
        width: 100%; /* Chiều rộng footer 100% */
        margin-top: 20px; /* Khoảng cách trên footer */
    }

</style>
