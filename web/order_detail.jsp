<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.OrderItem, model.Orders" %>
<%@ page import="dal.OrderDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết đơn hàng - Toyo</title>
        <link rel="stylesheet" href="css/order_detail.css?v=1.0">
    </head>
    <body>
        <div class="content-wrapper">
            <header>
                <h1>Chi tiết đơn hàng</h1>
            </header>
            <main>
                <%
                String orderIdStr = request.getParameter("orderId");
                Orders order = null;
                List<OrderItem> orderItems = new ArrayList<>();
                
                if (orderIdStr != null && !orderIdStr.isEmpty()) {
                    int orderId = Integer.parseInt(orderIdStr);
                    OrderDAO orderDAO = new OrderDAO();
                    order = orderDAO.getOrderById(orderId);
                    orderItems = orderDAO.getOrderItemsByOrderId(order.getOrderId()); 
                }

                if (order != null) {
                %>
                <table border="1">
                    <thead>
                        <tr>       
                            <th>Mã đơn hàng</th>
                            <th>Tên người mua</th>
                            <th>Điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Ngày đặt</th>
                            <th>Giá trị hóa đơn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>           
                            <td><p><%= order.getOrderId() %></p></td>
                            <td><p><%= order.getBuyerName() %></p></td>
                            <td><p><%= order.getBuyerPhone() %></p></td>
                            <td><p><%= order.getBuyerAddress() %></p></td>
                            <td><p><%= order.getOrderDate() %></p></td>
                            <td><p><%= order.getTotalPrice() %></p></td>
                        </tr>
                    </tbody>
                </table>

                <h1 style="text-align: center;">Các sản phẩm trong đơn hàng</h1>
                <table>
                    <thead>
                        <tr>
                            <th>Tên sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Tổng giá </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (OrderItem item : orderItems) {
                        %>
                        <tr>
                            <td><%= item.getProductName() %></td>
                            <td><%= item.getQuantity() %></td> 
                            <td><%= item.getPriceAtPurchase()%></td> 
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>

                <%
                } else {
                %>
                <p>Không tìm thấy đơn hàng.</p>
                <%
                }
                %>
                <a href="orderList.jsp" class="btn-back">Quay lại danh sách đơn hàng</a>
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
