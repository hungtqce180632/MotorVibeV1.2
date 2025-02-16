<%-- 
    Document   : homepage2
    Created on : 27 thg 9, 2024, 16:14:14
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
    <head>
        <%
            //Thử control + f5 để refresh cache, hoặc gõ '${host}/../..' vào cái link
            String host = request.getRequestURI();
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- AE copy từ đây tới title nếu tạo jsp mới thêm các thể khác thì thêm trên -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <!-- Font chữ -->        
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@500&family=Outfit:wght@700&display=swap" rel="stylesheet">
        <link rel="icon" href="${host}/ImageController/logo.png" type="image/x-icon">        
        <title >DriveAura</title>
        <style>
            *{
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            .card {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
            }

            .card:hover {
                transform: translateY(-10px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
            }

            .card-img-top {
                height: 200px;
                width: 150px;
                object-fit: cover;
            }

            a{
                text-decoration: none;
            }

            .navbar-brand  {
                font-family: "Oswald", sans-serif;
                font-optical-sizing: auto;
                font-weight: 500;
                font-style: normal;
                color: #050B20;
            }
        </style>
    </head>
    <body>        
        <%
            Cookie[] cookies = request.getCookies();
            boolean isAdmin = false;
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("admin")) {
                        isAdmin = true;
                        break;
                    }
                }
            }
            if (isAdmin) {
                response.sendRedirect("/AdminController/Dashboard");
                return; // Ensure to return after redirect
            }
        %>
        <!-- Navigation -->
        <nav class="shadow-sm rounded navbar navbar-expand-md navbar-light bg-white position-fixed top-0 start-0 w-100 m-0 p-0" style="z-index: 1;">
            <div class="container">
                <a class="navbar-brand" href="/"><h1>DriveAura</h1></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/ProductController/Views">Product</a>                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/HomePageController/Event">Event</a>
                        </li>                    
                        <!-- Nút logOut cho customer -->

                        <%
                            // Lấy danh sách cookies từ request
                            String userEmail = null;
                            String role = null;

                            // Duyệt qua các cookies và kiểm tra cookie "userEmail"
                            if (cookies != null) {
                                for (Cookie cookie : cookies) {
                                    if (cookie.getName().equals("userEmail")) {
                                        userEmail = cookie.getValue(); // Lấy giá trị email từ cookie
                                    }
                                    if (cookie.getName().equals("role")) {
                                        role = cookie.getValue();
                                    }
                                }
                            }

                            // Kiểm tra nếu cookie "userEmail" tồn tại
                            if ((userEmail != null) && (role.equals("customer"))) {
                        %>
                        <!-- Hiển thị nút nếu là customer -->
                        <li class="nav-item">
                            <a class="border rounded-circle btn btn-outline-dark text-center" href="/CustomerController/Profile" title="Profile">
                                <i class="fa-solid fa-user"></i>
                            </a>
                        </li>                        
                        <input hidden value="<%= userEmail%>" id="userEmail">    
                        <%
                        } else {
                            if ((userEmail != null) && (role.equals("employee"))) {
                        %>
                        <!-- Hiển thị nút nếu là employee -->
                        <li class="nav-item">
                            <a class="border rounded-circle btn btn-outline-dark text-center" href="/EmployeeController/Profile" title="Profile">
                                <i class="fa-solid fa-user"></i>
                            </a>
                        </li>                        
                        <input hidden id="role" value="<%= role%>">
                        <%
                        } else {
                        %>
                        <!-- Hiển thị thông báo nếu không có cookie -->
                        <li class="nav-item">                            
                            <a class="nav-link" href="${host}/HomePageController/Login">Login</a>
                        </li>
                        <%
                                }
                            }
                        %>
                        <!-- Nút tìm kiếm -->
                        <li class="nav-item">
                            <a class="nav-link" href="#" id="searchButton" data-bs-toggle="modal" data-bs-target="#searchModal"><i class="fa-solid fa-magnifying-glass"></i></a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Search Modal -->
        <div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="searchModalLabel">Search Cars</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="searchForm">
                            <div class="input-group mb-3">
                                <input 
                                    type="text" 
                                    id="searchInput" 
                                    name="search" 
                                    class="form-control" 
                                    placeholder="Enter car name..." 
                                    aria-label="Search" 
                                    required>
                                <button class="btn btn-outline-secondary" type="submit">Search</button>
                            </div>
                        </form>
                        <div id="loadingIndicator" class="text-center" style="display:none;">Searching...</div>
                        <div id="searchResults" class="mt-4"></div> <!-- Search results will appear here -->
                    </div>
                </div>
            </div>
        </div>

        <!-- jQuery CDN -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                // Handle form submission
                $('#searchForm').on('submit', function (event) {
                    event.preventDefault(); // Prevent page reload

                    const searchTerm = $('#searchInput').val().trim(); // Get search input
                    if (!searchTerm) {
                        showErrorMessage('Please enter a search term.');
                        return;
                    }

                    updateUIBeforeSearch(); // Show loader and clear results

                    // Send AJAX request to the servlet
                    $.ajax({
                        url: '/SearchController',
                        method: 'POST',
                        data: {search: searchTerm},
                        dataType: 'html', // Expect HTML response from the server
                        success: function (response) {
                            showLoadingIndicator(false); // Hide loader once response is received

                            // Insert the HTML response directly into the search results container
                            $('#searchResults').html(response);                           
                        },
                        error: function (xhr, status, error) {
                            const errorMessage = xhr.responseText || error || 'Unknown error';
                            console.error(`Error occurred: ${status} - ${errorMessage}`);
                            showErrorMessage(`An error occurred: ${errorMessage}`);
                            showLoadingIndicator(false); // Hide loader on error
                        }
                    });
                });

                // UI update before starting a new search
                function updateUIBeforeSearch() {
                    showLoadingIndicator(true);
                    clearSearchResults();
                }

                // Show or hide the loading indicator
                function showLoadingIndicator(show) {
                    $('#loadingIndicator').toggle(show);
                    $('#searchForm button[type="submit"]').prop('disabled', show);
                }

                // Clear previous search results
                function clearSearchResults() {
                    $('#searchResults').empty();
                }

                // Show error messages to the user
                function showErrorMessage(message) {
                    $('#searchResults').html(`
                        <div class="alert alert-danger text-center" role="alert">
            ${message}
                        </div>
                    `);
                }
            });
        </script>

        <section class="d-flex justify-content-center align-items-center text-center bg-dark text-white mt-5" style="height: 80vh; background-image: url('/ImageController/a/bghome.jpg'); background-size: cover; background-position: center;">
            <div class="container ">
                <h1 class="display-4 fw-bold">Find Your Perfect Vehicle Online</h1>
                <p class="lead fw-bold">The World's Largest Used Car Dealership</p>
            </div>
        </section>

        <!-- Best Seller Cars -->
        <section class="container my-5">
            <h2 class="text-center mb-4">The Best Seller Cars</h2>
            <%@include file="/views/bestSellCar.jsp" %>
        </section>




        <!-- Why Choose Us -->
        <section class="bg-dark text-white py-5">
            <div class="container">
                <h2 class="text-center mb-5">Why Choose Us?</h2>
                <div class="row text-center">
                    <div class="col-md-3">
                        <div class="mb-2"><i class="fa-solid fa-dollar-sign text-white" style="font-size: 2rem;"></i></div>
                        <h5>Special Financing Offers</h5>
                        <p>Our stress-free finance department can help you save money.</p>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-2"><i class="fa-solid fa-shield text-white" style="font-size: 2rem;"></i></div>
                        <h5>Trusted Car Dealership</h5>
                        <p>We provide transparent and reliable services.</p>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-2"><i class="fa-solid fa-tag text-white" style="font-size: 2rem;"></i></div>
                        <h5>Transparent Pricing</h5>
                        <p>No hidden fees or surprises.</p>
                    </div>
                    <div class="col-md-3">
                        <div class="mb-2"><i class="fa-solid fa-screwdriver-wrench text-white" style="font-size: 2rem;"></i></div>
                        <h5>Expert Car Service</h5>
                        <p>Our certified experts keep your car in top condition.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- New Car Section -->
        <section class="container my-5" id="newCarContainer">
            <h2 class="text-center mb-5">The New Cars</h2>
            <%@include file="/views/newCar.jsp" %>
        </section>

        <!-- Footer -->
        <footer class="bg-dark text-white py-4">
            <div class="container">
                <%@include file="/views/footer.jsp" %>
            </div>
        </footer>
    </body>    
</html>