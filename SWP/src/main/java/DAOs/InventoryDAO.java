package DAOs;

import DB.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class InventoryDAO {

    public boolean addInventory(int id, int quantity) throws SQLException {
        String sql = "INSERT INTO inventory (car_id, quantity) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.setInt(2, quantity);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }

    public boolean editInventory(int id, int quantity) throws SQLException {
        String sql = "UPDATE inventory SET quantity = ? WHERE car_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantity);
            stmt.setInt(2, id);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }
}
