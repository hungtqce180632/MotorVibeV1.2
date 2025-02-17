package Controllers;

import DAOs.BrandDAO;
import DAOs.CarDAO;
import DAOs.CustomerDAO;
import DAOs.FuelDAO;
import DAOs.InventoryDAO;
import DAOs.ModelDAO;
import DB.DBConnection;
import Models.BrandModel;
import Models.CarModel;
import Models.CustomerAccountModel;
import Models.FuelModel;
import Models.ModelsCarModel;
import Models.newCarModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@MultipartConfig(maxFileSize = 16177215) // 16MB
public class CarController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<html><head><title>CarController</title></head><body>");
            out.println("<h1>CarController at " + request.getContextPath() + "</h1>");
            out.println("</body></html>");
        }
    }

    // Utility for sending an error message to session & redirect
    private void sendMessageError(HttpServletRequest request, HttpServletResponse response,
            String message, String redirect) throws IOException {
        request.getSession().setAttribute("message", message);
        response.sendRedirect(redirect);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String host = request.getRequestURI();
        CarDAO carDAO = new CarDAO();

        // Create new car form
        if (host.equals("/CarController/Create")) {
            request.getRequestDispatcher("/views/createCar.jsp").forward(request, response);
        }
        // View car images
        if (host.startsWith("/CarController/ViewImage")) {
            request.getRequestDispatcher("/views/viewCarImage.jsp").forward(request, response);
        }
        // Update car image
        if (host.startsWith("/CarController/UpdateCarImg/")) {
            String[] s = host.split("/");
            String id = s[s.length - 1];
            request.setAttribute("imgId", id);
            request.getRequestDispatcher("/views/updateCarImg.jsp").forward(request, response);
        }
        // Edit car
        if (host.startsWith("/CarController/Edit")) {
            request.getRequestDispatcher("/views/editCar.jsp").forward(request, response);
        }
        // Change car status
        if (host.startsWith("/CarController/Status/")) {
            String[] s = host.split("/");
            String id = s[s.length - 1];
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                boolean isUpdate = carDAO.changeStatus(Integer.parseInt(id));
                if (isUpdate) {
                    out.println("<script>");
                    out.println("window.close();");
                    out.println("</script>");
                }
            } catch (SQLException ex) {
                Logger.getLogger(CarController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        // View car info
        if (host.startsWith("/CarController/View/")) {
            String[] s = host.split("/");
            String id = s[s.length - 1];
            request.getRequestDispatcher("/views/carViews.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CarDAO carDAO = new CarDAO();
        BrandDAO brandDAO = new BrandDAO();
        ModelDAO modelDAO = new ModelDAO();
        FuelDAO fuelDAO = new FuelDAO();

        // 1) If user clicked “BUY” button on car detail page:
        if ("buyCar".equals(request.getParameter("action"))) {
            // parse carId from request
            String carIdParam = request.getParameter("car_id");
            if (carIdParam == null) {
                sendMessageError(request, response,
                        "No car specified.", "/");
                return;
            }
            int carId = Integer.parseInt(carIdParam);

            // 2) get user email from cookie or from param
            //    typically from “userEmail” cookie
            String userEmail = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("userEmail".equals(c.getName())) {
                        userEmail = c.getValue();
                        break;
                    }
                }
            }
            if (userEmail == null) {
                // not logged in
                sendMessageError(request, response,
                        "Please log in before buying.",
                        "/HomePageController/Login");
                return;
            }

            // 3) look up the customer's profile
            CustomerDAO cusDao = new CustomerDAO();
            CustomerAccountModel acc = null;
            try {
                acc = cusDao.getCustomerInfor(userEmail);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            if (acc == null) {
                // no such user in DB
                sendMessageError(request, response,
                        "Account not found. Please log in again.", "/");
                return;
            }

            // 4) check if profile is complete: name, email, address, phone, citizen ID
            if (isProfileIncomplete(acc)) {
                // missing something => redirect to /CustomerController/Profile
                sendMessageError(request, response,
                        "Please finish your profile to buy a product.",
                        "/CustomerController/Profile");
                return;
            }

            // 5) if profile is complete => proceed with “buy” logic
            // e.g. redirect to your OrderController or create an order directly
            // For example:
            response.sendRedirect("/OrderController/Create?carId=" + carId);
            return;
        }

        // 1) Show data list
        if ("true".equals(request.getParameter("fetchData"))) {
            List<CarModel> cars = new ArrayList<>();
            List<BrandModel> brands = new ArrayList<>();
            List<ModelsCarModel> models = new ArrayList<>();
            List<FuelModel> fuels = new ArrayList<>();

            try {
                cars = carDAO.getAllCars();
                brands = brandDAO.getAllBrands();
                models = modelDAO.getAllModels();
                fuels = fuelDAO.getAllFuels();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            Map<String, Object> data = new HashMap<>();
            data.put("cars", cars);
            data.put("brands", brands);
            data.put("models", models);
            data.put("fuels", fuels);

            String jsonResponse = new Gson().toJson(data);
            response.getWriter().write(jsonResponse);
        }

        // 2) Prepare for create
        if ("true".equals(request.getParameter("getForCreate"))) {
            List<BrandModel> brands = new ArrayList<>();
            List<ModelsCarModel> models = new ArrayList<>();
            List<FuelModel> fuels = new ArrayList<>();

            brands = brandDAO.getAllBrands();
            models = modelDAO.getAllModels();
            fuels = fuelDAO.getAllFuels();

            Map<String, Object> data = new HashMap<>();
            data.put("brands", brands);
            data.put("models", models);
            data.put("fuels", fuels);

            String jsonResponse = new Gson().toJson(data);
            response.getWriter().write(jsonResponse);
        }

        // 3) Create a car
        if (request.getParameter("createCar") != null) {
            String car_name = request.getParameter("car_name");
            String date_start = request.getParameter("date_start");
            String color = request.getParameter("color");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String description = request.getParameter("car_description");
            int brand_id = Integer.parseInt(request.getParameter("brand_name"));
            int fuel_id = Integer.parseInt(request.getParameter("fuel_name"));
            int model_id = Integer.parseInt(request.getParameter("model_name"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            CarModel car = new CarModel(brand_id, model_id, car_name, date_start, color, price, fuel_id, true, description);
            boolean isCreated = carDAO.createCar(car);

            if (isCreated) {
                // Insert images
                int car_id = carDAO.findCarIdByName(car);
                String sql = "INSERT INTO car_image (car_id, picture) VALUES (?, ?)";
                try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

                    for (Part part : request.getParts()) {
                        if ("images".equals(part.getName()) && part.getSize() > 0) {
                            InputStream inputStream = part.getInputStream();
                            stmt.setInt(1, car_id);
                            stmt.setBlob(2, inputStream);
                            stmt.executeUpdate();
                        }
                    }
                    // Add inventory
                    InventoryDAO inventoryDAO = new InventoryDAO();
                    boolean isAddQuantity = inventoryDAO.addInventory(car_id, quantity);
                    if (!isAddQuantity) {
                        System.out.println("Error adding quantity to inventory");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // Close popup
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.println("<script>");
                out.println("window.close();");
                out.println("</script>");
            }
        }

        // 4) Retrieve car images
        if ("true".equals(request.getParameter("getCarImg"))) {
            List<Integer> imageIdList = new ArrayList<>();
            int carId = Integer.parseInt(request.getParameter("carImageId"));
            String sql = "SELECT car_image_id FROM car_image WHERE car_id = ?";

            try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, carId);
                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        imageIdList.add(rs.getInt("car_image_id"));
                    }
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            String jsonResponse = new Gson().toJson(imageIdList);
            response.getWriter().write(jsonResponse);
        }

        // 5) Update car image
        if (request.getParameter("updateCarImgBtn") != null) {
            String imgId = request.getParameter("imageId");
            Part filePart = request.getPart("image");
            boolean isUpdated = carDAO.updateCarImage(filePart, Integer.parseInt(imgId));

            if (isUpdated) {
                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.println("<script>");
                    out.println("window.close();");
                    out.println("</script>");
                }
            }
        }

        // 6) Show single car data
        if (request.getParameter("carId") != null) {
            int carId = Integer.parseInt(request.getParameter("carId"));
            try {
                CarModel car = carDAO.getCarById(carId);
                if (car != null) {
                    response.setContentType("application/json");
                    response.getWriter().write(new Gson().toJson(car));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    response.getWriter().write("{\"error\": \"Car not found\"}");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 7) Edit Car
        if (request.getParameter("editCar") != null) {
            int car_id = Integer.parseInt(request.getParameter("car_id"));
            String car_name = request.getParameter("car_name");
            String date_start = request.getParameter("date_start");
            String color = request.getParameter("color");
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            String description = request.getParameter("car_description");
            int brand_id = Integer.parseInt(request.getParameter("brand_name"));
            int fuel_id = Integer.parseInt(request.getParameter("fuel_name"));
            int model_id = Integer.parseInt(request.getParameter("model_name"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            CarModel car = new CarModel(brand_id, model_id, car_name, date_start, color, price, fuel_id, true, description);
            boolean isEdited = carDAO.editCar(car, car_id);

            if (isEdited) {
                InventoryDAO inventoryDAO = new InventoryDAO();
                try {
                    inventoryDAO.editInventory(car_id, quantity);
                } catch (SQLException ex) {
                    Logger.getLogger(CarController.class.getName()).log(Level.SEVERE, null, ex);
                }
                response.setContentType("text/html;charset=UTF-8");
                try (PrintWriter out = response.getWriter()) {
                    out.println("<script>");
                    out.println("window.close();");
                    out.println("</script>");
                }
            }
        }

        // 8) Car details + brand/model/fuel list
        if (request.getParameter("car_id_details") != null) {
            int carId = Integer.parseInt(request.getParameter("car_id_details"));
            CarModel car = null;
            List<BrandModel> brands = new ArrayList<>();
            List<ModelsCarModel> models = new ArrayList<>();
            List<FuelModel> fuels = new ArrayList<>();
            try {
                car = carDAO.getCarById(carId);
                brands = brandDAO.getAllBrands();
                models = modelDAO.getAllModels();
                fuels = fuelDAO.getAllFuels();
            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"error\": \"Internal server error\"}");
                return;
            }

            Map<String, Object> jsonResponse = new HashMap<>();
            if (car != null) {
                Map<String, Object> carData = new HashMap<>();
                carData.put("car_id", car.getCar_id());
                carData.put("car_name", car.getCar_name());
                carData.put("price", car.getPrice());
                carData.put("description", car.getDescription());
                carData.put("color", car.getColor());
                carData.put("quantity", car.getQuantity());
                carData.put("brand_id", car.getBrand_id());
                carData.put("model_id", car.getModel_id());
                carData.put("fuel_id", car.getFuel_id());
                jsonResponse.put("car", carData);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                jsonResponse.put("error", "Car not found");
            }

            // brand list
            List<Map<String, Object>> brandList = new ArrayList<>();
            for (BrandModel b : brands) {
                Map<String, Object> brandData = new HashMap<>();
                brandData.put("brand_id", b.getBrand_id());
                brandData.put("brand_name", b.getBrand_name());
                brandList.add(brandData);
            }
            jsonResponse.put("brands", brandList);

            // model list
            List<Map<String, Object>> modelList = new ArrayList<>();
            for (ModelsCarModel m : models) {
                Map<String, Object> modelData = new HashMap<>();
                modelData.put("model_id", m.getModel_id());
                modelData.put("model_name", m.getModel_name());
                modelList.add(modelData);
            }
            jsonResponse.put("models", modelList);

            // fuel list
            List<Map<String, Object>> fuelList = new ArrayList<>();
            for (FuelModel f : fuels) {
                Map<String, Object> fuelData = new HashMap<>();
                fuelData.put("fuel_id", f.getFuel_id());
                fuelData.put("fuel_name", f.getFuel_name());
                fuelList.add(fuelData);
            }
            jsonResponse.put("fuels", fuelList);

            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(jsonResponse));
        }

        // 9) getRelatedCar
        if (request.getParameter("getRelatedCar") != null) {
            int brand_id = Integer.parseInt(request.getParameter("getRelatedCar"));
            List<newCarModel> cars = new ArrayList<>();
            cars = carDAO.getRelatedCar(brand_id);
            String jsonResponse = new Gson().toJson(cars);
            response.getWriter().write(jsonResponse);
        }
    }

    @Override
    public String getServletInfo() {
        return "CarController - now checks if the user's profile is complete before allowing a buy action";
    }

    /**
     * Helper to check if name/email/address/phone/cus_id_number are missing.
     */
    private boolean isProfileIncomplete(CustomerAccountModel acc) {
        if (acc.getName() == null || acc.getName().trim().isEmpty()) {
            return true;
        }
        if (acc.getEmail() == null || acc.getEmail().trim().isEmpty()) {
            return true;
        }
        if (acc.getAddress() == null || acc.getAddress().trim().isEmpty()) {
            return true;
        }
        if (acc.getPhone_number() == null || acc.getPhone_number().trim().isEmpty()) {
            return true;
        }
        if (acc.getCus_id_number() == null || acc.getCus_id_number().trim().isEmpty()) {
            return true;
        }
        return false;
    }
}
