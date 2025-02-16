package controller;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.User;
import dal.UserDAO; // Nhập lớp UserDAO
import java.sql.SQLException;

public class admin_edit extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        UserDAO userDAO = new UserDAO(); // Khởi tạo UserDAO
        User userToEdit = null;

        try {
            // Lấy người dùng theo tên người dùng
            userToEdit = userDAO.getUserByUsername(username);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("list_user.jsp"); // Redirect nếu có lỗi
            return;
        }

        if (userToEdit != null) {
            request.setAttribute("userToEdit", userToEdit);
            request.getRequestDispatcher("edit_admin.jsp").forward(request, response);
        } else {
            response.sendRedirect("list_user.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        UserDAO userDAO = new UserDAO(); // Khởi tạo UserDAO

        // Lấy dữ liệu từ form
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String displayname = request.getParameter("displayname");
        String role = request.getParameter("role");

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setDisplayName(displayname);
        user.setRole(role);

        try {
            // Cập nhật thông tin người dùng trong cơ sở dữ liệu
            userDAO.updateUser(user);
            // Thiết lập thông báo thành công
            getServletContext().setAttribute("message", "User updated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            // Thiết lập thông báo lỗi
            getServletContext().setAttribute("message", "Error updating user: " + e.getMessage());
        }

        response.sendRedirect("list_user.jsp");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
