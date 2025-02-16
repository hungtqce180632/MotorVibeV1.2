<%-- 
    Document   : createCar
    Created on : 17 thg 10, 2024, 00:18:53
    Author     : thaii
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Car</title>
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
                    <input type="date" class="form-control" id="date_start" name="date_start" required>
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
                <div class="mb-3">
                    <label for="car_image" class="form-label">Car Image</label>
                    <div class="d-flex">
                        <input class="form-control me-2" type="file" name="images" id="car_image" multiple>
                        <button type="button" class="btn btn-warning" data-bs-toggle="popover" title="Instructions for Uploading Multiple Images" data-bs-content="Hold down the Ctrl key when selecting multiple images. Maximum 9 picture."><i class="fa-solid fa-question"></i></button>    
                    </div>
                </div>                
                <!-- Phần alert của bắt lỗi -->
                <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                    <p id="alertTxt" class="p-0 m-0"></p>
                    <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
                </div>
                <!-- Phần alert của bắt lỗi -->
                <button type="submit" class="btn btn-primary" name="createCar">Submit</button>
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
                $.ajax({
                    url: "/CarController", // Đường dẫn tới EventController
                    type: "POST", // Phương thức HTTP GET
                    data: {getForCreate: 'true'}, // Gửi ID sự kiện
                    dataType: "json", // Định dạng dữ liệu trả về
                    success: function (response) {
                        var brands = response.brands;
                        var models = response.models;
                        var fuels = response.fuels;

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
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            });

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

                // Kiểm tra date_start không nhỏ hơn hôm nay
                const today = new Date();
                const curDate = today.toLocaleDateString('en-CA'); // 'en-CA' cho định dạng YYYY-MM-DD                                               
                if (dateStart < curDate) {
                    sendMessageError('The start date cannot be less than today.');
                    event.preventDefault();
                }

                // Kiểm tra color không vượt quá 255 ký tự
                if (color.length > 255) {
                    sendMessageError('Color cannot exceed 255 characters.');
                    event.preventDefault();
                }

                // Kiểm tra price không vượt quá 12 ký tự và lớn hơn 0
                if (price.length > 19) {
                    if (price < 0 && price > 8000000000000000000) {
                        sendMessageError('Price cannot exceed 19 characters and greater than 0 and less than 8,000,000,000,000,000,000.');
                        event.preventDefault();
                    }
                }

                // Kiểm tra price không vượt quá 12 ký tự và lớn hơn 0
                if (quantity < 0) {
                    sendMessageError('Quantity must greater than 0.');
                    event.preventDefault();
                }


                // Kiểm tra description không vượt quá 65,535 ký tự
                if (description.length > 65535) {
                    sendMessageError('Description cannot exceed 65,535 characters.');
                    event.preventDefault();
                }

                // KIểm tra ảnh
                const imageInput = document.getElementById("car_image");
                const files = imageInput.files;
                const maxFileSize = 16 * 1024 * 1024; // 16MB
                const allowedTypes = ['image/jpeg', 'image/png', 'image/gif']; // Các loại ảnh cho phép

                console.log(files.length);
                if (files.length > 9) {
                    sendMessageError('Maximum 12 images.');
                    event.preventDefault();
                }

                // Kiểm tra mỗi tệp
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];

                    // Kiểm tra kích thước tệp
                    if (file.size > maxFileSize) {
                        sendMessageError('File exceeds 16MB size limit.');
                        event.preventDefault();
                    }

                    // Kiểm tra loại tệp
                    if (!allowedTypes.includes(file.type)) {
                        sendMessageError('Please upload a valid image file (JPEG, PNG, or GIF).');
                        event.preventDefault();
                    }
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
