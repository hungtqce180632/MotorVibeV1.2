/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AccountDAO;
import DAOs.CustomerDAO;
import DAOs.WishlistDAO;
import Models.CustomerAccountModel;
import Models.CustomerModel;
import Models.newCarModel;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Ensures that the customer must have a complete profile (address, phone)
 * before certain actions (e.g., buying a car).
 * Also doesn't allow editing the numeric CustomerId in editCusInfor.
 */
public class CustomerController extends HttpServlet {

    /**
     * Processes requests for both GET & POST
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* Example default text */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>CustomerController</title></head>");
            out.println("<body>");
            out.println("<h1>Customer Controller at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP GET method
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String host = request.getRequestURI();
        if (host.equals("/CustomerController/Profile")) {
            request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/EditProfile")) {
            request.getRequestDispatcher("/views/editProfile.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/Warranty")) {
            request.getRequestDispatcher("/views/customerWarranty.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/Order")) {
            request.getRequestDispatcher("/views/orderCustomer.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/Feedback")) {
            request.getRequestDispatcher("/views/customerFeedback.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/Wishlist")) {
            request.getRequestDispatcher("/views/wishlist.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/Appointment")) {
            request.getRequestDispatcher("/views/appointmentCustomer.jsp").forward(request, response);
        }
        if (host.equals("/CustomerController/ResetPassword")) {
            request.getRequestDispatcher("/views/customerResetPwd.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP POST method
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CustomerDAO cusDao = new CustomerDAO();

        // 1) Return profile info as JSON for the front-end
        if (request.getParameter("getInforUser") != null) {
            String userEmail = request.getParameter("getInforUser");
            try {
                CustomerAccountModel cus = cusDao.getCustomerInfor(userEmail);
                Gson gson = new Gson();
                String jsonResponse = gson.toJson(cus);
                response.getWriter().write(jsonResponse);
            } catch (SQLException ex) {
                Logger.getLogger(CustomerController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // 2) Edit customer info (but do NOT allow editing the numeric customerId)
        //    We also ignore user attempts to pass new customerId
        if (request.getParameter("editCusInfor") != null) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String oldEmail = request.getParameter("user_email");

            // We do NOT let them change the numeric customerId
            // so we never read it from user input

            String address = null;
            String phone = null;
            String emailSendOTP = (String) request.getSession().getAttribute("emailSendOTP");

            // check if the user changed to a new email that is not verified
            if (!email.equals(emailSendOTP) && emailSendOTP != null) {
                String message = "The email sent does not match the verified email.";
                sendMessageError(request, response, message, "/CustomerController/EditProfile");
                return;
            }

            // fetch the customer using oldEmail => that means we can't change user_id or customer_id
            AccountDAO accDao = new AccountDAO();
            CustomerAccountModel cus = accDao.getCustomerAccByEmail(oldEmail);
            if (cus == null) {
                String message = "Cannot locate your account. Please log in again.";
                sendMessageError(request, response, message, "/");
                return;
            }
            int cus_id = cus.getCustomer_id();  // not from user input
            int user_id = cus.getUser_id();     // not from user input

            if (request.getParameter("address") != null) {
                address = request.getParameter("address");
            }
            if (request.getParameter("phone") != null) {
                phone = request.getParameter("phone").trim();
            }

            boolean isUpdate = cusDao.updateCusotmerInfor(name, email, address, phone, cus_id, user_id);

            response.setContentType("text/html;charset=UTF-8");
            try ( PrintWriter out = response.getWriter()) {
                if (isUpdate) {
                    // update the cookie for userEmail if changed
                    changeCookie(request, response, email);
                    out.println("<script>");
                    out.println("alert('Profile updated successfully');");
                    out.println("window.close();");
                    out.println("</script>");
                } else {
                    out.println("<script>");
                    out.println("alert('Error updating profile.');");
                    out.println("window.close();");
                    out.println("</script>");
                }
            }
        }

        // 3) Show info for edit profile
        if (request.getParameter("user_email") != null) {
            String user_email = request.getParameter("user_email");
            try {
                CustomerAccountModel cus = cusDao.getCustomerInfor(user_email);
                Gson gson = new Gson();
                String jsonResponse = gson.toJson(cus);
                response.getWriter().write(jsonResponse);
            } catch (SQLException ex) {
                Logger.getLogger(CustomerController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        // 4) get customer info by ID for employee order
        if (request.getParameter("getCustomerInfo") != null) {
            int id = Integer.parseInt(request.getParameter("getCustomerInfo"));
            CustomerModel cmodel = cusDao.getCutomerById(id);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Gson gson = new Gson();
            String employeesJson = gson.toJson(cmodel);
            response.getWriter().write(employeesJson);
        }

        // 5) get wishlist
        if ("true".equals(request.getParameter("getWishlistCars"))) {
            String email = request.getParameter("userEmail");
            WishlistDAO wishDao = new WishlistDAO();
            List<newCarModel> wishlists = new ArrayList<>();

            try {
                CustomerAccountModel cus = cusDao.getCustomerInfor(email);
                if (cus != null) {
                    wishlists = wishDao.getAllWishlist(cus.getCustomer_id());
                }
            } catch (SQLException ex) {
                Logger.getLogger(CustomerController.class.getName()).log(Level.SEVERE, null, ex);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String employeesJson = new Gson().toJson(wishlists);
            response.getWriter().write(employeesJson);
        }

        // 6) Check if the user’s profile is complete before letting them buy
        //    Suppose CarController calls this with param=buyCar => we confirm the user has phone + address
        if ("buyCar".equals(request.getParameter("action"))) {
            // get the user from cookie or param
            String userEmail = request.getParameter("email"); 
            // or read from cookie: 
            /*
            Cookie[] cookies = request.getCookies();
            String userEmail = null;
            if (cookies != null) {
                for (Cookie c : cookies) {
                    if ("userEmail".equals(c.getName())) {
                        userEmail = c.getValue();
                        break;
                    }
                }
            }
            */

            // fetch the customer from the DB
            try {
                CustomerAccountModel userAcc = cusDao.getCustomerInfor(userEmail);
                if (userAcc == null) {
                    // no account found
                    sendMessageError(request, response, "No user found. Please log in again.", "/");
                    return;
                }

                // check phone + address
                if (userAcc.getPhone_number() == null || userAcc.getAddress() == null
                    || userAcc.getPhone_number().trim().isEmpty() || userAcc.getAddress().trim().isEmpty()) {

                    // redirect them to fill out their profile
                    sendMessageError(request, response, 
                        "Please complete your profile (phone, address) before purchasing.",
                        "/CustomerController/EditProfile");
                    return;
                }

                // if profile is complete, proceed with "buy" logic here
                // e.g. redirect or do something else
                response.sendRedirect("/OrderController/Create?carId=1"); // Example 
                // or do more logic

            } catch (SQLException ex) {
                ex.printStackTrace();
                sendMessageError(request, response, "An error occurred", "/");
            }
        }
    }

    /**
     * Utility method to send an error message to the session, then redirect.
     */
    public void sendMessageError(HttpServletRequest request, HttpServletResponse response,
                                 String message, String redirect) throws IOException {
        request.getSession().setAttribute("message", message);
        response.sendRedirect(redirect);
    }

    /**
     * Update the userEmail cookie if needed
     */
    public void changeCookie(HttpServletRequest request, HttpServletResponse response, String newEmail) {
        Cookie[] cookies = request.getCookies();
        Cookie userEmailCookie = null;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("userEmail".equals(cookie.getName())) {
                    userEmailCookie = cookie;
                    break;
                }
            }
        }
        if (userEmailCookie == null) {
            userEmailCookie = new Cookie("userEmail", newEmail);
        } else {
            userEmailCookie.setValue(newEmail);
        }
        userEmailCookie.setPath("/");
        response.addCookie(userEmailCookie);
    }

    @Override
    public String getServletInfo() {
        return "CustomerController - ensures profile completion before certain actions, prevents direct editing of numeric customerId, etc.";
    }
}
