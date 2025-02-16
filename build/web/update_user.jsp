<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="dal.UserDAO" %>
<%
    String username = request.getParameter("username");
    String displayName = request.getParameter("displayName");
    String password = request.getParameter("password");
    String role = request.getParameter("role");

    User user = new User();
    user.setUsername(username);
    user.setDisplayName(displayName);
    user.setPassword(password);
    user.setRole(role);

    UserDAO userDAO = new UserDAO();
    userDAO.updateUser(user);

    getServletContext().setAttribute("message", "User updated successfully.");
    response.sendRedirect("list_user.jsp");
%>
