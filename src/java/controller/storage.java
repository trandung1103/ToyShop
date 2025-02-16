package controller;

import dal.CategoryDAO;
import dal.ProductDAO;
import jakarta.servlet.RequestDispatcher;
import model.Category;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
@MultipartConfig 
public class storage extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("updateProduct".equals(action)) {
            int productId = Integer.parseInt(request.getParameter("product_id"));
            ProductDAO productDAO = new ProductDAO();
            Product product = null;
            try {
                product = productDAO.getProductById(productId); // Giả sử bạn đã có phương thức này trong ProductDAO
            } catch (SQLException ex) {
                Logger.getLogger(storage.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Gửi đối tượng sản phẩm đến trang JSP để hiển thị
            request.setAttribute("product", product);
            RequestDispatcher dispatcher = request.getRequestDispatcher("admin_product.jsp");
            dispatcher.forward(request, response);
        }
        // Xử lý các hành động khác...
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action) {
            case "addCategory":
                addCategory(request, response);
                break;
            case "deleteCategory":
                deleteCategory(request, response);
                break;
            case "updateProduct":
                updateProduct(request, response);
                break;
            case "deleteProduct":
                deleteProduct(request, response);
                break;
            case "addProduct":
                addProduct(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productName = request.getParameter("product_name");
        double productPrice = Double.parseDouble(request.getParameter("product_price"));
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
        String productDescription = request.getParameter("description");
        String categoryId = request.getParameter("categoryId");

        Part filePart = request.getPart("imageFile");
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        String projectPath = uploadPath.substring(0, uploadPath.length() - "/build/web".length());
        String filePath = projectPath + "web" + File.separator + "img" + File.separator + fileName;
        filePart.write(filePath);
        String relativePath = "img" + "/" + fileName;
        Product product = new Product(0, productName, productPrice, productQuantity, productDescription, categoryId, relativePath, 0);
        ProductDAO productDAO = new ProductDAO();

        productDAO.addProduct(product);
        response.sendRedirect("storage.jsp"); // Chuyển hướng nếu thành công
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryName = request.getParameter("category_name");
        Category category = new Category();
        category.setName(categoryName);

        CategoryDAO categoryDAO = new CategoryDAO();
        boolean success = categoryDAO.addCategory(category);

        if (success) {
            response.sendRedirect("storage.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to add category");
            request.getRequestDispatcher("addCategory.jsp").forward(request, response);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));

        CategoryDAO categoryDAO = new CategoryDAO();
        boolean success = categoryDAO.deleteCategory(categoryId);

        if (success) {
            response.sendRedirect("storage.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to delete category");
            request.getRequestDispatcher("storage.jsp").forward(request, response);
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("product_id"));
        String productName = request.getParameter("product_name");
        double productPrice = Double.parseDouble(request.getParameter("product_price"));
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
        String productDescription = request.getParameter("description"); // Sửa key cho mô tả
        String categoryId = request.getParameter("categoryID");

        // Kiểm tra xem có file hình ảnh hay không trước khi lấy Part
        Part filePart = request.getPart("imageFile");
        String relativePath = null;

        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            String projectPath = uploadPath.substring(0, uploadPath.length() - "/build/web".length());
            String filePath = projectPath + "web" + File.separator + "img" + File.separator + fileName;
            filePart.write(filePath);
            relativePath = "img" + "/" + fileName; 
        }

        Product product = new Product(productId, productName, productPrice, productQuantity, productDescription, categoryId, relativePath);
        ProductDAO productDAO = new ProductDAO();

        boolean success = productDAO.updateProduct(product);

        if (success) {
            response.sendRedirect("storage.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to update product");
            request.getRequestDispatcher("admin_product.jsp").forward(request, response);
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));

        ProductDAO productDAO = new ProductDAO();
        boolean success = productDAO.deleteProduct(productId);

        if (success) {
            response.sendRedirect("storage.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to delete product");
            request.getRequestDispatcher("storage.jsp").forward(request, response);
        }
    }
}
