<%-- 
    Document   : employee
    Created on : Oct 21, 2024, 10:59:11 AM
    Author     : counh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
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
                    url: "/EmployeeController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchData: "true"},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (employees) {
                        // Initialize DataTables after receiving data
                        var table = $('#employeesTable').DataTable({
                            responsive: true, // Bật chế độ responsive
                            data: employees, // Load the data directly into DataTable
                            columns: [
                                {data: 'employeeId'},
                                {data: 'userId'},
                                {data: 'name'},
                                {data: 'email'},
                                {data: 'phoneNumber'},
                                {data: null,
                                    render: function (row) {
                                        return '<a target="_blank" href="/EmployeeController/Edit/' + row.employeeId + '" class="btn btn-primary me-2">Edit</a>' +
                                                (row.status ?
                                                        '<a target="_blank" href="/EmployeeController/Status/' + row.employeeId + '" class="btn btn-danger">Disable</a>' :
                                                        '<a target="_blank" href="/EmployeeController/Status/' + row.employeeId + '" class="btn btn-success">Active</a>');
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
        <table id="employeesTable" class="table table-striped nowrap w-100" style="width: 100%;">
            <thead>
                <tr>
                    <th>employee id</th>
                    <th>user id</th>
                    <th>employee name</th>
                    <th>employee email</th>
                    <th>employee phone Number</th>
                    <th>employee status</th>
                </tr>
            </thead>
            <tbody id="eventBody">
                <!-- Dữ liệu sẽ được chèn vào đây -->                
            </tbody>
        </table>      
    </body>
</html>
