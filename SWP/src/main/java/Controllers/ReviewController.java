/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AccountDAO;
import DAOs.ReviewDAO;
import Models.CustomerAccountModel;
import Models.ReviewModels;
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
 *
 * @author thaii
 */
public class ReviewController extends HttpServlet {

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
            out.println("<title>Servlet ReviewController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ReviewController at " + request.getContextPath() + "</h1>");
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
        if (host.equals("/ReviewController/Views")) {
            request.getRequestDispatcher("/views/reviewEmployee.jsp").forward(request, response);
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
        if (request.getParameter("checkCusHaveOrder") != null && request.getParameter("checkCusHaveOrder").equals("true")) {
            int carId = Integer.parseInt(request.getParameter("carId"));
            String email = request.getParameter("userEmail");
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel acc = accDao.getCustomerAccByEmail(email);
            int cusId = acc.getCustomer_id();
            ReviewDAO reviewDao = new ReviewDAO();
            boolean result = false;

            try {
                result = reviewDao.checkCusHaveOrder(carId, cusId);
            } catch (SQLException ex) {
                Logger.getLogger(ReviewController.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            // Create a Gson object to convert boolean to JSON
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(result); // Convert boolean to JSON

            response.getWriter().write(jsonResponse); // Write response to output        
        }

        if (request.getParameter("createReview") != null && request.getParameter("createReview").equals("true")) {
            int carId = Integer.parseInt(request.getParameter("carId"));
            int rating = Integer.parseInt(request.getParameter("rating"));
            String review_text = request.getParameter("review_text");

            String userEmail = request.getParameter("userEmail");
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(userEmail);

            int cusId = cus.getCustomer_id();
            ReviewDAO reviewDao = new ReviewDAO();
            boolean isCreate = reviewDao.createReview(cusId, carId, rating, review_text);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Create a Gson object to convert boolean to JSON
            Gson gson = new Gson();
            String jsonResponse = gson.toJson(isCreate);

            response.getWriter().write(jsonResponse);
        }

        if (request.getParameter("getReviews") != null && request.getParameter("getReviews").equals("true")) {
            int carId = Integer.parseInt(request.getParameter("carId"));
            ReviewDAO reviewDao = new ReviewDAO();
            List<ReviewModels> reviews = new ArrayList<>();

            try {
                reviews = reviewDao.getAllReviewOfCar(carId);
            } catch (SQLException ex) {
                Logger.getLogger(ReviewController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Thiết lập kiểu phản hồi là JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Sử dụng Gson để chuyển danh sách thành JSON
            Gson gson = new Gson();
            String reviewsJson = gson.toJson(reviews);
            response.getWriter().write(reviewsJson);
        }

        // Lấy all review cho Employee
        if (request.getParameter("fetchReviewForEmployee") != null && request.getParameter("fetchReviewForEmployee").equals("true")) {
            List<ReviewModels> reviews = new ArrayList<>();
            ReviewDAO reviewDao = new ReviewDAO();
            try {
                reviews = reviewDao.getAllReview();
            } catch (SQLException ex) {
                Logger.getLogger(ReviewController.class.getName()).log(Level.SEVERE, null, ex);
            }

            // Thiết lập kiểu phản hồi là JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Sử dụng Gson để chuyển danh sách thành JSON
            Gson gson = new Gson();
            String reviewsJson = gson.toJson(reviews);
            response.getWriter().write(reviewsJson);
        }

        if (request.getParameter("changeReviewStatus") != null && request.getParameter("changeReviewStatus").equals("true")) {
            int id = Integer.parseInt(request.getParameter("review_id"));
            ReviewDAO reviewDao = new ReviewDAO();
            boolean isChange = false;
            try {
                isChange = reviewDao.changeStatus(id);
            } catch (SQLException ex) {
                Logger.getLogger(ReviewController.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            // Thiết lập kiểu phản hồi là JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Sử dụng Gson để chuyển danh sách thành JSON
            Gson gson = new Gson();
            String reviewsJson = gson.toJson(isChange);
            response.getWriter().write(reviewsJson);
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
