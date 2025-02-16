package DAOs;

import DB.DBConnection;
import Models.BrandModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {

    public static List<BrandModel> getAllBrands() {
        String sql = "SELECT * FROM brands";
        List<BrandModel> brands = new ArrayList<>();

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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return brands;
    }
}
