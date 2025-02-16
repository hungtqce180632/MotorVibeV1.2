<%-- 
    Document   : admin
    Created on : 9 thg 10, 2024, 18:19:45
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard</title>
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Font Awesome for Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="icon" href="/ImageController/a/logo.png" type="image/x-icon">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <style>
            .nav-link .fa-solid, .fas {
                margin-right: 10px;
            }

            /* Media query for screens smaller than 320px */
            @media (max-width: 768px) {
                .nav-link span {
                    display: none;
                }

                .nav-link .fa-solid, .fas {
                    margin-right: 0px;
                }
            }

            #loading {
                display: block;
                margin: 20px auto;
                width: 50px;
                height: 50px;
            }
            #mainCar, #mainCustomer, #mainEmployee, #mainEvent, #mainOrder {
                max-width: 100%;
                overflow-x: auto;
            }
        </style>
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
        %>
        <input id="email" value="<%= email%>" hidden>
        <%
                    }
                }
            }
            if (!isAdmin) {
                response.sendRedirect("/");
            }
        %>
        <script>
            function logOut() {
                $.ajax({
                    url: "/LoginController",
                    type: "POST",
                    data: {adminOut: 'logOut'},
                    success: function () {
                        location.reload();
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            }
        </script>
        <!-- main đây -->
        <div class="container-fluid m-0 p-0">
            <div class="row">
                <nav class="navbar navbar-expand-lg navbar-dark bg-dark justify-content-center col-12">
                    <a class="navbar-brand fs-3" href="/AdminController/Dashboard">Admin <span id="adminName">Admin</span></a>
                    <div class="nav-item justify-content-end me-3">
                        <button onclick="logOut()" class="btn btn-danger d-flex align-items-center w-100" id="logout-button">
                            <i class="fas fa-sign-out-alt"></i>
                            <span>Logout</span>
                        </button>
                    </div>
                </nav>
            </div>

            <hr>
            <div class="row">
                <!-- Nav (Vertical Tabs) -->
                <div class="col-xl-2 bg-dark">
                    <ul class="nav flex-column nav-pills shadow-sm p-3 m-0 p-0 h-100" id="v-pills-tab"
                        role="tablist" aria-orientation="vertical">  

                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white active" id="v-pills-revenue-tab" 
                               data-bs-toggle="pill" href="#v-pills-revenue" role="tab" aria-controls="v-pills-revenue" 
                               aria-selected="true"> <!-- Set aria-selected to true -->
                                <i class="fa-solid fa-dollar-sign me-2"></i>
                                <span>Revenue</span>
                            </a>
                        </li>

                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white" id="v-pills-cars-tab"
                               data-bs-toggle="pill" href="#v-pills-cars" role="tab" aria-controls="v-pills-cars"
                               aria-selected="false">
                                <i class="fa-solid fa-car"></i>
                                <span>Cars</span>
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white" id="v-pills-cusomers-tab"
                               data-bs-toggle="pill" href="#v-pills-cusomers" role="tab" aria-controls="v-pills-cusomers"
                               aria-selected="false">
                                <i class="fa-solid fa-user"></i>
                                <span>Customers</span>
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white" id="v-pills-employees-tab"
                               data-bs-toggle="pill" href="#v-pills-employees" role="tab" aria-controls="v-pills-employees"
                               aria-selected="false">
                                <i class="fa-solid fa-circle-user"></i>
                                <span>Employees</span>
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white" id="v-pills-events-tab"
                               data-bs-toggle="pill" href="#v-pills-events" role="tab" aria-controls="v-pills-events"
                               aria-selected="false">
                                <i class="fa-solid fa-gift"></i>
                                <span>Events</span>
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link d-flex align-items-center text-white" id="v-pills-orders-tab"
                               data-bs-toggle="pill" href="#v-pills-orders" role="tab" aria-controls="v-pills-orders"
                               aria-selected="false">
                                <i class="fa-solid fa-clipboard"></i>
                                <span>Orders</span>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Tab Content -->
                <div class="col-xl-10">
                    <div class="tab-content shadow-sm p-4 rounded bg-white w-100" id="v-pills-tabContent">
                        <div class="tab-pane fade show active w-100" id="v-pills-revenue" role="tabpanel" aria-labelledby="v-pills-revenue-tab">
                            <button id="loadRevenueButton" class="btn btn-outline-secondary mb-3">Load Revenue Page</button>
                            <div id="includeRevenueContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainRevenue">
                                <%@ include file="/views/static.jsp" %> 
                            </div>
                        </div>
                        <div class="tab-pane fade w-100" id="v-pills-cars" role="tabpanel" aria-labelledby="v-pills-cars-tab">
                            <a target="_blank" href="/CarController/Create" class="btn btn-primary mb-3">Create New Car</a>
                            <button id="loadCarButton" class="btn btn-outline-secondary mb-3">Load Car Page</button>
                            <div id="includeCarContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainCar" class="container-fluid">
                                <%@include file="/views/car.jsp" %> 
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-cusomers" role="tabpanel"
                             aria-labelledby="v-pills-cusomers-tab">
                            <button id="loadCustomerButton" class="btn btn-outline-secondary mb-3">Load Customer Page</button>
                            <div id="includeCustomerContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainCustomer">
                                <%@include file="/views/customer.jsp" %> 
                            </div>
                        </div>
                        <div class="tab-pane fade" id="v-pills-employees" role="tabpanel" 
                             aria-labelledby="v-pills-employees-tab">
                            <a target="_blank" href="/EmployeeController/Create" class="btn btn-primary mb-3">Create New Employee</a>
                            <button id="loadEmployeeButton" class="btn btn-outline-secondary mb-3">Load Employee Page</button>
                            <div id="includeEmployeeContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainEmployee">
                                <%@include file="/views/employee.jsp" %> 
                            </div>
                        </div>
                        <div class="tab-pane fade w-100" id="v-pills-events" role="tabpanel" aria-labelledby="v-pills-events-tab" id="eventContent">
                            <a target="_blank" href="/EventController/Create" class="btn btn-primary mb-3">Create New Event</a>
                            <button id="loadEventButton" class="btn btn-outline-secondary mb-3">Load Event Page</button>
                            <div id="includeEventContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainEvent">
                                <%@include file="/views/event.jsp" %> 
                            </div>
                        </div>
                        <div class="tab-pane fade w-100" id="v-pills-orders" role="tabpanel" aria-labelledby="v-pills-orders-tab" id="orderContent">
                            <button id="loadOrderButton" class="btn btn-outline-secondary mb-3">Load Order Page</button>
                            <div id="includeOrderContainer" class="w-100 container-fluid p-0 m-0"></div>
                            <div id="mainOrder">
                                <%@include file="/views/orderAdmin.jsp" %> 
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap 5 JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                            const nav = document.getElementById('v-pills-tab');
                            const toggleNav = () => {
                                if (window.innerWidth < 1200) {
                                    nav.classList.remove('flex-column', 'vh-100');
                                    nav.classList.add('flex-row', 'w-100', 'justify-content-center');
                                } else {
                                    nav.classList.remove('flex-row', 'w-100', 'justify-content-center');
                                    nav.classList.add('flex-column', 'vh-100');
                                }
                            };
                            window.addEventListener('resize', toggleNav);
                            toggleNav();

                            // Load event page
                            var loadEventButton = document.getElementById('loadEventButton');
                            if (loadEventButton) {
                                loadEventButton.addEventListener('click', function () {
                                    $('#includeEventContainer').load('/views/event.jsp');
                                    $('#mainEvent').hide();
                                });
                            }
                            // Load revenu page
                            var loadRevenueButton = document.getElementById('loadRevenueButton');
                            if (loadRevenueButton) {
                                loadRevenueButton.addEventListener('click', function () {
                                    $('#includeRevenueContainer').load('/views/static.jsp');
                                    $('#mainRevenue').hide();
                                });
                            }
                            // Load car page
                            var loadCarButton = document.getElementById('loadCarButton');
                            if (loadCarButton) {
                                loadCarButton.addEventListener('click', function () {
                                    $('#includeCarContainer').load('/views/car.jsp');
                                    $('#mainCar').hide();
                                });
                            }
                            ;
                            window.addEventListener('resize', toggleNav);
                            toggleNav();


                            // Load employee page
                            var loadEmployeeButton = document.getElementById('loadEmployeeButton');
                            if (loadEmployeeButton) {
                                loadEmployeeButton.addEventListener('click', function () {
                                    $('#includeEmployeeContainer').load('/views/employee.jsp');
                                    $('#mainEmployee').hide();
                                });
                            }

                            // Load employee page
                            var loadOrderButton = document.getElementById('loadOrderButton');
                            if (loadOrderButton) {
                                loadOrderButton.addEventListener('click', function () {
                                    $('#includeOrderContainer').load('/views/orderAdmin.jsp');
                                    $('#mainOrder').hide();
                                });
                            }
                            // Load Customer page
                            var loadCustomerButton = document.getElementById('loadCustomerButton');
                            if (loadCustomerButton) {
                                loadCustomerButton.addEventListener('click', function () {
                                    $('#includeCustomerContainer').load('/views/customer.jsp');
                                    $('#mainCustomer').hide();
                                });
                            }

                            $(document).ready(function () {
                                var email = document.getElementById("email").value;
                                $.ajax({
                                    url: "/AdminController",
                                    type: "POST",
                                    data: {getName: 'true', email: email},
                                    dataType: "json",
                                    success: function (name) {
                                        $('#adminName').text(name);
                                    },
                                    error: function (xhr, status, error) {
                                        console.error("Có lỗi xảy ra khi lấy dữ liệu xe: " + error);
                                    }
                                });
                            });
        </script>
    </body>
</html>