<%-- 
    Document   : editEvent
    Created on : 12 thg 10, 2024, 00:42:36
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <!-- Quill Editor -->
        <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <style>
            #editor-container {
                height: 200px;
            }
        </style>       
    </head>
    <body>
        <%
            // Lấy danh sách cookies từ request
            Cookie[] cookies = request.getCookies();
            boolean isAdmin = false;
            // Duyệt qua các cookies và kiểm tra cookie "userEmail"
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        isAdmin = true;
                    }
                    if (cookie.getName().equals("email")) {
                        String email = cookie.getValue();
                    }
                }
            }
            if (!isAdmin) {
                response.sendRedirect("/");
            }
        %>
        <div class="container mt-5">
            <h2>Edit Event</h2>
            <form action="EventController" method="post" enctype="multipart/form-data" id="eventForm">
                <div class="mb-3">
                    <label for="eventId" class="form-label">Event Id:</label>
                    <input type="text" class="form-control" id="eventId" name="event_id" readonly>
                </div>
                <div class="mb-3">
                    <label for="eventName" class="form-label">Event Name:</label>
                    <input type="text" class="form-control" id="eventName" name="event_name" required>
                </div>
                <div class="mb-3">
                    <label for="eventDetails" class="form-label">Event Details:</label>
                    <div id="editor-container"></div>                    
                    <input type="hidden" name="event_details" id="eventDetails">
                </div>
                <div class="mb-3">
                    <label for="eventImage" class="form-label">Upload Image:</label>
                    <input type="file" class="form-control" id="eventImage" name="event_image">
                    <input id="haveImg" hidden name="haveImg">
                    <!-- Button to Open the Modal -->
                    <button type="button" class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#exampleModal">
                        Open Image
                    </button>
                </div>
                <div class="mb-3">
                    <label for="dateStart" class="form-label">Date Start:</label>
                    <input type="date" class="form-control" id="dateStart" name="date_start" required>
                </div>
                <div class="mb-3">
                    <label for="dateEnd" class="form-label">Date End:</label>
                    <input type="date" class="form-control" id="dateEnd" name="date_end" required>
                </div>
                <!-- Phần alert của bắt lỗi -->
                <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                    <p id="alertTxt" class="p-0 m-0"></p>
                    <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
                </div>
                <!-- Phần alert của bắt lỗi -->

                <button type="submit" class="btn btn-primary" name="editEvent">Submit</button>
            </form>
            <div class="container mt-5">
                <!-- The Modal -->
                <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="exampleModalLabel">View Image</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <img id="eventImagePreview" src="" alt="Event Image" class="img-fluid" style="max-width: 100%;">
                            </div>                        
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <script>
            var toolbarOptions = [
                ['bold', 'italic', 'underline', 'strike'], // toggled buttons
                ['blockquote', 'code-block'],

                [{'header': 1}, {'header': 2}], // custom button values
                [{'list': 'ordered'}, {'list': 'bullet'}],
                [{'script': 'sub'}, {'script': 'super'}], // superscript/subscript
                [{'indent': '-1'}, {'indent': '+1'}], // outdent/indent
                [{'direction': 'rtl'}], // text direction

                [{'size': ['small', false, 'large', 'huge']}], // custom dropdown
                [{'header': [1, 2, 3, 4, 5, 6, false]}],

                [{'color': []}, {'background': []}], // dropdown with defaults from theme
                [{'font': []}],
                [{'align': []}],
                ['clean']                                         // remove formatting button
            ];

            var quill = new Quill('#editor-container', {
                modules: {
                    toolbar: toolbarOptions
                },
                theme: 'snow'
            });
            document.getElementById('eventForm').addEventListener('submit', function () {
                document.getElementById('eventDetails').value = quill.root.innerHTML;
            });

            document.getElementById('eventForm').addEventListener('submit', function (event) {
                // Lấy giá trị của các input
                const eventName = document.getElementById('eventName').value;
                const eventDetails = document.getElementById('eventDetails').value;
                const eventImage = document.getElementById('eventImage').files[0];
                const haveImg = document.getElementById('haveImg');
                const dateStart = document.getElementById('dateStart').value;
                const dateEnd = document.getElementById('dateEnd').value;
                const today = new Date().toISOString().split('T')[0]; // Ngày hiện tại theo định dạng yyyy-mm-dd                
                const maxSizeInBytes = 16 * 1024 * 1024; // 16 MB

                if (!eventImage) {
                    // Nếu không có file, xét value là false
                    haveImg.value = 'false';
                } else {
                    haveImg.value = 'true';
                }

                // Kiểm tra độ dài của event_name (không quá 255 ký tự)
                if (eventName.length > 255) {
                    sendMessageError('Event Name cannot exceed 255 characters.');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }

                // Kiểm tra độ dài của event_details (tùy chỉnh theo giới hạn, ở đây là 5000 ký tự và lớn hơn 300 ký tự)
                if (eventDetails.length > 5000000 || eventDetails.length < 300) {
                    sendMessageError('Event Details must from 300 to 5000000 characters .');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }

                // Kiểm tra định dạng ảnh (chỉ cho phép JPEG, PNG, GIF)
                const validImageTypes = ['image/jpeg', 'image/png', 'image/gif'];
                if (eventImage && !validImageTypes.includes(eventImage.type)) {
                    sendMessageError('Please upload a valid image file (JPEG, PNG, or GIF).');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }

                if (eventImage.size > maxSizeInBytes) {
                    sendMessageError("File must not exceed 16 MB.");
                    event.preventDefault();
                }

                // Kiểm tra ngày (dateStart không nhỏ hơn ngày hiện tại và dateEnd không nhỏ hơn dateStart)
                if (dateStart < today) {
                    sendMessageError('Start Date cannot be earlier than today.');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }

                if (dateEnd <= dateStart) {
                    sendMessageError('End Date must be greater than Start Date.');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }
            });

            function hideAlert() {
                var alertElement = document.getElementById('alertError');
                alertElement.classList.add('d-none');
            }

            function sendMessageError(mess) {
                const alertText = document.getElementById('alertTxt');
                const alertError = document.getElementById('alertError');
                alertError.classList.remove("d-none");
                alertText.innerHTML = mess;
            }

            function fetchEventById(eventId) {
                $.ajax({
                    url: "/EventController", // Đường dẫn tới EventController
                    type: "POST", // Phương thức HTTP GET
                    data: {eventId: eventId}, // Gửi ID sự kiện
                    dataType: "json", // Định dạng dữ liệu trả về
                    success: function (event) {
                        // Điền dữ liệu vào form
                        $('#eventId').val(event.event_id);
                        $('#eventName').val(event.event_name);
                        $('#eventDetails').val(event.event_details); // Nếu cần hiển thị lại trong editor, cần dùng quill
                        quill.root.innerHTML = event.event_details; // Cập nhật nội dung cho Quill editor
                        $('#dateStart').val(event.date_start);
                        $('#dateEnd').val(event.date_end);
                        // Nếu có hình ảnh thì hiển thị ở đây (cần thêm logic để xử lý)
                        $('#eventImagePreview').attr('src', '/ImageController/b/' + event.event_id);
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: " + error);
                    }
                });
            }
            $(document).ready(function () {
                // Lấy URL hiện tại
                var urlPath = window.location.pathname; // Lấy đường dẫn URL
                var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'

                // Giả sử eventId nằm ở phần thứ 4 trong mảng (index 3), điều chỉnh nếu cần
                var eventId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID sự kiện)
                fetchEventById(eventId); // Gọi hàm để lấy dữ liệu sự kiện
            });
        </script>
    </body>
</html>
