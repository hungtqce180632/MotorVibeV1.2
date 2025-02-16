package DAOs;

import DB.DBConnection;
import Encryption.MD5;
import Models.EmployeeModels;
import static org.apache.commons.codec.digest.DigestUtils.md5Hex;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO {

    // Add a new employee account with transaction
    public boolean addNewEmployeeAccount(String email, String name, String password, String phoneNumber) {
        String accQuery = "INSERT INTO user_account (email, password, role, date_created, status) VALUES (?, ?, ?, ?, ?)";
        String empQuery = "INSERT INTO employees (user_id, name, email, phone_number) VALUES (?, ?, ?, ?)";

        String hashedPassword = md5Hex(password);
        String role = "employee";
        String dateCreated = LocalDate.now().toString();
        boolean status = true;

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Database connection failed!");
                return false;
            }
            conn.setAutoCommit(false);

            try (PreparedStatement accStmt = conn.prepareStatement(accQuery, Statement.RETURN_GENERATED_KEYS)) {
                accStmt.setString(1, email);
                accStmt.setString(2, hashedPassword);
                accStmt.setString(3, role);
                accStmt.setString(4, dateCreated);
                accStmt.setBoolean(5, status);

                if (accStmt.executeUpdate() > 0) {
                    try (ResultSet keys = accStmt.getGeneratedKeys()) {
                        if (keys.next()) {
                            int userId = keys.getInt(1);

                            try (PreparedStatement empStmt = conn.prepareStatement(empQuery)) {
                                empStmt.setInt(1, userId);
                                empStmt.setString(2, name);
                                empStmt.setString(3, email);
                                empStmt.setString(4, phoneNumber);

                                if (empStmt.executeUpdate() > 0) {
                                    conn.commit();
                                    System.out.println("Transaction committed successfully.");
                                    return true;
                                }
                            }
                        }
                    }
                }
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getUserID(int employeeId) {
        String query = "SELECT user_id FROM employees WHERE employee_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, employeeId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Edit employee account (with optional password update)
    public boolean editEmployeeAccount(int userId, String email, String name, String password, String phoneNumber) {
        boolean updatePassword = (password != null && !password.isEmpty());
        String accQuery = updatePassword
                ? "UPDATE user_account SET email = ?, password = ? WHERE user_id = ?"
                : "UPDATE user_account SET email = ? WHERE user_id = ?";
        String empQuery = "UPDATE employees SET name = ?, email = ?, phone_number = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("Database connection failed!");
                return false;
            }
            conn.setAutoCommit(false);

            // Update user_account
            try (PreparedStatement accStmt = conn.prepareStatement(accQuery)) {
                accStmt.setString(1, email);
                if (updatePassword) {
                    accStmt.setString(2, md5Hex(password));
                    accStmt.setInt(3, userId);
                } else {
                    accStmt.setInt(2, userId);
                }
                accStmt.executeUpdate();
            }

            // Update employees
            try (PreparedStatement empStmt = conn.prepareStatement(empQuery)) {
                empStmt.setString(1, name);
                empStmt.setString(2, email);
                empStmt.setString(3, phoneNumber);
                empStmt.setInt(4, userId);
                empStmt.executeUpdate();
            }

            conn.commit();
            System.out.println("Transaction committed successfully.");
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            try (Connection conn = DBConnection.getConnection()) {
                if (conn != null) {
                    conn.rollback();
                    System.out.println("Transaction rolled back.");
                }
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
        }
        return false;
    }

    public static List<EmployeeModels> getAllEmployee() throws SQLException {
        String sql = "SELECT e.*, ua.status FROM employees e JOIN user_account ua ON e.user_id = ua.user_id";
        List<EmployeeModels> employees = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                EmployeeModels employee = new EmployeeModels();
                employee.setEmployeeId(rs.getInt("employee_id"));
                employee.setUserId(rs.getInt("user_id"));
                employee.setName(rs.getString("name"));
                employee.setEmail(rs.getString("email"));
                employee.setPhoneNumber(rs.getString("phone_number"));
                employee.setStatus(rs.getBoolean("status"));
                employees.add(employee);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return employees;
    }

    public EmployeeModels getEmployeeByID(int employeeID) throws SQLException {
        String sql = "SELECT e.*, ua.status FROM employees e JOIN user_account ua ON e.user_id = ua.user_id WHERE e.employee_id = ?";
        EmployeeModels employee = new EmployeeModels();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, employeeID);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    employee.setEmployeeId(rs.getInt("employee_id"));
                    employee.setUserId(rs.getInt("user_id"));
                    employee.setName(rs.getString("name"));
                    employee.setEmail(rs.getString("email"));
                    employee.setPhoneNumber(rs.getString("phone_number"));
                    employee.setStatus(rs.getBoolean("status"));
                }
            }
        }
        return employee;
    }

    public boolean changeStatus(String id) throws SQLException {
        int empId = Integer.parseInt(id);
        EmployeeModels employee = getEmployeeByID(empId);
        String sql = "UPDATE user_account AS ua "
                   + "JOIN employees AS e ON ua.user_id = e.user_id "
                   + "SET ua.status = CASE WHEN ua.status = 1 THEN 0 ELSE 1 END "
                   + "WHERE e.employee_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, empId);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }

    public EmployeeModels getEmployeeByEmail(String email) throws SQLException {
        String sql = "SELECT e.*, ua.status "
                   + "FROM employees e JOIN user_account ua ON e.user_id = ua.user_id "
                   + "WHERE e.email = ?";
        EmployeeModels employee = new EmployeeModels();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    employee.setEmployeeId(rs.getInt("employee_id"));
                    employee.setUserId(rs.getInt("user_id"));
                    employee.setName(rs.getString("name"));
                    employee.setEmail(rs.getString("email"));
                    employee.setPhoneNumber(rs.getString("phone_number"));
                    employee.setStatus(rs.getBoolean("status"));
                }
            }
        }
        return employee;
    }
}
