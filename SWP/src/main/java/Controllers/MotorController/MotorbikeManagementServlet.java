/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers.MotorController;

import DAOs.BrandDAO;
import DAOs.CarDAO;
import DAOs.FuelDAO;
import DAOs.ModelDAO;
import DAOs.MotorbikeDAO;
import Models.BrandModel;
import Models.CarModel_Model;
import Models.FuelModel;
import Models.ModelsCarModel;
import Models.Motorbike;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;

/**
 *
 * @author tiend
 */
public class MotorbikeManagementServlet extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MotorbikeListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MotorbikeListServlet at " + request.getContextPath() + "</h1>");
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
        //Lấy danh sách từ database thẩy lên request
        MotorbikeDAO motordao = new MotorbikeDAO();
        request.setAttribute("MotorbikeList", motordao.getMotorbikeList());
        //Tạo một hashMap để ánh xạ các Brand được lấy từ database thẩy lên request
        BrandDAO bd = new BrandDAO();
        List<BrandModel> brandList = bd.getAllBrands();
        HashMap<Integer, BrandModel> brandMap = new HashMap<>();
        for(BrandModel brand: brandList){
            brandMap.put(brand.getBrand_id(), brand);
        }
        request.setAttribute("brandMap", brandMap);
        //Tạo một hashMap để ánh xạ các Model được lấy từ database thẩy lên request
        ModelDAO md = new ModelDAO();
        List<ModelsCarModel> modelList = md.getAllModels();
        HashMap<Integer, ModelsCarModel> modelMap = new HashMap<>();
        for(ModelsCarModel model: modelList){
            modelMap.put(model.getModel_id(),model);
        }
        request.setAttribute("modelMap", modelMap);
        //Tạo một hashMap để ánh xạ các Fuel được lấy từ database thẩy lên request
        FuelDAO fd = new FuelDAO();
        List<FuelModel> fuelList = fd.getAllFuels();
        HashMap<Integer, FuelModel> fuelMap = new HashMap<>();
        for(FuelModel fuel: fuelList){
            fuelMap.put(fuel.getFuel_id(),fuel);
        }
        request.setAttribute("fuelMap", fuelMap);
        request.getRequestDispatcher("views/MotorbikeManagement/MotorbikeManagement.jsp").forward(request, response);
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
        processRequest(request, response);
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
