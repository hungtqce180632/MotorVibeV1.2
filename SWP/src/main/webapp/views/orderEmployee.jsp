<%-- 
    Document   : orderEmployee
    Created on : 28 thg 10, 2024, 22:57:31
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Employee</title>
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


        <!-- navBar -->
        <%@include file="navbar.jsp" %>
        <%    if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
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
                    data: {fetchDataForEmployee: "true", userEmail: userEmail},
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
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';

                                        if (row.has_warranty === false && (row.order_status && row.deposit_status)) {
                                            html += '<a target="_blank" href="/WarrantyController/Create/' + row.order_id + '" class="btn btn-primary me-2">Create Warranty</a>';
                                        } else {
                                            if (row.has_warranty === true && (row.order_status && row.deposit_status)) {
                                                html += '<a target="_blank" href="/WarrantyController/Edit/' + row.warranty_id + '" class="btn btn-primary me-2">Edit Warranty</a>';
                                            } else {
                                                html += '<p class="text-danger fw-bold m-0 p-0 fs-5">No Warranty</p>';
                                            }
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
        <div class="container mt-5 pt-5 mb-5">
            <a class="btn btn-primary mb-3" href="/EmployeeController/CreateOrder" target="_blank">Create Order</a>
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
                        <th>Warranty</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được chèn vào đây -->                
                </tbody>
            </table>
        </div>
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
    </body>
</html>
