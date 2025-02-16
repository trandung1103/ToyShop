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
                <h1>Giỏ hàng của bạn</h1>
            </header>
            <main>
                <%
                User user = (User) session.getAttribute("user");
                ProductDAO product = new ProductDAO();
                ArrayList<Product> products = (ArrayList<Product>) product.getAll();
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
                            for (Product pro : products) {
                                if (pro.getProduct_id() == item.getProduct().getProduct_id() && pro.getProduct_quantity()>0) {
                                    double itemTotal = item.getProduct().getProduct_price() * item.getQuantity(); // Tính tổng cho từng sản phẩm
                                    totalAmount += itemTotal;
                        %>
                        <tr>
                            <td><%= item.getProduct().getProduct_name() %></td>
                            <td><%= item.getProduct().getProduct_price() %></td>
                            <td>
                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="product_id" value="<%= item.getProduct().getProduct_id() %>">
                                    <input type="number" name="quantity" value="<%= item.getQuantity() %>" min="1" max="<%= pro.getProduct_quantity() + item.getQuantity() %>">
                                    <button type="submit" name="action" value="update">Cập nhật</button>
                                </form>
                            </td>
                            <td><%= itemTotal %></td>
                            <td>
                                <form action="CartServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="product_id" value="<%= item.getProduct().getProduct_id() %>">
                                    <input type="hidden" name="quantity" value="<%= item.getQuantity() %>"> <!-- Thêm trường quantity -->
                                    <button type="submit" name="action" value="remove">Xóa</button>
                                </form>
                            </td>

                        </tr>

                        <%
                                }
                            }
                        }
                        %>
                    </tbody>
                    <th colspan="5">
                        
                        Tổng giá trị hóa đơn:<%=totalAmount%>
                    </th>
                </table>
                <%
                    } else {
                %>
                <p>Giỏ hàng của bạn đang trống.</p>
                <%                    
                    }
                } else {
                %>
                <p>Vui lòng <a href="login.jsp">đăng nhập</a> để xem giỏ hàng.</p>
                <%
                }
                %>
                <div class="action-buttons">
                    <a href="home.jsp" class="btn-back">Quay lại cửa hàng</a>
                    <form action="CartServlet" method="post" style="display: inline;">
                        <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
                        <input type="hidden" name="user_id" value="<%= user.getId() %>"> 
                        <button type="submit" class="btn-checkout" name="action" value="checkout">Thanh toán</button> 
                    </form>
                </div>
            </main>
        </div>
        <footer>
            <p>&copy; 2024 Toyo. All rights reserved.</p>
        </footer>
    </body>
</html>
