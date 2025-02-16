package controller;

import dal.CartDAO;
import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;
import model.Product;
import model.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class CartServlet extends HttpServlet {

    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO(); // Khởi tạo CartDAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            switch (action) {
                case "add":
                    addToCart(request, user, response);
                    break;
                case "update":
                    updateCartItem(request, user);
                    break;
                case "remove":
                    removeFromCart(request, user);
                    break;
                case "checkout":
                    checkout(user, session);
                    response.sendRedirect("checkout.jsp");
                    return;
                default:
                    throw new RuntimeException("Hành động không hợp lệ.");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra trong quá trình xử lý.");
            return;
        }

        response.sendRedirect("cart.jsp");
    }

    private void addToCart(HttpServletRequest request, User user, HttpServletResponse response) throws SQLException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        // Kiểm tra số lượng
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);

        if (product == null) {
            throw new RuntimeException("Sản phẩm không tồn tại.");
        }

        if (quantity > product.getProduct_quantity()) {
            throw new RuntimeException("Số lượng yêu cầu vượt quá số lượng có sẵn.");
        }

        // Thêm sản phẩm vào giỏ hàng
        cartDAO.addToCart(user, new CartItem(product, quantity));

//        // Giảm số lượng sản phẩm trong kho
        product.setProduct_quantity(product.getProduct_quantity() - quantity);
        productDAO.updateProductQuantity(product); // Cập nhật số lượng trong cơ sở dữ liệu
    }

    private void updateCartItem(HttpServletRequest request, User user) throws SQLException {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int newQuantity = Integer.parseInt(request.getParameter("quantity"));

        // Lấy thông tin sản phẩm từ giỏ hàng
        CartItem currentItem = cartDAO.getCartItem(user, productId); // Lấy CartItem hiện tại từ giỏ hàng

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            throw new RuntimeException("Sản phẩm không tồn tại.");
        }
        int quantityDifference = newQuantity - currentItem.getQuantity();

        cartDAO.updateCartItemQuantity(user, product, newQuantity);
//
        product.setProduct_quantity(product.getProduct_quantity() - quantityDifference);
        productDAO.updateProductQuantity(product);
    }

    private void removeFromCart(HttpServletRequest request, User user) throws SQLException {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);

        if (product != null) {
//            product.setProduct_quantity(product.getProduct_quantity() + quantity);
//            productDAO.updateProductQuantity(product);
            cartDAO.removeFromCart(user, product);
        } else {
            throw new RuntimeException("Sản phẩm không tồn tại trong kho.");
        }
    }

    private void checkout(User user, HttpSession session) throws SQLException {
        List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cart");
//        cartDAO.checkout(user);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            try {
                List<CartItem> cartItems = cartDAO.getCart(user);
                request.setAttribute("cartItems", cartItems);
                request.getRequestDispatcher("cart.jsp").forward(request, response);
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Có lỗi xảy ra. Vui lòng thử lại.");
                request.getRequestDispatcher("error.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
