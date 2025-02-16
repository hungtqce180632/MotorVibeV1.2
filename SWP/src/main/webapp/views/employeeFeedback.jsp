<%-- 
    Document   : customerFeeaback
    Created on : 31 thg 10, 2024, 03:00:21
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Feedback</title>
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
        <%            if (!role.equals("employee")) {
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
                const userEmail = $('#userEmail').val();
                getFeedback(userEmail);
            });

            function getFeedback(userEmail) {
                $.ajax({
                    url: "/EmployeeController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchFeedbackForEmployee: "true", userEmail: userEmail},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (fbs) {
                        // Initialize DataTables after receiving data
                        var table = $('#feedbackTable').DataTable({
                            responsive: true,
                            data: fbs,
                            columns: [
                                {data: 'feedback_id'},
                                {data: 'order_id'},
                                {data: 'customer_id'},
                                {data: 'feedback_content'},
                                {
                                    data: 'date_create',
                                    render: function (data) {
                                        return formatDate(data);
                                    }
                                },
                                {
                                    data: 'feedback_status',
                                    render: function (data, type, row) {
                                        if (data) {
                                            return '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>';
                                        } else {
                                            return '<button id="changeStatus-' + row.feedback_id + '" class="btn btn-warning" data-id="' + row.feedback_id + '">Check it done</button>';
                                        }
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

            $(document).on('click', '[id^="changeStatus-"]', function () {
                var feedbackId = $(this).data('id'); // Lấy feedback_id từ thuộc tính data-id
                const userEmail = $('#userEmail').val();

                // Cảnh báo xác nhận trước khi thực hiện hành động
                Swal.fire({
                    title: 'Are you sure?',
                    text: 'Once checked, this feedback cannot be changed back. Please make sure the issue is resolved.',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, mark as done',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Gửi yêu cầu AJAX để cập nhật trạng thái feedback nếu người dùng xác nhận
                        $.ajax({
                            url: '/FeedBackController',
                            type: 'POST',
                            data: {
                                feedback_id: feedbackId,
                                changeStatus: "true"
                            },
                            success: function (response) {
                                console.log(response);
                                if (response) {
                                    Swal.fire({
                                        title: 'Feedback updated successfully',
                                        icon: 'success',
                                        confirmButtonColor: '#3085d6',
                                        confirmButtonText: 'OK'
                                    }).then(() => {
                                        $('#feedbackTable').DataTable().clear().destroy();
                                        getFeedback(userEmail);
                                    });
                                } else {
                                    Swal.fire({
                                        title: 'Update failed',
                                        text: response.error || 'An error occurred. Please try again.',
                                        icon: 'error',
                                        confirmButtonColor: '#d33',
                                        confirmButtonText: 'OK'
                                    });
                                }
                            },
                            error: function (xhr, status, error) {
                                Swal.fire({
                                    title: 'Error',
                                    text: 'There was a problem updating the feedback. Please try again later.',
                                    icon: 'error',
                                    confirmButtonColor: '#d33',
                                    confirmButtonText: 'OK'
                                });
                            }
                        });
                    }
                });
            });
        </script>

        <!-- Table Structure -->
        <div class="container mt-5 pt-5 mb-5">
            <table id="feedbackTable" class="table table-striped nowrap w-100" style="width: 100%;">
                <thead>
                    <tr>
                        <th>feedback_id</th>
                        <th>order_id</th>
                        <th>customer_id</th>
                        <th>feedback_content</th>
                        <th>date_create</th>
                        <th>feedback_status</th>
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
