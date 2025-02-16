<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User, model.Orders" %>
<%@ page import="java.util.List" %>
<%@ page import="dal.OrderDAO" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đơn hàng - Toyo</title>
        <link rel="stylesheet" href="css/order.css?v=1.0">
    </head>
    <body>
        <div class="content-wrapper">
            <header>
                <h1>Danh sách đơn hàng của bạn</h1>
            </header>
            <main>
                <%
                User user = (User) session.getAttribute("user");
                OrderDAO orderDAO = new OrderDAO();
                List<Orders> orders = orderDAO.getOrdersByUser(user);

                if (user != null) {
                    if (orders != null && !orders.isEmpty()) {
                %>
                <table>
                    <thead>
                        <tr>
                            <th>ID Đơn hàng</th>
                            <th>Tổng giá (VND)</th>
                            <th>Tên người mua</th>
                            <th>Ngày đặt</th>
                            <th>Chi tiết</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        for (Orders order : orders) {
                        %>
                        <tr>
                            <td><%= order.getOrderId() %></td>
                            <td><%= order.getTotalPrice() %></td>
                            <td><%= order.getBuyerName() %></td>
                            <td><%= order.getOrderDate() %></td>
                            <td>
                                <form action="order_detail.jsp" method="get">
                                    <input type="hidden" name="orderId" value="<%= order.getOrderId() %>">
                                    <button type="submit">Xem chi tiết</button>
                                </form>
                            </td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
                <%
                    } else {
                %>
                <p>Bạn chưa có đơn hàng nào.</p>
                <%
                    }
                } else {
                %>
                <p>Vui lòng <a href="login.jsp">đăng nhập</a> để xem đơn hàng.</p>
                <%
                }
                %>
                <a href="home.jsp" class="btn-back">Quay lại cửa hàng</a>
            </main>
        </div>
        <footer>
            <p>&copy; 2024 Toyo. All rights reserved.</p>
        </footer>
    </body>
</html>
