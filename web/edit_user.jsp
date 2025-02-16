<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Profile</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

        <link rel="stylesheet" href="css/edit_user.css?v=1.1">
    </head>
    <body>
        <div class="container">
            <h1>Edit Profile</h1>
            <%
                User user = (User) session.getAttribute("user");
            
                if (user != null) {
            %>
            <form action="update_profile" method="post">
                <label for="username">Tài khoản</label>
                <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly><br><br>

                <label for="displayName">Tên hiển thị</label>
                <input type="text" id="displayName" name="displayName" value="<%= user.getDisplayName() %>"><br><br>

                <label for="password">Mật khẩu</label>
                <div class="password-container">
                    <input type="password" id="password" name="password" required>
                    <span class="eye-icon" onclick="togglePassword()">
                        <i class="fa-solid fa-eye"></i>
                    </span>
                </div><br><br>

                <input type="submit" value="Cập nhật thông tin">
                <button > <a style="text-decoration: none; color: #f4f4f4;" href="home.jsp"> Quay về trang chủ</a></button>
            </form>
            <%
                } else {
                    response.sendRedirect("login.jsp");
                }
            %>
        </div>

        <script>
            function togglePassword() {
                var passwordInput = document.getElementById("password");
                if(passwordInput.type = (passwordInput.type === "password")){
                    passwordInput.type = "text";
                    icon.innerHTML = '<i class="fa-solid fa-eye"></i>';
                }
                else {
                    passwordInput.type = "password";
                    icon.innerHTML = '<i class="fas fa-eye-slash"></i>';
                }
                
            }
        </script>
    </body>
</html>
