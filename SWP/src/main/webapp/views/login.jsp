<%-- 
    Document   : login
    Created on : 28 thg 9, 2024, 15:23:38
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
        <link rel="stylesheet" type="text/css" href="css/font.css"/>
        <link rel="icon" href="/ImageController/a/logo.png" type="image/x-icon">
        <title>Login Page</title>
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
        <%
            Cookie[] cookies = request.getCookies();
            // Duyệt qua các cookies và kiểm tra cookie "userEmail" nếu có thì quay về trang chủ
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        response.sendRedirect("/AdminController/Dashboard");
                        break;
                    }
                    if (cookie.getName().equals("userEmail")) {
                        response.sendRedirect("/");
                        break;
                    }
                }
            }
        %>
        <div class="container-fluid vh-100">
            <div class="row h-100">
                <!-- Left side with background -->
                <div class="col-lg-6 d-none d-lg-block" style="background-image: url('${host}/ImageController/a/loginImage.jpg'); background-size: cover; background-position: center;"></div>

                <!-- Right side with form -->
                <div class="col-lg-6 d-flex justify-content-center align-items-center">                     
                    <div class="w-100" style="max-width: 400px;">
                        <a class="logo text-decoration-none" href="/"><h1 class="mb-5">MotoVibe</h1></a>   

                        <h2 class="fw-bold">Welcome back!</h2>
                        <c:if test="${not empty message}">
                            <div class="alert alert-warning">${message}</div>
                        </c:if>
                        <%
                            session.removeAttribute("message");
                        %>
                        <p>Enter your credentials to access your account</p>
                        <form onsubmit="return validateForm()" action="/LoginController" method="post">
                            <div class="mb-3">
                                <label for="email" class="form-label">Email address</label>
                                <input type="email" class="form-control" id="email" name="emailTxt" placeholder="Enter your email">
                                <span id="emailError" class="text-danger"></span> <!-- Thêm thẻ này để hiển thị lỗi -->
                            </div>    
                            <label for="password" class="form-label">Password</label>
                            <div class="mb-3 d-flex">
                                <input type="password" class="form-control" id="password" name="pwdTxt" placeholder="Enter your password">
                                <button type="button" class="form-control btn btn-outline-dark" id="showPassword" onclick="togglePassword()" style="width: 50px;">
                                    <i class="fa-solid fa-eye p-0 m-0" id="icon"></i>
                                </button>
                            </div>
                            <div class="form-check mb-3">
                                <input required type="checkbox" class="form-check-input" id="terms">
                                <label class="form-check-label" for="terms">I agree to the <a href="/HomePageController/Term" target="_blank">terms & policy</a></label>
                            </div>
                            <span id="passwordError" class="text-danger mb-4"></span> <!-- Thêm thẻ này để hiển thị lỗi -->                           
                            <button type="submit" class="btn btn-dark w-100 mb-3" name="loginBtn">Login</button>
                            <div class="text-center">Or</div>
                            <a class="btn btn-outline-dark w-100 mt-3" href="https://accounts.google.com/o/oauth2/auth?scope=email profile openid&redirect_uri=http://localhost:8080/LoginController/Login&response_type=code&client_id=660845253786-djntvvn4rk8lnt6vmrbop3blvttdmrnm.apps.googleusercontent.com&approval_prompt=force&state=login">
                                <img src="${host}/ImageController/a/logoGG.png" style="width: 20px;" alt="Google Logo"> 
                                Login with Google
                            </a>
                            <div class="text-center mt-3" name="forgotPwdBtn">
                                <a href="/HomePageController/ResetPassword">Forgot password?</a>
                            </div>
                            <div class="text-center mt-2">
                                Don't have an account? <a href="/HomePageController/SignUp">Sing Up</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!-- valid data -->
        <script>
            function validateForm() {
                var email = document.getElementById("email").value;
                var password = document.getElementById("password").value;
                var emailError = document.getElementById("emailError");
                var passwordError = document.getElementById("passwordError");

                // Reset thông báo lỗi
                emailError.textContent = "";
                passwordError.textContent = "";

                // Regular expression kiểm tra định dạng email
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    emailError.textContent = "Invalid email.";
                    return false; // Dừng form submit
                }

                // Regular expression kiểm tra mật khẩu
                var passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{6,32}$/;
                if (!passwordRegex.test(password)) {
                    passwordError.textContent = "Password must be 6-32 characters, at least 1 uppercase letter, 1 number and 1 special character.";
                    console.log("Password không hợp lệ");
                    return false; // Dừng form submit
                }

                console.log("Form validation passed"); // Form hợp lệ
                return true;
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
        </script>
    </body>
</html>
