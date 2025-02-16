<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.OrderItem, model.Orders" %>
<%@ page import="dal.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách đơn hàng - Toyo</title>
        <link rel="stylesheet" href="css/order_detail.css?v=1.0">
    </head>
    <body>
        <div class="content-wrapper">
            <header>
                <h1>Danh sách đơn hàng</h1>
            </header>
            <main>
                <%
                User user = (User) session.getAttribute("user"); // Lấy thông tin người dùng từ session
                List<Orders> ordersList = new ArrayList<>();
                OrderDAO orderDAO = new OrderDAO();

                if (user != null) {
                    ordersList = orderDAO.getAllOrdersByUserId(user.getId()); // Lấy danh sách đơn hàng theo ID người dùng
                } else {
                %>
                <p>Vui lòng đăng nhập để xem danh sách đơn hàng.</p>
                <%
                }

                if (!ordersList.isEmpty()) {
                %>
                <table>
                    <thead>
                        <tr>
                            <th>Đơn hàng ID</th>
                            <th>Tổng giá (VND)</th>
                            <th>Tên người mua</th>
                            <th>Điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Ngày đặt</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (Orders order : ordersList) {
                        %>
                        <tr>
                            <td><%= order.getOrderId() %></td>
                            <td><%= order.getTotalPrice() %></td>
                            <td><%= order.getBuyerName() %></td>
                            <td><%= order.getBuyerPhone() %></td>
                            <td><%= order.getBuyerAddress() %></td>
                            <td><%= order.getOrderDate() %></td>
                            <td><a href="order_detail.jsp?orderId=<%= order.getOrderId() %>" class="btn-detail">Chi tiết</a></td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
                <%
                } else {
                %>
                <p>Không có đơn hàng nào.</p>
                <%
                }
                %>
                <a href="home.jsp" class="btn-back">Quay lại trang chủ</a>
            </main>
        </div>
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
        background-color: #f5f5f5;
    }

    .content-wrapper {
        width: 80%;
        margin: 0 auto;
        padding: 20px;
        background-color: white;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    header {
        text-align: center;
        margin-bottom: 20px;
    }

    h1 {
        color: #2c3e50;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }

    th, td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    th {
        background-color: #2980b9;
        color: white;
    }

    tr:hover {
        background-color: #f1f1f1;
    }

    .btn-detail {
        display: inline-block;
        padding: 8px 12px;
        background-color: #27ae60;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        transition: background-color 0.3s;
    }

    .btn-detail:hover {
        background-color: #219653;
    }

    .btn-back {
        display: inline-block;
        padding: 10px 15px;
        background-color: #e67e22;
        color: white;
        text-decoration: none;
        border-radius: 4px;
        margin-top: 20px;
        transition: background-color 0.3s;
    }

    .btn-back:hover {
        background-color: #d35400;
    }

    footer {
        text-align: center;
        margin-top: 20px;
        color: #7f8c8d;
    }

</style>