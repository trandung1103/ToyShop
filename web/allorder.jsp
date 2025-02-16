<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Orders, dal.OrderDAO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách Đơn hàng</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f4f4f4;
            }
            header {
                background: linear-gradient(90deg, #2980b9, #66bb6a);
                color: #fff;
                padding: 15px 0;
                text-align: center;
            }
            table {
                width: 80%;
                margin: 20px auto;
                border-collapse: collapse;
                background-color: #fff;
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
            th, td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: center;
            }
            th {
                background-color: #2980b9;
                color: white;
            }
        </style>
    </head>
    <body>
        <header>
            <h1>Danh sách Đơn hàng</h1>
        </header>
        <main>

            <%
                OrderDAO orderDAO = new OrderDAO();
                List<Orders> orders = orderDAO.getAllOrders();
            %>*

            <table>
                <thead>
                    <tr>
                        <th>Mã đơn hàng</th>
                        <th>Tên người dùng</th>
                        <th>Tổng tiền</th>
                        <th>Tên người mua</th>
                        <th>Số điện thoại người mua</th>
                        <th>Địa chỉ người mua</th>
                        <th>Thời gian mua</th>
                        <th>Chi tiết</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Orders order : orders) {
                    %>
                    <tr>
                        <td><%= order.getOrderId() %></td>
                        <td><%= order.getUserName() %></td>
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
                <th colspan="8"><a href="admin.jsp" class="btn-detail">Quay về trang quản trị</a></th>
            </table>

        </main>
    </body>
</html>
