/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import Models.CustomerModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet implementation class AdminCustomerContronller
 *
 * @author counh
 */
public class AdminCustomerContronller extends HttpServlet {

    private static final long serialVersionUID = 1L;

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
            out.println("<title>Servlet AdminCustomerContronller</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminCustomerContronller at " + request.getContextPath() + "</h1>");
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
        System.out.println("Request URI: " + host);  // Debug: Check the request URI

        if (host.equals("/AdminCustomerContronller/Create")) {
            request.getRequestDispatcher("/views/createEmployee.jsp").forward(request, response);
        } else if (host.startsWith("/AdminCustomerContronller/Edit")) {
            request.getRequestDispatcher("/views/editEvent.jsp").forward(request, response);
        } else if (host.startsWith("/AdminCustomerContronller/Status/")) {
            String[] s = host.split("/");
            String id = s[s.length - 1];

            CustomerDAO customerDAO = new CustomerDAO();
            response.setContentType("text/html;charset=UTF-8");

            try ( PrintWriter out = response.getWriter()) {
                boolean isUpdated = customerDAO.changeStatus(id);

                if (isUpdated) {
                    out.println("<script>window.close();</script>");  // Close window on success
                } else {
                    out.println("<script>alert('Failed to change status!');</script>");
                    out.println("<script>window.close();</script>");
                }
            } catch (SQLException ex) {
                System.out.println("SQL Exception: " + ex.getMessage());  // Debugging: Capture SQL error
                Logger.getLogger(AdminCustomerContronller.class.getName()).log(Level.SEVERE, null, ex);
            } catch (Exception e) {
                System.out.println("Unexpected Exception: " + e.getMessage());  // Debug unexpected errors
            }
        } else {
            System.out.println("No matching route found!");  // Debug
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
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
        CustomerDAO customerDAO = new CustomerDAO();
        // Handle AJAX request to fetch employee data
        String fetchData = request.getParameter("fetchData");

        if ("true".equals(fetchData)) {
            List<CustomerModel> customers = new ArrayList<>();
            customers = customerDAO.getAllCustomer(); // Retrieve the list of employees

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String customerJson = gson.toJson(customers);
            response.getWriter().write(customerJson);
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
