<%-- 
    Document   : car
    Created on : 16 thg 10, 2024, 18:40:38
    Author     : thaii
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Car List</title>
        <!-- CSS Links -->
        <link
            href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css"
            rel="stylesheet">
        <link
            href="https://cdn.datatables.net/1.13.1/css/dataTables.bootstrap5.min.css"
            rel="stylesheet">
        <link
            href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css"
            rel="stylesheet">
        <style>
            .modal-body {
                word-break: break-all;
            }            
        </style>
    </head>
    <body>
        <!-- JavaScript Links -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script
        src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
        <script
        src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
        <script
        src="https://cdn.datatables.net/1.13.1/js/dataTables.bootstrap5.min.js"></script>
        <script
        src="https://cdn.datatables.net/responsive/2.4.1/js/dataTables.responsive.min.js"></script>
        <script
        src="https://cdn.datatables.net/responsive/2.4.1/js/responsive.bootstrap5.min.js"></script>

        <script>
            var carList = [];
            $(document).ready(function () {
                // Gọi AJAX để lấy dữ liệu sự kiện
                $.ajax({
                    url: "/CarController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchData: "true"},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (response) {
                        // Initialize DataTables after receiving data
                        var cars = response.cars;
                        var brands = response.brands;
                        var models = response.models;
                        var fuels = response.fuels;

                        $.each(cars, function (index, car) {
                            // Tìm brand_name từ brands dựa trên brand_id
                            var brand = brands.find(function (b) {
                                return b.brand_id === car.brand_id;
                            });
                            var brand_name = brand ? brand.brand_name : "Unknow Brand";

                            // Tìm model_name từ models dựa trên model_id
                            var model = models.find(function (m) {
                                return m.model_id === car.model_id;
                            });
                            var model_name = model ? model.model_name : "Unknown Model";

                            // Tìm fuel_name từ fuels dựa trên fuel_id
                            var fuel = fuels.find(function (f) {
                                return f.fuel_id === car.fuel_id;
                            });
                            var fuel_name = fuel ? fuel.fuel_name : "Unknown Fuel";

                            // Tạo đối tượng car mới với các giá trị đã thay thế
                            var updatedCar = {
                                car_id: car.car_id,
                                car_name: car.car_name,
                                brand_name: brand_name, // Thay thế brand_id bằng brand_name
                                model_name: model_name, // Thay thế model_id bằng model_name
                                date_start: car.date_start,
                                color: car.color,
                                price: car.price,
                                fuel_name: fuel_name, // Thay thế fuel_id bằng fuel_name
                                status: car.status,
                                description: car.description,
                                quantity: car.quantity
                            };

                            // Thêm car đã cập nhật vào danh sách carList
                            carList.push(updatedCar);
                        });
                        var table = $('#carsTable').DataTable({
                            responsive: true, // Bật chế độ responsive
                            data: carList, // Dữ liệu từ carList
                            columns: [
                                {data: 'car_id'},
                                {data: 'car_name'},
                                {data: 'brand_name'},
                                {data: 'model_name'},
                                {data: 'date_start'},
                                {data: 'color'},
                                {data: 'price'},
                                {data: 'quantity'},
                                {data: 'fuel_name'},
                                {
                                    data: null,
                                    render: function (row) {
                                        return '<button class="btn btn-link" data-bs-toggle="modal" data-bs-target="#descriptionCarModal' + row.car_id + '">View</button>';
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        return '<a class="btn btn-link" target="_blank" href="/CarController/ViewImage/' + row.car_id + '">View</a>';
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        return '<a target="_blank" href="/CarController/Edit/' + row.car_id + '" class="btn btn-primary me-2">Edit</a>' +
                                                (row.status ? '<a target="_blank" href="/CarController/Status/' + row.car_id + '" class="btn btn-danger">Disable</a>' : '<a target="_blank" href="/CarController/Status/' + row.car_id + '" class="btn btn-success">Active</a>');
                                    }
                                }
                            ]
                        });

                        // Xóa các modal cũ trước khi chèn mới
                        $('body').find('[id^="descriptionCarModal"]').remove(); // Xóa tất cả modals có id bắt đầu bằng 'descriptionCarModal'
//
                        carList.forEach(function (car) {
                            // Create modal for details
                            var detailsModal = '<div class="modal fade" id="descriptionCarModal' + car.car_id + '" tabindex="-1" aria-labelledby="descriptionCarModal' + car.car_id + '" aria-hidden="true">' +
                                    '<div class="modal-dialog modal-lg">' +
                                    '<div class="modal-content">' +
                                    '<div class="modal-header">' +
                                    '<h5 class="modal-title" id="descriptionCarModal' + car.car_id + '">' + car.car_name + '</h5>' +
                                    '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
                                    '</div>' +
                                    '<div class="modal-body">' +
                                    car.description +
                                    '</div>' +
                                    '</div>' +
                                    '</div>' +
                                    '</div>';

                            // Append modals to the body
                            $('body').append(detailsModal); // Append modal to body
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra: " + error);
                    }
                });
            });
        </script>

        <!-- Table Structure -->
        <table id="carsTable" class="table table-striped nowrap w-100 align-items-center">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th>Date Start</th>
                    <th>Color</th>
                    <th>Price</th>
                    <th>Quantity</th>
                    <th>Fuel</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="eventBody">
                <!-- Dữ liệu sẽ được chèn vào đây -->                
            </tbody>
        </table>       
    </body>
</html>
