/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DB.DBConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thaii
 */
public class ImageController extends HttpServlet {

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
            out.println("<title>Servlet ImageController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ImageController at " + request.getContextPath() + "</h1>");
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
        // Các ảnh khác
        if (host.startsWith("/ImageController/a/")) {
            // Lấy đường dẫn hình ảnh từ URL sau /ImageController/
            String imagePath = request.getPathInfo().replace("/a/", "/");

            // Lấy đường dẫn tuyệt đối của hình ảnh
            String fullImagePath = getServletContext().getRealPath("/images") + imagePath;

            // Đặt loại nội dung (ví dụ: image/jpeg)
            response.setContentType(getServletContext().getMimeType(fullImagePath));

            // Đọc hình ảnh và xuất ra response
            FileInputStream fis = new FileInputStream(fullImagePath);
            OutputStream os = response.getOutputStream();
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }

            // Đóng stream
            fis.close();
            os.close();
        }
        // Image event
        if (host.startsWith("/ImageController/b/")) {
            try ( Connection conn = DBConnection.getConnection()) {
                int eventId = Integer.parseInt(request.getPathInfo().replace("/b/", ""));
                String sql = "SELECT image FROM events WHERE event_id = ?";
                PreparedStatement statement = conn.prepareStatement(sql);
                statement.setInt(1, eventId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    // Lấy dữ liệu ảnh dạng binary
                    InputStream inputStream = resultSet.getBinaryStream("image");
                    OutputStream outputStream = response.getOutputStream();

                    // Thiết lập loại nội dung là hình ảnh
                    response.setContentType("image/jpeg");

                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    // Ghi dữ liệu ảnh từ database ra client
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    inputStream.close();
                    outputStream.close();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                response.getWriter().print("Error: " + ex.getMessage());
            }
        }

        // Image của car
        if(host.startsWith("/ImageController/c/")) {
            try ( Connection conn = DBConnection.getConnection()) {
                int carImgId = Integer.parseInt(request.getPathInfo().replace("/c/", ""));
                String sql = "SELECT picture FROM car_image WHERE car_image_id = ?";
                PreparedStatement statement = conn.prepareStatement(sql);
                statement.setInt(1, carImgId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    // Lấy dữ liệu ảnh dạng binary
                    InputStream inputStream = resultSet.getBinaryStream("picture");
                    OutputStream outputStream = response.getOutputStream();

                    // Thiết lập loại nội dung là hình ảnh
                    response.setContentType("image/jpeg");

                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    // Ghi dữ liệu ảnh từ database ra client
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    inputStream.close();
                    outputStream.close();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                response.getWriter().print("Error: " + ex.getMessage());
            }
        }
        
        //1  Image của car
        if(host.startsWith("/ImageController/co/")) {
            try ( Connection conn = DBConnection.getConnection()) {
                int carId = Integer.parseInt(request.getPathInfo().replace("/co/", ""));
                String sql = "SELECT picture, car_image_id FROM car_image WHERE car_id = ? ORDER BY RAND() LIMIT 1;";
                PreparedStatement statement = conn.prepareStatement(sql);
                statement.setInt(1, carId);
                ResultSet resultSet = statement.executeQuery();
                if (resultSet.next()) {
                    // Lấy dữ liệu ảnh dạng binary
                    InputStream inputStream = resultSet.getBinaryStream("picture");
                    OutputStream outputStream = response.getOutputStream();

                    // Thiết lập loại nội dung là hình ảnh
                    response.setContentType("image/jpeg");

                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;

                    // Ghi dữ liệu ảnh từ database ra client
                    while ((bytesRead = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, bytesRead);
                    }

                    inputStream.close();
                    outputStream.close();
                }

            } catch (SQLException ex) {
                ex.printStackTrace();
                response.getWriter().print("Error: " + ex.getMessage());
            }
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
