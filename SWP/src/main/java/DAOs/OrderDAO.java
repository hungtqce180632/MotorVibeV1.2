package DAOs;

import DB.DBConnection;
import Models.CustomerAccountModel;
import Models.EmployeeModels;
import Models.OrderModel;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public boolean createOrder(int car_id, int customer_id, String customer_cccd,
                               String customer_phone, String customer_address, BigDecimal car_price) throws SQLException {

        Integer employeeId = findLeastBusyEmployee();
        if (employeeId == null) {
            return false;
        }

        String insertOrderSql =
            "INSERT INTO orders (customer_id, employee_id, car_id, create_date, payment_method, total_amount, " +
            "                    deposit_status, order_status, date_start, date_end) " +
            "VALUES (?, ?, ?, GETDATE(), 'online_transfer', ?, 0, 0, CAST(GETDATE() AS date), " +
            "        DATEADD(DAY, 7, CAST(GETDATE() AS date)))";

        String updateCustomerSql =
            "UPDATE customers SET address = ?, phone_number = ?, cus_id_number = ? WHERE customer_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement(insertOrderSql)) {
                stmt.setInt(1, customer_id);
                stmt.setInt(2, employeeId);
                stmt.setInt(3, car_id);
                stmt.setBigDecimal(4, car_price);

                int rowsInserted = stmt.executeUpdate();
                boolean isCreated = (rowsInserted > 0);

                try (PreparedStatement stmt2 = conn.prepareStatement(updateCustomerSql)) {
                    stmt2.setString(1, customer_address);
                    stmt2.setString(2, customer_phone);
                    stmt2.setString(3, customer_cccd);
                    stmt2.setInt(4, customer_id);

                    int row1 = stmt2.executeUpdate();
                    boolean isCustomerUpdated = (row1 > 0);

                    return isCreated && isCustomerUpdated;
                }
            }
        }
    }

    private Integer findLeastBusyEmployee() throws SQLException {
        String selectSql =
            "SELECT TOP 1 e.employee_id " +
            "FROM employees e " +
            "LEFT JOIN orders o ON e.employee_id = o.employee_id " +
            "  AND (o.order_status = 0 OR o.deposit_status = 0) " +
            "GROUP BY e.employee_id " +
            "ORDER BY COUNT(o.order_id) ASC, NEWID()";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(selectSql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("employee_id");
            }
        }
        return null;
    }

    public static List<OrderModel> getAllOrders() throws SQLException {
        String sql = "SELECT * FROM orders";
        List<OrderModel> orders = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                OrderModel order = new OrderModel();
                order.setOrder_id(rs.getInt("order_id"));
                order.setCustomer_id(rs.getInt("customer_id"));
                order.setEmployee_id(rs.getInt("employee_id"));
                order.setCar_id(rs.getInt("car_id"));
                order.setCreate_date(rs.getString("create_date"));
                order.setPayment_method(rs.getString("payment_method"));
                order.setTotal_amount(rs.getBigDecimal("total_amount"));
                order.setDeposit_status(rs.getBoolean("deposit_status"));
                order.setOrder_status(rs.getBoolean("order_status"));
                order.setDate_start(rs.getString("date_start"));
                order.setDate_end(rs.getString("date_end"));
                orders.add(order);
            }
        }
        return orders;
    }

    public OrderModel getOrderById(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        OrderModel order = new OrderModel();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    order.setOrder_id(rs.getInt("order_id"));
                    order.setCustomer_id(rs.getInt("customer_id"));
                    order.setEmployee_id(rs.getInt("employee_id"));
                    order.setCar_id(rs.getInt("car_id"));
                    order.setCreate_date(rs.getString("create_date"));
                    order.setPayment_method(rs.getString("payment_method"));
                    order.setTotal_amount(rs.getBigDecimal("total_amount"));
                    order.setDeposit_status(rs.getBoolean("deposit_status"));
                    order.setOrder_status(rs.getBoolean("order_status"));
                    order.setDate_start(rs.getString("date_start"));
                    order.setDate_end(rs.getString("date_end"));
                }
            }
        }
        return order;
    }

    public boolean changeDepositStatus(String id) throws SQLException {
        int orderId = Integer.parseInt(id);
        String sql = "UPDATE orders SET deposit_status = 1 WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            int row = stmt.executeUpdate();
            return (row > 0);
        }
    }

    public boolean changeOrderStatus(String id) throws SQLException {
        int orderId = Integer.parseInt(id);
        String sqlOrder = "UPDATE orders SET order_status = 1 WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlOrder)) {
            stmt.setInt(1, orderId);
            int row = stmt.executeUpdate();
            if (row > 0) {
                return updateInventory(orderId);
            }
        }
        return false;
    }

    private boolean updateInventory(int orderId) throws SQLException {
        String sql = "UPDATE inventory " +
                     "SET quantity = quantity - 1 " +
                     "WHERE car_id = (SELECT car_id FROM orders WHERE order_id = ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            int row = stmt.executeUpdate();
            return (row > 0);
        }
    }

    public boolean isOrderByCarAndCusForReview(int carId, int cusId) throws SQLException {
        String sql = "SELECT * FROM orders " +
                     "WHERE car_id = ? AND customer_id = ? AND order_status = 1";
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

    public static List<OrderModel> getAllOrdersForEmployee(String email) throws SQLException {
        EmployeeDAO empDao = new EmployeeDAO();
        EmployeeModels emp = empDao.getEmployeeByEmail(email);
        if (emp == null) return new ArrayList<>();

        String sql = "SELECT o.*, w.warranty_id, " +
                     "CASE WHEN w.order_id IS NOT NULL THEN 1 ELSE 0 END AS has_warranty " +
                     "FROM orders o " +
                     "LEFT JOIN warranty w ON o.order_id = w.order_id " +
                     "WHERE o.employee_id = ?";

        List<OrderModel> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, emp.getEmployeeId());
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderModel order = new OrderModel();
                    order.setOrder_id(rs.getInt("order_id"));
                    order.setCustomer_id(rs.getInt("customer_id"));
                    order.setEmployee_id(rs.getInt("employee_id"));
                    order.setCar_id(rs.getInt("car_id"));
                    order.setCreate_date(rs.getString("create_date"));
                    order.setPayment_method(rs.getString("payment_method"));
                    order.setTotal_amount(rs.getBigDecimal("total_amount"));
                    order.setDeposit_status(rs.getBoolean("deposit_status"));
                    order.setOrder_status(rs.getBoolean("order_status"));
                    order.setDate_start(rs.getString("date_start"));
                    order.setDate_end(rs.getString("date_end"));
                    order.setHas_warranty(rs.getBoolean("has_warranty"));
                    order.setWarranty_id(rs.getInt("warranty_id"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public static List<OrderModel> getAllOrdersForCustomer(String email) throws SQLException {
        CustomerDAO cusDao = new CustomerDAO();
        CustomerAccountModel cus = cusDao.getCustomerInfor(email);
        if (cus == null) return new ArrayList<>();

        int cus_id = cus.getCustomer_id();
        String sql = "SELECT * FROM orders WHERE customer_id = ?";
        List<OrderModel> orders = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cus_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderModel order = new OrderModel();
                    order.setOrder_id(rs.getInt("order_id"));
                    order.setCustomer_id(rs.getInt("customer_id"));
                    order.setEmployee_id(rs.getInt("employee_id"));
                    order.setCar_id(rs.getInt("car_id"));
                    order.setCreate_date(rs.getString("create_date"));
                    order.setPayment_method(rs.getString("payment_method"));
                    order.setTotal_amount(rs.getBigDecimal("total_amount"));
                    order.setDeposit_status(rs.getBoolean("deposit_status"));
                    order.setOrder_status(rs.getBoolean("order_status"));
                    order.setDate_start(rs.getString("date_start"));
                    order.setDate_end(rs.getString("date_end"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    public boolean checkHaveFiveNotDoneOrder(int cus_id) {
        String sql =
            "SELECT COUNT(*) AS number " +
            "FROM orders " +
            "WHERE customer_id = ? " +
            "  AND (deposit_status = 0 OR (order_status = 0 AND date_end > CAST(GETDATE() AS date)))";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cus_id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int number = rs.getInt("number");
                    return (number >= 5);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean createOrderByEmp(int carId, int cusId, String cccd, BigDecimal total, int emp_id, String payment_method) throws SQLException {

        String insertOrderSql =
            "INSERT INTO orders (customer_id, employee_id, car_id, create_date, payment_method, total_amount, " +
            "                    deposit_status, order_status, date_start, date_end) " +
            "VALUES (?, ?, ?, GETDATE(), ?, ?, 0, 0, CAST(GETDATE() AS date), " +
            "        DATEADD(DAY, 7, CAST(GETDATE() AS date)))";

        String updateCustomerSql = "UPDATE customers SET cus_id_number = ? WHERE customer_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement stmtInsert = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                stmtInsert.setInt(1, cusId);
                stmtInsert.setInt(2, emp_id);
                stmtInsert.setInt(3, carId);
                stmtInsert.setString(4, payment_method);
                stmtInsert.setBigDecimal(5, total);

                int rowsInserted = stmtInsert.executeUpdate();
                boolean isCreate = rowsInserted > 0;

                try (PreparedStatement stmt2 = conn.prepareStatement(updateCustomerSql)) {
                    stmt2.setString(1, cccd);
                    stmt2.setInt(2, cusId);
                    int row1 = stmt2.executeUpdate();
                    boolean isEdit = row1 > 0;

                    if (isCreate && isEdit) {
                        conn.commit();
                        return true;
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public static List<Integer> getOrderIds(String email) throws SQLException {
        CustomerDAO cusDao = new CustomerDAO();
        CustomerAccountModel cus = cusDao.getCustomerInfor(email);
        if (cus == null) return new ArrayList<>();
        int cus_id = cus.getCustomer_id();

        String sql = "SELECT order_id FROM orders WHERE customer_id = ? AND order_status = 1 AND deposit_status = 1";
        List<Integer> listOrderId = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cus_id);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    listOrderId.add(rs.getInt("order_id"));
                }
            }
        }
        return listOrderId;
    }
}
