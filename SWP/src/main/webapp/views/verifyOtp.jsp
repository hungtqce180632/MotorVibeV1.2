<%-- 
    Document   : verifyOtp
    Created on : 4 thg 10, 2024, 21:31:11
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <title>Verify OTP</title>
    </head>
    <body>
        <div class="container">
            <h2>OTP Verification</h2>
            <form action="/VerifyOtpServlet" method="POST">
                <div class="mb-3">
                    <label for="otp" class="form-label">Enter OTP</label>
                    <input type="text" class="form-control" id="otp" name="otp" required>
                </div>
                <button type="submit" class="btn btn-dark">Verify OTP</button>
            </form>
        </div>
    </body>
</html>
