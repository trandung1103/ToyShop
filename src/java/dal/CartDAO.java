package dal;

import model.CartItem;
import model.User;
import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Cart;

public class CartDAO {

    private Connection connection;

    public CartDAO() {
        DBContext dbContext = new DBContext();
        this.connection = dbContext.connection;
    }

    public void addToCart(User user, CartItem item) throws SQLException {
        if (item.getProduct() == null) {
            throw new IllegalArgumentException("Sản phẩm không hợp lệ.");
        }

        String checkSql = "SELECT quantity FROM CartItem WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?) AND product_id = ?";
        try (PreparedStatement checkStatement = connection.prepareStatement(checkSql)) {
            checkStatement.setInt(1, user.getId());
            checkStatement.setInt(2, item.getProduct().getProduct_id());
            ResultSet checkResultSet = checkStatement.executeQuery();

            if (checkResultSet.next()) {
                // Nếu đã có sản phẩm, cập nhật số lượng
                int currentQuantity = checkResultSet.getInt("quantity");
                updateCartItemQuantity(user, item.getProduct(), currentQuantity + item.getQuantity());
            } else {
                // Nếu chưa có, thêm mới vào giỏ hàng
                String insertSql = "INSERT INTO CartItem (cart_id, product_id, quantity) VALUES ((SELECT cart_id FROM Cart WHERE user_id = ?), ?, ?)";
                try (PreparedStatement insertStatement = connection.prepareStatement(insertSql)) {
                    insertStatement.setInt(1, user.getId());
                    insertStatement.setInt(2, item.getProduct().getProduct_id());
                    insertStatement.setInt(3, item.getQuantity());
                    insertStatement.executeUpdate();
                }
            }
        }
    }

    public void updateCartItemQuantity(User user, Product product, int quantity) throws SQLException {
        String sql = "UPDATE CartItem SET quantity = ? WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?) AND product_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, quantity);
            statement.setInt(2, user.getId());
            statement.setInt(3, product.getProduct_id());
            statement.executeUpdate();
        }
    }

    public List<CartItem> getCart(User user) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = "SELECT ci.product_id, ci.quantity, p.product_name, p.product_price, p.product_quantity, p.product_description, p.category_id, p.image_url "
                + "FROM CartItem ci JOIN Product p ON ci.product_id = p.product_id "
                + "JOIN Cart c ON ci.cart_id = c.cart_id "
                + "WHERE c.user_id = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, user.getId());
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Product product = new Product(
                        resultSet.getInt("product_id"),
                        resultSet.getString("product_name"),
                        resultSet.getDouble("product_price"),
                        resultSet.getInt("product_quantity"),
                        resultSet.getString("product_description"),
                        resultSet.getString("category_id"), // Sửa lại thành category_id
                        resultSet.getString("image_url")
                );

                int quantity = resultSet.getInt("quantity");
                cartItems.add(new CartItem(product, quantity));
            }
        }
        return cartItems;
    }

    // Xóa sản phẩm khỏi giỏ hàng
    public void removeFromCart(User user, Product product) throws SQLException {
        String sql = "DELETE FROM CartItem WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?) AND product_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, user.getId());
            pstmt.setInt(2, product.getProduct_id());
            pstmt.executeUpdate();
        }
    }

    // Thanh toán
    public void checkout(User user) throws SQLException {
        String sql = "DELETE FROM CartItem WHERE cart_id = (SELECT cart_id FROM Cart WHERE user_id = ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, user.getId());
            statement.executeUpdate();



            
        }
    }
    

    public void clearCart(User user) throws SQLException {
        String sql = "DELETE FROM CartItem WHERE cart_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, user.getId());
            statement.executeUpdate();
        }
    }

    public CartItem getCartItem(User user, int productId) throws SQLException {
        CartItem cartItem = null;
        String sql = "SELECT ci.quantity FROM CartItem ci JOIN Cart c ON ci.cart_id = c.cart_id WHERE c.user_id = ? AND ci.product_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, user.getId());
            pstmt.setInt(2, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int quantity = rs.getInt("quantity");
                    ProductDAO productDAO = new ProductDAO();
                    Product product = productDAO.getProductById(productId);
                    cartItem = new CartItem(product, quantity);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartItem;
    }
    
    

    public static void main(String[] args) {
        try {
            // Khởi tạo DAO cho người dùng và sản phẩm
            UserDAO userDAO = new UserDAO();
            ProductDAO productDAO = new ProductDAO();
            CartDAO dao = new CartDAO();

            // Lấy người dùng từ cơ sở dữ liệu
            User user = userDAO.getUserById(1); // Giả sử ID người dùng là 1

            // Lấy sản phẩm từ cơ sở dữ liệu
            Product product1 = productDAO.getProductById(1); // Giả sử ID sản phẩm A là 1

            // Kiểm tra xem sản phẩm có tồn tại không
            if (product1 == null) {
                throw new RuntimeException("Sản phẩm không tồn tại.");
            }

            // Thêm sản phẩm vào giỏ hàng
            dao.addToCart(user, new CartItem(product1, 2)); // Thêm 2 sản phẩm vào giỏ hàng

            // Kiểm tra toàn bộ giỏ hàng của người dùng
            List<CartItem> cartItems = dao.getCart(user);
            System.out.println("Giỏ hàng của người dùng: " + user.getDisplayName());
            double totalPrice = 0.0; // Tổng giá
            for (CartItem item : cartItems) {
                System.out.printf("%s - Số lượng: %d - Giá: %.2f\n", item.getProduct().getProduct_name(), item.getQuantity(), item.getProduct().getProduct_price());
                totalPrice += item.getProduct().getProduct_price() * item.getQuantity(); // Tính tổng giá
            }
            System.out.printf("Tổng giá: %.2f\n", totalPrice); // In tổng giá
        } catch (SQLException e) {
            System.out.println("SQL Exception: " + e.getMessage());
        }
    }
}
