/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AccountDAO;
import DAOs.CustomerDAO;
import DAOs.WarrantyDAO;
import Models.CustomerAccountModel;
import Models.CustomerModel;
import Models.WarrantyModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thaii
 */
public class WarrantyController extends HttpServlet {

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
            out.println("<title>Servlet WarrantyController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WarrantyController at " + request.getContextPath() + "</h1>");
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

        if (host.startsWith("/WarrantyController/Create/")) {
            request.getRequestDispatcher("/views/createWarranty.jsp").forward(request, response);
        }

        if (host.startsWith("/WarrantyController/Edit/")) {
            request.getRequestDispatcher("/views/editWarranty.jsp").forward(request, response);
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
        //Create
        if (request.getParameter("createWarranty") != null && request.getParameter("createWarranty").equals("true")) {
            int order_id = Integer.parseInt(request.getParameter("orderId"));
            String warranty_details = request.getParameter("warrantyDetails");
            String warranty_expiry = request.getParameter("expirationDate");

            WarrantyDAO warratyDao = new WarrantyDAO();

            boolean isCreate = warratyDao.createWarranty(order_id, warranty_details, warranty_expiry);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isCreate);
            response.getWriter().write(employeesJson);
        }
        // Get infor
        if (request.getParameter("getWarrantyForEdit") != null && request.getParameter("getWarrantyForEdit").equals("true")) {
            int warranty_id = Integer.parseInt(request.getParameter("warrantyId"));
            WarrantyDAO warrantyDao = new WarrantyDAO();
            WarrantyModel warranties = new WarrantyModel();
            warranties = warrantyDao.getWarranty(warranty_id);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(warranties);
            response.getWriter().write(employeesJson);
        }

        //Create
        if (request.getParameter("editWarranty") != null && request.getParameter("editWarranty").equals("true")) {
            int warranty_id = Integer.parseInt(request.getParameter("warrantyId"));
            String warranty_details = request.getParameter("warrantyDetails");
            String warranty_expiry = request.getParameter("expirationDate");

            WarrantyDAO warratyDao = new WarrantyDAO();

            boolean isEdit = warratyDao.editWarranty(warranty_id, warranty_details, warranty_expiry);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isEdit);
            response.getWriter().write(employeesJson);
        }

        //Warranty cho customer
        if (request.getParameter("fetchWarrantyForCustomer")!=null && request.getParameter("fetchWarrantyForCustomer").equals("true")) {
            String userEmail = request.getParameter("userEmail");
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(userEmail);
            int cus_id = cus.getCustomer_id();
            WarrantyDAO warratyDao = new WarrantyDAO();
            List<WarrantyModel> warranties = new ArrayList<>();
            warranties = warratyDao.getAllCustomerWarranty(cus_id);
            
            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(warranties);
            response.getWriter().write(employeesJson);
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
