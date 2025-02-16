<%-- 
    Document   : orderAdmin
    Created on : 26 thg 10, 2024, 00:17:37
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order List</title>
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
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
            function formatDate(dateString) {
                // Tách chuỗi ngày thành các phần
                const parts = dateString.split('-');
                // Đảm bảo rằng chúng ta có 3 phần
                if (parts.length === 3) {
                    const year = parts[0];
                    const month = parts[1];
                    const day = parts[2];
                    // Trả về định dạng dd-mm-yyyy
                    return day + '-' + month + '-' + year;
                }
                return dateString; // Trả về giá trị gốc nếu không phải định dạng đúng
            }

            function getOrder() {
                const today = new Date();
                const todayFormatted = today.getFullYear() + '-' +
                        String(today.getMonth() + 1).padStart(2, '0') + '-' +
                        String(today.getDate()).padStart(2, '0'); // Định dạng 'yyyy-mm-dd'

                $.ajax({
                    url: "/OrderController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchData: "true"},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (orders) {
                        // Initialize DataTables after receiving data
                        var table = $('#ordersTable').DataTable({
                            responsive: true,
                            data: orders,
                            columns: [
                                {data: 'order_id'},
                                {data: 'customer_id'},
                                {data: 'employee_id'},
                                {data: 'car_id'},
                                {data: 'create_date'},
                                {data: 'payment_method'},
                                {data: 'date_start'},
                                {data: 'date_end'},
                                {data: 'total_amount'},
                                {data: 'deposit_status'},
                                {data: 'order_status'},
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';

                                        if (row.date_end < todayFormatted && (!row.order_status || !row.deposit_status)) {
                                            html += '<p class="text-danger fw-bold m-0 p-0 fs-5">Expired</p>';
                                            return html;
                                        }

                                        if (!row.deposit_status) {
                                            html += '<a href="#" class="btn btn-primary me-2" ' +
                                                    'onclick="return showConfirmationDeposit(' + row.order_id + ')">Deposit</a>';
                                        }

                                        if (!row.order_status && row.deposit_status) {
                                            html += '<a href="#" class="btn btn-primary me-2" ' +
                                                    'onclick="return showConfirmationOrder(' + row.order_id + ')">Order</a>';
                                        }

                                        if (row.order_status && row.deposit_status) {
                                            html += '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>';
                                        }

                                        return html;
                                    }
                                }
                            ]
                        });

                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra: " + error);
                    }
                });
            }

            $(document).ready(function () {
                getOrder();
            });

            // Hàm xác nhận Deposit
            function showConfirmationDeposit(orderId) {
                Swal.fire({
                    title: 'Confirm order has been deposited',
                    text: "Are you sure you want to confirm? Once changed, it cannot be edited.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Agree',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "/OrderController", // URL của Servlet
                            type: "POST", // Phương thức HTTP POST
                            data: {changeDeposit: "true", orderId: orderId},
                            dataType: "json", // Định dạng dữ liệu trả về là JSON
                            success: function (response) {
                                if (response === true) {
                                    Swal.fire({
                                        title: 'Success!',
                                        text: 'Deposit changed successfully.',
                                        icon: 'success',
                                        confirmButtonText: 'OK'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            $('#ordersTable').DataTable().clear().destroy();
                                            getOrder();
                                        }
                                    });
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("Có lỗi xảy ra: " + error);
                            }
                        });
                    }
                });
            }

            // Hàm xác nhận Order
            function showConfirmationOrder(orderId) {
                Swal.fire({
                    title: 'Confirm order has been done',
                    text: "Are you sure you want to confirm? Once changed, it cannot be edited.",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Agree',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: "/OrderController", // URL của Servlet
                            type: "POST", // Phương thức HTTP POST
                            data: {changeOrder: "true", orderId: orderId},
                            dataType: "json", // Định dạng dữ liệu trả về là JSON
                            success: function (response) {
                                if (response === true) {
                                    Swal.fire({
                                        title: 'Success!',
                                        text: 'Order changed successfully.',
                                        icon: 'success',
                                        confirmButtonText: 'OK'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            $('#ordersTable').DataTable().clear().destroy();
                                            getOrder();
                                        }
                                    });
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error("Có lỗi xảy ra: " + error);
                            }
                        });
                    }
                });
            }
        </script>

        <!-- Table Structure -->
        <table id="ordersTable" class="table table-striped nowrap w-100" style="width: 100%;">
            <thead>
                <tr>
                    <th>OrderID</th>
                    <th>CusID</th>
                    <th>EmpID</th>
                    <th>CarID</th>
                    <th>Create Date</th>
                    <th>Pay Method</th>
                    <th>Start</th>
                    <th>End</th>
                    <th>Total</th>
                    <th>Deposit</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <!-- Dữ liệu sẽ được chèn vào đây -->                
            </tbody>
        </table>
    </body>
</html>
