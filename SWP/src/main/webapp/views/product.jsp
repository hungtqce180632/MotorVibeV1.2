<%@page import="Models.BrandModel"%>
<%@page import="Models.FuelModel"%>
<%@page import="Models.CarModel_Model"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Car Filter</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <style>
            .zoom-img {
                transition: transform 0.3s ease; /* Thêm hiệu ứng chuyển đổi */
            }

            .card:hover .zoom-img {
                transform: scale(0.9); /* Zoom out ảnh khi hover */
            }
        </style>
        <script>
            let currentPage = 1;
            const itemsPerPage = 12;
            let totalPages = 1;
            let carData = [];

            $(document).ready(function () {
                fetchCars(0, 0, 0);

                $('#brand, #fuel, #model').change(function () {
                    updateCars();
                    changePage(1); // cho nó quay về trang đầu tiên 
                });
            });

            function updateCars() {
                var brandId = $('#brand').val();
                var fuelId = $('#fuel').val();
                var modelId = $('#model').val();
                fetchCars(brandId, fuelId, modelId);
            }

            function fetchCars(brandId, fuelId, modelId) {
                $.ajax({
                    type: 'POST',
                    url: '/ProductController',
                    data: {brand_id: brandId, fuel_id: fuelId, model_id: modelId},
                    dataType: 'json',
                    success: function (cars) {
                        renderCarList(cars);
                    },
                    error: function () {
                        alert('Error fetching car data');
                    }
                });
            }

            function renderCarList(cars) {
                carData = cars;
                const carList = $('#carList');
                const pagination = $('#pagination');

                carList.empty();
                pagination.empty();

                totalPages = Math.ceil(carData.length / itemsPerPage);
                const start = (currentPage - 1) * itemsPerPage;
                const end = start + itemsPerPage;
                if (carData.length > 0) {
                    $.each(carData.slice(start, end), function (index, car) {
                        const inStock = car.quantity > 0 ?
                                '<span class="badge bg-success me-2">In Stock</span>' :
                                '<span class="badge bg-danger me-2">Out of Stock</span>';

                        carList.append(
                                '<div class="col-xl-3 col-md-4 col-sm-6 mb-4">' +
                                '<a class="text-decoration-none text-dark" href="/CarController/View/' + car.car_id + '">' +
                                '<div class="card pb-3">' +
                                '<img src="/ImageController/c/' + car.first_car_image_id + '" class="card-img-top zoom-img" alt="' + car.car_name + '" style="height: 250px;">' +
                                '<div class="card-body">' +
                                '<h5 class="card-title">' + car.car_name + '</h5>' +
                                '<p class="card-text">' + car.price + ' VND</p>' +
                                '<p class="card-text">' + inStock + '</p>' +
                                '</div>' +
                                '</div>' +
                                '</a>' +
                                '</div>'
                                );
                    });
                } else {
                    carList.append('<li class="text-center"><h2>No cars found</h2></li>');
                }

                renderPagination();
            }

            function renderPagination() {
                const pagination = $('#pagination');
                pagination.empty();

                pagination.append(
                        '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" aria-label="Previous" onclick="changePage(' + (currentPage - 1) + ')">' +
                        '<span aria-hidden="true">&laquo;</span>' +
                        '</a>' +
                        '</li>'
                        );

                for (let i = 1; i <= totalPages; i++) {
                    pagination.append(
                            '<li class="page-item ' + (currentPage === i ? 'active' : '') + '">' +
                            '<a class="page-link" href="#" onclick="changePage(' + i + ')">' + i + '</a>' +
                            '</li>'
                            );
                }

                pagination.append(
                        '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" aria-label="Next" onclick="changePage(' + (currentPage + 1) + ')">' +
                        '<span aria-hidden="true">&raquo;</span>' +
                        '</a>' +
                        '</li>'
                        );
            }

            function changePage(page) {
                if (page >= 1 && page <= totalPages) {
                    currentPage = page;
                    renderCarList(carData);
                }
            }


        </script>

    </head>
    <body>
        <!-- navBar -->
        <%@include file="navbar.jsp" %>

        <div class="container-fluid mt-5 pt-5">
            <h1 class="text-center mb-5">Filter Cars</h1>
            <div class="container px-5 mb-5">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="brand">Brand:</label>
                        <select class="form-select" name="brand_id" id="brand">
                            <option value="0">None</option>
                            <%                    List<BrandModel> brands = (List<BrandModel>) request.getAttribute("brands");
                                if (brands != null) {
                                    for (BrandModel brand : brands) {
                            %>
                            <option value="<%= brand.getBrand_id()%>"><%= brand.getBrand_name()%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="fuel">Fuel Type:</label>
                        <select class="form-select" name="fuel_id" id="fuel">
                            <option value="0">None</option>
                            <%
                                List<FuelModel> fuels = (List<FuelModel>) request.getAttribute("fuels");
                                if (fuels != null) {
                                    for (FuelModel fuel : fuels) {
                            %>
                            <option value="<%= fuel.getFuel_id()%>"><%= fuel.getFuel_name()%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="model">Model:</label>
                        <select class="form-select" name="model_id" id="model">
                            <option value="0">None</option>
                            <%
                                List<CarModel_Model> models = (List<CarModel_Model>) request.getAttribute("models");
                                if (models != null) {
                                    for (CarModel_Model model : models) {
                            %>
                            <option value="<%= model.getModel_id()%>"><%= model.getModel_name()%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </div>
                </div>
            </div>

            <h1 class="text-center mb-5">Car List</h1>
            <div class="container">
                <ul class="row justify-content-center list-unstyled text-center" id="carList">
                    <!-- Car list will be populated here -->
                </ul>
                <nav aria-label="Car-list-pagination">
                    <ul class="pagination justify-content-center" id="pagination">
                        <!-- Pagination buttons will be populated here -->
                    </ul>
                </nav>
            </div>

        </div>
    </body>
</html>
