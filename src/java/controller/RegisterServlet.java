package controller;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = "user"; // Mặc định là user
        String displayName = request.getParameter("displayname");

        UserDAO userDAO = new UserDAO();


        if (userDAO.userExists(username)) {
            request.setAttribute("errorMessage", "Tài khoản đã tồn tại.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }


        User user = new User(0, username, password, role, displayName); 


        if (userDAO.register(user)) {

            int userId = userDAO.getUserIdByUsername(username);
            userDAO.createCart(userId); 

            response.sendRedirect("login.jsp"); 
        } else {
            response.sendRedirect("error.jsp");
        }
    }
}
