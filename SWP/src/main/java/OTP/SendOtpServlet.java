/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package OTP;


import DAOs.AccountDAO;
import com.google.gson.Gson;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author thaii
 */
public class SendOtpServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet SendOtpServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet SendOtpServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Receives an email address from the client, generates a random OTP, and
     * sends it via Gmail SMTP for free. The OTP is stored in the session for
     * verification.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String emailSendOTP = request.getParameter("email");

        // Example: your DAO usage, if you need to check something about the user
        AccountDAO accDao = new AccountDAO();
        // boolean userExists = accDao.checkUserByEmail(emailSendOTP); // your code, if needed

        // Generate random 6-digit OTP
        int otp = new Random().nextInt(999999); // range 0-999999
        if (otp < 100000) {
            otp += 100000; // ensure it's always 6 digits (e.g., 012345 -> 12345)
        }

        // Attempt to send email
        boolean sendSuccess = sendEmail(emailSendOTP, otp);

        // JSON response setup
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();

        // If successful, store OTP in session and return success = true
        if (sendSuccess) {
            request.getSession().setAttribute("otp", otp);
            request.getSession().setAttribute("emailSendOTP", emailSendOTP);

            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write(gson.toJson(true));
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(false));
        }
    }

    @Override
    public String getServletInfo() {
        return "SendOtpServlet - sends an email OTP using Gmail SMTP";
    }

    /**
     * Sends the OTP email via Gmail SMTP. For this to be free, you must use
     * your own Gmail + either an app password (recommended) or enable
     * appropriate access in your Google account settings.
     */
    private boolean sendEmail(String toEmail, int otp) {
        // Replace with your Gmail address:
        final String fromEmail = "motovibe132@gmail.com";
        // Replace with your app password or account password (see notes below):
        final String password = "hcgl qqmf orzz nlcz";

        // Gmail SMTP properties
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true"); 
        props.put("mail.smtp.starttls.enable", "true"); 
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // Create mail session with credentials
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        try {
            // Build the message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );
            message.setSubject("Your OTP code from DriveAura");
            message.setText("Hello,\n\nYour OTP code is: " + otp
                          + "\n\nPlease enter this code to verify.\n\nThank you!");

            // Send
            Transport.send(message);
            return true;

        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}