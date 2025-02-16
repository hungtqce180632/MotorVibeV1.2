<%-- 
    Document   : navbar
    Created on : 1 thg 11, 2024, 14:03:03
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="https://kit.fontawesome.com/a611f8fd5b.js" crossorigin="anonymous"></script>
        <title>JSP Page</title>
        <!-- Font chữ -->        
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Oswald:wght@500&family=Outfit:wght@700&display=swap" rel="stylesheet">
        <style>
            .navbar-brand  {
                font-family: "Oswald", sans-serif;
                font-optical-sizing: auto;
                font-weight: 500;
                font-style: normal;
                color: #050B20;
            }

            .searchResults{
                overflow-y: auto;
            }
        </style>
    </head>
    <body>
        <!-- Navigation -->
        <nav class="shadow-sm rounded navbar navbar-expand-md navbar-light bg-white position-fixed top-0 start-0 w-100 m-0 p-0" style="z-index: 2;">
            <div class="container">
                <a class="navbar-brand" href="/"><h1>MotoVibe</h1></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/ProductController/Views">Product</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/HomePageController/Event">Event</a>
                        </li>                    
                        <!-- Nút logOut cho customer -->

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
                        <input hidden id="role" value="<%= role%>">
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
                        <input hidden value="<%= userEmail%>" id="userEmail">
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
</html>
