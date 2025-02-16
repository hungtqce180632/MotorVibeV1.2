<%-- 
    Document   : review
    Created on : 27 thg 10, 2024, 16:09:23
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2 class="text-center mb-3">Review</h2>
        <div id="review">
            <form id="reviewForm">

            </form>
        </div>

        <div id="reviewsContainer" class="container mt-3">
            <!-- Reviews will be injected here -->
        </div>

        <!-- Pagination controls -->
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center" id="paginationControls">
                <!-- Pagination buttons will be injected here -->
            </ul>
        </nav>
        <script>
            $("#reviewForm").on("submit", function (event) {
                event.preventDefault(); // Prevent form's default submission behavior
                const role = $('#role').val();
                const rating = $('input[name="rating"]:checked').val();
                const reviewText = $("#review_text").val();
                const userEmail = $("#userEmail").val();
                const urlPath = window.location.pathname;
                const parts = urlPath.split('/');
                const carId = parts[parts.length - 1];
                const reviewDate = new Date().toISOString().split('T')[0]; // Format: YYYY-MM-DD

                $.ajax({
                    url: '/ReviewController',
                    type: 'POST',
                    data: {
                        carId: carId,
                        rating: rating,
                        review_text: reviewText,
                        createReview: 'true',
                        userEmail: userEmail
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response) {
                            // SweetAlert for success
                            swal({
                                title: "Success!",
                                text: "Review submitted successfully!",
                                icon: "success",
                                button: "OK"
                            });
                            $('#review').hide();
                        } else {
                            // SweetAlert for error
                            swal({
                                title: "Error!",
                                text: response.error || "Failed to submit review.",
                                icon: "error",
                                button: "OK"
                            });
                        }
                        fetchReviews(carId);
                    },
                    error: function (xhr, status, error) {
                        alert("AJAX error:", error);
                    }
                });
            });

            let allReviews = [];
            const reviewsPerPage = 5;
            let currentPage = 1;

            function fetchReviews(carId) {
                $.ajax({
                    url: '/ReviewController',
                    type: 'post',
                    data: {carId: carId, getReviews: 'true'},
                    dataType: 'json',
                    success: function (reviews) {
                        if (reviews.length === 0) {
                            $('#paginationControls').hide();
                            $('#reviewsContainer').append('<h5 class="text-center">No Review</h5>');
                        } else {
                            allReviews = reviews;
                            currentPage = 1;
                            updateReviewsDisplay();
                            updatePaginationControls();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching reviews: " + error);
                    }
                });
            }

            function updateReviewsDisplay() {
                $("#reviewsContainer").empty();

                // Calculate start and end indices based on the current page
                const start = (currentPage - 1) * reviewsPerPage;
                const end = Math.min(start + reviewsPerPage, allReviews.length);

                // Loop through the reviews for the current page
                for (let i = start; i < end; i++) {
                    const review = allReviews[i];

                    // Check if the rating is 3 or below
                    const responseMessage = review.rating <= 3 ? "We're sorry to hear about your experience. We appreciate your <a href='/FeedBackController/Create' target='_blank'>feedback</a>!" : "";

                    const reviewElement =
                            '<div class="card mb-3">' +
                            '<div class="card-body">' +
                            '<h5 class="card-title">' + review.customer_name + '</h5>' +
                            '<h6 class="card-subtitle mb-2 text-muted">Rating: ' + getStarsHTML(review.rating) + '</h6>' +
                            '<p class="card-text">' + review.review_text + '</p>' +
                            (responseMessage ? '<p class="alert alert-info">' + responseMessage + '</p>' : '') +
                            '<p class="text-muted"><small>Reviewed on: ' + formatDate(review.review_date) + '</small></p>' +
                            '</div>' +
                            '</div>';

                    $("#reviewsContainer").append(reviewElement);
                }
            }

            function updatePaginationControls() {
                const totalPages = Math.ceil(allReviews.length / reviewsPerPage);
                const paginationControls = $("#paginationControls");

                paginationControls.empty(); // Clear existing pagination controls

                // Add Previous button
                paginationControls.append(
                        '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" onclick="goToPage(' + (currentPage - 1) + ', event)">Previous</a>' +
                        '</li>'
                        );

                // Add page number buttons
                for (let i = 1; i <= totalPages; i++) {
                    paginationControls.append(
                            '<li class="page-item ' + (currentPage === i ? 'active' : '') + '">' +
                            '<a class="page-link" href="#" onclick="goToPage(' + i + ', event)">' + i + '</a>' +
                            '</li>'
                            );
                }

                // Add Next button
                paginationControls.append(
                        '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" onclick="goToPage(' + (currentPage + 1) + ', event)">Next</a>' +
                        '</li>'
                        );
            }

            function goToPage(page, event) {
                // Prevent the default action of the anchor tag
                event.preventDefault();

                // Ensure the page number is within the valid range
                const totalPages = Math.ceil(allReviews.length / reviewsPerPage);
                if (page >= 1 && page <= totalPages) {
                    currentPage = page;
                    updateReviewsDisplay(); // Update the displayed reviews for the current page
                    updatePaginationControls(); // Update the pagination controls
                }
            }


            // Helper function to generate star icons based on the rating
            function getStarsHTML(rating) {
                let starsHTML = '';
                for (let i = 1; i <= rating; i++) {
                    starsHTML += `<i class="fa fa-star${i <= rating ? ' checked text-warning' : ''}"></i>`;
                }
                return starsHTML;
            }

            function checkCusHaveOrder(carId) {
                var roleElement = document.getElementById('role');
                var emailElement = document.getElementById('userEmail');

                // Check if the elements are found in the DOM
                if (!roleElement || !emailElement) {
                    console.error("Role or userEmail element is missing in the DOM.");
                    return;
                }

                var userRole = roleElement.value;
                var userEmail = emailElement.value;

                $.ajax({
                    url: "/ReviewController",
                    type: "POST",
                    data: {checkCusHaveOrder: "true", carId: carId, userEmail: userEmail},
                    dataType: "json",
                    success: function (response) {
                        if (!response) {
                            if (userRole === 'customer') {
                                var btn = '<div class="star-rating">' +
                                        '<input type="radio" id="star5" name="rating" value="5" required><label for="star5"><i class="fa fa-star"></i></label>' +
                                        '<input type="radio" id="star4" name="rating" value="4"><label for="star4"><i class="fa fa-star"></i></label>' +
                                        '<input type="radio" id="star3" name="rating" value="3"><label for="star3"><i class="fa fa-star"></i></label>' +
                                        '<input type="radio" id="star2" name="rating" value="2"><label for="star2"><i class="fa fa-star"></i></label>' +
                                        '<input type="radio" id="star1" name="rating" value="1"><label for="star1"><i class="fa fa-star"></i></label>' +
                                        '</div>' +
                                        '<textarea class="form-control my-3" id="review_text" name="review_text" rows="3" placeholder="Write your review..." required></textarea>' +
                                        '<button type="submit" class="btn btn-primary w-100">Submit</button>';
                                document.getElementById('reviewForm').innerHTML = btn;
                            }
                        } else {
                            $('#review').remove();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra: " + error);
                    }
                });
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
        </script>
    </body>
</html>
