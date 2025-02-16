package DAOs;

import DB.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class StaticDAO {

    /**
     * Originally: 
     * SELECT DATE(create_date) AS revenue_date, SUM(total_amount) AS total_revenue
     * FROM orders 
     * GROUP BY DATE(create_date) 
     * ORDER BY revenue_date DESC 
     * LIMIT 10
     * 
     * In SQL Server, we do something like:
     * SELECT TOP 10 CONVERT(varchar(10), create_date, 23) AS revenue_date, 
     *    SUM(total_amount) AS total_revenue
     * FROM orders
     * GROUP BY CONVERT(varchar(10), create_date, 23)
     * ORDER BY revenue_date DESC
     */
    public Map<String, Double> getDailyRevenue() {
        Map<String, Double> dailyRevenue = new HashMap<>();
        String query =
            "SELECT TOP 10 "
          + "  CONVERT(VARCHAR(10), create_date, 23) AS revenue_date, "
          + "  SUM(total_amount) AS total_revenue "
          + "FROM orders "
          + "GROUP BY CONVERT(VARCHAR(10), create_date, 23) "
          + "ORDER BY revenue_date DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String date = rs.getString("revenue_date");
                double revenue = rs.getDouble("total_revenue");
                dailyRevenue.put(date, revenue);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyRevenue;
    }

    /**
     * getDailyCarStatic: 
     * MySQL: SELECT DATE(create_date) AS revenue_date, cars.car_name 
     * FROM orders 
     * JOIN cars ON cars.car_id = orders.car_id
     * WHERE deposit_status=true AND order_status=true
     * LIMIT 10
     * 
     * In SQL Server we do something like:
     * SELECT TOP 10 
     *   CONVERT(VARCHAR(10), create_date, 23) AS revenue_date,
     *   c.car_name
     * FROM orders o
     * JOIN cars c ON c.car_id = o.car_id
     * WHERE deposit_status=1 AND order_status=1
     */
    public Map<String, String> getDailyCarStatic() {
        Map<String, String> dailyCarStatic = new HashMap<>();
        String query = 
            "SELECT TOP 10 "
          + "  CONVERT(VARCHAR(10), o.create_date, 23) AS revenue_date, "
          + "  c.car_name "
          + "FROM orders o "
          + "JOIN cars c ON c.car_id = o.car_id "
          + "WHERE deposit_status = 1 AND order_status = 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                String car_name = rs.getString("car_name");
                String revenue_date = rs.getString("revenue_date");
                dailyCarStatic.put(car_name, revenue_date);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return dailyCarStatic;
    }
}
