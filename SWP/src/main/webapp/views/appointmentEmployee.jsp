<%-- 
    Document   : appointmentCustomer
    Created on : 30 thg 10, 2024, 22:52:53
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Customer</title>
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
                getAppointment();
            });

            function getAppointment() {
                const today = new Date();
                const todayFormatted = today.getFullYear() + '-' +
                        String(today.getMonth() + 1).padStart(2, '0') + '-' +
                        String(today.getDate()).padStart(2, '0'); // Định dạng 'yyyy-mm-dd'
                const userEmail = $('#userEmail').val();
                $.ajax({
                    url: "/AppointmentController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchDataForEmployee: "true", userEmail: userEmail},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (appointments) {
                        var table = $('#appointmentsTable').DataTable({
                            responsive: true,
                            data: appointments,
                            columns: [
                                {data: 'appointment_id'},
                                {data: 'customer_id'},
                                {data: 'employee_id'},
                                {
                                    data: 'date_start',
                                    render: function (data) {
                                        return formatDate(data);
                                    }
                                },
                                {
                                    data: 'date_end',
                                    render: function (data) {
                                        return formatDate(data);
                                    }},
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';

                                        if (row.note && row.note.trim() !== '') {
                                            html = row.note;
                                        } else {
                                            html = '<p class="text-secondary fw-bold m-0 p-0 fs-6">Nothing</p>';
                                        }

                                        return html;
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';
                                        if (row.date_end < todayFormatted && !row.appointment_status) {
                                            html += '<p class="text-danger fw-bold m-0 p-0 fs-5">Expired</p>';
                                            return html;
                                        }

                                        if (row.appointment_status) {
                                            html += '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>';
                                        } else {
                                            html += '<p class="text-secondary fw-bold m-0 p-0 fs-5">Not Done</p>';
                                        }

                                        return html;
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        let html = '';
                                        if (row.date_end < todayFormatted && !row.appointment_status) {
                                            html += '<p class="text-secondary fw-bold m-0 p-0 fs-5">Nothing</p>';
                                            return html;
                                        }

                                        if (!row.appointment_status) {
                                            html = '<button class="btn btn-warning change-appointment" data-appointment-id="' + row.appointment_id + '">Change Status</button>';
                                        } else {
                                            html = '<p class="text-success fw-bold m-0 p-0 fs-5">Done</p>';
                                        }

                                        return html;
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

            $(document).on('click', '.change-appointment', function () {
                const appointmentId = $(this).data('appointment-id'); // Get the appointment ID from data attribute

                // Confirm before removing
                Swal.fire({
                    title: 'Are you sure?',
                    text: 'Do you really want to change this appointment?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonText: 'Yes, change it!',
                    cancelButtonText: 'No, keep it'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // AJAX call to remove the appointment
                        $.ajax({
                            url: '/AppointmentController', // Change this to your actual server endpoint
                            type: 'POST',
                            data: {
                                changeAppointment: 'true',
                                appointmentId: appointmentId
                            },
                            success: function (response) {
                                if (response === true) {
                                    Swal.fire({
                                        title: 'Change Status!',
                                        text: 'The appointment has been changed.',
                                        icon: 'success',
                                        confirmButtonText: 'OK'
                                    }).then(() => {
                                        $('#appointmentsTable').DataTable().clear().destroy();
                                        getAppointment();
                                    });

                                } else {
                                    Swal.fire({
                                        title: 'Error!',
                                        text: 'Failed to change the appointment. Please try again.',
                                        icon: 'error',
                                        confirmButtonText: 'OK'
                                    });
                                }
                            },
                            error: function () {
                                Swal.fire({
                                    title: 'Error!',
                                    text: 'An error occurred. Please try again later.',
                                    icon: 'error',
                                    confirmButtonText: 'OK'
                                });
                            }
                        });
                    }
                });
            });

            $(document).on('click', '#reload', function () {
                $('#appointmentsTable').DataTable().clear().destroy();
                getAppointment();
            });
        </script>

        <!-- Table Structure -->
        <div class="container mt-5 pt-5 mb-5">
            <button class="btn btn-outline-primary mb-3" id="reload">Reload</button>
            <table id="appointmentsTable" class="table table-striped nowrap w-100" style="width: 100%;">
                <thead>
                    <tr>
                        <th>Appointment Id</th>
                        <th>Customer Id</th>
                        <th>Employee Id</th>
                        <th>Date Start</th>
                        <th>Date End</th>
                        <th>Note</th>
                        <th>Appointment Status</th>
                        <th>Action</th>
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
