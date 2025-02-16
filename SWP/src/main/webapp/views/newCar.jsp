<%-- 
    Document   : newCar
    Created on : 17 thg 10, 2024, 23:48:22
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <style>
            .zoom-img {
                transition: transform 0.3s ease; /* Thêm hiệu ứng chuyển đổi */
            }

            .card:hover .zoom-img {
                transform: scale(1.1); /* Zoom out ảnh khi hover */
            }
        </style>
    </head>
    <body>
        <script>
            $(document).ready(function () {
                $.ajax({
                    url: '/HomePageController',
                    type: 'post',
                    data: {getNewCar: 'true'},
                    dataType: "json",
                    success: function (newCarList) {
                        $.each(newCarList, function (index, car) {
                            var inStock;
                            if (car.quantity > 0) {
                                inStock = '<span class="badge bg-success me-2">In Stock</span>';
                            } else {
                                inStock = '<span class="badge bg-danger me-2">Out of Stock</span>';
                            }
                            var carCard = '<div class="col-xl-3 col-md-6 mb-4"><a class="text-decoration-none text-dark" href="/CarController/View/' + car.car_id + '">' +
                                    '<div class="card pb-3">' +
                                    '<img src="/ImageController/c/' + car.first_car_image_id + '" class="card-img-top zoom-img" alt="' + car.car_name + '" style="height: 250px;">' +
                                    '<div class="card-body">' +
                                    '<h5 class="card-title">' + car.car_name + '</h5>' +
                                    '<p class="card-text">' + formatCurrency(car.price) + ' VND</p>' +
                                    '<p class="card-text">' + inStock + '</p>' +
                                    '</div>' +
                                    '</div>' +
                                    '</a></div>';
                            $('#newCar').append(carCard);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            });
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
        </script>

        <div class="row justify-content-center" id="newCar">

        </div>
    </body>
</html>
