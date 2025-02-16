<%-- 
    Document   : orderCustomer
    Created on : 30 thg 10, 2024, 22:52:53
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Customer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <link rel="icon" href="${host}/ImageController/logo.png" type="image/x-icon">
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
    </head>
    <body class="d-flex flex-column min-vh-100">
        <!-- JavaScript Links -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script
        src="https://cdn.datatables.net/1.13.1/js/jquery.dataTables.min.js"></script>
        <script
        src="https://cdn.datatables.net/1.13.1/js/dataTables.bootstrap5.min.js"></script>
        <script
        src="https://cdn.datatables.net/responsive/2.4.1/js/dataTables.responsive.min.js"></script>
        <script
        src="https://cdn.datatables.net/responsive/2.4.1/js/responsive.bootstrap5.min.js"></script>


        <%@include file="navbar.jsp" %>
        <%    if (!role.equals("customer")) {
                response.sendRedirect("/");
            }
        %>
        <!-- Modal tìm kiếm -->
        <div class="modal fade p-0 m-0" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="searchModalLabel">Tìm Kiếm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="searchForm">
                            <div class="input-group">
                                <input type="text" class="form-control" placeholder="Nhập từ khóa tìm kiếm..." aria-label="Search">
                                <button class="btn btn-outline-secondary" type="submit">Tìm</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Order Table -->
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
            $(document).ready(function () {
                const today = new Date();
                const todayFormatted = today.getFullYear() + '-' +
                        String(today.getMonth() + 1).padStart(2, '0') + '-' +
                        String(today.getDate()).padStart(2, '0'); // Định dạng 'yyyy-mm-dd'
                const userEmail = $('#userEmail').val();
                $.ajax({
                    url: "/OrderController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchDataForCustomer: "true", userEmail: userEmail},
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
                                {
                                    data: 'deposit_status',
                                    render: function (data) {
                                        return data ? '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>' : '<p class="text-secondary fw-bold m-0 p-0 fs-5">Not Done</p>';
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';

                                        if (row.date_end < todayFormatted && (!row.order_status || !row.deposit_status)) {
                                            html += '<p class="text-danger fw-bold m-0 p-0 fs-5">Expired</p>';
                                            return html;
                                        }

                                        if (row.order_status && row.deposit_status) {
                                            html += '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>';
                                        } else {
                                            html += '<p class="text-secondary fw-bold m-0 p-0 fs-5">Not Done</p>';
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
            });
        </script>

        <!-- Table Structure -->
        <div class="container my-5 pt-5">
            <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#qrModal">QR Code</button>
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
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được chèn vào đây -->                
                </tbody>
            </table>
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
        </div>
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
    </body>
</html>
