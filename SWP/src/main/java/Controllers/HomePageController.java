/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CarDAO;
import Models.newCarModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thaii
 */
public class HomePageController extends HttpServlet {

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
            out.println("<title>Servlet HomePageController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet HomePageController at " + request.getContextPath() + "</h1>");
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
        if (host.equals("") || host.equals("/")) {
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
        if (host.startsWith("/HomePageController/SignUp")) {
            request.getRequestDispatcher("/views/signup.jsp").forward(request, response);
        }

        if (host.startsWith("/HomePageController/Login")) {
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }

        if (host.equals("/HomePageController/ResetPassword")) {
            request.getRequestDispatcher("/views/resetPWD.jsp").forward(request, response);
        }

        if (host.equals("/HomePageController/ResetSuccess")) {
            request.getRequestDispatcher("/views/resetPWDSuccess.jsp").forward(request, response);
        }

        if (host.equals("/HomePageController/Event")) {
            request.getRequestDispatcher("/views/listEvent.jsp").forward(request, response);
        }
        if (host.equals("/HomePageController/Term")) {
            request.getRequestDispatcher("/views/termandpolicy.jsp").forward(request, response);
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
        CarDAO carDAO = new CarDAO();
        // Get 4 newCar
        if (request.getParameter("getNewCar") != null) {
            if (request.getParameter("getNewCar").equals("true")) {
                List<newCarModel> cars = new ArrayList<>();
                cars = carDAO.getNewCars();

                // Chuyển đổi dữ liệu thành JSON
                Gson gson = new Gson();
                String jsonResponse = gson.toJson(cars);

                // Gửi JSON phản hồi về client
                response.getWriter().write(jsonResponse);
            }
        }

        // Get best sell
        if (request.getParameter("getBestSellingCars") != null) {
            if (request.getParameter("getBestSellingCars").equals("true")) {
                List<newCarModel> cars = new ArrayList<>();
                cars = carDAO.getBestSellingCars();
                // Chuyển đổi dữ liệu thành JSON
                Gson gson = new Gson();
                String jsonResponse = gson.toJson(cars);

                // Gửi JSON phản hồi về client
                response.getWriter().write(jsonResponse);
            }
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
