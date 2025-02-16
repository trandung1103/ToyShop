package dal;

import model.OrderItem;
import model.Orders;
import model.User;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends DBContext {

    private Connection connection;

    public OrderDAO() {
        DBContext dbContext = new DBContext();
        this.connection = dbContext.connection;
    }

    public int saveOrder(Orders order) {
        int generatedId = -1;
        String sql = "INSERT INTO Orders (user_id, total_price, order_date, buyer_name, buyer_phone, buyer_address) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement pstmt = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, order.getUserId());
            pstmt.setDouble(2, order.getTotalPrice());
            LocalDateTime currentTime = LocalDateTime.now();
            pstmt.setTimestamp(3, Timestamp.valueOf(currentTime));
            pstmt.setString(4, order.getBuyerName());
            pstmt.setString(5, order.getBuyerPhone());
            pstmt.setString(6, order.getBuyerAddress());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedId = generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In thông báo lỗi ra console
        }
        return generatedId;
    }

    public void saveOrderItem(OrderItem orderItem) {
        String sql = "INSERT INTO OrderItem (order_id, product_id, quantity, price_at_purchase) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getProductId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setFloat(4, orderItem.getPriceAtPurchase());

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("OrderItem inserted successfully!");
            } else {
                System.out.println("Failed to insert OrderItem.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Orders> getOrdersByUser(User user) throws SQLException {
        List<Orders> ordersList = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, user.getId());
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getDouble("total_price"));
                order.setBuyerName(rs.getString("buyer_name"));
                order.setBuyerPhone(rs.getString("buyer_phone"));
                order.setBuyerAddress(rs.getString("buyer_address"));
                order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                ordersList.add(order);
            }
        }
        return ordersList;
    }

    // Xóa đơn hàng theo ID
    public void deleteOrder(int orderId) {
        String sql = "DELETE FROM Orders WHERE order_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Thêm vào lớp OrderDAO
    public List<Orders> getAllOrdersByUserId(int userId) throws SQLException {
        List<Orders> ordersList = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE user_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getDouble("total_price"));
                order.setBuyerName(rs.getString("buyer_name"));
                order.setBuyerPhone(rs.getString("buyer_phone"));
                order.setBuyerAddress(rs.getString("buyer_address"));
                order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
                ordersList.add(order);
            }
        }
        return ordersList;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> orderItems = new ArrayList<>();
        String sql = "SELECT oi.*, p.product_name FROM OrderItem oi JOIN Product p ON oi.product_id = p.product_id WHERE oi.order_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(rs.getInt("order_id"));
                orderItem.setProductId(rs.getInt("product_id"));
                orderItem.setQuantity(rs.getInt("quantity"));
                orderItem.setPriceAtPurchase(rs.getFloat("price_at_purchase"));
                orderItem.setProductName(rs.getString("product_name"));
                orderItems.add(orderItem);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orderItems;
    }

    public Orders getOrderById(int orderId) {
        Orders order = null;
        String sql = "SELECT * FROM Orders WHERE order_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalPrice(rs.getDouble("total_price"));
                order.setBuyerName(rs.getString("buyer_name"));
                order.setBuyerPhone(rs.getString("buyer_phone"));
                order.setBuyerAddress(rs.getString("buyer_address"));
                order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    public void updateSoldQuantity(int productId, int quantity) {
        String sql = "UPDATE Product SET sold_quantity = sold_quantity + ? WHERE product_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, quantity);
            pstmt.setInt(2, productId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Orders> getAllOrders() {
    List<Orders> ordersList = new ArrayList<>();
    // Câu lệnh SQL để lấy tất cả các đơn hàng cùng với tên người dùng
    String sql = "SELECT o.order_id, o.user_id, o.total_price, o.buyer_name, o.buyer_phone, o.buyer_address, o.order_date, u.username "
               + "FROM Orders o JOIN Users u ON o.user_id = u.user_id";

    try (PreparedStatement pstmt = connection.prepareStatement(sql); ResultSet rs = pstmt.executeQuery()) {
        // Duyệt qua kết quả truy vấn
        while (rs.next()) {
            Orders order = new Orders();
            order.setOrderId(rs.getInt("order_id")); // Lấy ID đơn hàng
            order.setUserId(rs.getInt("user_id")); // Lấy ID người dùng
            order.setUserName(rs.getString("username")); // Lấy tên người dùng
            order.setTotalPrice(rs.getDouble("total_price")); // Lấy tổng giá
            order.setBuyerName(rs.getString("buyer_name")); // Lấy tên người mua
            order.setBuyerPhone(rs.getString("buyer_phone")); // Lấy điện thoại người mua
            order.setBuyerAddress(rs.getString("buyer_address")); // Lấy địa chỉ người mua
            order.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime()); // Lấy ngày đặt hàng
            ordersList.add(order); // Thêm đơn hàng vào danh sách
        }
    } catch (SQLException e) {
        e.printStackTrace(); // Xử lý ngoại lệ
    }

    return ordersList; // Trả về danh sách đơn hàng
}


}
