package DAOs;

import DB.DBConnection;
import Models.newCarModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WishlistDAO {

    public List<newCarModel> getAllWishlist(int cusId) throws SQLException {
        String sql =
            "SELECT c.*, i.quantity, "
          + "  (SELECT TOP 1 ci.car_image_id "
          + "   FROM car_image ci "
          + "   WHERE ci.car_id = c.car_id "
          + "   ORDER BY ci.car_image_id ASC) AS first_car_image_id "
          + "FROM wishlist w "
          + "JOIN cars c ON w.car_id = c.car_id "
          + "LEFT JOIN inventory i ON c.car_id = i.car_id "
          + "WHERE w.customer_id = ?";

        List<newCarModel> cars = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cusId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    newCarModel car = new newCarModel();
                    car.setCar_id(rs.getInt("car_id"));
                    car.setBrand_id(rs.getInt("brand_id"));
                    car.setModel_id(rs.getInt("model_id"));
                    car.setCar_name(rs.getString("car_name"));
                    car.setDate_start(rs.getString("date_start"));
                    car.setColor(rs.getString("color"));
                    car.setPrice(rs.getBigDecimal("price"));
                    car.setFuel_id(rs.getInt("fuel_id"));
                    car.setStatus(rs.getBoolean("status"));
                    car.setDescription(rs.getString("description"));
                    car.setQuantity(rs.getInt("quantity"));
                    car.setFirst_car_image_id(rs.getInt("first_car_image_id"));
                    cars.add(car);
                }
            }
        }
        return cars;
    }

    public boolean removeCarFromWishlist(int carId, int cusId) {
        String sql = "DELETE FROM wishlist WHERE car_id = ? AND customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setInt(2, cusId);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addWishlist(int carId, int cusId) {
        String sql = "INSERT INTO wishlist (car_id, customer_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setInt(2, cusId);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkHaveWish(int carId, int cusId) {
        String sql = "SELECT * FROM wishlist WHERE car_id = ? AND customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setInt(2, cusId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
