<%-- 
    Document   : wishlist
    Created on : 1 thg 11, 2024, 12:06:41
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <!-- Toastr CSS và JS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" />
        <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

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
            #carList .zoom-img {
                transition: transform 0.3s ease; /* Thêm hiệu ứng chuyển đổi */
            }

            #carList .card:hover .zoom-img {
                transform: scale(0.9); /* Zoom out ảnh khi hover */
            }

            #carList .card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
            }

            #carList .card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            #carList .card-img-top {
                height: 200px;
                object-fit: cover;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <!-- navBar -->
        <%@include file="navbar.jsp" %>
        <%    if (!role.equals("customer")) {
                response.sendRedirect("/");
            }
        %>
        <!-- wishlist -->
        <div class="container my-5">
            <h2 class="text-center mt-5 pt-5">Your Wishlist</h2>
            <div id="carList" class="row">
                <!-- Car items will be dynamically inserted here -->
            </div>
            <div id="noCarsMessage" class="text-center mt-4" style="display: none;">
                <h5>No Car In Wishlist</h5>
            </div>
            <nav aria-label="Page navigation" class="mt-4" id="paginationNav" style="display: none;">
                <ul class="pagination justify-content-center" id="pagination">
                    <!-- Pagination items will be dynamically inserted here -->
                </ul>
            </nav>
        </div>
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
        <script>
            $(document).ready(function () {
                fetchWishlistCars();
            });

            const itemsPerPage = 12;
            let carsData = [];

            function fetchWishlistCars() {
                var userEmail = document.getElementById("userEmail").value;
                $.ajax({
                    url: '/CustomerController', // Replace with your server endpoint
                    type: 'POST',
                    data: {getWishlistCars: 'true', userEmail: userEmail},
                    dataType: 'json',
                    success: function (cars) {
                        carsData = cars;
                        if (carsData.length === 0) {
                            $('#noCarsMessage').show();
                        } else {
                            renderPage(1); // Render the first page
                            setupPagination();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching wishlist cars:", error);
                    }
                });
            }

            function renderPage(page) {
                const startIndex = (page - 1) * itemsPerPage;
                const endIndex = startIndex + itemsPerPage;
                let pageContent = '';

                for (let i = startIndex; i < endIndex && i < carsData.length; i++) {
                    const car = carsData[i];

                    const carCard =
                            '<div class="col-xl-3 col-md-6 mb-4">' +
                            '<div class="card pb-3">' +
                            '<a class="text-decoration-none text-dark" href="/CarController/View/' + car.car_id + '">' +
                            '<img src="/ImageController/c/' + car.first_car_image_id + '" class="card-img-top zoom-img" alt="' + car.car_name + '" style="height: 250px;">' +
                            '<div class="card-body">' +
                            '<h5 class="card-title">' + car.car_name + '</h5>' +
                            '<p class="card-text">' + car.price + ' VND</p>' +
                            '</div>' +
                            '</a>' +
                            '<button type="button" class="btn btn-danger w-75 m-auto" onclick="removeFromWishlist(' + car.car_id + ')">Remove from Wishlist</button>' +
                            '</div>' +
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
                $('#paginationNav').show(); // Show pagination if there are cars
                setActivePage(1); // Set the first page as active
            }

            function setActivePage(page) {
                $('#pagination .page-item').removeClass('active');
                $('#pagination .page-item').eq(page - 1).addClass('active');
            }

            function removeFromWishlist(carId) {
                var userEmail = document.getElementById("userEmail").value;

                $.ajax({
                    url: '/WishlistController', // Replace with your server endpoint for removing car
                    type: 'POST',
                    data: {removeCar: 'true', car_id: carId, userEmail: userEmail},
                    success: function (response) {
                        if (response === true) {
                            toastr.success('Car removed from wishlist successfully!');
                            fetchWishlistCars();
                        } else {
                            toastr.error('Failed to remove car from wishlist. Please try again.');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error removing car from wishlist:", error);
                    }
                });
            }
        </script>
    </body>
</html>
