<%-- 
    Document   : carViews
    Created on : 21 thg 10, 2024, 11:02:45
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
        <!-- Toastr CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
        <!-- Toastr JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

        <!-- SweetAlert CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
        <!-- SweetAlert JS -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
        <title>View Car</title>
        <style>
            body {
                background-color: #f8f9fa;
            }
            .product-img {
                width: 100%;
                height: auto;
                object-fit: cover;
                border-radius: 10px;
                box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            }
            .card {
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
            }
            .btn-custom {
                border-radius: 50px;
            }
            .nav-side {
                position: fixed;
                top: 20%;
                width: 200px;
                padding: 20px;
                background-color: #fff;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                border-radius: 10px;
            }
            .nav-left {
                left: 20px;
            }
            .nav-right {
                right: 20px;
            }

            a{
                text-decoration: none;
            }

            #relatedCar .zoom-img {
                transition: transform 0.3s ease; /* Thêm hiệu ứng chuyển đổi */
            }

            #relatedCar .card:hover .zoom-img {
                transform: scale(1.1); /* Zoom out ảnh khi hover */
            }

            #relatedCar .card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
            }

            #relatedCar .card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            #relatedCar .card-img-top {
                height: 200px;
                object-fit: cover;
            }
            *{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                justify-content: center;
            }
            .star-rating input {
                display: none;
            }
            .star-rating label {
                font-size: 1.5rem;
                color: #ddd;
                cursor: pointer;
            }
            .star-rating input:checked ~ label, .star-rating label:hover, .star-rating label:hover ~ label {
                color: #f39c12;
            }
        </style>
    </head>
    <body>
        <!-- navBar -->
        <%@include file="navbar.jsp" %>

        <!-- Xem thông tin -->
        <div class="container-fluid p-0 pt-5 mt-5">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="card p-4">
                        <div class="row">                     

                            <div class="col-md-5">
                                <div id="carouselExampleIndicators" class="carousel slide carousel-dark" data-bs-ride="carousel">
                                    <div class="carousel-indicators" id="carousel-indicators">
                                        <!-- Các nút điều hướng sẽ được thêm động tại đây -->
                                    </div>
                                    <div class="carousel-inner" id="carousel-inner">
                                        <!-- Các carousel-item sẽ được thêm động tại đây -->
                                    </div>
                                    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <h2 class="fw-bold" id="car_name">Car Name</h2>
                                <p class="text-muted">Brand: <span id="brand_name"></span></p>
                                <p class="text-muted">Model: <span id="model_name"></span></p>
                                <p class="text-muted">Fuel Type: <span id="fuel_name"></span></p>
                                <p class="text-muted">Color: <span id="color"></span></p>
                                <h4 class="text-primary mb-4" id="price"></h4>
                                <div id="description"></div>
                                <div class="mb-4">
                                    <span class="badge bg-success me-2" id="stock_status">In Stock</span>                                    
                                </div>
                                <div id="buy" class="mb-3">
                                </div>
                                <div id="wishlist">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Related Products Section -->
                    <div class="mt-4 p-3">
                        <h4 class="fw-bold mb-3 text-center">Related Products</h4>
                        <div class="row m-0 p-0 justify-content-center" id="relatedCar">
                            <!-- Related Product 1 -->

                        </div>
                    </div>
                </div>
            </div>
            <!-- Review -->

            <div class="container justify-content-center">                
                <%@include file="/views/review.jsp" %>
            </div>

            <!-- Footer -->
            <footer class="bg-dark text-white py-4">
                <div class="container">
                    <%@include file="/views/footer.jsp" %>
                </div>
            </footer>
            <!-- Script -->
            <script>
                function formatCurrency(number) {
                    // Ensure the number has two decimal places
                    var decimalPart = (number % 1).toFixed(2).split('.')[1];

                    // Get the integer part of the number and convert it to a string
                    var integerPart = Math.floor(number).toString();

                    // Add thousand separator (dot) for the integer part
                    var formattedIntegerPart = '';
                    while (integerPart.length > 3) {
                        formattedIntegerPart = '.' + integerPart.slice(-3) + formattedIntegerPart;
                        integerPart = integerPart.slice(0, integerPart.length - 3);
                    }
                    formattedIntegerPart = integerPart + formattedIntegerPart;

                    // Return the formatted string with comma separating the integer and decimal parts
                    return formattedIntegerPart + ',' + decimalPart;
                }

                $(document).ready(function () {
                    // Khi trang load, thực hiện AJAX để lấy thông tin xe
                    $.ajax({
                        url: "/CarController", // Đường dẫn tới CarController để lấy thông tin xe
                        type: "POST",
                        data: {getForCreate: 'true'}, // Thông tin để lấy dữ liệu của xe
                        dataType: "json", // Định dạng dữ liệu trả về là JSON
                        success: function (response) {
                            // Giả sử response trả về dữ liệu của xe cùng với các thuộc tính liên quan
                            var car = response.car;

                            // Sau khi các select đã được điền dữ liệu, gọi hàm fetchCarById để lấy dữ liệu car
                            // Lấy URL hiện tại
                            var urlPath = window.location.pathname; // Lấy đường dẫn URL
                            var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'
                            var carId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID xe)

                            // Gọi hàm fetchCarById để lấy thông tin chi tiết về xe
                            fetchCarById(carId);
                            getCarImageId(carId);
                            checkCusHaveOrder(carId);
                            fetchReviews(carId);
                        },
                        error: function (xhr, status, error) {
                            console.error("Có lỗi xảy ra khi lấy dữ liệu xe: " + error);
                        }
                    });
                });

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
                                // Tên xe
                                $('#car_name').text(car.car_name);

                                // Thông tin thương hiệu, model và loại nhiên liệu
                                let brandName = 'N/A';
                                response.brands.forEach(function (brand) {
                                    if (brand.brand_id === car.brand_id) {
                                        brandName = brand.brand_name;
                                    }
                                });
                                getRelatedCar(car.brand_id);
                                $('#brand_name').text(brandName);

                                let modelName = 'N/A';
                                response.models.forEach(function (model) {
                                    if (model.model_id === car.model_id) {
                                        modelName = model.model_name;
                                    }
                                });
                                $('#model_name').text(modelName);

                                let fuelName = 'N/A';
                                response.fuels.forEach(function (fuel) {
                                    if (fuel.fuel_id === car.fuel_id) {
                                        fuelName = fuel.fuel_name;
                                    }
                                });
                                $('#fuel_name').text(fuelName);

                                //Color
                                $('#color').text(car.color);

                                // Giá xe
                                $('#price').text('VND ' + formatCurrency(car.price));

                                // Mô tả xe
                                var desc = document.getElementById("description");
                                desc.innerHTML = car.description;
                                var role = document.getElementById('role').value;
                                // Tình trạng kho (In Stock hoặc Out of Stock)
                                if (car.quantity > 0) {
                                    $('#stock_status').text('In Stock').removeClass('bg-danger').addClass('bg-success');
                                    //Buy btn
                                    var buyBtn;
                                    if (role !== 'customer') {
                                        buyBtn = '<a target="_blank" href="/OrderController/Buy/' + car.car_id + '" class="btn btn-primary btn-custom px-4 disabled">Buy</a>';
                                    } else {
                                        buyBtn = '<a target="_blank" href="/OrderController/Buy/' + car.car_id + '" class="btn btn-primary btn-custom px-4">Buy</a>';
                                    }
                                    $('#buy').append(buyBtn);

                                } else {
                                    $('#stock_status').text('Out of Stock').removeClass('bg-success').addClass('bg-danger');
                                    //Buy btn                                    
                                    var buyBtn = '<a target="_blank" href="/OrderController/Buy/' + car.car_id + '" class="btn btn-primary btn-custom px-4 disabled">Buy</a>';
                                    $('#buy').append(buyBtn);
                                }

                                if (role === 'customer') {
                                    $('#wishlist').append('<button id="add-to-wishlist" class="btn btn-info rounded-pill text-white" data-car-id="' + car.car_id + '">Add to Wishlist</button>');
                                }

                            } else {
                                console.error("Car data is not available in the response");
                            }

                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching car data: ", error);
                        }
                    });
                }


                function getCarImageId(carId) {
                    $.ajax({
                        url: '/CarController',
                        type: 'POST',
                        data: {getCarImg: 'true', carImageId: carId},
                        dataType: "json",
                        success: function (imgIdList) {
                            // Xóa các phần tử cũ (nếu có) trước khi thêm mới
                            $('#carousel-indicators').empty();
                            $('#carousel-inner').empty();

                            $.each(imgIdList, function (index, imageId) {
                                // Thêm các chỉ số (indicators) cho carousel
                                var indicator =
                                        '<button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="' + index + '" ' +
                                        (index === 0 ? 'class="active" aria-current="true"' : '') +
                                        ' aria-label="Slide ' + (index + 1) + '"></button>';

                                $('#carousel-indicators').append(indicator);

                                // Thêm các carousel-item tương ứng với từng ảnh
                                var carouselItem =
                                        '<div class="carousel-item ' + (index === 0 ? 'active' : '') + '">' +
                                        '<img src="/ImageController/c/' + imageId + '" class="d-block w-100" alt="Car ' + carId + '" style="object-fit: cover; height: 500px;">' +
                                        '</div>';

                                $('#carousel-inner').append(carouselItem);
                            });
                        },
                        error: function (xhr, status, error) {
                            console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: ", error);
                            console.log("Response từ server: ", xhr.responseText);
                        }
                    });
                }

                function getRelatedCar(brand_id) {
                    $.ajax({
                        url: '/CarController',
                        type: 'post',
                        data: {getRelatedCar: brand_id},
                        dataType: "json",
                        success: function (newCarList) {
                            $.each(newCarList, function (index, car) {
                                var inStock;
                                if (car.quantity > 0) {
                                    inStock = '<span class="badge bg-success me-2">In Stock</span>';
                                } else {
                                    inStock = '<span class="badge bg-danger me-2">Out of Stock</span>';
                                }
                                var carCard = '<div class="col-xl-3 col-md-5 mb-4"><a class="text-decoration-none text-dark" href="/CarController/View/' + car.car_id + '">' +
                                        '<div class="card pb-3">' +
                                        '<img src="/ImageController/c/' + car.first_car_image_id + '" class="card-img-top zoom-img" alt="' + car.car_name + '" style="height: 250px;">' +
                                        '<div class="card-body">' +
                                        '<h5 class="card-title">' + car.car_name + '</h5>' +
                                        '<p class="card-text">' + formatCurrency(car.price) + ' VND</p>' +
                                        '<p class="card-text">' + inStock + '</p>' +
                                        '</div>' +
                                        '</div>' +
                                        '</a></div>';
                                $('#relatedCar').append(carCard);
                            });
                        },
                        error: function (xhr, status, error) {
                            console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                        }
                    });
                }

                $(document).on('click', '#add-to-wishlist', function () {
                    const carId = $(this).data('car-id'); // Lấy car_id từ thuộc tính data
                    var userEmail = $('#userEmail').val();
                    // Gửi yêu cầu thêm vào wishlist đến server
                    $.ajax({
                        url: '/WishlistController',
                        method: 'POST',
                        data: {car_id: carId, userEmail: userEmail, addWish: 'true'},
                        success: function (response) {
                            if (response === true) {
                                toastr.success('Car added to wishlist successfully!');
                            } else {
                                toastr.error('Unable to add vehicle to wishlist. Or car is already in wishlist.');
                            }
                        },
                        error: function () {
                            toastr.error('An error occurred. Please try again.');
                        }
                    });
                });
            </script>
    </body>
</html>
