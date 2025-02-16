package DAOs;

import DB.DBConnection;
import Models.BrandModel;
import Models.CarModel;
import Models.CarModel_Model;
import Models.FuelModel;
import Models.newCarModel;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CarDAO {

    public static List<CarModel> getAllCars() throws SQLException {
        String sql = "SELECT c.*, i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id";
        List<CarModel> cars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                CarModel car = new CarModel();
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
                cars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }

    public CarModel getCarById(int car_id) throws SQLException {
        String sql = "SELECT c.*, i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.car_id = ?";
        CarModel car = new CarModel();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, car_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
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
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return car;
    }

    public boolean createCar(CarModel car) {
        String sql = "INSERT INTO cars (brand_id, model_id, car_name, date_start, color, price, fuel_id, status, description) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, car.getBrand_id());
            stmt.setInt(2, car.getModel_id());
            stmt.setString(3, car.getCar_name());
            stmt.setString(4, car.getDate_start());
            stmt.setString(5, car.getColor());
            stmt.setBigDecimal(6, car.getPrice());
            stmt.setInt(7, car.getFuel_id());
            stmt.setBoolean(8, true);
            stmt.setString(9, car.getDescription());
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int findCarIdByName(CarModel car) {
        String sql = "SELECT car_id FROM cars WHERE car_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, car.getCar_name());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("car_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateCarImage(javax.servlet.http.Part file, int id) throws java.io.IOException {
        String sql = "UPDATE car_image SET picture = ? WHERE car_image_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            InputStream inputStream = file.getInputStream();
            stmt.setBlob(1, inputStream);
            stmt.setInt(2, id);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean changeStatus(int id) throws SQLException {
        CarModel car = getCarById(id);
        String sql = "UPDATE cars SET status = ? WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, !car.isStatus());
            stmt.setInt(2, id);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean editCar(CarModel car, int id) {
        String sql = "UPDATE cars "
                   + "SET brand_id = ?, model_id = ?, car_name = ?, date_start = ?, color = ?, price = ?, fuel_id = ?, description = ? "
                   + "WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, car.getBrand_id());
            stmt.setInt(2, car.getModel_id());
            stmt.setString(3, car.getCar_name());
            stmt.setString(4, car.getDate_start());
            stmt.setString(5, car.getColor());
            stmt.setBigDecimal(6, car.getPrice());
            stmt.setInt(7, car.getFuel_id());
            stmt.setString(8, car.getDescription());
            stmt.setInt(9, id);

            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // getNewCars: was using LIMIT, CURDATE(). Now replaced with TOP x, CAST(GETDATE() as date)
    public static List<newCarModel> getNewCars() {
        String sql = "SELECT TOP 4 "
                   + "   c.*, "
                   + "   (SELECT TOP 1 ci.car_image_id "
                   + "    FROM car_image ci "
                   + "    WHERE ci.car_id = c.car_id "
                   + "    ORDER BY ci.car_image_id ASC "
                   + "   ) AS first_car_image_id, "
                   + "   i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.status = 1 "
                   + "  AND c.date_start <= CAST(GETDATE() AS date) "
                   + "ORDER BY c.date_start DESC, c.car_id DESC";
        List<newCarModel> newCars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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
                car.setFirst_car_image_id(rs.getInt("first_car_image_id"));
                car.setQuantity(rs.getInt("quantity"));
                newCars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newCars;
    }

    // getRelatedCar: replaced LIMIT 4 with TOP 4, RAND() with NEWID()
    public static List<newCarModel> getRelatedCar(int brand_id) {
        String sql = "SELECT TOP 4 "
                   + "   c.*, "
                   + "   i.quantity, "
                   + "   (SELECT TOP 1 ci.car_image_id "
                   + "    FROM car_image ci "
                   + "    WHERE ci.car_id = c.car_id "
                   + "    ORDER BY ci.car_image_id ASC "
                   + "   ) AS first_car_image_id "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.brand_id = ? AND c.status = 1 "
                   + "ORDER BY NEWID()";
        List<newCarModel> cars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, brand_id);
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }

    // getBestSellingCars: replaced LIMIT 12 with TOP 12, plus date_start <= GETDATE()
    // also group by all columns from c
    public static List<newCarModel> getBestSellingCars() {
        String sql = "SELECT TOP 12 "
                   + "   c.car_id, c.brand_id, c.model_id, c.car_name, c.date_start, c.color, c.price, "
                   + "   c.fuel_id, c.status, c.description, "
                   + "   MAX(i.quantity) AS quantity, COUNT(o.car_id) AS total_orders, "
                   + "   (SELECT TOP 1 ci.car_image_id "
                   + "    FROM car_image ci "
                   + "    WHERE ci.car_id = c.car_id "
                   + "    ORDER BY ci.car_image_id ASC) AS first_car_image_id "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "LEFT JOIN orders o ON c.car_id = o.car_id "
                   + "WHERE c.status = 1 "
                   + "  AND c.date_start <= CAST(GETDATE() AS date) "
                   + "GROUP BY c.car_id, c.brand_id, c.model_id, c.car_name, c.date_start, c.color, "
                   + "         c.price, c.fuel_id, c.status, c.description "
                   + "ORDER BY total_orders DESC";
        List<newCarModel> newCars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

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
                newCars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newCars;
    }

    public List<newCarModel> getCarByName(String input) {
        String sql = "SELECT c.*, "
                   + "  (SELECT TOP 1 ci.car_image_id "
                   + "   FROM car_image ci "
                   + "   WHERE ci.car_id = c.car_id "
                   + "   ORDER BY ci.car_image_id ASC) AS first_car_image_id, "
                   + "  i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.status = 1 AND c.car_name LIKE ?";
        List<newCarModel> newCars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, "%" + input + "%");
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
                    car.setFirst_car_image_id(rs.getInt("first_car_image_id"));
                    car.setQuantity(rs.getInt("quantity"));
                    newCars.add(car);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newCars;
    }

    public List<CarModel> getListAllCars() throws SQLException {
        String sql = "SELECT c.*, i.quantity FROM cars c LEFT JOIN inventory i ON c.car_id = i.car_id";
        List<CarModel> cars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                CarModel car = new CarModel();
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
                cars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cars;
    }

    public List<newCarModel> getListtAllCars() {
        String sql = "SELECT c.*, "
                   + " (SELECT TOP 1 car_image_id FROM car_image ci WHERE ci.car_id = c.car_id ORDER BY ci.car_image_id ASC) AS first_car_image_id, "
                   + " i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.status = 1";
        List<newCarModel> newCars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
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
                car.setFirst_car_image_id(rs.getInt("first_car_image_id"));
                car.setQuantity(rs.getInt("quantity"));
                newCars.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newCars;
    }

    public List<FuelModel> getAllFuelTypes() {
        List<FuelModel> models = new ArrayList<>();
        String sql = "SELECT * FROM fuel";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                FuelModel model = new FuelModel();
                model.setFuel_id(rs.getInt("fuel_id"));
                model.setFuel_name(rs.getString("fuel_name"));
                models.add(model);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return models;
    }

    public List<BrandModel> getAllBrands() {
        List<BrandModel> brands = new ArrayList<>();
        String sql = "SELECT * FROM brands";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                BrandModel brand = new BrandModel();
                brand.setBrand_id(rs.getInt("brand_id"));
                brand.setBrand_name(rs.getString("brand_name"));
                brand.setCountry_of_origin(rs.getString("country_of_origin"));
                brand.setDescription(rs.getString("description"));
                brands.add(brand);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return brands;
    }

    public List<CarModel_Model> getAllModels() {
        List<CarModel_Model> models = new ArrayList<>();
        String sql = "SELECT * FROM model";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                CarModel_Model model = new CarModel_Model();
                model.setModel_id(rs.getInt("model_id"));
                model.setModel_name(rs.getString("model_name"));
                models.add(model);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return models;
    }

    public List<newCarModel> getAllFilterCars(int brand_id, int fuel_id, int model_id) {
        String sql = "SELECT c.*, "
                   + " (SELECT TOP 1 ci.car_image_id FROM car_image ci WHERE ci.car_id = c.car_id ORDER BY ci.car_image_id ASC) AS first_car_image_id, "
                   + " i.quantity "
                   + "FROM cars c "
                   + "LEFT JOIN inventory i ON c.car_id = i.car_id "
                   + "WHERE c.status = 1 ";

        List<Object> params = new ArrayList<>();

        if (brand_id > 0) {
            sql += " AND c.brand_id = ?";
            params.add(brand_id);
        }
        if (fuel_id > 0) {
            sql += " AND c.fuel_id = ?";
            params.add(fuel_id);
        }
        if (model_id > 0) {
            sql += " AND c.model_id = ?";
            params.add(model_id);
        }

        List<newCarModel> cars = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            // Bind parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stmt.executeQuery();
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
                car.setFirst_car_image_id(rs.getInt("first_car_image_id"));
                car.setQuantity(rs.getObject("quantity") == null ? 0 : rs.getInt("quantity"));

                cars.add(car);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return cars;
    }

    public boolean updateCarImage(Part filePart, int imageId) {
    String sql = "UPDATE car_image SET picture = ? WHERE car_image_id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        // Convert the uploaded file (Part) into an InputStream
        InputStream inputStream = filePart.getInputStream();

        // Bind parameters
        stmt.setBlob(1, inputStream);   // For SQL Server, ensure column type is VARBINARY(MAX)
        stmt.setInt(2, imageId);

        int rowsAffected = stmt.executeUpdate();
        return (rowsAffected > 0);

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
}
