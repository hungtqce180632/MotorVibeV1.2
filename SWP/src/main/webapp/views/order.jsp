<%-- 
    Document   : order
    Created on : 23 thg 10, 2024, 16:39:34
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        <!-- Toastr CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
        <!-- Toastr JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

        <!-- SweetAlert2 CSS -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <!-- SweetAlert2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>

        <title>Create Order</title>
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
            .custom-checkbox {
                margin-top: 20px;
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

            // Kiểm tra nếu cookie "userEmail" tồn tại
            if (userEmail == null || role == null || !role.equals("customer")) {
                response.sendRedirect("/HomePageController/Login");
            }
        %>
        <div class="container mt-5">
            <h1 class="mb-4 text-center">Car Order Summary</h1>

            <!-- Car and Customer Information -->
            <div class="row">
                <!-- Car Details Section -->
                <div class="col-md-6 mb-4">
                    <div class="order-summary">
                        <h4 class="mb-4">Car Details</h4>
                        <div class="text-center mb-4">
                            <img id="carImage" src="" alt="Car Image" class="car-image rounded">
                        </div>
                        <div>
                            <h5><strong>Car Name:</strong> <span id="carName">Car Name</span></h5>
                            <p><strong>Brand:</strong> <span id="carBrand">Brand</span></p>
                            <p><strong>Model:</strong> <span id="carModel">Model</span></p>
                            <p><strong>Fuel:</strong> <span id="carFuel">Fuel</span></p>
                            <p><strong>Color:</strong> <span id="carColor">Color</span></p>
                            <p><strong>Quantity:</strong> <span id="carQuantity">1</span></p>
                            <p><strong>Price:</strong> $<span id="carPrice">0</span></p>
                        </div>
                    </div>
                </div>

                <!-- Customer Information and Payment Section -->
                <div class="col-md-6">
                    <div class="order-summary">
                        <h4 class="mb-4">Customer Information</h4>

                        <div class="mb-3">
                            <label for="customerName" class="form-label"><strong>Name</strong></label>
                            <input type="text" class="form-control" id="customerName" placeholder="Enter your name" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="customerEmail" class="form-label"><strong>Email</strong></label>
                            <input type="email" class="form-control" id="customerEmail" placeholder="Enter your email" readonly>
                        </div>                            
                        <div class="mb-3">
                            <label for="customerPhone" class="form-label"><strong>Phone Number</strong></label>
                            <input type="text" class="form-control" id="customerPhone" name="customerPhone" placeholder="Enter your phone number" required>
                        </div>
                        <div class="mb-3">
                            <label for="customerID" class="form-label"><strong>Citizen Identification</strong></label>
                            <input type="text" class="form-control" id="customerID" name="customerID" placeholder="Enter your ID" required>
                        </div>
                        <div class="mb-3">
                            <label for="customerAddress" class="form-label"><strong>Address</strong></label>
                            <textarea class="form-control" id="customerAddress" name="customerAddress" rows="3" placeholder="Enter your address" required></textarea>
                        </div>                            

                    </div>

                    <div class="order-summary mt-4">
                        <h4 class="mb-3">Deposit Details</h4>
                        <p><strong>Deposit Amount (5% of Car Price):</strong> $<span id="depositAmount">0</span></p>
                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#qrModal">QR Code</button>
                    </div>
                </div>
            </div>

            <!-- Checkbox for Agreement -->
            <!-- Phần alert của bắt lỗi -->
            <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                <p id="alertTxt" class="p-0 m-0"></p>
                <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
            </div>
            <!-- Phần alert của bắt lỗi -->
            <div class="custom-checkbox text-center">
                <input type="checkbox" id="agreementCheckbox">
                <label for="agreementCheckbox">I have made the payment and agree to the <a href="/HomePageController/Term" target="_blank">terms & policy</a></label>
            </div>

            <!-- Action Buttons -->
            <div class="text-center mt-4">
                <button type="submit" onclick="createOrder()" id="confirmOrderBtn" class="btn btn-success btn-lg" disabled name="createOrder">Confirm Order</button>
                <button class="btn btn-outline-secondary btn-lg ms-3">Cancel</button>
            </div>
        </div>



        <!-- QR Code Modal -->
        <div class="modal fade" id="qrModal" tabindex="-1" aria-labelledby="qrModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="qrModalLabel">Scan to Pay</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body text-center">
                        <p class="mt-3"><strong>Scan the QR code to complete the payment using the format (Full Name)_(Car Name)_(Deposit/All), for example: Nguyen Van A_Car AAA_Deposit. Please contact us directly if any issues occur.</strong></p>
                        <img src="/ImageController/a/vcb.jpg" alt="QR Code for Payment" class="img-fluid rounded">
                    </div>
                </div>
            </div>
        </div>
        <input id="car_id" value="" hidden>
        <input id="customer_id" value="" hidden>
        <script>
            // Hàm lấy thông tin xe và khách hàng
            function fetchCarById(carId) {
                $.ajax({
                    url: '/CarController', // Gửi yêu cầu tới server
                    type: 'POST', // Sử dụng phương thức POST
                    data: {car_id_details: carId}, // Gửi carId để lấy dữ liệu chi tiết của xe
                    dataType: 'json', // Định dạng dữ liệu trả về là JSON
                    success: function (response) {
                        // Kiểm tra nếu dữ liệu xe được trả về
                        if (response.car) {
                            const car = response.car;
                            // Điền thông tin của xe vào các thẻ HTML tương ứng
                            $('#car_id').val(car.car_id);
                            // Tên xe
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

                            //Color
                            $('#carColor').text(car.color);

                            // Giá xe
                            $('#carPrice').text(car.price);

                            $('#carImage').attr('src', '/ImageController/co/' + car.car_id);
                            updateDepositAmount();
                        } else {
                            console.error("Car data is not available in the response");
                        }

                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching car data: ", error);
                    }
                });
            }

            function fetchCustomerData() {
                var userEmail = document.getElementById('userEmail').value;
                $.ajax({
                    url: "/CustomerController", // Đường dẫn đến CustomerController
                    type: "POST", // Phương thức HTTP GET
                    data: {getInforUser: userEmail}, // Gửi email
                    dataType: "json", // Định dạng dữ liệu trả về
                    success: function (customer) {
                        $('#customer_id').val(customer.customer_id);
                        $('#customerName').val(customer.name);
                        $('#customerPhone').val(customer.phone_number);
                        $('#customerEmail').val(customer.email);
                        $('#customerID').val(customer.cus_id_number);
                        $('#customerAddress').val(customer.address);
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu khách hàng: " + error);
                    }
                });
            }

            // Tính giá đặt cọc (5% giá trị xe)
            function updateDepositAmount() {
                var carPrice = parseFloat(document.getElementById('carPrice').innerText);
                var depositAmount = carPrice * 0.05;
                document.getElementById('depositAmount').innerText = depositAmount.toFixed(2);
            }

            // Kích hoạt nút "Confirm Order" khi người dùng chọn checkbox
            var agreementCheckbox = document.getElementById('agreementCheckbox');
            var confirmOrderBtn = document.getElementById('confirmOrderBtn');

            agreementCheckbox.addEventListener('change', function () {
                confirmOrderBtn.disabled = !this.checked; // Kích hoạt nút nếu đã chọn
            });

            // Thực hiện gọi dữ liệu khi trang tải
            $(document).ready(function () {
                var urlPath = window.location.pathname; // Lấy đường dẫn URL
                var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'
                var carId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID xe)

                fetchCarById(carId);
                fetchCustomerData();
            });

            function createOrder() {
                if (!validateInputs()) {
                    return; // Stop if validation fails
                }

                var car_id = document.getElementById("car_id").value;
                var customer_id = document.getElementById("customer_id").value;
                var customer_cccd = document.getElementById("customerID").value;
                var customer_phone = document.getElementById("customerPhone").value;
                var customer_address = document.getElementById("customerAddress").value;
                var car_price = parseFloat($("#carPrice").text());

                checkHaveFiveNotDoneOrder(customer_id)
                        .then(banCreateOrder => {
                            if (banCreateOrder) {
                                // Stop function execution if there are too many orders
                                return;
                            }

                            // Proceed with order creation if check passes
                            $.ajax({
                                url: "/OrderController",
                                type: "POST",
                                data: {
                                    createOrder: 'true',
                                    car_id: car_id,
                                    customer_id: customer_id,
                                    customer_cccd: customer_cccd,
                                    customer_phone: customer_phone,
                                    customer_address: customer_address,
                                    car_price: car_price
                                },
                                success: function (response) {
                                    $("body").css("pointer-events", "none");

                                    toastr.success('Your order has been successfully created.', 'Success!', {
                                        timeOut: 3000 // Auto-close after 3 seconds
                                    });

                                    setTimeout(function () {
                                        $("body").css("pointer-events", "auto"); // Re-enable interactions
                                        window.close(); // Close the page
                                    }, 3000);
                                },
                                error: function (xhr, status, error) {
                                    console.error("Error creating order: " + error);
                                }
                            });
                        })
                        .catch(error => {
                            console.error("Error:", error);
                        });
            }



            function hideAlert() {
                var alertElement = document.getElementById('alertError');
                alertElement.classList.add('d-none');
            }
            function validateInputs() {
                var customer_cccd = document.getElementById("customerID").value;
                var customer_phone = document.getElementById("customerPhone").value;
                var customer_address = document.getElementById("customerAddress").value;

                // Kiểm tra customer_phone
                if (!/^\d{10}$/.test(customer_phone)) {
                    sendMessageError("Phone number must be numeric and 10 characters.");
                    return false; // Dừng lại nếu lỗi
                }

                // Kiểm tra customer_cccd
                if (!/^\d{12}$/.test(customer_cccd)) {
                    sendMessageError("CCCD must be a number and 12 characters.");
                    return false; // Dừng lại nếu lỗi
                }

                // Kiểm tra customer_address
                if (customer_address.length > 255) {
                    sendMessageError("Address cannot exceed 255 characters.");
                    return false; // Dừng lại nếu lỗi
                }

                // Nếu không có lỗi
                return true;
            }

            function sendMessageError(mess) {
                const alertText = document.getElementById('alertTxt');
                const alertError = document.getElementById('alertError');
                alertError.classList.remove("d-none");
                alertText.innerHTML = mess;
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
