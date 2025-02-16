/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import DAOs.WishlistDAO;
import Models.CustomerAccountModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thaii
 */
public class WishlistController extends HttpServlet {

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
            out.println("<title>Servlet WishlistController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet WishlistController at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        if (request.getParameter("removeCar") != null && request.getParameter("removeCar").equals("true")) {
            int carId = Integer.parseInt(request.getParameter("car_id"));
            String userEmail = request.getParameter("userEmail");
            CustomerDAO cusDao = new CustomerDAO();
            CustomerAccountModel cus = new CustomerAccountModel();
            try {
                cus = cusDao.getCustomerInfor(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(WishlistController.class.getName()).log(Level.SEVERE, null, ex);
            }
            int cusId = cus.getCustomer_id();

            WishlistDAO wDao = new WishlistDAO();
            boolean isRemove = wDao.removeCarFromWishlist(carId, cusId);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isRemove);
            response.getWriter().write(employeesJson);
        }

        if (request.getParameter("addWish") != null && request.getParameter("addWish").equals("true")) {
            int carId = Integer.parseInt(request.getParameter("car_id"));
            String userEmail = request.getParameter("userEmail");
            CustomerDAO cusDao = new CustomerDAO();
            CustomerAccountModel cus = new CustomerAccountModel();
            
            try {
                cus = cusDao.getCustomerInfor(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(WishlistController.class.getName()).log(Level.SEVERE, null, ex);
            }
            int cusId = cus.getCustomer_id();

            WishlistDAO wDao = new WishlistDAO();
            boolean haveWish = wDao.checkHaveWish(carId, cusId);
            boolean isAdd = false;
            if(!haveWish){
                isAdd = wDao.addWishlist(carId, cusId);
            }
            
            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isAdd);
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
