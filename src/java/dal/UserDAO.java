package dal;

import model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Lớp UserDAO lấy kết nối từ lớp DBContext
public class UserDAO {

    private Connection connection;

    // Constructor, lấy kết nối từ lớp DBContext
    public UserDAO() {
        DBContext dbContext = new DBContext();  // Khởi tạo đối tượng DBContext
        this.connection = dbContext.connection; // Lấy kết nối từ DBContext
    }

    public boolean userExists(String username) {
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username); // Gán tham số cho tên người dùng
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // Trả về true nếu số lượng người dùng lớn hơn 0
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Xử lý ngoại lệ SQL
        }
        return false; // Trả về false nếu có lỗi xảy ra
    }

    public int user_quantity() {
        String sql = "SELECT COUNT(*) FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public User getUserByName(String name) {
        try {
            String query = "SELECT * FROM Users WHERE username = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, name); // Gán tham số cho tên
            ResultSet rs = ps.executeQuery(); // Thực hiện câu lệnh SELECT

            if (rs.next()) {
                // Nếu tìm thấy người dùng, trả về đối tượng User
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("display_name") // Sửa thành "display_name" từ "displayName"
                );
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Xử lý ngoại lệ SQL
        }
        return null; // Trả về null nếu không tìm thấy người dùng
    }
    // Lấy user_id theo username

    public int getUserIdByUsername(String username) {
        String query = "SELECT user_id FROM Users WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("user_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Nếu không tìm thấy
    }

    // Phương thức đăng ký (register)
    public boolean register(User user) {
        try {
            // Nếu vai trò là admin, đếm số lượng admin hiện có
            if (user.getRole().equals("admin")) {
                String countAdminQuery = "SELECT COUNT(*) AS adminCount FROM Users WHERE role = 'admin'";
                PreparedStatement countPs = connection.prepareStatement(countAdminQuery);
                ResultSet rs = countPs.executeQuery();
                int adminCount = 0;
                if (rs.next()) {
                    adminCount = rs.getInt("adminCount");
                }
                // Đặt displayName là "ADMIN" + số lượng admin hiện có (cộng thêm 1 cho admin mới)
                user.setDisplayName("ADMIN" + (adminCount + 1));
            }

            // Thực hiện câu lệnh INSERT
            String query = "INSERT INTO Users (username, password, role, display_name) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getDisplayName());

            int rows = ps.executeUpdate();
            return rows > 0; // Trả về true nếu việc đăng ký thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi xảy ra
        }
    }

    // Tạo giỏ hàng cho người dùng
    public void createCart(int userId) {
        String query = "INSERT INTO Cart (user_id) VALUES (?)";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Phương thức đăng nhập (login)
    public User login(String name, String password) {
        try {
            String query = "SELECT * FROM Users WHERE username = ? AND password = ?";
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setString(1, name);    // Gán tham số cho tên
            ps.setString(2, password); // Gán tham số cho mật khẩu
            ResultSet rs = ps.executeQuery(); // Thực hiện câu lệnh SELECT

            if (rs.next()) {
                // Nếu tìm thấy người dùng, trả về đối tượng User
                return new User(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("role"),
                        rs.getString("display_name") // Sửa thành "display_name" từ "display-name"
                );
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Xử lý ngoại lệ SQL
        }
        return null; // Trả về null nếu không tìm thấy người dùng
    }

    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("user_id")); // Đảm bảo có cột user_id
                user.setUsername(resultSet.getString("username"));
                user.setPassword(resultSet.getString("password"));
                user.setRole(resultSet.getString("role"));
                user.setDisplayName(resultSet.getString("display_name"));
                return user;
            }
        }
        return null; // Không tìm thấy người dùng
    }

    // Cập nhật thông tin người dùng
    public void updateUser(User user) throws SQLException {
        String sql = "UPDATE Users SET password = ?, display_name = ?, role = ? WHERE username = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, user.getPassword());
            statement.setString(2, user.getDisplayName());
            statement.setString(3, user.getRole());
            statement.setString(4, user.getUsername());
            statement.executeUpdate();
        }
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE Users SET display_name = ?, password = ? WHERE username = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, user.getDisplayName());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getUsername());
            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Phương thức lấy người dùng theo ID
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                User user = new User();
                user.setId(resultSet.getInt("user_id"));
                user.setUsername(resultSet.getString("username"));
                user.setPassword(resultSet.getString("password"));
                user.setRole(resultSet.getString("role"));
                user.setDisplayName(resultSet.getString("display_name")); // Sửa thành "display_name"
                return user;
            }
        }
        return null; // Nếu không tìm thấy người dùng
    }

    public List<User> searchUsers(String keyword) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE username LIKE ? OR display_name LIKE ?";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setDisplayName(rs.getString("display_name"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    public void deleteUserById(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // Phương thức lấy tất cả người dùng

    public List<User> getAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try {
            PreparedStatement pre = connection.prepareStatement(sql);
            ResultSet rs = pre.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("user_id");
                String name = rs.getString("username");
                String pass = rs.getString("password");
                String role = rs.getString("role");
                String displayName = rs.getString("display_name");
                User user = new User(id, name, pass, role, displayName);
                list.add(user);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching data: " + e.getMessage());
        }
        return list;
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        dao.register(new User(0, "dung", "12345", "admin", "ADMIN"));
        dao.register(new User(0, "dung1", "12345", "admin", "ADMIN"));
        dao.register(new User(0, "dung2", "12345", "user", "User"));
        dao.register(new User(0, "dung3", "12345", "admin", "ADMIN"));
        List<User> ls = dao.getAll();
        if (!ls.isEmpty()) {
            for (User user : ls) {
                System.out.println(user.getId());
                System.out.println(user.getUsername());
                System.out.println(user.getPassword());
                System.out.println(user.getRole());
                System.out.println(user.getDisplayName());
                System.out.println("");
            }
        } else {
            System.out.println("No data found.");
        }
    }
}
