<%-- 
    Document   : bestSellCar
    Created on : 29 thg 10, 2024, 02:15:17
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    </head>
    <body>
        <div class="container my-5">
            <div id="carList" class="row">
                <!-- Car items will be dynamically inserted here -->
            </div>

            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center" id="pagination">
                    <!-- Pagination items will be dynamically inserted here -->
                </ul>
            </nav>
        </div>

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
                fetchBestSellingCars();
            });

            const itemsPerPage = 4;
            let carsData = [];

            function fetchBestSellingCars() {
                $.ajax({
                    url: '/HomePageController', // Replace with your server endpoint
                    type: 'POST',
                    data: {getBestSellingCars: 'true'},
                    dataType: 'json',
                    success: function (cars) {
                        carsData = cars;
                        renderPage(1); // Render the first page
                        setupPagination();
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching best selling cars:", error);
                    }
                });
            }

            function renderPage(page) {
                const startIndex = (page - 1) * itemsPerPage;
                const endIndex = startIndex + itemsPerPage;
                let pageContent = '';

                for (let i = startIndex; i < endIndex && i < carsData.length; i++) {
                    const car = carsData[i];

                    const inStock = car.quantity > 0 ?
                            '<span class="badge bg-success me-2">In Stock</span>' :
                            '<span class="badge bg-danger me-2">Out of Stock</span>';
                    const carCard =
                            '<div class="col-xl-3 col-md-6 mb-4">' +
                            '<a class="text-decoration-none text-dark" href="/CarController/View/' + car.car_id + '">' +
                            '<div class="card pb-3">' +
                            '<img src="/ImageController/c/' + car.first_car_image_id + '" class="card-img-top zoom-img" alt="' + car.car_name + '" style="height: 250px;">' +
                            '<div class="card-body">' +
                            '<h5 class="card-title">' + car.car_name + '</h5>' +
                            '<p class="card-text">' + formatCurrency(car.price) + ' VND</p>' +
                            '<p class="card-text">' + inStock + '</p>' +
                            '</div>' +
                            '</div>' +
                            '</a>' +
                            '</div>';

                    pageContent += carCard;
                }

                $('#carList').html(pageContent);
                setActivePage(page);
            }

            function setupPagination() {
                const totalPages = Math.ceil(carsData.length / itemsPerPage);
                let paginationContent = '';

                for (let i = 1; i <= totalPages; i++) {
                    paginationContent += '<li class="page-item"><a class="page-link" href="#" onclick="renderPage(' + i + '); return false;">' + i + '</a></li>';
                }

                $('#pagination').html(paginationContent);
                setActivePage(1); // Set the first page as active
            }

            function setActivePage(page) {
                $('#pagination .page-item').removeClass('active');
                $('#pagination .page-item').eq(page - 1).addClass('active');
            }
        </script>
    </body>
</html>
