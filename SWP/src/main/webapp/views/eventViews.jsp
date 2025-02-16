<%-- 
    Document   : eventViews
    Created on : 22 thg 10, 2024, 21:26:23
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/font.css"/>
        <link rel="icon" href="${host}/ImageController/a/logo.png" type="image/x-icon">
        <style>
            .event-image {
                max-height: 400px; /* Chiều cao tối đa của hình ảnh */
                object-fit: cover; /* Đảm bảo hình ảnh không bị méo */
            }
            #eventDetails{
                word-break: break-all;
            }
        </style>
    </head>
    <body class="d-flex flex-column min-vh-100">
        <!-- navBar -->
        <%@include file="navbar.jsp" %>

        <!-- Show sự kiện infor -->
        <div class="container mt-5 pt-5">
            <div class="card shadow border-light mb-4" style="border-radius: 8px;">
                <div class="card-body">
                    <div class="text-center">
                        <h1 class="display-4" id="eventName">Event Title</h1>
                        <img id="eventImagePreview" src="" alt="Event Image" class="img-fluid event-image rounded mb-3" style="max-height: 500px; object-fit: cover;">
                    </div>
                    <p><strong>Date Start:</strong> <span id="dateStart"></span></p>
                    <p><strong>Date End:</strong> <span id="dateEnd"></span></p>
                    <div class="lead" id="eventDetails"></div>                
                </div>
            </div>
        </div>


        <!-- Footer -->
        <footer class="bg-dark text-white py-4 mt-auto w-100">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
        <script>
            function fetchEventById(eventId) {
                $.ajax({
                    url: "/EventController", // Đường dẫn tới EventController
                    type: "POST", // Phương thức HTTP POST
                    data: {eventId: eventId}, // Gửi ID sự kiện
                    dataType: "json", // Định dạng dữ liệu trả về
                    success: function (event) {
                        // Điền dữ liệu vào trang
                        $('#eventName').text(event.event_name);
                        document.getElementById('eventDetails').innerHTML = event.event_details;

                        $('#dateStart').text(event.date_start);
                        $('#dateEnd').text(event.date_end);
                        $('#eventImagePreview').attr('src', '/ImageController/b/' + event.event_id); // Hiển thị hình ảnh
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

                // Giả sử eventId nằm ở phần cuối cùng của đường dẫn
                var eventId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID sự kiện)
                fetchEventById(eventId); // Gọi hàm để lấy dữ liệu sự kiện
            });
        </script>
    </body>
</html>
