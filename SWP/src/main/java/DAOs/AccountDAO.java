/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAOs;

import DB.DBConnection;
import Encryption.MD5;
import Models.CustomerAccountModel;
import Models.GoogleAccount;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;

/**
 *
 * @author thaii
 */
public class AccountDAO {

    public boolean checkAccountExsit(String acc_email) {
        String sql = "SELECT email FROM user_account WHERE email = ?";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, acc_email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String email = rs.getString("email");
                    return acc_email.equals(email);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addNewAccountGoogle(GoogleAccount acc) {
        // password omitted for google accounts, so we only store email, role, etc.
        String sql = "INSERT INTO user_account (email, role, date_created, status) VALUES (?, ?, ?, ?)";
        MD5 md5 = new MD5();
        String acc_email = acc.getEmail();
        String role = "customer";
        String date_created = String.valueOf(LocalDate.now());
        boolean status = true;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, acc_email);
            stmt.setString(2, role);
            stmt.setString(3, date_created);
            stmt.setBoolean(4, status);

            stmt.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addNewCustomerAccountGoogle(GoogleAccount acc) {
        String sql = "SELECT * FROM user_account WHERE email = ? AND role = ? AND status = 1";
        String sql2 = "INSERT INTO customers (user_id, name, email, picture) VALUES (?, ?, ?, ?)";

        String email = acc.getEmail();
        String name = acc.getName();
        String picture = acc.getPicture();
        String role = "customer";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, email);
            stm.setString(2, role);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                PreparedStatement stm2 = conn.prepareStatement(sql2);
                stm2.setInt(1, userId);
                stm2.setString(2, name);
                stm2.setString(3, email);
                stm2.setString(4, picture);
                stm2.executeUpdate();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public CustomerAccountModel getCustomerAccByEmail(GoogleAccount acc) {
        String sql = "SELECT * FROM customers WHERE email = ?";
        CustomerAccountModel cus_acc = null;
        String email = acc.getEmail();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int customer_id = rs.getInt("customer_id");
                int user_id = rs.getInt("user_id");
                String name = rs.getString("name");
                String picture = rs.getString("picture");
                String phone_number = rs.getString("phone_number");
                String cus_id_number = rs.getString("cus_id_number");
                String address = rs.getString("address");
                String preferred_contact_method = rs.getString("preferred_contact_method");
                cus_acc = new CustomerAccountModel(customer_id, user_id, name, email, picture,
                                                   phone_number, cus_id_number, address, preferred_contact_method);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return cus_acc;
    }

    public CustomerAccountModel getCustomerAccByEmail(String email) {
        String sql = "SELECT * FROM customers WHERE email = ?";
        CustomerAccountModel cus_acc = null;

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int customer_id = rs.getInt("customer_id");
                int user_id = rs.getInt("user_id");
                String name = rs.getString("name");
                String picture = rs.getString("picture");
                String phone_number = rs.getString("phone_number");
                String cus_id_number = rs.getString("cus_id_number");
                String address = rs.getString("address");
                String preferred_contact_method = rs.getString("preferred_contact_method");
                cus_acc = new CustomerAccountModel(customer_id, user_id, name, email, picture,
                                                   phone_number, cus_id_number, address, preferred_contact_method);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
        return cus_acc;
    }

    public boolean addNewAccount(String email, String name, String password) {
    String sql = "INSERT INTO user_account (email, password, role, date_created, status) VALUES (?, ?, ?, ?, ?)";
    String sql2 = "INSERT INTO customers (user_id, name, email, status) VALUES (?, ?, ?, ?)";

    MD5 md5 = new MD5();
    String hashedPassword = md5.getMd5(password);
    String role = "customer";
    String date_created = String.valueOf(LocalDate.now());
    boolean status = true;

    try (Connection conn = DBConnection.getConnection()) {
        // Insert into user_account
        PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        stmt.setString(1, email);
        stmt.setString(2, hashedPassword);
        stmt.setString(3, role);
        stmt.setString(4, date_created);
        stmt.setBoolean(5, status);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            ResultSet generatedKeys = stmt.getGeneratedKeys();
            if (generatedKeys.next()) {
                int userId = generatedKeys.getInt(1); // Get generated user_id

                // Insert into customers
                PreparedStatement stmt2 = conn.prepareStatement(sql2);
                stmt2.setInt(1, userId);
                stmt2.setString(2, name);
                stmt2.setString(3, email);
                stmt2.setBoolean(4, status);
                stmt2.executeUpdate();
            }
            return true;
        }
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
    return false;
}


    public boolean addNewCustomerAccount(String email, String name) {
        String sql = "SELECT * FROM user_account WHERE email = ? AND role = ? AND status = 1";
        String sql2 = "INSERT INTO customers (user_id, name, email) VALUES (?, ?, ?)";
        String role = "customer";

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stm = conn.prepareStatement(sql);
            stm.setString(1, email);
            stm.setString(2, role);

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int userId = rs.getInt("user_id");
                PreparedStatement stm2 = conn.prepareStatement(sql2);
                stm2.setInt(1, userId);
                stm2.setString(2, name);
                stm2.setString(3, email);
                stm2.executeUpdate();
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return false;
    }

    public boolean loginAccount(String email, String password) {
        String sql = "SELECT * FROM user_account WHERE email = ? AND password = ? AND status = 1";
        MD5 md5 = new MD5();
        String hassPassword = md5.getMd5(password);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, hassPassword);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean resetPassword(String email, String password) {
        String sql = "UPDATE user_account SET email = ?, password = ? WHERE email = ?";
        MD5 md5 = new MD5();
        String hassPassword = md5.getMd5(password);

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);
            stmt.setString(2, hassPassword);
            stmt.setString(3, email);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isAdmin(String email) {
        String sql = "SELECT * FROM user_account WHERE role = 'admin' AND email = ?;";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String getRole(String email) {
        String sql = "SELECT role FROM user_account WHERE email = ?";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    public String getAdminName(String email) {
        // This queries an "admin" table that might not exist in your schema,
        // so adapt to your actual table structure or remove if not used.
        String sql = "SELECT a.name FROM user_account ua JOIN admin a ON ua.user_id = a.user_id "
                   + "WHERE ua.role = 'admin' AND ua.email = ?;";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("name");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean checkAccountBan(String acc_email) {
        String sql = "SELECT * FROM user_account WHERE email = ? AND status = 0;";
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, acc_email);

            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}