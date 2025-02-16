<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận đơn hàng - Toyo</title>
    </head>
    <body>
        <div class="content-wrapper">
            <header>
                <h1>Xác nhận đơn hàng</h1>
            </header>
            <main>
                <%
                    String successMessage = (String) request.getAttribute("successMessage");
                    if (successMessage != null) {
                %>
                <p><%= successMessage %></p>
                <%
                    } else {
                %>
                <p>Không có thông tin xác nhận.</p>
                <%
                    }
                %>
                <a href="home.jsp">Quay lại cửa hàng</a>
            </main>
        </div>
    </body>
</html>

<style>

    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
    }


    .content-wrapper {
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background-color: white;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        text-align: center;
    }

    header h1 {
        font-size: 2em;
        color: #333;
        margin-bottom: 20px;
    }


    p {
        font-size: 1.2em;
        color: #5cb85c;
        background-color: #dff0d8;
        padding: 15px;
        border: 1px solid #d6e9c6;
        border-radius: 5px;
    }


    p.error {
        color: #d9534f;
        background-color: #f2dede;
        border-color: #ebccd1;
    }


    a {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #0275d8;
        color: white;
        text-decoration: none;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    a:hover {
        background-color: #025aa5;
    }


    @media (max-width: 600px) {
        .content-wrapper {
            padding: 15px;
            margin: 20px auto;
        }

        header h1 {
            font-size: 1.5em;
        }

        a {
            width: 100%;
            text-align: center;
        }
    }

</style>
