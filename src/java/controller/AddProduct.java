package controller;

import dal.ProductDAO;
import model.Product;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@MultipartConfig 
public class AddProduct extends HttpServlet {
    private static final String UPLOAD_DIR = "path/to/upload/directory";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String productName = request.getParameter("product_name");
        double productPrice = Double.parseDouble(request.getParameter("product_price"));
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        String category = ""+categoryId;

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

        // Tạo đối tượng sản phẩm
        Product product = new Product();
        product.setProduct_name(productName);
        product.setProduct_price(productPrice);
        product.setProduct_quantity(productQuantity);
        product.setProduct_description(description);
        product.setCategoryID(category);
        product.setImage_url(relativePath); // Đường dẫn lưu trữ ảnh

        // Thêm sản phẩm vào kho
        ProductDAO productDAO = new ProductDAO();
        productDAO.addProduct(product);

        // Chuyển hướng đến trang thành công hoặc trang danh sách sản phẩm
        response.sendRedirect("storage.jsp");
    }
}
