<%-- 
    Document   : editProfile
    Created on : 21 thg 10, 2024, 16:33:53
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    </head>
    <body>
        <div class="container mt-5">
            <h2>Edit Profile</h2>
            <c:if test="${not empty message}">
                <div class="alert alert-warning">${message}</div>
            </c:if>
            <%
                session.removeAttribute("message");
            %>
            <form onsubmit="return validateForm()" action="/CustomerController" method="post">
                <%
                    // Lấy danh sách cookies từ request
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
                            if (cookie.getName().equals("userEmail")) {
                                userEmail = cookie.getValue(); // Lấy giá trị email từ cookie
                %>
                <input hidden id="user_email" type="text" name="user_email" value="<%= userEmail%>">
                <%
                            }
                            if (cookie.getName().equals("role")) {
                                role = cookie.getValue();

                            }
                        }
                    }
                    if (!role.equals("customer")) {
                        response.sendRedirect("/");
                    }
                %>
                <div class="row">
                    <!-- Name Field -->
                    <div class="mb-3 col-sm-6">
                        <label for="name" class="form-label">Name</label>
                        <input type="text" class="form-control" id="name" name="name" placeholder="Name" required>
                    </div>

                    <!-- Email Field -->
                    <div class="mb-3 col-sm-6">
                        <label for="email" class="form-label">E-mail</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                    </div>

                    <!-- Address Field -->
                    <div class="mb-3 col-sm-6">
                        <label for="address" class="form-label">Address</label>
                        <input type="text" class="form-control" id="address" name="address" placeholder="Address">
                    </div>

                    <!-- Phone Number Field -->
                    <div class="mb-3 col-sm-6">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone number">
                    </div>
                    <div class="col-sm-12 row">
                        <div class="mb-3 col-sm-6">
                            <!-- Bắt đầu phần OTP -->
                            <div class="alert alert-warning alert-dismissible fade d-none show" role="alert" id="alertOTP">
                                You should enter your email.
                                <button type="button" class="btn-close" aria-label="Close" onclick="hideAlertOTP()"></button>
                            </div>
                            <div class="d-flex mb-3 align-items-center" id="otpSend">
                                <button type="button" class="btn btn-outline-primary me-3" id="sendOtpButton" onclick="showNoti();
                                        sendOtp();
                                        disableButtonWithCountdown()">Send OTP</button>
                                <p class="text-danger" hidden id="notificationOtp">Please wait a few seconds.</p>
                            </div>
                            <div id="otpInput" style="display: none;" class="mb-3">
                                <label for="otp" class="form-label">Enter your code</label>
                                <div class="mb-2">
                                    <input type="text" class="form-control" id="otp" name="otp">
                                </div>
                                <button type="button" class="btn btn-success" onclick="verifyOtp()">Verification</button>
                            </div>
                            <p style="display: none;" class="text-success mb-3 fw-bold" id="OTPSuccess">OTP authentication successful!</p>
                            <input hidden id="verificationResult" class="mt-3" name="OTPResult" value=""/>
                            <!-- Kết thúc phần OTP -->
                        </div>                        

                        <!-- Submit Button -->
                        <div class="mb-3 col-sm-6 text-end">
                            <!-- Phần alert của bắt lỗi -->
                            <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                                <p id="alertTxt" class="p-0 m-0"></p>
                                <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
                            </div>
                            <!-- Phần alert của bắt lỗi -->
                            <button type="submit" class="btn btn-primary" name="editCusInfor">Save Changes</button>
                        </div>
                    </div>

                </div>
            </form>
        </div>
        <script>
            $(document).ready(function () {
                // Lấy userEmail từ cookie
                var userEmail = document.getElementById('user_email').value;
                // Nếu tìm thấy userEmail, gửi AJAX request để lấy thông tin người dùng
                $.ajax({
                    url: '/CustomerController', // Đường dẫn đến API hoặc servlet xử lý theo email
                    type: 'POST', // Sử dụng phương thức GET
                    data: {getInforUser: userEmail}, // Gửi email dưới dạng tham số
                    dataType: 'json', // Định dạng dữ liệu trả về là JSON
                    success: function (user) {
                        // Điền các giá trị vào các input tương ứng
                        $('#name').val(user.name);
                        $('#email').val(user.email);

                        if (user.phone_number !== undefined && user.phone_number !== null && user.phone_number !== '') {
                            $('#phone').val(user.phone_number);
                        }


                        if (user.address !== undefined && user.address !== null && user.address !== '') {
                            $('#address').val(user.address);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi lấy thông tin người dùng:", error);
                    }
                });
            });


            function validateForm() {
                var email = document.getElementById("email").value;
                var name = document.getElementById("name").value;
                var address = document.getElementById("address").value;
                var phone = document.getElementById("phone").value;
                var user_email = document.getElementById("user_email").value;

                console.log(user_email !== email);
                if (user_email !== email) {

                    var OTPResult = document.getElementById('verificationResult').value; // Lấy giá trị của input hidden
                    if (OTPResult !== 'Success') { // Kiểm tra nếu giá trị không phải 'Success'
                        sendMessageError("Please verify OTP."); // In ra giá trị OTPResult
                        return false; // Dừng thực hiện
                    } else {
                        // Thực hiện hành động khác nếu OTPResult là 'Success'
                        console.log("OTP xác nhận thành công.");
                    }
                }


                // Regular expression kiểm tra định dạng email
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (!emailRegex.test(email)) {
                    sendMessageError('Invalid email.');
                    return false; // Dừng form submit
                }

                // Regular expression kiểm tra mật khẩu
                if (name.length > 255) {
                    sendMessageError('Maximum 255 characters.');
                    return false; // Dừng form submit
                }

                if (!/^\d{10}$/.test(phone)) {
                    sendMessageError('Phone number must be exactly 10 digits.');
                    return false; // Dừng form submit
                }


                if (address.length > 255) {
                    sendMessageError('Maximum 255 characters.');
                    return false; // Dừng form submit
                }
                return true;
            }

            function sendOtp() {
                const email = $('#email').val();
                $.ajax({
                    type: "POST",
                    url: "/SendOtpServlet",
                    data: {email: email},
                    success: function (response) {
                        $('#otpInput').show();
                        $('#sendOtpButton').hide();
                        $('#otpSend').removeClass('mb-3');
                        $('#notificationOtp').hide();
                    },
                    error: function (xhr, status, error) {
                        $('#alertOTP').removeClass('d-none');
                        $('#notificationOtp').attr('hidden', true);
                    }
                });
            }

            function verifyOtp() {
                const otp = $('#otp').val();
                $.ajax({
                    type: "POST",
                    url: "VerifyOtpServlet",
                    data: {otp: otp},
                    success: function () {
                        $('#verificationResult').val('Success');
                        $('#otpInput').hide();
                        $('#OTPSuccess').css('display', 'block');
                    },
                    error: function (xhr, status, error) {
                        alert("Lỗi: " + error);
                    }
                });
            }

            function disableButtonWithCountdown() {
                var sendOtpButton = document.getElementById("sendOtpButton");
                var otpSend = document.getElementById("otpSend");
                var alertOTP = document.getElementById("alertOTP");
                var countdown = 60;

                // Vô hiệu hóa nút
                sendOtpButton.disabled = true;

                // Cập nhật nội dung nút với thời gian đếm ngược
                sendOtpButton.innerText = "Chờ " + countdown + " giây";

                // Tạo bộ đếm ngược
                var interval = setInterval(function () {
                    countdown--;
                    sendOtpButton.innerText = "Chờ " + countdown + " giây";

                    // Kiểm tra nếu otpSend không có class mb-3 thì dừng bộ đếm                    
                    if (!otpSend.classList.contains('mb-3') || !alertOTP.classList.contains('d-none')) {
                        clearInterval(interval);
                        sendOtpButton.disabled = false;
                        sendOtpButton.innerText = "Send OTP";
                        return; // Thoát khỏi hàm
                    }

                    // Khi hết 60 giây, kích hoạt lại nút
                    if (countdown <= 0) {
                        clearInterval(interval);
                        sendOtpButton.disabled = false;
                        sendOtpButton.innerText = "Send OTP";
                    }
                }, 1000); // Cập nhật mỗi giây
            }

            function showNoti() {
                document.getElementById('notificationOtp').removeAttribute('hidden');
            }

            function offNoti() {
                document.getElementById('notificationOtp').hidden;
            }

            function offMb3() {
                document.getElementById('sendOtpButton').className = document.getElementById('sendOtpButton').className.replace('mb-3', '').trim();
            }

            function hideAlertOTP() {
                console.log('adasd');
                var alertElement = document.getElementById('alertOTP');
                alertElement.classList.add('d-none');
            }

            function hideAlert() {
                console.log('adasd');
                var alertElement = document.getElementById('alertError');
                alertElement.classList.add('d-none');
            }
            function sendMessageError(mess) {
                const alertText = document.getElementById('alertTxt');
                const alertError = document.getElementById('alertError');
                alertError.classList.remove("d-none");
                alertText.innerHTML = mess;
            }

        </script>
    </body>
</html>
