<%-- 
    Document   : resetPWDSuccess
    Created on : 5 thg 10, 2024, 01:44:02
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/font.css"/>
        <link rel="icon" href="${host}/ImageController/logo.png" type="image/x-icon">
        <title>Reset Successful</title>
        <style>
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f8f9fa;
            }

            .success-container {
                text-align: center;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            }

            .success-message {
                color: #28a745;
                font-size: 1.5rem;
                margin-bottom: 20px;
            }

            .btn-back-login {
                font-size: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="success-container">
            <div class="success-icon">
                <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" fill="currentColor" class="bi bi-check-circle" viewBox="0 0 16 16" style="color: #28a745;">
                <path d="M8 15A7 7 0 1 0 8 1a7 7 0 0 0 0 14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"/>
                <path d="M10.97 6.03a.75.75 0 0 1 1.07 1.05L8.477 11.4a.75.75 0 0 1-1.08.02L5.324 9.354a.75.75 0 0 1 1.06-1.06l1.658 1.657 3.924-4.924z"/>
                </svg>
            </div>
            <div class="success-message">
                Reset Password Successful!
            </div>
            <p>Your password has been successfully reset. You can now log in with your new password.</p>
            <a href="/HomePageController/Login">
                <button class="btn btn-outline-primary btn-back-login">Back to Login</button>
            </a>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    </body>
</html>
