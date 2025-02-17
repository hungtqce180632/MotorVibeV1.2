package DAOs;

import DB.DBConnection;
import Models.ModelsCarModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ModelDAO {

    public List<ModelsCarModel> getAllModels() {
        String sql = "SELECT * FROM model";
        List<ModelsCarModel> models = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ModelsCarModel model = new ModelsCarModel();
                model.setModel_id(rs.getInt("model_id"));
                model.setModel_name(rs.getString("model_name"));
                models.add(model);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return models;
    }
}
