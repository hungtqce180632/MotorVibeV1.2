package Controllers;

import DAOs.CarDAO;
import Models.BrandModel;
import Models.CarModel_Model;
import Models.FuelModel;
import Models.newCarModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

public class ProductController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final CarDAO carDAO = new CarDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.endsWith("/ProductController/Views")) {
            // Redirect or forward to a specific view
            // Fetch data
            List<BrandModel> brands = carDAO.getAllBrands();
            List<FuelModel> fuels = carDAO.getAllFuelTypes();
            List<CarModel_Model> models = carDAO.getAllModels();

            // Set attributes
            request.setAttribute("brands", brands);
            request.setAttribute("fuels", fuels);
            request.setAttribute("models", models);
            request.getRequestDispatcher("/views/product.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Parse and log the incoming parameters
        int brandId = parseInteger(request.getParameter("brand_id"));
        int fuelId = parseInteger(request.getParameter("fuel_id"));
        int modelId = parseInteger(request.getParameter("model_id"));
//
//        // Print the received IDs to the server console
//        System.out.println("Received IDs:");
//        System.out.println("Brand ID: " + brandId);
//        System.out.println("Fuel ID: " + fuelId);
//        System.out.println("Model ID: " + modelId);

        try ( PrintWriter out = response.getWriter()) {
            // Fetch filtered car list
            List<newCarModel> cars = carDAO.getAllFilterCars(brandId, fuelId, modelId);
            // Convert to JSON and send response
            String json = gson.toJson(cars);
            out.write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while filtering cars.");
        }
    }

    private Integer parseInteger(String param) {
        try {
            return param == null ? 0 : Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return 0; // Default to 0 if parameter is invalid
        }
    }

    @Override
    public String getServletInfo() {
        return "ProductController Servlet handles car product filtering and displays";
    }
}
