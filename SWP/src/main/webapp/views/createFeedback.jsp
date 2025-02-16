<%-- 
    Document   : createFeedback
    Created on : 31 thg 10, 2024, 01:12:59
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.4/dist/sweetalert2.all.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.14.4/dist/sweetalert2.min.css" rel="stylesheet">
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
        %>
        <input hidden value="<%= userEmail%>" id="userEmail">
        <%
                    }
                    if (cookie.getName().equals("role")) {
                        role = cookie.getValue(); // Lấy giá trị email từ cookie                        
                    }
                }
            }

            if (!role.equals("customer")) {
                response.sendRedirect("/");
            }

        %>
        <div class="container mt-5">
            <h2 class="text-center mb-4">Create Feedback</h2>
            <form id="feedbackForm">
                <div class="form-group">
                    <label for="orderId">Select Order ID:</label>
                    <select class="form-control" id="orderId" required>
                        <option value="">Select an order...</option>
                        <!-- Order IDs will be populated here -->
                    </select>
                </div>
                <div class="form-group">
                    <label for="feedbackContent">Feedback Details:</label>
                    <textarea class="form-control" id="feedbackContent" rows="4" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Submit Feedback</button>
            </form>
        </div>
        <script>
            $(document).ready(function () {
                var userEmail = document.getElementById('userEmail').value;
                $.ajax({
                    url: '/OrderController',
                    type: 'POST',
                    data: {getOrderIds: "true", userEmail: userEmail},
                    dataType: 'json',
                    success: function (response) {
                        // Populate the select options with order IDs
                        response.forEach(function (order) {
                            $('#orderId').append('<option value="' + order + '">' + order + '</option>');
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching order IDs: " + error);
                    }
                });
            }
            );

            $('#feedbackForm').on('submit', function (event) {
                event.preventDefault(); // Prevent the default form submission

                const orderId = $('#orderId').val();
                const feedbackContent = document.getElementById("feedbackContent").value;
                var userEmail = document.getElementById('userEmail').value;

                // Validation for feedback content length
                if (feedbackContent.length < 10) {
                    Swal.fire({
                        title: 'Validation Error',
                        text: 'Feedback must be at least 10 characters long.',
                        icon: 'warning',
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    });
                    return; // Prevent form submission
                }

                if (feedbackContent.length > 5000) {
                    Swal.fire({
                        title: 'Validation Error',
                        text: 'Feedback cannot exceed 5000 characters.',
                        icon: 'warning',
                        confirmButtonColor: '#3085d6',
                        confirmButtonText: 'OK'
                    });
                    return; // Prevent form submission
                }

                // Submit feedback via Ajax
                $.ajax({
                    url: '/FeedBackController', // Change this to your actual controller URL
                    type: 'POST',
                    data: {
                        order_id: orderId,
                        feedback_content: feedbackContent,
                        createFeedback: "true",
                        userEmail: userEmail
                    },
                    dataType: 'json',
                    success: function (response) {
                        if (response) {
                            Swal.fire({
                                title: 'Feedback Submitted Successfully',
                                text: 'Please wait until we contact you.',
                                icon: 'success',
                                confirmButtonColor: '#3085d6',
                                confirmButtonText: 'OK'
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    window.close(); // Close the window when the user clicks OK
                                }
                            });
                        } else {
                            Swal.fire({
                                title: 'Submission Failed',
                                text: 'There was an error sending your feedback or you already have feedback, please wait for us to process it.',
                                icon: 'error',
                                confirmButtonColor: '#d33',
                                confirmButtonText: 'OK'
                            });
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("Error submitting feedback: " + error);
                    }
                });
            });
        </script>
    </body>
</html>
