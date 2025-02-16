package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Invalidate the current session
        HttpSession session = request.getSession(false); // Get the session if it exists
        if (session != null) {
            session.invalidate(); // Invalidate the session
        }

        // Remove the cookie by setting its max age to 0
        Cookie usernameCookie = new Cookie("username", null);
        usernameCookie.setMaxAge(0); // Set cookie to expire immediately
        response.addCookie(usernameCookie);

        // Redirect to home page
        response.sendRedirect("home.jsp");
    }
}
