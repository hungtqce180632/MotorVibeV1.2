<%-- 
    Document   : editCar
    Created on : 17 thg 10, 2024, 15:33:30
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Car</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <!-- Quill Editor -->
        <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
        <style>
            #description {
                height: 200px;
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
                    }
                }
            }
            if (!isAdmin) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5">
            <h2 class="mb-4">Create New Car</h2>
            <form id="carForm" class="mb-5" action="/CarController" method="post" enctype="multipart/form-data">                
                <div class="mb-3">
                    <label for="car_name" class="form-label">Car Name</label>
                    <input type="text" class="form-control" id="car_name" name="car_name" required>
                </div>                
                <div class="mb-3">
                    <label for="date_start" class="form-label">Date Start</label>
                    <input readonly type="date" class="form-control" id="date_start" name="date_start" required>
                </div>
                <div class="mb-3">
                    <label for="color" class="form-label">Color</label>
                    <input type="text" class="form-control" id="color" name="color" required>
                </div>
                <div class="mb-3">
                    <label for="price" class="form-label">Price</label>
                    <input type="number" class="form-control" id="price" name="price" required>
                </div>
                <div class="mb-3">
                    <label for="quantity" class="form-label">Quantity</label>
                    <input type="number" class="form-control" id="quantity" name="quantity" required>
                </div>
                <div>
                    <label for="description" class="form-label">Description</label>
                    <div id="description"></div>
                    <input type="hidden" name="car_description" id="car_description">
                </div>
                <div class="mb-3">
                    <label for="brand_name" class="form-label">Brand Name</label>
                    <select class="form-select" id="brand_name" name="brand_name" required>
                        <option value="" disabled selected>Chọn thương hiệu</option>\
                    </select>
                </div>
                <div class="mb-3">
                    <label for="fuel_name" class="form-label">Fuel Name</label>
                    <select class="form-select" id="fuel_name" name="fuel_name" required>
                        <option value="" disabled selected>Chọn loại nhiên liệu</option>                        
                    </select>
                </div>                
                <div class="mb-3">
                    <label for="model_name" class="form-label">Model Name</label>
                    <select class="form-select" id="model_name" name="model_name" required>
                        <option value="" disabled selected>Chọn mẫu xe</option>                        
                    </select>
                </div>                
                <!-- Phần alert của bắt lỗi -->
                <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                    <p id="alertTxt" class="p-0 m-0"></p>
                    <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
                </div>
                <!-- Phần alert của bắt lỗi -->
                <button type="submit" class="btn btn-primary" name="editCar">Submit</button>
                <input hidden id="car_id" name="car_id">
            </form>
        </div>
        <script>
            var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
            var popoverList = popoverTriggerList.map(function (popoverTriggerEl) {
                return new bootstrap.Popover(popoverTriggerEl);
            });

            var toolbarOptions = [
                ['bold', 'italic', 'underline', 'strike'], // toggled buttons
                ['blockquote', 'code-block'],

                [{'header': 1}, {'header': 2}], // custom button values
                [{'list': 'ordered'}, {'list': 'bullet'}],
                [{'script': 'sub'}, {'script': 'super'}], // superscript/subscript
                [{'indent': '-1'}, {'indent': '+1'}], // outdent/indent
                [{'direction': 'rtl'}], // text direction

                [{'size': ['small', false, 'large', 'huge']}], // custom dropdown
                [{'header': [1, 2, 3, 4, 5, 6, false]}],

                [{'color': []}, {'background': []}], // dropdown with defaults from theme
                [{'font': []}],
                [{'align': []}],
                ['clean']                                         // remove formatting button
            ];

            var quill = new Quill('#description', {
                modules: {
                    toolbar: toolbarOptions
                },
                theme: 'snow'
            });

            $(document).ready(function () {
                // Đầu tiên, load các option cho select
                $.ajax({
                    url: "/CarController", // Đường dẫn tới CarController để lấy brands, models, fuels
                    type: "POST",
                    data: {getForCreate: 'true'}, // Thông tin để lấy dữ liệu cho các select
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (response) {
                        var brands = response.brands;
                        var models = response.models;
                        var fuels = response.fuels;

                        // Điền dữ liệu vào các select
                        $.each(brands, function (index, brand) {
                            var brandOption = '<option value="' + brand.brand_id + '">' + brand.brand_name + '</option>';
                            $('#brand_name').append(brandOption);
                        });

                        $.each(models, function (index, model) {
                            var modelOption = '<option value="' + model.model_id + '">' + model.model_name + '</option>';
                            $('#model_name').append(modelOption);
                        });

                        $.each(fuels, function (index, fuel) {
                            var fuelOption = '<option value="' + fuel.fuel_id + '">' + fuel.fuel_name + '</option>';
                            $('#fuel_name').append(fuelOption);
                        });

                        // Sau khi các select đã được điền dữ liệu, gọi hàm fetchCarById để lấy dữ liệu car
                        // Lấy URL hiện tại
                        var urlPath = window.location.pathname; // Lấy đường dẫn URL
                        var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'

                        // Giả sử eventId nằm ở phần thứ 4 trong mảng (index 3), điều chỉnh nếu cần
                        var carId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID sự kiện)
                        $('#car_id').val(carId);
                        fetchCarById(carId); // Gọi hàm để lấy dữ liệu sự kiện                        fetchCarById(carId); // Gọi hàm để lấy thông tin car và điền vào form

                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            });

            function fetchCarById(carId) {
                $.ajax({
                    url: '/CarController',
                    type: 'POST',
                    data: {carId: carId},
                    dataType: 'json',
                    success: function (car) {
                        console.log(car)
                        // Populate các input với dữ liệu car
                        $('#car_name').val(car.car_name);
                        $('#date_start').val(car.date_start);
                        $('#color').val(car.color);
                        $('#price').val(car.price);
                        quill.root.innerHTML = car.description;

                        // Set các option trong select đã được điền trước đó thành giá trị của car
                        $('#brand_name').val(car.brand_id); // Set đúng brand_id
                        $('#fuel_name').val(car.fuel_id);   // Set đúng fuel_id
                        $('#model_name').val(car.model_id); // Set đúng model_id
                        $('#quantity').val(car.quantity);
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching car data: ", error);
                    }
                });
            }


            document.getElementById('carForm').addEventListener('submit', function () {
                document.getElementById('car_description').value = quill.root.innerHTML;
            });

            document.getElementById("carForm").addEventListener("submit", function (event) {
                let dateStart = document.getElementById("date_start").value;
                let price = document.getElementById("price").value;
                let car_name = document.getElementById("car_name").value;
                let description = document.getElementById("car_description").value;
                let color = document.getElementById("color").value;
                let quantity = document.getElementById("quantity").value;

                // Kiểm tra car_name không vượt quá 255 ký tự
                if (car_name.length > 255) {
                    sendMessageError('Name cannot exceed 255 characters.');
                    event.preventDefault();
                }               

                // Kiểm tra color không vượt quá 255 ký tự
                if (color.length > 255) {
                    sendMessageError('Color cannot exceed 255 characters.');
                    event.preventDefault();
                }

                // Kiểm tra price không vượt quá 12 ký tự và lớn hơn 0
                if (price.length > 12) {
                    if (price < 0) {
                        sendMessageError('Price cannot exceed 12 characters and greater tahn 0.');
                        event.preventDefault();
                    }

                }

                // Kiểm tra quantity lớn hơn 0
                if (quantity < 0) {
                    sendMessageError('Quantity greater than 0.');
                    event.preventDefault();
                }

                // Kiểm tra description không vượt quá 65,535 ký tự
                if (description.length > 65535) {
                    sendMessageError('Description cannot exceed 65,535 characters.');
                    event.preventDefault();
                }
            });

            function hideAlert() {
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

