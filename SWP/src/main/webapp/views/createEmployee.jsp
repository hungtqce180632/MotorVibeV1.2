
<%-- 
    Document   : employeeCreate
    Created on : 21 Oct 2024
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Employee</title>
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css"
            rel="stylesheet">    
    </head>
    <body>
        <%
            // Lấy danh sách cookies từ request
            Cookie[] cookies = request.getCookies();
            boolean isAdmin = false;
            // Duyệt qua các cookies và kiểm tra cookie "userEmail"
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        isAdmin = true;
                    }
                    if (cookie.getName().equals("email")) {
                        String email = cookie.getValue();
                    }
                }
            }
            if (!isAdmin) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5">
            <h2>Create Employee</h2>
            <form id="employeeForm" method="POST" action="/EmployeeController/create">
                <div class="mb-3">
                    <label for="employeeName" class="form-label">Employee Name:</label>
                    <input type="text" class="form-control" id="employeeName" name="employee_name" required>
                </div>
                <div class="mb-3">
                    <label for="employeeEmail" class="form-label">Email:</label>
                    <input type="email" class="form-control" id="employeeEmail" name="employee_email" required>
                </div>
                <div class="mb-3">
                    <label for="employeePassword" class="form-label">Password:</label>
                    <input type="password" class="form-control" id="employeePassword" name="employee_password" required>
                </div>
                <div class="mb-3">
                    <label for="employeePhone" class="form-label">Phone Number:</label>
                    <input type="text" class="form-control" id="employeePhone" name="employee_phone" required>
                </div>
                <!-- Alert Section -->
                <div class="alert alert-warning alert-dismissible d-none" role="alert" id="alertError">
                    <p id="alertTxt" class="p-0 m-0 text-danger"></p>
                    <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
                </div>

                <button type="submit" class="btn btn-primary" id="createEmployee" name="createEmployee">Submit</button>
            </form>
        </div>

        <script>
            function showAlert(message) {
                const alertError = document.getElementById('alertError');
                const alertTxt = document.getElementById('alertTxt');
                alertTxt.innerHTML = message;
                alertError.classList.remove('d-none');
                alertError.style.display = 'block';
            }

            function hideAlert() {
                const alertError = document.getElementById('alertError');
                alertError.classList.add('d-none');
                alertError.style.display = 'none';
            }

            document.getElementById('employeeForm').addEventListener('submit', function (event) {

                const employeeEmail = document.getElementById('employeeEmail').value;
                const employeePassword = document.getElementById('employeePassword').value;
                const employeePhone = document.getElementById('employeePhone').value;

                // Email validation
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(employeeEmail)) {
                    showAlert('Invalid email.');
                    event.preventDefault();
                    return;
                }

                // Password validation
                var passwordRegex = /^(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{6,32}$/;
                if (!passwordRegex.test(employeePassword)) {
                    showAlert('Password must be 6-32 characters, at least 1 uppercase letter, 1 number and 1 special character.');
                    event.preventDefault();
                    return;
                }

                // Phone number validation (10-15 digits)
                const phonePattern = /^[0-9]{10}$/;
                if (!phonePattern.test(employeePhone)) {
                    showAlert('Phone number must be 10 digits.');
                    event.preventDefault();
                    return;
                }

                hideAlert(); // Hide any previous error messages
            });
        </script>
    </body>
</html>
