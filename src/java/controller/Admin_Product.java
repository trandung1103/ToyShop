package controller;

import dal.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Product;

public class Admin_Product extends HttpServlet {
    
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO(); // Khởi tạo ProductDAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // Lấy hành động từ request
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        String categoryID = request.getParameter("categoryID");
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String imageUrl = request.getParameter("imageUrl"); // Lấy URL hình ảnh từ request

        if ("add".equals(action)) {
            // Thêm sản phẩm mới
            Product newProduct = new Product(0, name, price, quantity, description, categoryID, imageUrl);
            productDAO.addProduct(newProduct);
        } else if ("update".equals(action)) {
            // Cập nhật sản phẩm
            int productId = Integer.parseInt(request.getParameter("productId")); // Lấy ID sản phẩm
            Product updatedProduct = new Product(productId, name, price, quantity, description, categoryID, imageUrl);
            productDAO.updateProduct(updatedProduct);
        } else if ("delete".equals(action)) {
            // Xóa sản phẩm
            int productId = Integer.parseInt(request.getParameter("productId")); // Lấy ID sản phẩm
            productDAO.deleteProduct(productId);
        }

        response.sendRedirect("admin_product.jsp"); // Chuyển hướng đến trang quản lý sản phẩm
    }
}
