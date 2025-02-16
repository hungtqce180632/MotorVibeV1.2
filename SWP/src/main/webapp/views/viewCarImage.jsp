<%-- 
    Document   : viewCarImage
    Created on : 17 thg 10, 2024, 10:45:27
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Car Image</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </head>
    <body>
        <script>
            $(document).ready(function () {
                // Lấy URL hiện tại
                var urlPath = window.location.pathname; // Lấy đường dẫn URL
                var parts = urlPath.split('/'); // Chia nhỏ đường dẫn thành mảng theo ký tự '/'

                // Giả sử eventId nằm ở phần thứ 4 trong mảng (index 3), điều chỉnh nếu cần
                var carId = parts[parts.length - 1]; // Lấy phần cuối cùng của đường dẫn (ID sự kiện)
                getCarImageId(carId); // Gọi hàm để lấy dữ liệu sự kiện
            });

            function getCarImageId(carId) {
                $.ajax({
                    url: '/CarController',
                    type: 'POST',
                    data: {getCarImg: 'true', carImageId: carId},
                    dataType: "json",
                    success: function (imgIdList) {
                        $.each(imgIdList, function (index, imageId) {
                            var imgCard = '<div class="col mb-4">' + // Added margin-bottom for spacing
                                    '<div class="card d-flex flex-column" style="height: 100%;">' + // Flex column for card
                                    '<img src="/ImageController/c/' + imageId + '" class="card-img-top" alt="Car ' + carId + '" style="object-fit: cover; height: 500px;">' + // Fixed height for image
                                    '<div class="card-body flex-grow-1 d-flex flex-column">' + // Make card body grow
                                    '<a href="/CarController/UpdateCarImg/' + imageId + '" type="button" id="updateImageCar" class="btn btn-primary mt-auto">Update</a>' + // Button positioned at the bottom
                                    '</div>' +
                                    '</div>' +
                                    '</div>';
                            $('#imageGallery').append(imgCard);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Có lỗi xảy ra khi lấy dữ liệu sự kiện: ", error);
                        console.log("Response từ server: ", xhr.responseText);
                    }
                });
            }

        </script>
        <div class="container">
            <h1 class="text-center mb-4">Car Image Gallery</h1>
            <div class="row row-cols-1 row-cols-md-3 g-4 m-0" id="imageGallery">            
            </div>
        </div>
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
    </body>
</html>
