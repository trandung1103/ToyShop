package controller;

import dal.CartDAO;
import dal.OrderDAO;
import dal.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import static java.lang.System.out;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Cart;
import model.CartItem;
import model.Orders;
import model.OrderItem;
import model.Product;
import model.User; // Đảm bảo rằng bạn có lớp User

public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        ProductDAO productDAO = new ProductDAO();
        double totalAmount = 0.0;
        List<CartItem> cartItems = null;

        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            try {
                cartItems = cartDAO.getCart(user);
            } catch (SQLException ex) {
                Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if ("checkout".equals(action)) {
            // Chuyển hướng đến trang checkout.jsp để người dùng xác nhận thông tin thanh toán
            RequestDispatcher dispatcher = request.getRequestDispatcher("checkout.jsp");
            dispatcher.forward(request, response);
        } else if ("confirm".equals(action)) {
            // Tiến hành thanh toán và lưu đơn hàng
            String buyerName = request.getParameter("buyerName");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");

            String totalAmountStr = request.getParameter("totalAmount");

            if (user == null) {
                request.setAttribute("errorMessage", "Bạn cần đăng nhập để thực hiện thanh toán.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
                dispatcher.forward(request, response);
                return;
            }
            if (totalAmountStr == null || totalAmountStr.isEmpty()) {
                throw new IllegalArgumentException("Giá trị tổng không được cung cấp.");
            } else {
                totalAmount = Double.parseDouble(totalAmountStr);
            }

            Orders order = new Orders();
            order.setUserId(user.getId());
            order.setTotalPrice(totalAmount);
            order.setBuyerName(buyerName);
            order.setBuyerPhone(phoneNumber);
            order.setBuyerAddress(address);

            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.saveOrder(order); 

            if (cartItems != null && !cartItems.isEmpty()) {
                for (CartItem item : cartItems) {
                    OrderItem orderItem = new OrderItem();
                    orderItem.setOrderId(orderId);
                    orderItem.setProductId(item.getProduct().getProduct_id());
                    orderItem.setQuantity(item.getQuantity());
                    orderItem.setPriceAtPurchase((float) (item.getProduct().getProduct_price() * item.getQuantity()));

                    orderDAO.saveOrderItem(orderItem);

                    orderDAO.updateSoldQuantity(item.getProduct().getProduct_id(), item.getQuantity());
                }

    
                CartDAO cartDAO = new CartDAO();
                try {
                    cartDAO.clearCart(user);
                } catch (SQLException ex) {
                    Logger.getLogger(CheckoutServlet.class.getName()).log(Level.SEVERE, null, ex);
                }

                request.setAttribute("successMessage", "Thanh toán thành công!");
                RequestDispatcher dispatcher = request.getRequestDispatcher("orderConfirmation.jsp");
                dispatcher.forward(request, response);
            }
        }
    }

}

