package DAOs;

import DB.DBConnection;
import Models.CustomerAccountModel;
import Models.CustomerModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {

    public static CustomerAccountModel getCustomerInfor(String email) throws SQLException {
        String sql = "SELECT * FROM customers WHERE email = ?";
        CustomerAccountModel cus = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    cus = new CustomerAccountModel();
                    cus.setUser_id(rs.getInt("user_id"));
                    cus.setCustomer_id(rs.getInt("customer_id"));
                    cus.setName(rs.getString("name"));
                    cus.setEmail(rs.getString("email"));
                    cus.setPicture(rs.getString("picture"));
                    cus.setPhone_number(rs.getString("phone_number"));
                    cus.setCus_id_number(rs.getString("cus_id_number"));
                    cus.setAddress(rs.getString("address"));
                    cus.setPreferred_contact_method(rs.getString("preferred_contact_method"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cus;
    }

    public boolean updateCusotmerInfor(String name, String email, String address, String phone, int cus_id, int user_id) {
        String sql1 = "UPDATE customers SET name = ?, email = ?, address = ?, phone_number = ? WHERE customer_id = ?";
        String sql2 = "UPDATE customers SET name = ?, email = ? WHERE customer_id = ?";
        String sql3 = "UPDATE customers SET name = ?, email = ?, phone_number = ? WHERE customer_id = ?";
        String sql4 = "UPDATE customers SET name = ?, email = ?, address = ? WHERE customer_id = ?";
        String sql5 = "UPDATE user_account SET email = ? WHERE user_id = ?";

        // We do partial logic for address/phone. You can unify this or keep separate if you wish.
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt;
            if (address != null && phone != null) {
                stmt = conn.prepareStatement(sql1);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, address);
                stmt.setString(4, phone);
                stmt.setInt(5, cus_id);
            } else if (address != null && phone == null) {
                stmt = conn.prepareStatement(sql4);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, address);
                stmt.setInt(4, cus_id);
            } else if (address == null && phone != null) {
                stmt = conn.prepareStatement(sql3);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setInt(4, cus_id);
            } else {
                stmt = conn.prepareStatement(sql2);
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setInt(3, cus_id);
            }

            int row = stmt.executeUpdate();
            if (row > 0) {
                // Now update user_account
                PreparedStatement stmt2 = conn.prepareStatement(sql5);
                stmt2.setString(1, email);
                stmt2.setInt(2, user_id);
                int row2 = stmt2.executeUpdate();
                return row2 > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CustomerModel> getAllCustomer() {
        String sql = "SELECT c.customer_id, c.user_id, c.name, c.email, c.phone_number, "
                   + "       c.cus_id_number, c.address, ua.status "
                   + "FROM customers c "
                   + "JOIN user_account ua ON c.user_id = ua.user_id";
        List<CustomerModel> customers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                CustomerModel customer = new CustomerModel();
                customer.setCustomer_id(rs.getInt("customer_id"));
                customer.setUser_id(rs.getInt("user_id"));
                customer.setName(rs.getString("name"));
                customer.setEmail(rs.getString("email"));

                String phoneNum = rs.getString("phone_number");
                customer.setPhone_number(phoneNum == null ? "haven't enter data" : phoneNum);

                String cusId = rs.getString("cus_id_number");
                customer.setCus_id_number(cusId == null ? "haven't enter data" : cusId);

                String addr = rs.getString("address");
                customer.setAddress(addr == null ? "haven't enter data" : addr);

                customer.setStatus(rs.getBoolean("status"));
                customers.add(customer);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customers;
    }

    public boolean changeStatus(String customerID) throws SQLException {
        int id = Integer.parseInt(customerID);
        String sql = "UPDATE user_account AS ua "
                   + "JOIN customers AS c ON ua.user_id = c.user_id "
                   + "SET ua.status = CASE WHEN ua.status = 1 THEN 0 ELSE 1 END "
                   + "WHERE c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }

    public CustomerModel getCutomerById(int id) {
        String sql = "SELECT * "
                   + "FROM customers c "
                   + "JOIN user_account u ON c.user_id = u.user_id "
                   + "WHERE c.customer_id = ? AND u.status = 1";
        CustomerModel customer = new CustomerModel();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    customer.setCustomer_id(rs.getInt("customer_id"));
                    customer.setUser_id(rs.getInt("user_id"));
                    customer.setName(rs.getString("name"));
                    customer.setEmail(rs.getString("email"));
                    String phoneNum = rs.getString("phone_number");
                    customer.setPhone_number(phoneNum == null ? "haven't enter data" : phoneNum);

                    String cusId = rs.getString("cus_id_number");
                    customer.setCus_id_number(cusId == null ? "haven't enter data" : cusId);

                    String addr = rs.getString("address");
                    customer.setAddress(addr == null ? "haven't enter data" : addr);

                    customer.setStatus(rs.getBoolean("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }
}
