<%-- 
    Document   : employeeProfile
    Created on : 28 thg 10, 2024, 20:31:13
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
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <title>Profile User</title>
        <style>
            body {
                background-color: #f8f9fa;
            }
            .profile-img {
                width: 100px;
                height: 100px;
                object-fit: cover;
                border-radius: 50%;
                border: 3px solid #fff;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            .btn-custom {
                border-radius: 50px;
            }

        </style>
    </head>
    <body class="container-fluid p-0 d-flex flex-column min-vh-100">
        <!-- navBar -->
        <%@include file="navbar.jsp" %>
        <%    if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <div class="container-fluid w-100 pt-5 mt-5">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card">
                        <div class="row g-0 row-bordered row-border-light">
                            <div
                                class="col-md-3 bg-light d-flex flex-column align-items-center p-4">
                                <div id="avarta">
                                    <!-- Avarta -->
                                </div>                                
                                <div class="dropdown w-100 mt-3">
                                    <button
                                        class="btn btn-outline-primary btn-custom w-100 dropdown-toggle"
                                        type="button" id="dropdownMenuButton"
                                        data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                        More Options
                                    </button>
                                    <ul class="dropdown-menu"
                                        aria-labelledby="dropdownMenuButton">
                                        <li><a class="dropdown-item"
                                               href="/EmployeeController/Order">View List
                                                Order</a></li>
                                        <li><a class="dropdown-item"
                                               href="/ReviewController/Views">List Review</a></li>
                                        <li><a class="dropdown-item"
                                               href="/EmployeeController/Feedback">List Feedback</a></li>
                                        <li><a class="dropdown-item"
                                               href="/EmployeeController/Appointment">List Appointment</a></li>
                                        <li><a class="dropdown-item"
                                               href="/EmployeeController/Customer">List Customer</a></li>
                                    </ul>
                                </div>
                            </div>
                            <div class="col-md-9">
                                <div class="tab-content p-4">
                                    <div class="tab-pane fade active show"
                                         id="account-general">                                        
                                        <hr class="border-light m-0">
                                        <div class="card-body">                                          
                                            <div class="row justify-content-evenly">
                                                <div
                                                    class="alert alert-warning mt-3">
                                                    * Contact Admin to edit personal information.<br>                                                    
                                                </div>
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">Name</label>
                                                    <input type="text" id="name"
                                                           class="form-control"
                                                           placeholder="Name" required>
                                                </div>
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">E-mail</label>
                                                    <input type="text" id="email"
                                                           class="form-control"
                                                           placeholder="E-mail" required>
                                                </div>
                                                <div class="mb-3 col-sm-5"> 
                                                    <label
                                                        class="form-label">Employee Id</label>
                                                    <input type="text" id="empId"
                                                           class="form-control"
                                                           placeholder="Employee Id">
                                                </div>
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">Phone number</label>
                                                    <input type="text" id="phone_number"
                                                           class="form-control"
                                                           placeholder="Phone number">
                                                </div>                                            
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row justify-content-md-end mt-4 mb-4">
                        <div class="col-12 col-md-6 col-lg-4 d-flex justify-content-end">
                            <a target="_blank" href="/EmployeeController/ResetPassword" class="btn btn-warning btn-custom me-2">Change Password</a>
                            <form action="/LoginController" method="POST">
                                <button type="submit" class="btn btn-secondary btn-custom" name="logOut">Log Out</button>
                            </form>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                // Lấy userEmail từ cookie
                var userEmail = document.getElementById('userEmail').value;
                // Nếu tìm thấy userEmail, gửi AJAX request để lấy thông tin người dùng
                $.ajax({
                    url: '/EmployeeController', // Đường dẫn đến API hoặc servlet xử lý theo email
                    type: 'POST', // Sử dụng phương thức GET
                    data: {getInforEmployee: userEmail}, // Gửi email dưới dạng tham số
                    dataType: 'json', // Định dạng dữ liệu trả về là JSON
                    success: function (user) {
                        // Điền các giá trị vào các input tương ứng
                        $('#name').val(user.name);
                        console.log(user);
                        $('#email').val(user.email);

                        var img = '<img src="/ImageController/a/avarta.png" alt="Profile Picture" class="profile-img mb-3">';
                        $('#avarta').append(img);

                        var phone = '********' + user.phoneNumber.slice(-2);
                        $('#phone_number').val(phone);


                        $('#empId').val(user.employeeId);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi lấy thông tin người dùng:", error);
                    }
                });
            });

        </script>
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
    </body>
</html>
