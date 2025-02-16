package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.User;

public class AdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy đối tượng ServletContext
        ServletContext context = getServletContext();
        
        // Lấy danh sách người dùng từ ServletContext
        ArrayList<User> users = (ArrayList<User>) context.getAttribute("users");
        if (users == null) {
            users = new ArrayList<>(); // Khởi tạo danh sách người dùng nếu chưa có
            context.setAttribute("users", users);
        }

        // Kiểm tra xem người dùng hiện tại có phải là admin hay không
        String username = request.getParameter("username"); // Nhận từ query hoặc session
        if (username != null) {
            User loggedInUser = null;

            // Tìm kiếm người dùng theo username
            for (User user : users) {
                if (user.getUsername().equals(username)) {
                    loggedInUser = user;
                    break;
                }
            }

            // Kiểm tra nếu người dùng là admin
            if (loggedInUser != null && "admin".equals(loggedInUser.getRole())) {
                // Truyền danh sách người dùng vào request để hiển thị ở admin.jsp
                request.setAttribute("users", users);
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            } else {
                // Nếu không phải admin, chuyển hướng về trang home
                response.sendRedirect("home.jsp");
            }
        } else {
            // Nếu không có người dùng đăng nhập, chuyển hướng về login
            response.sendRedirect("login.jsp");
        }
    }
}
