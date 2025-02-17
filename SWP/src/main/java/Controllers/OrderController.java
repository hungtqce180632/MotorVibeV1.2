package Controllers;

import DAOs.EmployeeDAO;
import DAOs.OrderDAO;
import Models.EmployeeModels;
import Models.OrderModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class OrderController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OrderController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OrderController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String host = request.getRequestURI();
        if (host.startsWith("/OrderController/Buy/")) {
            request.getRequestDispatcher("/views/order.jsp").forward(request, response);
        }
        if (host.startsWith("/OrderController/Edit/")) {
            request.getRequestDispatcher("/views/orderEdit.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        OrderDAO orderDao = new OrderDAO();

        if (request.getParameter("createOrder") != null) {
            int car_id = Integer.parseInt(request.getParameter("car_id"));
            int customer_id = Integer.parseInt(request.getParameter("customer_id"));
            String customer_cccd = request.getParameter("customer_cccd");
            String customer_phone = request.getParameter("customer_phone");
            String customer_address = request.getParameter("customer_address");
            int car_price = Integer.parseInt(request.getParameter("car_price"));
            BigDecimal price = BigDecimal.valueOf(car_price);
            BigDecimal vat = price.multiply(BigDecimal.valueOf(0.10));
            BigDecimal total = price.add(vat);

            try {
                orderDao.createOrder(car_id, customer_id, customer_cccd, customer_phone, customer_address, total);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        if (request.getParameter("fetchData") != null && request.getParameter("fetchData").equals("true")) {
            List<OrderModel> orders = new ArrayList<>();
            try {
                orders = orderDao.getAllOrders();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(orders);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("fetchDataForEmployee") != null && request.getParameter("fetchDataForEmployee").equals("true")) {
            String email = request.getParameter("userEmail");
            List<OrderModel> orders = new ArrayList<>();
            try {
                orders = orderDao.getAllOrdersForEmployee(email);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(orders);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("fetchDataForCustomer") != null && request.getParameter("fetchDataForCustomer").equals("true")) {
            String email = request.getParameter("userEmail");
            List<OrderModel> orders = new ArrayList<>();
            try {
                orders = orderDao.getAllOrdersForCustomer(email);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(orders);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("checkHaveFiveNotDoneOrder") != null && request.getParameter("checkHaveFiveNotDoneOrder").equals("true")) {
            int customer_id = Integer.parseInt(request.getParameter("customer_id"));
            boolean result = orderDao.checkHaveFiveNotDoneOrder(customer_id);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(result);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("getOrderIds") != null && request.getParameter("getOrderIds").equals("true")) {
            String userEmail = request.getParameter("userEmail");
            List<Integer> listOrderId = new ArrayList<>();
            try {
                listOrderId = orderDao.getOrderIds(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(listOrderId);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("createOrderEmp") != null && request.getParameter("createOrderEmp").equals("true")) {
            int cusId = Integer.parseInt(request.getParameter("customer_id"));
            int carId = Integer.parseInt(request.getParameter("car_id"));
            BigDecimal price = BigDecimal.valueOf(Long.parseLong(request.getParameter("car_price")));
            BigDecimal vat = price.multiply(BigDecimal.valueOf(0.10));
            BigDecimal total = price.add(vat);
            String cccd = request.getParameter("cusCCCD");
            String userEmail = request.getParameter("userEmail");
            String payment_method = request.getParameter("payment_method");

            EmployeeDAO empDao = new EmployeeDAO();
            EmployeeModels emp = null;
            try {
                emp = empDao.getEmployeeByEmail(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            int emp_id = emp.getEmployeeId();
            boolean isCreate = false;
            try {
                isCreate = orderDao.createOrderByEmp(carId, cusId, cccd, total, emp_id, payment_method);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(isCreate);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("changeDeposit") != null && request.getParameter("changeDeposit").equals("true")) {
            String orderId = request.getParameter("orderId");
            boolean isUpdated = false;
            try {
                isUpdated = orderDao.changeDepositStatus(orderId);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(isUpdated);
            response.getWriter().write(eventsJson);
        }

        if (request.getParameter("changeOrder") != null && request.getParameter("changeOrder").equals("true")) {
            String orderId = request.getParameter("orderId");
            boolean isUpdated = false;
            try {
                isUpdated = orderDao.changeOrderStatus(orderId);
            } catch (SQLException ex) {
                Logger.getLogger(OrderController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String eventsJson = gson.toJson(isUpdated);
            response.getWriter().write(eventsJson);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}
