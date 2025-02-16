<%-- 
    Document   : search_user
    Created on : Oct 22, 2024, 7:30:57 PM
    Author     : DUNG TD
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Số lượng người dùng <%= quantity_user %></h1>
        <table>
            <thead>
                <tr>
                    <th>Username</th>
                    <th>Display Name</th>
                    <th>Password</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (users != null && !users.isEmpty()) {
                        for (User user : users) {
                %>
                <tr>
                    <td><%= user.getUsername() %></td>
                    <td><%= user.getDisplayName() %></td>
                    <td>
                        <div class="password-container">
                            <input style="border: none;" type="password" id="password_<%= user.getUsername() %>" name="password" value="<%= user.getPassword() %>" required>
                            <span class="eye-icon" onclick="togglePassword('<%= user.getUsername() %>', this)">
                                <i class="fas fa-eye-slash"></i>
                            </span>
                        </div>
                    </td>
                    <td><%= user.getRole() %></td>
                    <td>
                        <a href="admin_edit?username=<%= user.getUsername() %>" class="edit-btn"><i class="fa-solid fa-pen-to-square"></i></a>
                            <%
                            if (user.getId() != 1) {
                            %>
                        <a href="delete?userID=<%= user.getId() %>" class="delete-btn"><i class="fa-solid fa-user-minus"></i></a>
                            <% } %>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="5">Không có người dùng nào được tìm thấy.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

    </body>
</html>
