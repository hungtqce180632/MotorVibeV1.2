package DAOs;

import DB.DBConnection;
import Models.EventModels;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EventDAO {

    public boolean createEvent(EventModels event) {
        String sql = "INSERT INTO events (event_name, event_details, image, date_start, date_end, event_status) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getEvent_name());
            stmt.setString(2, event.getEvent_details());
            if (event.getImage() != null) {
                stmt.setBlob(3, event.getImage());
            } else {
                stmt.setNull(3, java.sql.Types.BLOB);
            }
            stmt.setString(4, event.getDate_start());
            stmt.setString(5, event.getDate_end());
            stmt.setBoolean(6, event.isEvent_status());
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean editEventWithoutImg(EventModels event, int event_id) {
        String sql = "UPDATE events SET event_name = ?, event_details = ?, date_start = ?, date_end = ? "
                   + "WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getEvent_name());
            stmt.setString(2, event.getEvent_details());
            stmt.setString(3, event.getDate_start());
            stmt.setString(4, event.getDate_end());
            stmt.setInt(5, event_id);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean editEventWithImg(EventModels event, int event_id) {
        String sql = "UPDATE events SET event_name = ?, event_details = ?, image = ?, date_start = ?, date_end = ? "
                   + "WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, event.getEvent_name());
            stmt.setString(2, event.getEvent_details());
            if (event.getImage() != null) {
                stmt.setBlob(3, event.getImage());
            } else {
                stmt.setNull(3, java.sql.Types.BLOB);
            }
            stmt.setString(4, event.getDate_start());
            stmt.setString(5, event.getDate_end());
            stmt.setInt(6, event_id);

            int row = stmt.executeUpdate();
            return row > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public static List<EventModels> getAllEvents() throws SQLException {
        String sql = "SELECT * FROM events";
        List<EventModels> events = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                EventModels event = new EventModels();
                event.setEvent_id(rs.getInt("event_id"));
                event.setEvent_name(rs.getString("event_name"));
                event.setEvent_details(rs.getString("event_details"));
                event.setImage(null);
                event.setDate_start(rs.getString("date_start"));
                event.setDate_end(rs.getString("date_end"));
                event.setEvent_status(rs.getBoolean("event_status"));
                events.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }

    public EventModels getEventById(int eventId) throws SQLException {
        String sql = "SELECT * FROM events WHERE event_id = ?";
        EventModels event = new EventModels();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, eventId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    event.setEvent_id(rs.getInt("event_id"));
                    event.setEvent_name(rs.getString("event_name"));
                    event.setEvent_details(rs.getString("event_details"));
                    event.setImage(null);
                    event.setDate_start(rs.getString("date_start"));
                    event.setDate_end(rs.getString("date_end"));
                    event.setEvent_status(rs.getBoolean("event_status"));
                }
            }
        }
        return event;
    }

    public boolean changeStatus(String id) throws SQLException {
        int eventId = Integer.parseInt(id);
        EventModels event = getEventById(eventId);
        String sql = "UPDATE events SET event_status = ? WHERE event_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, !event.isEvent_status());
            stmt.setInt(2, eventId);
            int row = stmt.executeUpdate();
            return row > 0;
        }
    }

    public static List<EventModels> getAllEventsAvailable() throws SQLException {
        // Replaced "date_end > CURDATE()" with "date_end > CAST(GETDATE() AS date)"
        String sql = "SELECT * FROM events WHERE event_status = 1 AND date_end > CAST(GETDATE() AS date)";
        List<EventModels> events = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                EventModels event = new EventModels();
                event.setEvent_id(rs.getInt("event_id"));
                event.setEvent_name(rs.getString("event_name"));
                event.setEvent_details(rs.getString("event_details"));
                event.setImage(null);
                event.setDate_start(rs.getString("date_start"));
                event.setDate_end(rs.getString("date_end"));
                event.setEvent_status(rs.getBoolean("event_status"));
                events.add(event);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return events;
    }
}
