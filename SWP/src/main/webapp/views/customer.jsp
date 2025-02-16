<%-- 
    Document   : employee
    Created on : Oct 21, 2024, 10:59:11 AM
    Author     : counh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Customer Management</title>
        <!-- CSS Links -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/1.13.1/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/responsive/2.4.1/css/responsive.bootstrap5.min.css" rel="stylesheet">
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
            $(document).ready(function () {
                $.ajax({
                    url: "/AdminCustomerContronller", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchData: "true"},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (customers) {
                        // Initialize DataTables after receiving data
                        var table = $('#customersTable').DataTable({
                            responsive: true, // Bật chế độ responsive
                            data: customers, // Load the data directly into DataTable
                            columns: [
                                {data: 'customer_id'},
                                {data: 'user_id'},
                                {data: 'name'},
                                {data: 'email'},
                                {data: 'phone_number'},
                                {data: 'cus_id_number'},
                                {data: 'address'},
                                {
                                    data: null,
                                    render: function (data, type, row) {
                                        return row.status ?
                                                '<a target="_blank" href="/AdminCustomerContronller/Status/' + row.customer_id + '" class="btn btn-danger">Disable</a>' :
                                                '<a target="_blank" href="/AdminCustomerContronller/Status/' + row.customer_id + '" class="btn btn-success">Active</a>';
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
        <table id="customersTable" class="table table-striped nowrap w-100" style="width: 100%;">
            <thead>
                <tr>
                    <th>Customer Id</th>
                    <th>User Id</th>
                    <th>Customer Name</th>
                    <th>Customer Email</th>
                    <th>Customer Phone Number</th>
                    <th>Customer Id Number</th>
                    <th>Customer Address</th>
                    <th>Customer Status</th>
                </tr>
            </thead>
            <tbody id="eventBody">
                <!-- Dữ liệu sẽ được chèn vào đây -->                
            </tbody>
        </table>      
    </body>
</html>
