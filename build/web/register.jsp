<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="css/register.css?v=1.0"> <!-- Kết nối file CSS -->
    </head>
    <body>
        <div class="register-container">
            <h2>Đăng ký</h2>
            <form action="register" method="post">
                <label for="username">Tài khoản:</label>
                <input type="text" id="username" name="username" required>

                <label for="displayname">Tên hiển thị:</label>
                <input type="text" id="displayname" name="displayname" required>

                <label for="password">Mật khẩu:</label>
                <input type="password" id="password" name="password" required>     

                <%
                String error = (String) request.getAttribute("errorMessage");
                if (error != null) {
                %>
                <p style="color: red;"><%= error %></p>
                <%
                    }
                %>

                <input type="submit" class="register-button" value="Đăng ký">
                <div class="login-link">
                    Đã có tài khoản?<a href="login.jsp">Đăng nhập</a>
                </div>
            </form>
        </div>
    </body>
</html>
