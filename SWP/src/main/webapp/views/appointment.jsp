<%-- 
    Document   : appointment
    Created on : 2 thg 11, 2024, 16:12:52
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Appointment</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- SweetAlert CDN -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

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
                        role = cookie.getValue();
                    }
                }
            }
            if (!role.equals("customer")) {
                response.sendRedirect("/");
            }

            // Kiểm tra nếu cookie "userEmail" tồn tại
            if ((userEmail != null) && (role.equals("customer"))) {
        %>                    
        <input hidden value="<%= userEmail%>" id="userEmail">    
        <input hidden id="role" value="<%= role%>">
        <%
            }
        %>
        <div class="container mt-5 row justify-content-between m-auto">
            <h1 class="text-center mb-5">Create Appointment</h1>
            <form id="appointmentForm" class="col-md-5 p-0 mb-3">
                <div class="mb-3">
                    <label for="date_start" class="form-label">Start Date</label>
                    <input type="date" id="date_start" name="date_start" class="form-control" required>
                    <div id="dateError" class="text-danger mt-1"></div>
                </div>
                <div class="mb-3">
                    <label for="note" class="form-label">Note</label>
                    <textarea id="note" name="note" class="form-control" maxlength="5000" rows="4" required></textarea>
                    <div id="noteError" class="text-danger mt-1"></div>
                </div>
                <button type="submit" class="btn btn-primary">Create Appointment</button>
            </form>

            <!-- Notes Column -->
            <div class="col-md-5 p-0 mb-3">
                <div class="alert alert-info" role="alert">
                    <h4>Important Notes</h4>
                    <ul>
                        <li>Each customer can create only one appointment if they do not have any ongoing orders or existing appointments.</li>
                        <li>Appointments can only be scheduled during office hours (9 AM - 5 PM).</li>
                        <li>Each appointment has a maximum duration of 3 days from the selected date.</li>
                    </ul>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function () {
                const maxChars = 5000;

                $('#appointmentForm').on('submit', function (e) {
                    e.preventDefault(); // Prevent form submission until validation completes

                    let isValid = true;

                    // Note validation
                    const note = $('#note').val();
                    if (note.length > maxChars) {
                        $('#noteError').text(`Note cannot exceed ${maxChars} characters.`);
                        isValid = false;
                    } else {
                        $('#noteError').text(''); // Clear error if validation passes
                    }

                    // Date validation
                    const selectedDate = new Date($('#date_start').val());
                    const today = new Date();
                    today.setHours(0, 0, 0, 0); // Ensure only date is compared
                    const oneWeekFromToday = new Date();
                    oneWeekFromToday.setDate(today.getDate() + 7);

                    if (selectedDate < today) {
                        $('#dateError').text('The appointment date cannot be in the past.');
                        isValid = false;
                    } else if (selectedDate > oneWeekFromToday) {
                        $('#dateError').text('The appointment date cannot be more than one week from today.');
                        isValid = false;
                    } else {
                        $('#dateError').text(''); // Clear error if validation passes
                    }

                    // Submit form if validation passes
                    if (isValid) {
                        // Confirm before proceeding
                        Swal.fire({
                            title: 'Confirmation',
                            text: 'Are you sure? Please be aware that if your appointment exceeds working hours within 3 days from now, it will be canceled.',
                            icon: 'warning',
                            showCancelButton: true,
                            confirmButtonText: 'Yes, proceed!',
                            cancelButtonText: 'No, cancel!'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                var date_start = document.getElementById('date_start').value;
                                var userEmail = document.getElementById('userEmail').value;
                                $.ajax({
                                    url: '/AppointmentController', // Change this to your actual server endpoint
                                    type: 'POST',
                                    data: {
                                        createAppointment: 'true',
                                        date_start: date_start,
                                        userEmail: userEmail,
                                        note: note
                                    },
                                    success: function (response) {
                                        if (response === true) {
                                            // Show success message
                                            Swal.fire({
                                                title: 'Success!',
                                                text: 'Appointment created successfully!',
                                                icon: 'success',
                                                confirmButtonText: 'OK'
                                            }).then(() => {
                                                window.close(); // Close the window after the alert is acknowledged
                                            });
                                        } else {
                                            // If response is not true, you may want to handle that case
                                            Swal.fire({
                                                title: 'Oops!',
                                                text: 'Something went wrong or you already have an appointment .Please try again.',
                                                icon: 'error',
                                                confirmButtonText: 'OK'
                                            });
                                        }
                                    },
                                    error: function () {
                                        // Handle error
                                        Swal.fire({
                                            title: 'Error!',
                                            text: 'Failed to create appointment. Please try again.',
                                            icon: 'error',
                                            confirmButtonText: 'OK'
                                        });
                                    }
                                });
                            }
                        });
                    }
                });
            });
        </script>
    </body>
</html>
