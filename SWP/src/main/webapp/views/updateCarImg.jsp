<%-- 
    Document   : updateCarImg
    Created on : 17 thg 10, 2024, 14:27:06
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Car Image</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </head>
    <body>
        <%
            String imgId = (String) request.getAttribute("imgId");
        %>
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
        <div class="container text-center">
            <h1 class="text-center">Update Car Image</h1>
            <!-- Phần alert của bắt lỗi -->
            <div class="alert alert-warning alert-dismissible fade d-none show mb-3" role="alert" id="alertError">                    
                <p id="alertTxt" class="p-0 m-0"></p>
                <button type="button" class="btn-close" aria-label="Close" onclick="hideAlert()"></button>
            </div>
            <!-- Phần alert của bắt lỗi -->
            <img src="/ImageController/c/<%= imgId%>" class="mb-3" alt="Image" style="object-fit: cover; max-height: 500px; max-width: 500px;">
            <form method="post" action="/CarController" id="uploadForm" enctype="multipart/form-data"> 
                <div class="d-flex align-items-center justify-content-center mb-3"> 
                    <input required="" class="form-control me-2 w-25" type="file" id="image" name="image">               
                    <input hidden type="text" id="imageId" name="imageId" value="<%= imgId%>"> 
                    <button name="updateCarImgBtn" type="submit" id="updateImageCar" class="btn btn-primary">Update</button>
                </div> 
            </form> 
        </div>
        <script>
            document.getElementById('uploadForm').addEventListener('submit', function (event) {
                const validImageTypes = ['image/jpeg', 'image/png', 'image/gif'];
                const eventImage = document.getElementById('image').files[0]; // Lấy file upload
                const maxSizeInBytes = 16 * 1024 * 1024; // 16 M

                if (eventImage && !validImageTypes.includes(eventImage.type)) {
                    sendMessageError('Please upload a valid image file (JPEG, PNG, or GIF).');
                    event.preventDefault(); // Ngăn không cho submit form
                    return;
                }

                if (eventImage.size > maxSizeInBytes) {
                    sendMessageError("File must not exceed 16 MB.");
                    event.preventDefault();
                }
            });

            function sendMessageError(mess) {
                const alertText = document.getElementById('alertTxt');
                const alertError = document.getElementById('alertError');
                alertError.classList.remove("d-none");
                alertText.innerHTML = mess;
            }

            function hideAlert() {
                var alertElement = document.getElementById('alertError');
                alertElement.classList.add('d-none');
            }
        </script>
    </body>
</html>
