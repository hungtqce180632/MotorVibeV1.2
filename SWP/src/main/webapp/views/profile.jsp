<%-- 
    Document   : profile
    Created on : 21 thg 10, 2024, 15:37:29
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
        <%            if (!role.equals("customer")) {
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
                                               href="/CustomerController/Warranty">View List
                                                Warranty</a></li>
                                        <li><a class="dropdown-item"
                                               href="/CustomerController/Order">View List
                                                Order</a></li>
                                        <li><a class="dropdown-item"
                                               href="/CustomerController/Feedback">FeedBack</a></li>
                                        <li><a class="dropdown-item"
                                               href="/CustomerController/Wishlist">Wishlist</a></li>
                                        <li><a class="dropdown-item"
                                               href="/CustomerController/Appointment">View Appointment</a></li>
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
                                                    <strong>* Address, Citizen ID, and Phone Number </strong> are only required when purchasing a car. <br><strong>* Citizen ID</Strong> can only be changed when placing an order for security.<br>                                                    
                                                </div>
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">Customer Id</label>
                                                    <input type="text" id="id"
                                                           class="form-control"
                                                           placeholder="CustomerId" required>
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
                                                        class="form-label">Address</label>
                                                    <input type="text" id="address"
                                                           class="form-control"
                                                           placeholder="Address">
                                                </div>
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">Phone number</label>
                                                    <input type="text" id="phone_number"
                                                           class="form-control"
                                                           placeholder="Phone number">
                                                </div>  
                                                <div class="mb-3 col-sm-5">
                                                    <label
                                                        class="form-label">Citizen Identification</label>
                                                    <input type="text" id="cccd"
                                                           class="form-control"
                                                           placeholder="CustomerCCCD" required>
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
                            <a target="_blank" href="/CustomerController/EditProfile" class="btn btn-primary btn-custom me-2">Edit</a>
                            <a target="_blank" href="/CustomerController/ResetPassword" class="btn btn-warning btn-custom me-2">Change Password</a>
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
                    url: '/CustomerController', // Đường dẫn đến API hoặc servlet xử lý theo email
                    type: 'POST', // Sử dụng phương thức GET
                    data: {getInforUser: userEmail}, // Gửi email dưới dạng tham số
                    dataType: 'json', // Định dạng dữ liệu trả về là JSON
                    success: function (user) {
                        $('#name').val(user.name);
                        console.log(user);
                        $('#email').val(user.email);

                        $('#id').val(user.customer_id);

                        if (user.picture === undefined || user.picture === null || user.picture === '') {
                            var img = '<img src="/ImageController/a/avarta.png" alt="Profile Picture" class="profile-img mb-3">';
                            $('#avarta').append(img);
                        } else {
                            var img = '<img src="' + user.picture + '" alt="Profile Picture" class="profile-img mb-3">';
                            $('#avarta').append(img);
                        }

                        if (user.phone_number !== undefined && user.phone_number !== null && user.phone_number !== '') {
                            var phone = '********' + user.phone_number.slice(-2);
                            $('#phone_number').val(phone);
                        }

                        if (user.cus_id_number !== undefined && user.cus_id_number !== null && user.cus_id_number !== '') {
                            var cccd = '**********' + user.cus_id_number.slice(-2);
                            $('#cccd').val(cccd);
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

        </script>
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
    </body>
</html>
