<%-- 
    Document   : warrantyView
    Created on : 28 thg 10, 2024, 23:20:15
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Warranty</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>        <link href="https://cdn.jsdelivr.net/npm/@sweetalert2/theme-bootstrap-4/bootstrap-4.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    </head>
    <body>
        <%
            // Lấy danh sách cookies từ request
            Cookie[] cookies = request.getCookies();
            String userEmail = null;
            String role = null;
            // Duyệt qua các cookies và kiểm tra cookie "userEmail"
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        response.sendRedirect("/AdminController/Dashboard");
                        break;
                    }
                    if (cookie.getName().equals("userEmail")) {
                        userEmail = cookie.getValue(); // Lấy giá trị email từ cookie                        
                    }
                    if (cookie.getName().equals("role")) {
                        role = cookie.getValue(); // Lấy giá trị email từ cookie                        
                    }
                }
            }

            if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5">
            <h2 class="text-center mb-4">Edit Warranty</h2>
            <form id="warrantyForm">
                <div class="mb-3">
                    <label for="warrantyDetails" class="form-label">Warranty Details</label>
                    <textarea class="form-control" id="warrantyDetails" name="warrantyDetails" rows="5" maxlength="500" required></textarea>
                    <div class="form-text">Max 500 characters.</div>
                </div>
                <div class="mb-3">
                    <label for="expirationDate" class="form-label">Expiration Date</label>
                    <input type="date" class="form-control" id="expirationDate" name="expirationDate" required>
                </div>
                <button type="submit" class="btn btn-primary w-100">Submit</button>
            </form>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- SweetAlert2 JS -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            $(document).ready(function () {
                var urlPath = window.location.pathname; // Lấy đường dẫn URL
                var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'

                // Giả sử eventId nằm ở phần thứ 4 trong mảng (index 3), điều chỉnh nếu cần
                var warrantyId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID sự kiện)

                $.ajax({
                    url: "/WarrantyController", // Đường dẫn tới EventController
                    type: "POST", // Phương thức HTTP GET
                    data: {warrantyId: warrantyId, getWarrantyForEdit: "true"}, // Gửi ID sự kiện
                    dataType: "json", // Định dạng dữ liệu trả về
                    success: function (warranty) {
                        $('#warrantyDetails').val(warranty.warranty_details);
                        $('#expirationDate').val(warranty.warranty_expiry);
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            });


            // Handle form submission
            $("#warrantyForm").on("submit", function (event) {
                event.preventDefault(); // Prevent default form submission

                var urlPath = window.location.pathname;
                var parts = urlPath.split('/');
                const warrantyId = parts[parts.length - 1];
                const warrantyDetails = $("#warrantyDetails").val();
                const expirationDate = new Date($("#expirationDate").val());
                const date = expirationDate.toISOString().split('T')[0];
                const today = new Date();
                // Validate expiration date
                if (expirationDate <= today) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Invalid Date',
                        text: 'Expiration date must be greater than today.'
                    });
                    return;
                }

                // AJAX request to submit the form
                $.ajax({
                    url: '/WarrantyController', // Replace with your controller URL
                    type: 'POST',
                    data: {
                        warrantyId: warrantyId,
                        warrantyDetails: warrantyDetails,
                        expirationDate: date,
                        editWarranty: "true"
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response === true) {
                            Swal.fire({
                                icon: 'success',
                                title: 'Success',
                                text: 'Warranty edited successfully.',
                            }).then(() => {
                                window.close(); // Close the window after the alert
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: response.error || 'Failed to create warranty.'
                            });
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'An unexpected error occurred.'
                        }).then(() => {
                            window.close(); // Close the window after the alert
                        });
                    }
                });
            });
        </script>
    </body>
</html>
