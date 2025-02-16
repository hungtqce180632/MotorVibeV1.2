/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.EventDAO;
import Models.EventModels;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author thaii
 */
@MultipartConfig(maxFileSize = 16177215) // 16MB
public class EventController extends HttpServlet {

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
            out.println("<title>Servlet EventController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EventController at " + request.getContextPath() + "</h1>");
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
        if (host.equals("/EventController/Create")) {
            request.getRequestDispatcher("/views/createEvent.jsp").forward(request, response);
        }
        if (host.startsWith("/EventController/Edit")) {
            request.getRequestDispatcher("/views/editEvent.jsp").forward(request, response);
        }
        if (host.startsWith("/EventController/Views")) {
            request.getRequestDispatcher("/views/eventViews.jsp").forward(request, response);
        }
        if (host.startsWith("/EventController/Status/")) {
            String[] s = host.split("/");
            String id = s[s.length - 1];

            EventDAO eventDao = new EventDAO();
            response.setContentType("text/html;charset=UTF-8");

            try ( PrintWriter out = response.getWriter()) {
                boolean isUpdated = eventDao.changeStatus(id);
                if (isUpdated) {
                    out.println("<script>window.close();</script>");
                } else {
                    out.println("<script>alert('Status change failed!');</script>");
                }
            } catch (SQLException ex) {
                Logger.getLogger(EventController.class.getName()).log(Level.SEVERE, null, ex);
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
        EventDAO eventDAO = new EventDAO();
        // Phần create event
        if (request.getParameter("createEvent") != null) {
            // Nhận các tham số từ form
            String eventName = request.getParameter("event_name").trim();
            String eventDetails = request.getParameter("event_details");
            String dateStart = request.getParameter("date_start");
            String dateEnd = request.getParameter("date_end");
            Boolean event_status = true;
            // Nhận file ảnh từ form
            Part filePart = request.getPart("event_image");
            InputStream inputStream = null;
            if (filePart != null) {
                // Lấy nội dung của file upload
                inputStream = filePart.getInputStream();
            }
            EventModels event = new EventModels(eventName, eventDetails, inputStream, dateStart, dateEnd, event_status);
            boolean isCreated = eventDAO.createEvent(event);

            if (isCreated) {
                response.setContentType("text/html;charset=UTF-8");
                try ( PrintWriter out = response.getWriter()) {

                    out.println("<script>");
                    out.println("window.close();");
                    out.println("</script>");

                }
            }
        }

        //Phần edit
        if (request.getParameter("editEvent") != null) {
            // Nhận các tham số từ form
            int eventId = Integer.parseInt(request.getParameter("event_id"));
            String eventName = request.getParameter("event_name").trim();
            String eventDetails = request.getParameter("event_details");
            String dateStart = request.getParameter("date_start");
            String dateEnd = request.getParameter("date_end");
            String haveImg = request.getParameter("haveImg");
            System.out.println("có ảnh hay ko " + haveImg);
            Part filePart = request.getPart("event_image");
            InputStream inputStream = null;
            EventModels event = null;
            // Nhận file ảnh từ form            
            boolean isUpdated = false;
            inputStream = filePart.getInputStream();
            if (haveImg.equals("false")) {
                event = new EventModels(eventName, eventDetails, inputStream, dateStart, dateEnd);
                isUpdated = eventDAO.editEventWithoutImg(event, eventId);

            } else {
                event = new EventModels(eventName, eventDetails, inputStream, dateStart, dateEnd);
                isUpdated = eventDAO.editEventWithImg(event, eventId);
            }

            if (isUpdated) {
                response.setContentType("text/html;charset=UTF-8");
                try ( PrintWriter out = response.getWriter()) {

                    out.println("<script>");
                    out.println("window.close();");
                    out.println("</script>");

                }
            }
        }

        // Lấy tham số kiểm tra nếu cần
        String fetchData = request.getParameter("fetchData");

        // Nếu fetchData có giá trị "true", lấy dữ liệu sự kiện
        if ("true".equals(fetchData)) {
            List<EventModels> events = new ArrayList<>();
            try {
                events = eventDAO.getAllEvents(); // Trả về danh sách sự kiện
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // Thiết lập kiểu phản hồi là JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Sử dụng Gson để chuyển danh sách thành JSON
            Gson gson = new Gson();
            String eventsJson = gson.toJson(events);
            response.getWriter().write(eventsJson);
        }

        //Phần của edit cái event
        if (request.getParameter("eventId") != null) {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            EventModels event = null;
            try {
                event = eventDAO.getEventById(eventId);
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (event != null) {
                response.setContentType("application/json");
                response.getWriter().write(new Gson().toJson(event)); // Sử dụng Gson để chuyển đổi đối tượng thành JSON
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND); // Trả về mã lỗi 404 nếu không tìm thấy sự kiện
                response.getWriter().write("{\"error\": \"Event not found\"}"); // Trả về thông báo lỗi dạng JSON
            }
        }

        // Lấy tham số kiểm tra nếu cần
        String getEventList = request.getParameter("getEventList");

        // Nếu fetchData có giá trị "true", lấy dữ liệu sự kiện
        if ("true".equals(getEventList)) {
            List<EventModels> events = new ArrayList<>();
            try {
                events = eventDAO.getAllEventsAvailable(); // Trả về danh sách sự kiện
            } catch (SQLException e) {
                e.printStackTrace();
            }

            // Thiết lập kiểu phản hồi là JSON
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Sử dụng Gson để chuyển danh sách thành JSON
            Gson gson = new Gson();
            String eventsJson = gson.toJson(events);
            response.getWriter().write(eventsJson);
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
