/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.CarDAO;
import Models.newCarModel;
import java.text.NumberFormat;
import java.util.Locale;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.math.BigDecimal;
import java.util.List;

/**
 * Servlet implementation class SearchController
 *
 * @author counh
 */
public class SearchController extends HttpServlet {

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
            out.println("<title>Servlet SearchController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SearchController at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        String searchTerm = request.getParameter("search");

        List<newCarModel> searchResults = (searchTerm == null || searchTerm.trim().isEmpty())
                ? new CarDAO().getListtAllCars() : new CarDAO().getCarByName(searchTerm);

        StringBuilder htmlResponse = new StringBuilder();
        NumberFormat numberFormat = NumberFormat.getInstance(Locale.US);
        numberFormat.setGroupingUsed(true);
        // Generate the HTML for the search results
        for (newCarModel car : searchResults) {
            // Define each property to be used
            int carId = car.getCar_id();
            String carName = car.getCar_name();
            int carImageId = car.getFirst_car_image_id();
            BigDecimal price = car.getPrice();
            String formattedPrice = numberFormat.format(price);

            // Append the HTML for each car
            htmlResponse.append("<div class=\"card mb-3\">")
                    .append("<div class=\"row g-0\">")
                    .append("<div class=\"d-flex col-md-4 align-items-center overflow-hidden\">")
                    .append("<img src=\"/ImageController/c/")
                    .append(carImageId)
                    .append("\" class=\"img-fluid rounded-start object-fit-cover w-100 h-100\" alt=\"")
                    .append(carName)
                    .append("\" onerror=\"this.src='/path/to/fallback.jpg';\">")
                    .append("</div>")
                    .append("<div class=\"col-md-8\">")
                    .append("<div class=\"card-body\">")
                    .append("<h5 class=\"card-title\">")
                    .append(carName)
                    .append("</h5>")
                    .append("<p class=\"card-text\">Price: ")
                    .append(formattedPrice)
                    .append(" VND</p>")
                    .append("<a href=\"/CarController/View/")
                    .append(carId)
                    .append("\" class=\"btn btn-primary\">View Details</a>")
                    .append("</div>")
                    .append("</div>")
                    .append("</div>")
                    .append("</div>");
        }

        // Write the HTML response
        try ( PrintWriter out = response.getWriter()) {
            out.print(htmlResponse.toString());
            out.flush();
        }
    }

    @Override
    public String getServletInfo() {
        return "Handles car search requests.";
    }
}
