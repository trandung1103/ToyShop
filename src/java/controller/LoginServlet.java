package controller;

import dal.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            if ("on".equals(rememberMe)) {
                Cookie usernameCookie = new Cookie("username", user.getUsername());
                usernameCookie.setMaxAge(60 * 60 * 24);
                response.addCookie(usernameCookie);
            }

            response.sendRedirect("home.jsp");
        } else {
            request.setAttribute("error", "Tài khoản không tồn tại");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }

}
