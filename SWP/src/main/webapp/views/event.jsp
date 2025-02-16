<%-- 
    Document   : index
    Created on : Oct 8, 2024, 4:46:13 PM
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

        <!-- DataTable Initialization -->
        <script>
            $(document).ready(function () {
                const today = new Date().toISOString().split('T')[0]; // Ngày hiện tại theo định dạng yyyy-mm-dd                
                // Gọi AJAX để lấy dữ liệu sự kiện
                $.ajax({
                    url: "/EventController", // URL của Servlet
                    type: "POST", // Phương thức HTTP POST
                    data: {fetchData: "true"},
                    dataType: "json", // Định dạng dữ liệu trả về là JSON
                    success: function (events) {
                        // Initialize DataTables after receiving data
                        var table = $('#eventsTable').DataTable({
                            responsive: true, // Bật chế độ responsive
                            data: events, // Load the data directly into DataTable
                            columns: [
                                {data: 'event_id'},
                                {data: 'event_name'},
                                {
                                    data: null,
                                    render: function (row) {
                                        return '<button class="btn btn-link" data-bs-toggle="modal" data-bs-target="#detailsModal' + row.event_id + '">View Details</button>';
                                    }
                                },
                                {
                                    data: null,
                                    render: function (row) {
                                        return '<button class="btn btn-link" data-bs-toggle="modal" data-bs-target="#imageModal' + row.event_id + '">View Image</button>';
                                    }
                                },
                                {data: 'date_start'},
                                {data: 'date_end'},
                                {
                                    data: null,
                                    render: function (row) {
                                        const today = new Date();
                                        const dateStart = new Date(row.date_start);
                                        const dateEnd = new Date(row.date_end);

                                        // Add 3 days to date_start
                                        const dateStartPlus3 = new Date(dateStart);
                                        dateStartPlus3.setDate(dateStartPlus3.getDate() + 3);

                                        if (today > dateEnd) {
                                            return '<p class="text-danger fw-bold fs-5">Expired</p>';
                                        } else if (today >= dateStart && today <= dateStartPlus3) {
                                            return '<a target="_blank" href="/EventController/Edit/' + row.event_id + '" class="btn btn-primary me-2">Edit</a>' +
                                                    (row.event_status ?
                                                            '<a target="_blank" href="/EventController/Status/' + row.event_id + '" class="btn btn-danger">Disable</a>' :
                                                            '<a target="_blank" href="/EventController/Status/' + row.event_id + '" class="btn btn-success">Active</a>');
                                        } else {
                                            return (row.event_status ?
                                                    '<a target="_blank" href="/EventController/Status/' + row.event_id + '" class="btn btn-danger">Disable</a>' :
                                                    '<a target="_blank" href="/EventController/Status/' + row.event_id + '" class="btn btn-success">Active</a>');
                                        }
                                    }
                                }
                            ]
                        });
                        // Create modals for image and details
                        // Xóa các modal cũ trước khi chèn mới
                        $('body').find('[id^="imageModal"], [id^="detailsModal"]').remove(); // Xóa tất cả modals có id bắt đầu bằng 'imageModal' hoặc 'detailsModal'

                        $.each(events, function (index, event) {
                            var randomParam = new Date().getTime(); // Sử dụng Math.random()
                            // Create modal for images
                            var imageModal =
                                    '<div class="modal fade" id="imageModal' + event.event_id + '" tabindex="-1" aria-labelledby="imageModalLabel' + event.event_id + '" aria-hidden="true">' +
                                    '<div class="modal-dialog modal-lg">' +
                                    '<div class="modal-content">' +
                                    '<div class="modal-header">' +
                                    '<h5 class="modal-title" id="imageModalLabel' + event.event_id + '">' + event.event_name + '</h5>' +
                                    '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
                                    '</div>' +
                                    '<div class="modal-body">' +
                                    '<img src="/ImageController/b/' + event.event_id + '?t=' + randomParam + '" alt="' + event.event_name + '" class="img-fluid">' +
                                    '</div>' +
                                    '</div>' +
                                    '</div>' +
                                    '</div>';


                            // Create modal for details
                            var detailsModal = '<div class="modal fade" id="detailsModal' + event.event_id + '" tabindex="-1" aria-labelledby="detailsModalLabel' + event.event_id + '" aria-hidden="true">' +
                                    '<div class="modal-dialog modal-lg">' +
                                    '<div class="modal-content">' +
                                    '<div class="modal-header">' +
                                    '<h5 class="modal-title" id="detailsModalLabel' + event.event_id + '">' + event.event_name + '</h5>' +
                                    '<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>' +
                                    '</div>' +
                                    '<div class="modal-body">' +
                                    event.event_details +
                                    '</div>' +
                                    '</div>' +
                                    '</div>' +
                                    '</div>';

                            // Append modals to the body
                            $('body').append(imageModal);  // Append modal to body
                            $('body').append(detailsModal); // Append modal to body
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra: " + error);
                    }
                });
            });
        </script>

        <!-- Table Structure -->
        <table id="eventsTable" class="table table-striped nowrap w-100" style="width: 100%;">
            <thead>
                <tr>
                    <th>Event ID</th>
                    <th>Event Name</th>
                    <th>Event Details</th>
                    <th>Image</th>
                    <th>Date Start</th>
                    <th>Date End</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="eventBody">
                <!-- Dữ liệu sẽ được chèn vào đây -->                
            </tbody>
        </table>       
    </body>
</html>