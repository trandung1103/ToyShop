<%-- 
    Document   : user
    Created on : Sep 26, 2024, 1:52:35 PM
    Author     : DUNG TD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>User Profile</title>
        <link rel="stylesheet" href="css/user.css?v=1.0"> <!-- Kết nối file CSS -->
    </head>
    <body>
        <div class="profile-container">
            <h1>Thông tin tài khoản</h1>
            <%
                User user = (User) session.getAttribute("user");
                
                if (user != null) {
            %>
            <table>
                <tr>
                    <th>Tài khoản</th>
                    <td><%= user.getUsername() %></td>
                </tr>
                <tr>
                    <th>Tên hiển thị</th>
                    <td><%= user.getDisplayName() %></td>
                </tr>
                <tr>
                    <th>Mật khẩu</th>
                    <td><input style="border: none;" type="password" name="name" value="<%= user.getPassword() %>" onlyread></td>
                </tr>
                <tr>
                    <th>Chỉnh sửa thông tin:</th>
                    <td><a href="edit_user.jsp">Chỉnh sửa</a></td>
                </tr>
            </table>
            <div class="action-links">
                <a href="logout">Đăng xuất</a>
                <a href="home.jsp">Quay về trang chủ</a>
            </div>
            <%
                } else {
                    // Nếu không có thông tin người dùng, chuyển hướng về trang login
                    response.sendRedirect("login.jsp");
                }
            %>
        </div>
    </body>
</html>
