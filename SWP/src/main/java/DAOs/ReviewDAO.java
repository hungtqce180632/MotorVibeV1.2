package DAOs;

import DB.DBConnection;
import Models.ReviewModels;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    /**
     * checkCusHaveOrder => calls orderDao.isOrderByCarAndCusForReview to see if
     * there's a completed order. Then also checks if there's already a review.
     */
    public boolean checkCusHaveOrder(int carId, int cusId) throws SQLException {
        OrderDAO orderDao = new OrderDAO();
        boolean isCusHaveOrder = orderDao.isOrderByCarAndCusForReview(carId, cusId);
        boolean isHaveReview = checkHaveReview(carId, cusId);
        // if the user has no order, or user already has a review, we block
        // => so condition is if there's no order or there's an existing review => true means can't create
        if (!isCusHaveOrder) {
            return true;
        }
        return (isCusHaveOrder && isHaveReview);
    }

    public boolean checkHaveReview(int carId, int cusId) {
        String sql = "SELECT * FROM reviews WHERE car_id = ? AND customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            stmt.setInt(2, cusId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * createReview: MySQL code used "CURRENT_DATE" => in SQL Server, we do
     * "CAST(GETDATE() AS date)" or handle date in Java. We'll do T-SQL:
     */
    public boolean createReview(int cusId, int carId, int rating, String review_text) {
        String sql = "INSERT INTO reviews (customer_id, car_id, rating, review_text, review_date, review_status) "
                   + "VALUES (?, ?, ?, ?, CAST(GETDATE() AS date), 1)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cusId);
            stmt.setInt(2, carId);
            stmt.setInt(3, rating);
            stmt.setString(4, review_text);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<ReviewModels> getAllReviewOfCar(int carId) throws SQLException {
        String sql = "SELECT r.*, c.name "
                   + "FROM reviews r "
                   + "JOIN customers c ON r.customer_id = c.customer_id "
                   + "WHERE r.car_id = ? AND r.review_status = 1";

        List<ReviewModels> reviews = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, carId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ReviewModels review = new ReviewModels();
                    review.setReview_id(rs.getInt("review_id"));
                    review.setCustomer_id(rs.getInt("customer_id"));
                    review.setCar_id(rs.getInt("car_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setReview_text(rs.getString("review_text"));
                    review.setReview_date(rs.getString("review_date"));
                    review.setReview_status(rs.getBoolean("review_status"));
                    review.setCustomer_name(rs.getString("name"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    public static List<ReviewModels> getAllReview() throws SQLException {
        String sql = "SELECT * FROM reviews";
        List<ReviewModels> reviews = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                ReviewModels review = new ReviewModels();
                review.setReview_id(rs.getInt("review_id"));
                review.setCustomer_id(rs.getInt("customer_id"));
                review.setCar_id(rs.getInt("car_id"));
                review.setRating(rs.getInt("rating"));
                review.setReview_text(rs.getString("review_text"));
                review.setReview_date(rs.getString("review_date"));
                review.setReview_status(rs.getBoolean("review_status"));
                reviews.add(review);
            }
        }
        return reviews;
    }

    public static ReviewModels getReviewById(int review_id) throws SQLException {
        String sql = "SELECT * FROM reviews WHERE review_id = ?";
        ReviewModels review = new ReviewModels();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, review_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    review.setReview_id(rs.getInt("review_id"));
                    review.setCustomer_id(rs.getInt("customer_id"));
                    review.setCar_id(rs.getInt("car_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setReview_text(rs.getString("review_text"));
                    review.setReview_date(rs.getString("review_date"));
                    review.setReview_status(rs.getBoolean("review_status"));
                }
            }
        }
        return review;
    }

    public boolean changeStatus(int id) throws SQLException {
        ReviewModels review = getReviewById(id);
        if (review == null) return false;

        String sql = "UPDATE reviews SET review_status = ? WHERE review_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, !review.isReview_status());
            stmt.setInt(2, id);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }
}
