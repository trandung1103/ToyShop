package controller;

import dal.UserDAO;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import model.User;

public class add extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String displayName = request.getParameter("displayname");

        UserDAO userDAO = new UserDAO();

        if (userDAO.userExists(username)) {
            request.setAttribute("errorMessage", "Tên người dùng đã tồn tại.");
            request.getRequestDispatcher("admin_add.jsp").forward(request, response);
            return;
        }

        User user = new User(0, username, password, role, displayName); 

        // Đăng ký người dùng
        if (userDAO.register(user)) {
            // Tạo giỏ hàng cho người dùng
            int userId = userDAO.getUserIdByUsername(username); // Lấy user_id
            userDAO.createCart(userId); // Tạo giỏ hàng

            response.sendRedirect("list_user.jsp"); 
        } else {
            response.sendRedirect("error.jsp"); // Chuyển hướng đến trang lỗi nếu có vấn đề
        }
    }
}
