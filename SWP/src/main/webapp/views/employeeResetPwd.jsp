<%-- 
    Document   : resetPWD
    Created on : 5 thg 10, 2024, 00:38:46
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- AE copy từ đây tới title nếu tạo jsp mới thêm các thể khác thì thêm trên <title> -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/font.css"/>
        <link rel="icon" href="${host}/ImageController/logo.png" type="image/x-icon">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.all.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.5/dist/sweetalert2.min.css">
        <title>ResetPass</title>
        <%
            String host = request.getRequestURI();
        %>
        <style>
            .logo  {
                font-family: "Oswald", sans-serif;
                font-optical-sizing: auto;
                font-weight: 500;
                font-style: normal;
                color: #050B20;
            }

            a:hover {
                color: inherit; /* Giữ nguyên màu */
            }

            .btn-dark{
                background-color: #050B20;
            }
        </style>
    </head>
    <body>
        <script>
            function validateForm() {
                var password = document.getElementById("password").value;
                var confirmPassword = document.getElementById("confirmPassword").value;
                var passwordError = document.getElementById("passwordError");
                var confirmError = document.getElementById("confirmError");

                passwordError.textContent = "";
                confirmError.textContent = "";

                // Kiểm tra mật khẩu
                var passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{6,32}$/;
                if (!passwordRegex.test(password)) {
                    passwordError.textContent = "Password must be 6-32 characters, at least 1 uppercase letter, 1 number and 1 special character.";
                    event.preventDefault();
                    return false; // Ngăn form submit
                }

                // Kiểm tra khớp mật khẩu
                if (password !== confirmPassword) {
                    confirmError.textContent = "Passwords do not match.";
                    event.preventDefault();
                    return false; // Ngăn form submit
                }

                return true; // Cho phép submit nếu hợp lệ
            }

            function checkPasswordsMatch() {
                var password = document.getElementById('password').value;
                var confirmPassword = document.getElementById('confirmPassword').value;
                var confirmError = document.getElementById('confirmError');
                var resetBtn = document.querySelector("button[name='resetUserPWDBtn']");

                if (password !== confirmPassword) {
                    confirmError.textContent = "Passwords do not match.";
                    resetBtn.disabled = true;
                } else {
                    confirmError.textContent = "";
                    resetBtn.disabled = false;
                }
            }

            function togglePassword() {
                var passwordField = document.getElementById("password");
                var icon = document.getElementById("icon");

                if (passwordField.type === "password") {
                    passwordField.type = "text";
                    icon.classList.remove("fa-eye");
                    icon.classList.add("fa-eye-slash");
                } else {
                    passwordField.type = "password";
                    icon.classList.remove("fa-eye-slash");
                    icon.classList.add("fa-eye");
                }
            }

            function checkPasswords() {
                var password = document.getElementById('password').value;
                var confirmPassword = document.getElementById('confirmPassword').value;
                var confirmError = document.getElementById('confirmError');

                if (password !== confirmPassword) {
                    confirmError.textContent = "Passwords do not match.";
                } else {
                    confirmError.textContent = ""; // Xóa thông báo lỗi nếu mật khẩu khớp
                }
            }
        </script>       
        <%
            Cookie[] cookies = request.getCookies();

            String userEmail = null;
            String role = null;
            // Duyệt qua các cookies và kiểm tra cookie "userEmail"
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        response.sendRedirect("/AdminController/Dashboard");
                        break;
                    }
                    if (cookie.getName().equals("role")) {
                        role = cookie.getValue();
                    }
                    if (cookie.getName().equals("userEmail")) {
                        userEmail = cookie.getValue();
                    }
                }
            }
            if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <div class="container-fluid vh-100 m-0 p-0">
            <div class="row h-100">
                <div class="col-lg-6 d-flex justify-content-center align-items-center">
                    <div class="w-100" style="max-width: 400px;">
                        <a class="logo text-decoration-none" href="/"><h1 class="mb-5">DriveAura</h1></a>   
                        <c:if test="${not empty message}">
                            <div class="alert alert-warning">${message}</div>
                        </c:if>
                        <%
                            session.removeAttribute("message");
                        %>
                        <h2 class="mb-3">Reset Password</h2>
                        <form onsubmit="return validateForm()" action="/ResetPasswordController" method="POST">
                            <div class="form-group mb-3">
                                <label for="email" class="form-label">Email address</label>
                                <input name="emailTxt" readonly value="<%= userEmail%>" type="email" class="form-control" id="email" placeholder="Enter your email">
                            </div>
                            <label for="password" class="form-label">New Password</label>
                            <div class="mb-3 d-flex form-group">
                                <input required type="password" class="form-control" id="password" name="pwdTxt" placeholder="Enter your password">
                                <button type="button" class="form-control btn btn-outline-dark" id="showPassword" onclick="togglePassword()" style="width: 50px;">
                                    <i class="fa-solid fa-eye p-0 m-0" id="icon"></i>                                    
                                </button>                               
                            </div>
                            <span id="passwordError" class="text-danger mb-3"></span> <!-- Thêm thẻ này để hiển thị lỗi -->                           

                            <div class="form-group mb-3">
                                <label for="confirmPassword">Confirm Password:</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required oninput="checkPasswordsMatch()">
                                <small id="confirmError" class="text-danger"></small>
                            </div>                            

                            <button type="submit" class="btn btn-dark" name="resetUserPWDBtn" disabled>Reset Password</button>
                        </form>
                    </div>
                </div>
                <div class="col-lg-6 d-none d-lg-block" style="background-image: url('${host}/ImageController/a/loginImage.jpg'); background-size: cover; background-position: center;"></div>
            </div>
        </div>
    </body>
</html>