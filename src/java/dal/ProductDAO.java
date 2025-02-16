package dal;

import java.beans.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO {

    private Connection connection;

    public ProductDAO() {
        DBContext dbContext = new DBContext();
        this.connection = dbContext.connection;
    }

    // ProductDAO.java
    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM Product ORDER BY product_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"; // Câu lệnh SQL phân trang
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                // Tạo đối tượng Product từ ResultSet và thêm vào danh sách
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setProduct_price(rs.getDouble("product_price"));
                product.setProduct_quantity(rs.getInt("product_quantity"));
                product.setSold_quantity(rs.getInt("sold_quantity"));
                product.setCategoryID(rs.getString("category_id"));
                product.setImage_url(rs.getString("image_url"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public int getTotalPage(int pageSize) {
        int totalCount = getTotalCount();
        return (int) Math.ceil((double) totalCount / pageSize);
    }

    public List<Product> searchProducts(String query) {
        List<Product> productList = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE product_name LIKE ?"; 

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setString(1, "%" + query + "%");
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setProduct_id(rs.getInt("product_id"));
                product.setProduct_name(rs.getString("product_name"));
                product.setProduct_price(rs.getDouble("product_price"));
                product.setProduct_quantity(rs.getInt("product_quantity"));
                product.setSold_quantity(rs.getInt("sold_quantity"));
                product.setCategoryID(rs.getString("category_id"));
                product.setImage_url(rs.getString("image_url"));
                productList.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return productList;
    }

    // Lấy sản phẩm theo danh mục
    public List<Product> getProductsByCategory(String categoryId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.product_price, "
                + "p.product_quantity, p.product_description, "
                + "c.category_name, p.image_url "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "WHERE c.category_name = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, categoryId);
            ResultSet resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Product product = new Product();
                product.setProduct_id(resultSet.getInt("product_id"));
                product.setProduct_name(resultSet.getString("product_name"));
                product.setProduct_price(resultSet.getDouble("product_price"));
                product.setProduct_quantity(resultSet.getInt("product_quantity"));
                product.setProduct_description(resultSet.getString("product_description"));
                product.setCategoryID(resultSet.getString("category_name"));
                product.setImage_url(resultSet.getString("image_url"));
                products.add(product);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return products;
    }

    // Lấy sản phẩm nổi bật
    public List<Product> getFeaturedProduct() {
        List<Product> products = new ArrayList<>();
        try {
            String query = "SELECT * FROM Product WHERE isFeatured = 1";  // Cột isFeatured
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getDouble("product_price"),
                        rs.getInt("product_quantity"),
                        rs.getString("product_description"),
                        rs.getString("category_id"), 
                        rs.getString("image_url") 
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Lấy sản phẩm mới
    public List<Product> getNewProduct() {
        List<Product> products = new ArrayList<>();
        try {
            String query = "SELECT * FROM Product ORDER BY date_added DESC";  // Đổi tên cột cho phù hợp
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getDouble("product_price"),
                        rs.getInt("product_quantity"),
                        rs.getString("product_description"),
                        rs.getString("category_id"), // Đổi tên cột cho phù hợp
                        rs.getString("image_url") // Thêm cột hình ảnh
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Lấy sản phẩm bán chạy
    public List<Product> getBestSellers() {
        List<Product> products = new ArrayList<>();
        try {
            String query = "SELECT * FROM Product ORDER BY sold_quantity DESC";  // Đổi tên cột cho phù hợp
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getDouble("product_price"),
                        rs.getInt("product_quantity"),
                        rs.getString("product_description"),
                        rs.getString("category_id"), // Đổi tên cột cho phù hợp
                        rs.getString("image_url") // Thêm cột hình ảnh
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    // Lấy sản phẩm theo ID
    public Product getProductById(int id) throws SQLException {
        String sql = "SELECT p.product_id, p.product_name, p.product_price, "
                + "p.product_quantity, p.product_description, "
                + "c.category_name, p.image_url "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?"; // Sử dụng JOIN để lấy thông tin thể loại

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                // Tạo một đối tượng Product với các thông tin lấy từ CSDL
                return new Product(
                        resultSet.getInt("product_id"),
                        resultSet.getString("product_name"),
                        resultSet.getDouble("product_price"),
                        resultSet.getInt("product_quantity"),
                        resultSet.getString("product_description"),
                        resultSet.getString("category_name"), // Lấy tên thể loại
                        resultSet.getString("image_url") // Lấy đường dẫn hình ảnh
                );
            }
        }
        return null; // Nếu không tìm thấy sản phẩm
    }

    public Product getProductBycatgeoryId(String id) throws SQLException {
        String sql = "SELECT p.product_id, p.product_name, p.product_price, "
                + "p.product_quantity, p.product_description, "
                + "c.category_name, p.image_url "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "WHERE p.category_id = ?"; // Sử dụng JOIN để lấy thông tin thể loại

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, id);
            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                // Tạo một đối tượng Product với các thông tin lấy từ CSDL
                return new Product(
                        resultSet.getInt("product_id"),
                        resultSet.getString("product_name"),
                        resultSet.getDouble("product_price"),
                        resultSet.getInt("product_quantity"),
                        resultSet.getString("product_description"),
                        resultSet.getString("category_name"), // Lấy tên thể loại
                        resultSet.getString("image_url") // Lấy đường dẫn hình ảnh
                );
            }
        }
        return null; // Nếu không tìm thấy sản phẩm
    }

    public void addProduct(Product product) {
        String sql = "INSERT INTO Product (product_name, product_price, product_quantity, category_id, image_url,sold_quantity) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, product.getProduct_name());
            ps.setDouble(2, product.getProduct_price());
            ps.setInt(3, product.getProduct_quantity());
            ps.setString(4, product.getCategoryID());
            ps.setString(5, product.getImage_url());
            ps.setInt(6, 0);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Xử lý ngoại lệ nếu có
        }
    }

    // Phương thức lấy giá cao nhất
    public double getMaxPrice() {
        String query = "SELECT MAX(product_price) AS maxPrice FROM Product"; // Đổi tên cột cho phù hợp
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("maxPrice");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Nếu không có sản phẩm, trả về 0
    }

    // Phương thức lấy giá thấp nhất
    public double getMinPrice() {
        String query = "SELECT MIN(product_price) AS minPrice FROM Product"; // Đổi tên cột cho phù hợp
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("minPrice");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Nếu không có sản phẩm, trả về 0
    }

    // Phương thức lấy tổng số sản phẩm
    public int getTotalCount() {
        String query = "SELECT COUNT(*) AS total FROM Product";
        try (PreparedStatement ps = connection.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0; // Nếu không có sản phẩm, trả về 0
    }

    // Lấy tất cả sản phẩm
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.product_price, "
                + "p.product_quantity, p.product_description, "
                + "c.category_name, p.image_url, p.sold_quantity "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id";

        try (PreparedStatement pre = connection.prepareStatement(sql); ResultSet rs = pre.executeQuery()) {
            while (rs.next()) {
                int id = rs.getInt("product_id");
                String name = rs.getString("product_name");
                String description = rs.getString("product_description");
                double price = rs.getDouble("product_price");
                int quantity = rs.getInt("product_quantity");
                String categoryID = rs.getString("category_name");
                String imageUrl = rs.getString("image_url");
                int sold = rs.getInt("sold_quantity");
                Product product = new Product(id, name, price, quantity, description, categoryID, imageUrl, sold);
                list.add(product);
            }
        } catch (SQLException e) {
            System.out.println("Error fetching data: " + e.getMessage());
        }

        return list;
    }

    public List<Product> getBestSold() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT TOP 3 p.product_id, p.product_name, p.product_price, p.product_quantity, "
                + "p.product_description, c.category_name, p.image_url, p.sold_quantity "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "ORDER BY p.sold_quantity DESC";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getDouble("product_price"),
                            rs.getInt("product_quantity"),
                            rs.getString("product_description"),
                            rs.getString("category_name"),
                            rs.getString("image_url"),
                            rs.getInt("sold_quantity")
                    );
                    products.add(product);
                }
            }

        }
        return products;
    }

    public List<Product> getProductsByCategory1(String categoryName, int offset, int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.product_name, p.product_price, "
                + "p.product_quantity, p.product_description, "
                + "c.category_name, p.image_url "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "WHERE c.category_name = ? "
                + "ORDER BY p.product_id " // Phân trang yêu cầu sắp xếp
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement pre = connection.prepareStatement(sql)) {
            pre.setString(1, categoryName);  // Đặt tên danh mục
            pre.setInt(2, offset);  // Bắt đầu từ hàng số offset
            pre.setInt(3, limit);   // Giới hạn số hàng lấy ra

            try (ResultSet rs = pre.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("product_id");
                    String name = rs.getString("product_name");
                    String description = rs.getString("product_description");
                    double price = rs.getDouble("product_price");
                    int quantity = rs.getInt("product_quantity");
                    String categoryID = rs.getString("category_name");
                    String imageUrl = rs.getString("image_url");

                    Product product = new Product(id, name, price, quantity, description, categoryID, imageUrl);
                    list.add(product);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // In chi tiết lỗi ra console
        }
        return list; // Trả về danh sách sản phẩm
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE Product SET product_name = ?, product_price = ?, product_quantity = ?, product_description = ?, category_id = ?, image_url = ? WHERE product_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, product.getProduct_name());
            stmt.setDouble(2, product.getProduct_price());
            stmt.setInt(3, product.getProduct_quantity());
            stmt.setString(4, product.getProduct_description());
            stmt.setString(5, product.getCategoryID());
            stmt.setString(6, product.getImage_url());
            stmt.setInt(7, product.getProduct_id());

            return stmt.executeUpdate() > 0; // Trả về true nếu có bản ghi nào được cập nhật
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void updateProductQuantity(Product product) throws SQLException {
        String sql = "UPDATE Product SET product_quantity = ? WHERE product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, product.getProduct_quantity()); // Lấy số lượng từ đối tượng Product
            ps.setInt(2, product.getProduct_id()); // Lấy ID từ đối tượng Product
            ps.executeUpdate(); // Thực hiện cập nhật
        }
    }

    // Xóa sản phẩm
    public boolean deleteProduct(int productId) {
        String query = "DELETE FROM Product WHERE product_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(query)) {
            ps.setInt(1, productId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy 3 sản phẩm từ dưới lên với thông tin danh mục
    public List<Product> getLastThreeProducts() throws SQLException {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT TOP 3 p.product_id, p.product_name, p.product_price, p.product_quantity, "
                + "p.product_description, c.category_name, p.image_url "
                + "FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id DESC";

        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Product product = new Product(
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getDouble("product_price"),
                            rs.getInt("product_quantity"),
                            rs.getString("product_description"),
                            rs.getString("category_name"), // Lưu thông tin category_name nếu cần
                            rs.getString("image_url")
                    );
                    products.add(product);
                }
            }

        }
        return products;
    }

    public int getTotalProductsByCategory(String categoryName) {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM Product p "
                + "JOIN Category c ON p.category_id = c.category_id "
                + "WHERE c.category_name = ?";

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, categoryName); // Thiết lập tên danh mục
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    total = resultSet.getInt(1); // Lấy tổng số sản phẩm
                }
            }
        } catch (SQLException e) {
            System.out.println("Error fetching total products by category: " + e.getMessage());
        }
        return total;
    }

    public List<String> getAllCategoryNames() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT category_name FROM Category";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            ResultSet resultSet = statement.executeQuery();
            while (resultSet.next()) {
                categories.add(resultSet.getString("category_name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categories;
    }

    public List<Product> getProductsByCategorySortedByPrice(String categoryName, int offset, int limit, String sortOrder) {
        List<Product> products = new ArrayList<>();
//        (int product_id, String product_name, double product_price, int product_quantity, String product_description, String categoryID, String image_url) {
        String sql = "SELECT * FROM Product WHERE category_id = (SELECT category_id FROM Category WHERE category_name = ?) ORDER BY product_price " + sortOrder + " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, categoryName);
            stmt.setInt(2, offset);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getDouble("product_price"),
                        rs.getInt("product_quantity"),
                        rs.getString("product_description"),
                        rs.getString("category_id"),
                        rs.getString("image_url")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }


    // Phương thức main để kiểm tra
    public static void main(String[] args) throws SQLException {
        ProductDAO dao = new ProductDAO();
        List<Product> lastThreeProducts = dao.getAll();
        if (!lastThreeProducts.isEmpty()) {
            System.out.println("Top 3 sản phẩm cuối cùng:");
            for (Product p : lastThreeProducts) {
                System.out.println("ID: " + p.getProduct_id());
                System.out.println("Tên sản phẩm: " + p.getProduct_name());
                System.out.println("Giá: " + p.getProduct_price());
                System.out.println("Số lượng: " + p.getProduct_quantity());
                System.out.println("Mô tả: " + p.getProduct_description());
                System.out.println("Danh mục: " + p.getCategoryID());
                System.out.println("Hình ảnh: " + p.getImage_url());
                System.out.println("--------------------");
            }
        } else {
            System.out.println("Không có sản phẩm nào.");
        }
    }

}
