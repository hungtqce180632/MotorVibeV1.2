<%-- 
    Document   : editEmployee
    Created on : Oct 22, 2024, 9:34:23 AM
    Author     : counh
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Edit Employee</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            <h2 class="text-center mb-4">Edit Employee Details</h2>

            <!-- Form to edit employee details -->
            <form id="editEmployeeForm" action="EmployeeController" method="post" onsubmit="return validateForm()" class="needs-validation" novalidate>
                <!-- Hidden field to trigger the update operation -->
                <input type="hidden" name="updateEmployee" value="true">

                <div class="mb-3">
                    <label for="employee_id" class="form-label">Employee ID:</label>
                    <input type="text" id="employee_id" name="employee_id" class="form-control" readonly required
                           value="${employee.employeeId}">
                </div>

                <div class="mb-3">
                    <label for="employee_name" class="form-label">Name:</label>
                    <input type="text" id="employee_name" name="employee_name" class="form-control" required
                           value="${employee.name}">
                </div>

                <div class="mb-3">
                    <label for="employee_email" class="form-label">Email:</label>
                    <input type="email" id="employee_email" name="employee_email" class="form-control" required
                           pattern="[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+"
                           title="Please enter a valid email address with '@' symbol"
                           value="${employee.email}">
                </div>

                <div class="mb-3">
                    <label for="employee_password" class="form-label">New Password (optional):</label>
                    <input type="password" id="employee_password" name="employee_password" class="form-control">
                </div>

                <div class="mb-3">
                    <label for="employee_phone" class="form-label">Phone:</label>
                    <input type="text" id="employee_phone" name="employee_phone" class="form-control" pattern="\d{10}"
                           title="Please enter a valid 10-digit phone number" value="${employee.phoneNumber}">
                </div>

                <button type="submit" class="btn btn-primary">Update Employee</button>
            </form>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                function validateForm() {
                    // Kiểm tra email
                    const email = document.getElementById("employee_email").value;
                    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailPattern.test(email)) {
                        alert("Please enter a valid email address with '@' symbol.");
                        return false;
                    }

                    // Kiểm tra số điện thoại
                    const phone = document.getElementById("employee_phone").value;
                    const phonePattern = /^\d{10}$/;
                    if (!phonePattern.test(phone)) {
                        alert("Please enter a valid 10-digit phone number.");
                        return false;
                    }

                    // Kiểm tra mật khẩu (nếu có)
                    const password = document.getElementById("employee_password").value;
                    if (password) { // Chỉ kiểm tra nếu mật khẩu được nhập
                        const passwordPattern = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/;
                        if (!passwordPattern.test(password)) {
                            alert("Password must contain at least 6 characters, including one uppercase letter, one lowercase letter, one number, and one special character.");
                            return false;
                        }
                    }

                    // Nếu tất cả các điều kiện đều đúng, cho phép gửi form
                    return true;
                }
        </script>
    </body>
</html>
