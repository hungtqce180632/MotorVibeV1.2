<%-- 
    Document   : reviewEmployee
    Created on : 30 thg 10, 2024, 19:47:10
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Review</title>
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
        <%    if (!role.equals("employee")) {
                response.sendRedirect("/");
            }
        %>
        <!-- Warranty Table -->
        <script>
            // Function to format date in "dd/mm/yyyy" format
            function formatDate(dateString) {
                const date = new Date(dateString);
                if (!isNaN(date)) {
                    return date.getDate().toString().padStart(2, '0') + '/' +
                            (date.getMonth() + 1).toString().padStart(2, '0') + '/' +
                            date.getFullYear();
                }
                return '';
            }

            $(document).ready(function () {
                getAllReviews();
            });

            function getAllReviews() {
                $.ajax({
                    url: "/ReviewController",
                    type: "POST",
                    data: {fetchReviewForEmployee: "true"},
                    dataType: "json",
                    success: function (reviews) {
                        // Initialize DataTables after receiving data
                        var table = $('#reviewTable').DataTable({
                            responsive: true,
                            data: reviews,
                            columns: [
                                {data: 'review_id'},
                                {data: 'customer_id'},
                                {data: 'car_id'},
                                {
                                    data: 'rating',
                                    render: function (data) {
                                        return getStarsHTML(data); // Use the function here
                                    }
                                },
                                {
                                    data: 'review_text',
                                    render: function (data) {
                                        return '<button class="btn btn-primary btn-sm" onclick="showDetailsModal(\'' + data + '\')">View Details</button>';
                                    }
                                },
                                {
                                    data: 'review_date',
                                    render: function (data) {
                                        return formatDate(data); // Use the function here
                                    }
                                },
                                {
                                    data: 'review_status',
                                    render: function (data, type, row) {
                                        var buttonText = data === true ? "Disable review" : "Enable review";
                                        var action = data === true ? "disable" : "enable";
                                        var buttonClass = data === true ? "btn-danger" : "btn-success";

                                        // Add data attributes to store review ID and action
                                        return '<button class="btn btn-sm ' + buttonClass + '" data-review-id="' + row.review_id + '" data-action="' + action + '" onclick="confirmToggleReviewStatus(this)">' + buttonText + '</button>';
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

            // Helper function to generate star icons based on the rating
            function getStarsHTML(rating) {
                let starsHTML = '';
                for (let i = 1; i <= rating; i++) {
                    starsHTML += `<i class="fa fa-star${i <= rating ? ' checked text-warning' : ''}"></i>`;
                }
                return starsHTML;
            }

            // Function to show the modal with warranty details
            function showDetailsModal(details) {
                $('#reviewDetailsModalBody').text(details);
                $('#reviewDetailsModal').modal('show');
            }

            // Hàm định dạng ngày tháng
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

            // Define the confirmToggleReviewStatus function to get data from button
            function confirmToggleReviewStatus(button) {
                var reviewId = button.getAttribute('data-review-id');
                var action = button.getAttribute('data-action');
                var actionText = action === "disable" ? "Disable" : "Enable";

                // Show a SweetAlert confirmation dialog
                Swal.fire({
                    title: 'Are you sure?',
                    text: 'Do you really want to ' + actionText.toLowerCase() + ' this review?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: 'Yes, ' + actionText.toLowerCase() + ' it!',
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // If confirmed, call the AJAX function to toggle review status
                        toggleReviewStatus(reviewId, action);
                    }
                });
            }

            // Define the toggleReviewStatus function to send AJAX request
            function toggleReviewStatus(reviewId, action) {
                $.ajax({
                    url: "/ReviewController",
                    type: "POST",
                    data: {changeReviewStatus: 'true', review_id: reviewId},
                    success: function (response) {
                        // Show success notification
                        if (response) {
                            Swal.fire({
                                icon: 'success',
                                title: action === 'disable' ? 'Review Disabled' : 'Review Enabled',
                                text: 'The review status has been updated successfully.',
                                confirmButtonText: 'OK'
                            }).then(() => {
                                $('#reviewTable').DataTable().clear().destroy();
                                getAllReviews();
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Action Failed',
                                text: 'There was an issue updating the review status. Please try again.',
                                confirmButtonText: 'OK'
                            });
                        }

                    },
                    error: function (xhr, status, error) {
                        console.error("Error: " + error);
                        Swal.fire({
                            icon: 'error',
                            title: 'Action Failed',
                            text: 'There was an issue updating the review status. Please try again.',
                            confirmButtonText: 'OK'
                        });
                    }
                });
            }
        </script>

        <!-- Table Structure -->
        <div class="container mt-5 pt-5 mb-5">
            <table id="reviewTable" class="table table-striped nowrap w-100" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Review Id</th>
                        <th>Customer Id</th>
                        <th>Car Id</th>
                        <th>Rating</th>
                        <th>Review Details</th>
                        <th>Review Date</th>
                        <th>Review Status</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được chèn vào đây -->                
                </tbody>
            </table>
            <!-- Warranty Details Modal -->
            <div class="modal fade" id="reviewDetailsModal" tabindex="-1" aria-labelledby="reviewDetailsModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="reviewDetailsModalLabel">Warranty Details</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body" id="reviewDetailsModalBody">
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
