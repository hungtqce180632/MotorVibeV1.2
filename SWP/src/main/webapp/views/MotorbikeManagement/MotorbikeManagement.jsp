<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Motorbike Management</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <style>
        .status-available { color: green; font-weight: bold; }
        .status-sold-out { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h2 class="text-center mb-4">Motorbike Management</h2>
        
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Brand</th>
                    <th>Model</th>
                    <th>Name</th>
                    <th>Start Date</th>
                    <th>Color</th>
                    <th>Price ($)</th>
                    <th>Fuel Type</th>
                    <%--<th>Quantity</th>--%>
                    <%--<th>Status</th>--%>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="motor" items="${MotorbikeList}" varStatus="loop">
                    <tr>
                        <td>${loop.count}</td>
                        <td>
                            <c:choose>
                                <c:when test="${brandMap[motor.brandId] != null}">
                                    ${brandMap[motor.brandId].brand_name}
                                </c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${modelMap[motor.modelId] != null}">
                                    ${modelMap[motor.modelId].model_name}
                                </c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${motor.name}</td>
                        <td>${motor.dateStart}</td>
                        <td>${motor.color}</td>
                        <td>${motor.price}</td>
                        <td>
                            <c:choose>
                                <c:when test="${fuelMap[motor.fuelId] != null}">
                                    ${fuelMap[motor.modelId].fuel_name}
                                </c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </td>
                        <%--<td>${motor.quantity}</td>--%>
                        <%--<td>
                            <c:choose>
                                <c:when test="${motor.status}">
                                    <span class="status-available">Available</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-sold-out">Hidden</span>
                                </c:otherwise>
                            </c:choose>
                        </td>--%>
                        <td>${motor.description}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
