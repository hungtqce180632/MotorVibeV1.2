/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CustomerDAO;
import DAOs.FeedbackDAO;
import Models.CustomerAccountModel;
import Models.FeedbackModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thaii
 */
@WebServlet(name = "FeedBackController", urlPatterns = {"/FeedBackController/*"})
public class FeedBackController extends HttpServlet {

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
            out.println("<title>Servlet FeedBackController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FeedBackController at " + request.getContextPath() + "</h1>");
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
        if (host.equals("/FeedBackController/Create")) {
            request.getRequestDispatcher("/views/createFeedback.jsp").forward(request, response);
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
        if (request.getParameter("createFeedback") != null && request.getParameter("createFeedback").equals("true")) {
            int order_id = Integer.parseInt(request.getParameter("order_id"));
            String feedbackContent = request.getParameter("feedback_content");
            String userEmail = request.getParameter("userEmail");
            CustomerDAO cusDao = new CustomerDAO();
            CustomerAccountModel acc = new CustomerAccountModel();
            try {
                acc = cusDao.getCustomerInfor(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(FeedBackController.class.getName()).log(Level.SEVERE, null, ex);
            }
            int cus_id = acc.getCustomer_id();

            FeedbackDAO feedbackDao = new FeedbackDAO();
            boolean isCreate = feedbackDao.createFeedback(order_id, feedbackContent, cus_id);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isCreate);
            response.getWriter().write(employeesJson);
        }

        // lấy data cho cus
        if (request.getParameter("fetchDataForCustomer") != null && request.getParameter("fetchDataForCustomer").equals("true")) {
            String userEmail = request.getParameter("userEmail");
            CustomerDAO cusDao = new CustomerDAO();
            CustomerAccountModel acc = new CustomerAccountModel();
            try {
                acc = cusDao.getCustomerInfor(userEmail);
            } catch (SQLException ex) {
                Logger.getLogger(FeedBackController.class.getName()).log(Level.SEVERE, null, ex);
            }
            int cus_id = acc.getCustomer_id();

            List<FeedbackModel> fbs = new ArrayList();

            FeedbackDAO feedbackDao = new FeedbackDAO();
            fbs = feedbackDao.getAllFeedbackForCustomer(cus_id);

            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(fbs);
            response.getWriter().write(employeesJson);
        }
        
        //Change cái status
        if (request.getParameter("changeStatus") != null && request.getParameter("changeStatus").equals("true")) {
            int fbId = Integer.parseInt(request.getParameter("feedback_id"));
            FeedbackDAO feedbackDao = new FeedbackDAO();
            boolean isChange = feedbackDao.changeStatus(fbId);
            
            // Set response type to JSON and encode in UTF-8
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Convert employee list to JSON using Gson
            Gson gson = new Gson();
            String employeesJson = gson.toJson(isChange);
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
