<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
        <title>Create Order - Employee</title>
        <style>
            .order-summary {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .car-image {
                max-width: 100%;
                height: auto;
                max-height: 400px;
                object-fit: cover;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
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
        <input hidden value="<%= userEmail%>" id="userEmail">
        <%
                    }
                    if (cookie.getName().equals("role")) {
                        role = cookie.getValue(); // Lấy giá trị email từ cookie                        
                    }
                }
            }

            if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5">
            <h1 class="mb-4 text-center">Create Order for Customer</h1>

            <!-- Customer Information -->
            <div class="mb-3">
                <label for="customerId" class="form-label"><strong>Customer ID</strong></label>
                <input type="text" class="form-control" id="customerId" placeholder="Enter Customer ID" required>
                <button class="btn btn-primary mt-2" id="fetchCustomerBtn">Fetch Customer Info</button>
            </div>

            <div class="order-summary" id="customerInfo" style="display:none;">
                <h4 class="mb-4">Customer Information</h4>
                <p><strong>Name:</strong> <span id="customerName">N/A</span></p>
                <p><strong>Email:</strong> <span id="customerEmail">N/A</span></p>
                <p><strong>Phone Number:</strong> <span id="customerPhone">N/A</span></p>
                <p><strong>Address:</strong> <span id="customerAddress">N/A</span></p>
                <p><strong>Citizen Identification:</strong> <input id="customerCCCD" class="form-control" placeholder="Enter Citizen Identification" value="" required></p>

            </div>

            <!-- Car Information -->
            <div class="mb-3">
                <label for="carId" class="form-label"><strong>Car ID</strong></label>
                <input type="text" class="form-control" id="carId" placeholder="Enter Car ID" required>
                <button class="btn btn-primary mt-2" id="fetchCarBtn">Fetch Car Info</button>
            </div>

            <div class="order-summary" id="carInfo" style="display:none;">
                <h4 class="mb-4">Car Information</h4>
                <p><strong>Car Name:</strong> <span id="carName">N/A</span></p>
                <p><strong>Brand:</strong> <span id="carBrand">N/A</span></p>
                <p><strong>Model:</strong> <span id="carModel">N/A</span></p>
                <p><strong>Fuel:</strong> <span id="carFuel">N/A</span></p>
                <p><strong>Color:</strong> <span id="carColor">N/A</span></p>
                <p><strong>Price:</strong> $<span id="carPrice">0</span></p>
            </div>

            <!-- Action Button -->
            <div class="text-center mt-4">
                <button type="button" onclick="createOrder()" id="confirmOrderBtn" class="btn btn-success btn-lg" disabled>Create Order</button>
            </div>
        </div>

        <script>
            // Fetch customer information
            $(document).on('click', '#fetchCustomerBtn', function () {
                var customerId = $('#customerId').val();
                $.ajax({
                    url: '/CustomerController',
                    type: 'POST',
                    data: {getCustomerInfo: customerId},
                    dataType: 'json',
                    success: function (customer) {
                        if (customer.customer_id !== 0) {
                            $('#customerName').text(customer.name);
                            $('#customerEmail').text(customer.email);
                            $('#customerPhone').text(customer.phone_number);
                            $('#customerAddress').text(customer.address);
                            $('#customerCCCD').val(customer.cus_id_number);
                            $('#customerInfo').show();
                            checkEnableOrderButton();
                        } else {
                            Swal.fire('Error', customer.error || 'Customer not found or get banned', 'error');
                        }
                    },
                    error: function () {
                        Swal.fire('Error', 'Failed to fetch customer data', 'error');
                    }
                });
            });

            // Fetch car information
            $(document).on('click', '#fetchCarBtn', function () {
                var carId = $('#carId').val();
                $.ajax({
                    url: '/CarController',
                    type: 'POST',
                    data: {car_id_details: carId},
                    dataType: 'json',
                    success: function (response) {
                        console.log(response);
                        if (response.car.car_id !== 0) {
                            const car = response.car;
                            $('#carName').text(car.car_name);
                            // Thông tin thương hiệu, model và loại nhiên liệu
                            let brandName = 'N/A';
                            response.brands.forEach(function (brand) {
                                if (brand.brand_id === car.brand_id) {
                                    brandName = brand.brand_name;
                                }
                            });
                            $('#carBrand').text(brandName);

                            let modelName = 'N/A';
                            response.models.forEach(function (model) {
                                if (model.model_id === car.model_id) {
                                    modelName = model.model_name;
                                }
                            });
                            $('#carModel').text(modelName);

                            let fuelName = 'N/A';
                            response.fuels.forEach(function (fuel) {
                                if (fuel.fuel_id === car.fuel_id) {
                                    fuelName = fuel.fuel_name;
                                }
                            });
                            $('#carFuel').text(fuelName);
                            $('#carColor').text(car.color);
                            $('#carPrice').text(car.price);
                            $('#carInfo').show();
                            checkEnableOrderButton();
                        } else {
                            Swal.fire('Error', response.error || 'Car not found', 'error');
                        }
                    },
                    error: function () {
                        Swal.fire('Error', 'Failed to fetch car data', 'error');
                    }
                });
            });




            function createOrder() {
                var customerId = $('#customerId').val();
                var carId = $('#carId').val();
                var carPrice = document.getElementById("carPrice").innerHTML;
                var cusCCCD = document.getElementById("customerCCCD").value;
                var userEmail = document.getElementById("userEmail").value;

                checkHaveFiveNotDoneOrder(customerId)
                        .then(hasTooManyOrders => {
                            if (hasTooManyOrders) {
                                return; // Stop function execution if there are too many orders
                            }

                            // Proceed with order creation if check passes
                            $.ajax({
                                url: '/OrderController',
                                type: 'POST',
                                data: {createOrderEmp: "true", customer_id: customerId, car_id: carId, car_price: carPrice, cusCCCD: cusCCCD, userEmail: userEmail},
                                success: function (response) {
                                    if (response === true) {
                                        Swal.fire({
                                            title: 'Order Created Successfully!',
                                            text: 'The order has been created successfully.',
                                            icon: 'success',
                                            confirmButtonText: 'OK'
                                        }).then(() => {
                                            window.close(); // Close the webpage after success confirmation
                                        });
                                    } else {
                                        Swal.fire({
                                            title: 'Error',
                                            text: response.error || 'Failed to create order',
                                            icon: 'error',
                                            confirmButtonText: 'OK'
                                        });
                                    }
                                },
                                error: function () {
                                    Swal.fire('Error', 'Failed to create order', 'error');
                                }
                            });
                        })
                        .catch(error => {
                            console.error("Error:", error);
                        });
            }





            // Enable the order button only if both customer and car info are fetched
            function checkEnableOrderButton() {
                var customerFetched = $('#customerInfo').is(':visible');
                var carFetched = $('#carInfo').is(':visible');
                $('#confirmOrderBtn').prop('disabled', !(customerFetched && carFetched));
            }

            function checkHaveFiveNotDoneOrder(customer_id) {
                return new Promise((resolve, reject) => {
                    $.ajax({
                        url: "/OrderController",
                        type: "POST",
                        data: {checkHaveFiveNotDoneOrder: 'true', customer_id: customer_id},
                        success: function (response) {
                            if (response === true) {
                                Swal.fire({
                                    icon: 'warning',
                                    title: 'Too many orders',
                                    text: 'You need to pay or wait until the unfinished orders expire before placing another order. You can also go to the store to buy directly.',
                                    confirmButtonText: 'OK'
                                }).then(() => {
                                    resolve(true); // Resolve with true if there are too many orders
                                });
                            } else {
                                resolve(false); // Resolve with false if the user can create a new order
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching customer data: " + error);
                            reject(error); // Reject the promise if there's an error
                        }
                    });
                });
            }
        </script>
    </body>
</html>
