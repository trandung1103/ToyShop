<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập</title>
        <link rel="stylesheet" href="css/login.css?v=1.0">
    </head>
    <body>
        <div class="login-container">
            <h2>Đăng nhập</h2>
            <form action="login" method="post">
                <label for="username">Tài khoản:</label>
                <input type="text" id="username" name="username" required><br>

                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required><br>

                <input type="checkbox" id="rememberMe" name="rememberMe">Ghi nhớ đăng nhập


                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <p style="color: red;"><%= error %></p>
                <%
                    }
                %>

                <input type="submit" value="Đăng nhập" class="login-button">
            </form>

            <br> 
            Chưa có tài khoản?<a href="register.jsp" class="register-link">Đăng ký ngay</a>

        </div>
    </body>
</html>
