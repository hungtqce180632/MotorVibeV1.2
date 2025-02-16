package DAOs;

import DB.DBConnection;
import Models.FeedbackModel;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public boolean createFeedback(int order_id, String feedbackContent, int customerId) {
        String sql = "INSERT INTO feedbacks (order_id, customer_id, feedback_content, date_create, feedback_status) "
                   + "VALUES (?, ?, ?, ?, ?)";
        // Use LocalDate in code, so no MySQL/SQL Server function conflict
        LocalDate currentDate = LocalDate.now();
        String formattedDate = currentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        if (checkHaveFeedbackOnOrder(order_id, customerId)) {
            return false;
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, order_id);
            stmt.setInt(2, customerId);
            stmt.setString(3, feedbackContent);
            stmt.setString(4, formattedDate);
            stmt.setBoolean(5, false);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkHaveFeedbackOnOrder(int order_id, int customerId) {
        String sql = "SELECT * FROM feedbacks WHERE order_id = ? AND feedback_status = 0 AND customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, order_id);
            stmt.setInt(2, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<FeedbackModel> getAllFeedbackForCustomer(int cusId) {
        String sql = "SELECT * FROM feedbacks WHERE customer_id = ?";
        List<FeedbackModel> fbs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cusId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FeedbackModel fb = new FeedbackModel();
                    fb.setFeedback_id(rs.getInt("feedback_id"));
                    fb.setOrder_id(rs.getInt("order_id"));
                    fb.setCustomer_id(rs.getInt("customer_id"));
                    fb.setFeedback_content(rs.getString("feedback_content"));
                    fb.setDate_create(rs.getString("date_create"));
                    fb.setFeedback_status(rs.getBoolean("feedback_status"));
                    fbs.add(fb);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fbs;
    }

    public static List<FeedbackModel> getAllFeedbackForEmployee(int empId) {
        String sql = "SELECT f.* FROM feedbacks f JOIN orders o ON f.order_id = o.order_id WHERE o.employee_id = ?";
        List<FeedbackModel> fbs = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, empId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    FeedbackModel fb = new FeedbackModel();
                    fb.setFeedback_id(rs.getInt("feedback_id"));
                    fb.setOrder_id(rs.getInt("order_id"));
                    fb.setCustomer_id(rs.getInt("customer_id"));
                    fb.setFeedback_content(rs.getString("feedback_content"));
                    fb.setDate_create(rs.getString("date_create"));
                    fb.setFeedback_status(rs.getBoolean("feedback_status"));
                    fbs.add(fb);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return fbs;
    }

    public boolean changeStatus(int fbid) {
        String sql = "UPDATE feedbacks SET feedback_status = 1 WHERE feedback_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fbid);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
