<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.Cookie" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Logout</title>
    </head>
    <body>
        <%
            session.invalidate();
   
            Cookie usernameCookie = new Cookie("username", null);
            usernameCookie.setMaxAge(0); 
            response.addCookie(usernameCookie);
        
            // Redirect to home page
            response.sendRedirect("home.jsp");
        %>
    </body>
</html>
