<%-- 
    Document   : footer
    Created on : Oct 4, 2024, 1:18:43 PM
    Author     : DUNG TD
--%>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<footer class="footer">
    <p>&copy; 2024 Toyo. All rights reserved.</p>
</footer>

<style>
    /* Đảm bảo body và html chiếm toàn bộ chiều cao của trang */
    html, body {
        height: 100%;
        margin: 0;
        display: flex;
        flex-direction: column;
    }

    /* Phần chính chiếm toàn bộ không gian còn lại */
    main {
        flex: 1;
    }

    /* Đảm bảo footer nằm ở cuối */
    .footer {
        background-color: #333;
        color: #fff;
        text-align: center;
        padding: 10px 0;
        flex-shrink: 0;
    }

</style>
