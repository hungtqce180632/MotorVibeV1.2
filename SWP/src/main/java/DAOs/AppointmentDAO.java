package DAOs;

import DB.DBConnection;
import Models.AppointmentModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public List<AppointmentModel> getAppointment(int cus_id) {
        String sql = "SELECT * FROM appointments WHERE customer_id = ?";
        List<AppointmentModel> appointments = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cus_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    AppointmentModel appointment = new AppointmentModel();
                    appointment.setAppointment_id(rs.getInt("appointment_id"));
                    appointment.setCustomer_id(rs.getInt("customer_id"));
                    appointment.setEmployee_id(rs.getInt("employee_id"));
                    appointment.setDate_start(rs.getString("date_start"));
                    appointment.setDate_end(rs.getString("date_end"));
                    appointment.setNote(rs.getString("note"));
                    appointment.setAppointment_status(rs.getBoolean("appointment_status"));

                    appointments.add(appointment);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return appointments;
    }

    /**
     * Check if the customer has an unfinished appointment or deposit/order not done.
     * Replaces "appointment_status = false" with "appointment_status = 0", etc.
     */
    public boolean checkHaveAppointment(int cus_id) {
    String sql = 
          "SELECT customer_id, appointment_status AS status \n"
        + "FROM appointments \n"
        + "WHERE customer_id = ? \n"
        + "  AND appointment_status = 0 \n"  // Incomplete appointment check
        + "UNION \n"
        + "SELECT customer_id, \n"
        + "       CASE \n"
        + "           WHEN deposit_status = 0 THEN 'Deposit Pending' \n"
        + "           ELSE 'Order Pending' \n"
        + "       END AS status \n"
        + "FROM orders \n"
        + "WHERE customer_id = ? \n"
        + "  AND (deposit_status = 0 OR order_status = 0);"; // Pending orders check

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, cus_id);
        stmt.setInt(2, cus_id);

        try (ResultSet rs = stmt.executeQuery()) {
            // If we find any row, it means there's an unfinished appointment or order
            return rs.next();  // Return true if there's any unfinished appointment or order
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}


    /**
     * Approach: 
     * 1) find the employee with the fewest incomplete appointments 
     * 2) then do the insert with that employee_id
     */
    public boolean createAppointment(String date_start, String note, int customer_id, String date_end) throws SQLException {
    if (checkHaveAppointment(customer_id)) {
        return false; // Customer already has an unfinished appointment or order
    }

    Integer employeeId = getLeastBusyEmployee();
    if (employeeId == null) {
        return false; // No employees available
    }

    String sqlInsert = "INSERT INTO appointments (customer_id, employee_id, date_start, date_end, note, appointment_status) "
                     + "VALUES (?, ?, ?, ?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sqlInsert)) {
        stmt.setInt(1, customer_id);
        stmt.setInt(2, employeeId);
        stmt.setString(3, date_start);
        stmt.setString(4, date_end);
        stmt.setString(5, note);
        stmt.setInt(6, 0);  // Default status to 0 (pending)

        int row = stmt.executeUpdate();
        return row > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}



    /**
     * Utility method to find the employee with the fewest incomplete appointments.
     */
    private Integer getLeastBusyEmployee() {
        // We want employees with the smallest count of appointments that have appointment_status=0
        String sql = 
              "SELECT TOP 1 e.employee_id \n"
            + "FROM employees e \n"
            + "LEFT JOIN appointments a ON e.employee_id = a.employee_id AND a.appointment_status = 0 \n"
            + "GROUP BY e.employee_id \n"
            + "ORDER BY COUNT(a.appointment_id) ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("employee_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean removeAppointment(int customer_id, int appointment_id) throws SQLException {
        String sql = "DELETE FROM appointments WHERE customer_id = ? AND appointment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customer_id);
            stmt.setInt(2, appointment_id);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<AppointmentModel> getAppointmentEmployee(int emp_id) {
    String sql = "SELECT * FROM appointments WHERE employee_id = ?";
    List<AppointmentModel> appointments = new ArrayList<>();
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, emp_id);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                AppointmentModel appointment = new AppointmentModel();
                appointment.setAppointment_id(rs.getInt("appointment_id"));
                appointment.setCustomer_id(rs.getInt("customer_id"));
                appointment.setEmployee_id(rs.getInt("employee_id"));
                appointment.setDate_start(rs.getString("date_start"));
                appointment.setDate_end(rs.getString("date_end"));
                appointment.setNote(rs.getString("note"));
                appointment.setAppointment_status(rs.getBoolean("appointment_status"));
                appointments.add(appointment);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return appointments;
}



    public boolean changeAppointment(int appointment_id) throws SQLException {
    String sql = "UPDATE appointments SET appointment_status = 1 WHERE appointment_id = ?"; // Change status

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setInt(1, appointment_id);
        int row = stmt.executeUpdate();
        return row > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}

}
