package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.Product;

public class UpdateProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId =Integer.getInteger(request.getParameter("productId")) ;
        String name = request.getParameter("name");
        double price = Double.parseDouble(request.getParameter("price"));
        String description = request.getParameter("description");
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        ArrayList<Product> products = (ArrayList<Product>) getServletContext().getAttribute("products");
        if (products != null) {
            for (Product product : products) {
                if (product.getProduct_id()==productId) {
                    product.setProduct_name(name);
                    product.setProduct_price(price);
                    product.setProduct_description(description);
                    product.setProduct_quantity(quantity);
                    break;
                }
            }
        }

        // Redirect back to the product list or the admin page after update
        response.sendRedirect("home.jsp");
    }
}
