package dal;

import model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DBContext {

    private Connection connection;

    public CategoryDAO() {
        DBContext dbContext = new DBContext(); // Sử dụng DBContext để lấy kết nối
        this.connection = dbContext.connection;
    }

    // Lấy tất cả danh mục
    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Category"; // Thay đổi theo bảng của bạn
        try (PreparedStatement statement = connection.prepareStatement(sql); ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Category category = new Category();
                category.setId(resultSet.getInt("category_id")); // Thay đổi theo tên cột của bạn
                category.setName(resultSet.getString("category_name")); // Thay đổi theo tên cột của bạn
                categories.add(category);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    // Lấy danh mục theo ID
    public Category getCategoryById(int id) {
        Category category = null;
        String sql = "SELECT * FROM Category WHERE category_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = new Category();
                category.setId(resultSet.getInt("category_id"));
                category.setName(resultSet.getString("category_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category;
    }

    public int getCategoryByName(String name) {
        Category category = null;
        String sql = "SELECT category_id FROM Category WHERE category_name = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, name); // Sử dụng setString để gán tên danh mục
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                category = new Category();
                category.setId(resultSet.getInt("category_id")); // Lấy category_id
                category.setName(resultSet.getString("category_name")); // Lấy category_name
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return category.getId();
    }

    public boolean addCategory(Category category) {
        String sql = "INSERT INTO Category (category_name) VALUES (?)"; // Thay đổi theo tên cột của bạn
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, category.getName());
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu thêm thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi
        }
    }

    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM Category WHERE category_id = ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, categoryId);
            int rowsAffected = statement.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getTotalCountByCategory(String categoryName) {
        String query = "SELECT COUNT(*) AS total FROM Product p "
                + "JOIN Category cg ON p.category_id = cg.category_id "
                + "WHERE cg.category_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            // Thiết lập giá trị cho tham số categoryName
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total"); // Trả về số lượng sản phẩm
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching total count by category: " + e.getMessage());
        }
        return 0; // Nếu không có sản phẩm, trả về 0
    }

}
