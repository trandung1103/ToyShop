<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="dal.UserDAO" %>
<%
    String username = request.getParameter("username");
    UserDAO userDAO = new UserDAO();
    User user = userDAO.getUserByName(username);
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit User</title>
        <link rel="stylesheet" href="css/admin.css?v=1.0">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f5f5;
                color: #333;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 600px;
                margin: 40px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }

            h1 {
                text-align: center;
                color: #2980b9;
            }

            label {
                display: block;
                margin: 10px 0 5px;
            }

            input[type="text"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px;
                margin-bottom: 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            button {
                background-color: #3498db;
                color: white;
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                transition: background-color 0.3s;
                width: 100%;
            }

            button:hover {
                background-color: #2980b9;
            }

            .button-container {
                display: flex;
                justify-content: space-between;
                margin-top: 20px;
            }

            .back-btn {
                text-decoration: none;
                margin-top: 20px;
                display: inline-block;
                background-color: #e67e22;
                color: white;
                padding: 10px 15px;
                border-radius: 5px;
                transition: background-color 0.3s;
            }

            .back-btn:hover {
                background-color: #d35400;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Edit User</h1>
            <form action="update_user.jsp" method="post">
                <input type="hidden" name="username" value="<%= user.getUsername() %>">
                <div>
                    <label for="displayName">Display Name:</label>
                    <input type="text" id="displayName" name="displayName" value="<%= user.getDisplayName() %>" required>
                </div>
                <div>
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" value="<%= user.getPassword() %>" required>
                </div>
                <div>
                    <label for="role">Role:</label>
                    <select id="role" name="role">
                        <option value="admin" <%= user.getRole().equals("admin") ? "selected" : "" %>>Admin</option>
                        <option value="user" <%= user.getRole().equals("user") ? "selected" : "" %>>User</option>
                    </select>
                </div>
                <div>
                    <button type="submit">Update User</button>
                </div>
            </form>
            <div class="button-container">
                <a href="admin.jsp" class="back-btn">Back to User Management</a>
                <a href="home.jsp" class="back-btn">Back to Home</a>
            </div>
        </div>
    </body>
</html>
