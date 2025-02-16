<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page session="true" %>

<%
User user = (User) session.getAttribute("user");
if (user != null) {
    String productName = request.getParameter("productName");
    user.getCart().removeItem(productName); 
    response.sendRedirect("cart.jsp");
} else {
    response.sendRedirect("login.jsp");
}
%>
