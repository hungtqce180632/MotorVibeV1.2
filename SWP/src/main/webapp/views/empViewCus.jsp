
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
                                    render: function (row) {
                                        return row.status ?
                                                '<p class="text-success fs-5">Active</p>' :
                                                '<p class="text-danger fs-5">Disable</p>';
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
        <!-- navBar -->
        <%@include file="navbar.jsp" %>
        <%            if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5 pt-5 mb-5">
            <h2 class="text-center mb-3">View Customer</h2>
            <!-- Table Structure -->
            <table id="customersTable" class="table table-striped nowrap w-100" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Customer Id</th>
                        <th>User Id</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone Number</th>
                        <th>Id Number</th>
                        <th>Address</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="cusBody">
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
