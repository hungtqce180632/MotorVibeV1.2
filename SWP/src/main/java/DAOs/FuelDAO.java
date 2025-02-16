package DAOs;

import DB.DBConnection;
import Models.FuelModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FuelDAO {

    public static List<FuelModel> getAllFuels() throws SQLException {
        String sql = "SELECT * FROM fuel";
        List<FuelModel> fuels = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                FuelModel fuel = new FuelModel();
                fuel.setFuel_id(rs.getInt("fuel_id"));
                fuel.setFuel_name(rs.getString("fuel_name"));
                fuels.add(fuel);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fuels;
    }
}
