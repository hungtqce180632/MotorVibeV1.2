/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AccountDAO;
import DAOs.AppointmentDAO;
import DAOs.EmployeeDAO;
import Models.AppointmentModel;
import Models.CustomerAccountModel;
import Models.EmployeeModels;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thaii
 */
public class AppointmentController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AppointmentController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AppointmentController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String host = request.getRequestURI();
        if (host.equals("/AppointmentController/Create")) {
            request.getRequestDispatcher("/views/appointment.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getParameter("createAppointment") != null && request.getParameter("createAppointment").equals("true")) {
            String date_start = request.getParameter("date_start");
            String userEmail = request.getParameter("userEmail");
            String note = request.getParameter("note");

            // Parse date_start to LocalDate
            LocalDate startDate = LocalDate.parse(date_start);

            // Calculate date_end by adding 3 days to date_start
            LocalDate endDate = startDate.plusDays(2);

            // Format date_end to String in "yyyy-MM-dd"
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            String date_end = endDate.format(formatter);

            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(userEmail);

            int cus_id = cus.getCustomer_id();

            AppointmentDAO appDao = new AppointmentDAO();
            boolean isCreate = false;
            try {
                isCreate = appDao.createAppointment(date_start, note, cus_id, date_end);
            } catch (SQLException ex) {
                Logger.getLogger(AppointmentController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isCreate);
            response.getWriter().write(employeesJson);
        }

        //get for customer
        if (request.getParameter("fetchDataForCustomer") != null && request.getParameter("fetchDataForCustomer").equals("true")) {
            String userEmail = request.getParameter("userEmail");
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(userEmail);

            int cus_id = cus.getCustomer_id();

            AppointmentDAO appDao = new AppointmentDAO();
            List<AppointmentModel> appointments = new ArrayList<>();

            appointments = appDao.getAppointment(cus_id);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String appointmentJson = gson.toJson(appointments);
            response.getWriter().write(appointmentJson);
        }

        //remove
        if (request.getParameter("removeAppointment") != null && request.getParameter("removeAppointment").equals("true")) {
            AppointmentDAO appDao = new AppointmentDAO();

            String userEmail = request.getParameter("userEmail");
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(userEmail);

            int cus_id = cus.getCustomer_id();

            int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));

            boolean isRemove = false;
            try {
                isRemove = appDao.removeAppointment(cus_id, appointmentId);
            } catch (SQLException ex) {
                Logger.getLogger(AppointmentController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String appointmentJson = gson.toJson(isRemove);
            response.getWriter().write(appointmentJson);
        }

        //get for emp
        if (request.getParameter("fetchDataForEmployee") != null && request.getParameter("fetchDataForEmployee").equals("true")) {
            String userEmail = request.getParameter("userEmail");
            EmployeeDAO empDao = new EmployeeDAO();
            EmployeeModels emp = new EmployeeModels();
            try {
                emp = empDao.getEmployeeByEmail(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(AppointmentController.class.getName()).log(Level.SEVERE, null, ex);
            }

            int emp_id = emp.getEmployeeId();

            AppointmentDAO appDao = new AppointmentDAO();
            List<AppointmentModel> appointments = new ArrayList<>();

            appointments = appDao.getAppointmentEmployee(emp_id);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String appointmentJson = gson.toJson(appointments);
            response.getWriter().write(appointmentJson);
        }

        //change status
        if (request.getParameter("changeAppointment") != null && request.getParameter("changeAppointment").equals("true")) {
            int app_id = Integer.parseInt(request.getParameter("appointmentId"));
            AppointmentDAO appDao = new AppointmentDAO();
            boolean isChange = false;
            try {
                isChange = appDao.changeAppointment(app_id);
            } catch (SQLException ex) {
                Logger.getLogger(AppointmentController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String appointmentJson = gson.toJson(isChange);
            response.getWriter().write(appointmentJson);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
