<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="dal.UserDAO" %>
<%@ page import="java.util.List" %>
<%
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAll();
    int quantity_user=userDAO.user_quantity();
    String message = (String) getServletContext().getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin - User Management</title>
        <link rel="stylesheet" href="css/admin.css?v=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                color: #333;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 800px;
                margin: 20px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            h1 {
                text-align: center;
                color: #2980b9;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }

            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }

            th {
                background-color: #3498db;
                color: white;
            }

            tr:nth-child(even) {
                background-color: #f2f2f2;
            }

            tr:hover {
                background-color: #ddd;
            }

            .password-container {
                display: flex;
                align-items: center;
            }

            .eye-icon {
                cursor: pointer;
                margin-left: 5px;
            }

            .button-container {
                text-align: center;
                margin-top: 20px;
            }

            .back-btn {
                text-decoration: none;
                margin: 0 5px;
            }

            button {
                background-color: #e67e22;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
            }

            button:hover {
                background-color: #d35400;
            }

            .message {
                color: #e74c3c;
                text-align: center;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Quản lý người dùng</h1>
            <%
                if (users != null && !users.isEmpty()) {
            %>
            <table>
                <h1>Số lượng người dùng <%= quantity_user%></h1>
                <thead>
                    <tr>
                        <th>Tài khoản</th>
                        <th>Tên hiển thị</th>
                        <th>Mật khẩu</th>
                        <th>Phân quyền</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <%
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
                            <% if (user.getId() != 1) { %>
                            <a href="admin_edit?username=<%= user.getUsername() %>" class="edit-btn"><i class="fa-solid fa-pen-to-square"></i></a>
                            <a href="delete?userID=<%= user.getId() %>" class="delete-btn"><i class="fa-solid fa-user-minus"></i></a>
                                <% } %>
                        </td>

                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <%
                } else {
                    if (message != null) {
            %>
            <p class="message"><%= message %></p>
            <%
                    }
                }
            %>
            <div class="button-container">
                <a href="admin_add.jsp" class="back-btn"><button><i class="fa-solid fa-user-plus"></i>Thêm người dùng</button></a>
                <br>
                <a href="admin.jsp" class="back-btn"><button>Quay về trang quản trị</button></a>
            </div>
        </div>
    </body>
</html>

<script>
    function togglePassword(username, icon) {
        var passwordInput = document.getElementById("password_" + username);
        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.innerHTML = '<i class="fas fa-eye"></i>';
        } else {
            passwordInput.type = "password";
            icon.innerHTML = '<i class="fas fa-eye-slash"></i>';
        }
    }
</script>
