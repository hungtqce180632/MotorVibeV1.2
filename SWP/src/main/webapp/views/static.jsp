<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Daily Revenue and Car Statistics</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>        
        <script>
            $(document).ready(function () {

                $.ajax({
                    type: "POST",
                    url: "/DailyRevenueController",
                    success: function (response) {
                        // Parse the response
                        var dailyRevenue = response.dailyRevenue;
                        var dailyCarStatic = response.dailyCarStatic;

                        // Prepare data for the revenue chart
                        var revenueDates = Object.keys(dailyRevenue);
                        var revenues = Object.values(dailyRevenue);

                        // Prepare data for the car static chart
                        var carNames = Object.keys(dailyCarStatic);
                        var carDates = Object.values(dailyCarStatic);

                        // Create the revenue chart
                        var ctxRevenue = document.getElementById('revenueChart').getContext('2d');
                        new Chart(ctxRevenue, {
                            type: 'bar',
                            data: {
                                labels: revenueDates,
                                datasets: [{
                                        label: 'Daily Revenue',
                                        data: revenues,
                                        backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                        borderColor: 'rgba(75, 192, 192, 1)',
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                scales: {
                                    y: {
                                        beginAtZero: true
                                    }
                                },
                                plugins: {
                                    legend: {
                                        display: false
                                    },
                                    tooltip: {
                                        callbacks: {
                                            label: function (context) {
                                                return 'Revenue: ' + context.raw.toLocaleString('en-US', {style: 'currency', currency: 'USD'});
                                            }
                                        }
                                    }
                                }
                            }
                        });

                        // Create the car statistics chart
                        var ctxCarStatic = document.getElementById('carStaticChart').getContext('2d');
                        new Chart(ctxCarStatic, {
                            type: 'pie',
                            data: {
                                labels: carNames,
                                datasets: [{
                                        label: 'Daily Car Statistics',
                                        data: carDates.map(date => new Date(date).getDate()), // Transform dates for display
                                        backgroundColor: carNames.map(() => 'rgba(153, 102, 255, 0.2)'),
                                        borderColor: carNames.map(() => 'rgba(153, 102, 255, 1)'),
                                        borderWidth: 1
                                    }]
                            },
                            options: {
                                plugins: {
                                    tooltip: {
                                        callbacks: {
                                            label: function (context) {
                                                return context.label + ': ' + new Date(context.raw).toLocaleDateString();
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    },
                    error: function () {
                        alert("Error fetching data.");
                    }
                });
            });
        </script>
    </head>
    <body>
        <h1 class="mb-3 text-center">Daily Revenue and Car Statistics</h1>
        <canvas id="revenueChart" class="w-100 mb-5"></canvas>
        <h2 class="text-center mb-3">Car Statistics</h2>
        <div class="d-flex justify-content-center align-items-center">            
            <canvas id="carStaticChart" class="w-50 h-50"></canvas>
        </div>

    </body>
</html>
