/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package OTP;


import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author thaii
 */
@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/VerifyOtpServlet"})
public class VerifyOtpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet VerifyOtpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet VerifyOtpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * This does nothing special if you call it via GET, but it's here to conform
     * to the standard servlet structure.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Receives an OTP from the client, compares it to the session-stored OTP,
     * and returns true or false as JSON.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get the user-entered OTP
        String enteredOtp = request.getParameter("otp");

        // Retrieve the stored OTP from session (which was placed there by SendOtpServlet)
        Object otpObj = request.getSession().getAttribute("otp");
        String sessionOtp = (otpObj != null) ? String.valueOf(otpObj) : "";

        // Basic check (in production, also check if session otp is null/expired, etc.)
        boolean match = enteredOtp.equals(sessionOtp);

        // Remove OTP from session so it can't be reused
        request.getSession().removeAttribute("otp");

        // Prepare JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();

        // Return success/failure as JSON boolean
        response.getWriter().write(gson.toJson(match));
    }

    @Override
    public String getServletInfo() {
        return "VerifyOtpServlet - verifies the OTP code user entered matches the session OTP";
    }
}