package DB;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class DBConnection {

    // database chính 
//    private static final String URL = "jdbc:mysql://26.57.132.168:3306/swp";
//    private static final String USER = "ckchfbc";
//    private static final String PASSWORD = "1412";
////
////    //data base của kiên
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=swp2";
private static final String USER = "sa"; // Change if using a different SQL Server user
private static final String PASSWORD = "123"; // Replace with your actual password

//    
    public static Connection getConnection() {
    Connection conn = null;
    try {
        // Load SQL Server JDBC Driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        conn = DriverManager.getConnection(URL, USER, PASSWORD);

        // Optionally, print out the name of the connected database
        if (conn != null) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT DB_NAME()");
            if (rs.next()) {
                System.out.println("Connected to database: " + rs.getString(1));
            }
            rs.close();
            stmt.close();
        }
    } catch (ClassNotFoundException e) {
        System.err.println("SQL Server JDBC Driver not found: " + e.getMessage());
    } catch (SQLException e) {
        System.err.println("Error establishing connection: " + e.getMessage());
    }
    return conn;
}

    // Utility method to close the connection
    // Utility method to close the connection
public static void closeConnection(Connection conn) {
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}
}