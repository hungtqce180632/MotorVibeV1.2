/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBConnection;
import Models.Motorbike;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author tiend
 */
public class MotorbikeDAO {

    private final Connection con;
    public MotorbikeDAO() {
         con = DBConnection.getConnection();
    }
    public List<Motorbike> getMotorbikeList() {
        List<Motorbike> motorbikeList = new ArrayList<>();
        String sql = "SELECT * FROM swp2.dbo.cars";

        try (PreparedStatement stmt = con.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Motorbike motor = new Motorbike(
                    rs.getInt("car_id"),
                    rs.getInt("brand_id"),
                    rs.getInt("model_id"),
                    rs.getString("car_name"),
                    rs.getDate("date_start"),
                    rs.getString("color"),
                    rs.getDouble("price"),
                    rs.getInt("fuel_id"),
                    rs.getBoolean("status"),
                    rs.getString("description")
                );
                motorbikeList.add(motor);
            }
        } catch (SQLException e) {
        }
        return motorbikeList;
    }
}
