package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dal.UserDAO;

public class update_profile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public update_profile() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            String displayName = request.getParameter("displayName");
            String password = request.getParameter("password");

            // Kiểm tra đầu vào không trống
            if (displayName != null && !displayName.trim().isEmpty() && 
                password != null && !password.trim().isEmpty()) {

                // Cập nhật thông tin người dùng
                user.setDisplayName(displayName);
                user.setPassword(password);


                UserDAO userDAO = new UserDAO();
                boolean updateSuccess = userDAO.updateProfile(user);

                if (updateSuccess) {
                    session.setAttribute("user", user);
                    response.sendRedirect("user.jsp?update=success");
                } else {
   
                    response.sendRedirect("edit_user.jsp?error=dbError");
                }
            } else {

                response.sendRedirect("edit_user.jsp?error=invalidInput");
            }
        } else {

            response.sendRedirect("login.jsp");
        }
    }

    // Phương thức doGet để chuyển hướng về trang edit_user.jsp nếu truy cập qua GET
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            response.sendRedirect("edit_user.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}
