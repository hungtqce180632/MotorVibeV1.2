<%-- 
    Document   : customerWarranty
    Created on : 29 thg 10, 2024, 21:25:19
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Warranty</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
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
        <%    if (!role.equals("customer")) {
                response.sendRedirect("/");
            }
        %>
        <!-- Warranty Table -->
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
                    url: "/WarrantyController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchWarrantyForCustomer: "true", userEmail: userEmail},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (warranties) {
                        // Initialize DataTables after receiving data
                        var table = $('#warrantyTable').DataTable({
                            responsive: true,
                            data: warranties,
                            columns: [
                                {data: 'warranty_id'},
                                {data: 'order_id'},
                                {
                                    data: 'warranty_details',
                                    render: function (data, type, row) {
                                        return '<button class="btn btn-primary btn-sm" onclick="showDetailsModal(\'' + data + '\')">View Details</button>';
                                    }
                                },
                                {data: 'warranty_expiry'}
                            ]
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra: " + error);
                    }
                });
            });


            // Function to show the modal with warranty details
            function showDetailsModal(details) {
                $('#warrantyDetailsModalBody').text(details);
                $('#warrantyDetailsModal').modal('show');
            }
        </script>

        <!-- Table Structure -->
        <div class="container my-5 pt-5">
            <table id="warrantyTable" class="table table-striped nowrap w-100" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Warranty Id</th>
                        <th>Order Id</th>
                        <th>Warranty Details</th>
                        <th>Warranty Expiry</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được chèn vào đây -->                
                </tbody>
            </table>
            <!-- Warranty Details Modal -->
            <div class="modal fade" id="warrantyDetailsModal" tabindex="-1" aria-labelledby="warrantyDetailsModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="warrantyDetailsModalLabel">Warranty Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="warrantyDetailsModalBody">
                            <!-- Warranty details will be displayed here -->
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
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
