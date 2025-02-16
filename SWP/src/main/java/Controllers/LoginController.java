/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAOs.AccountDAO;
import GoogleClass.GoogleLogin;
import Models.GoogleAccount;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        boolean error = false;
        if (request.getParameter("error") != null) {
            error = request.getParameter("error").equals("access_denied");
            error = true;
        }

        // If Google OAuth says "access_denied"
        if (error) {
            response.sendRedirect("/");
            return;
        }

        // Check state to determine if it's a Google "signup" or "login"
        String state = request.getParameter("state");

        // Google signup
        if ("signup".equals(state)) {
            String code = request.getParameter("code");
            GoogleLogin gg = new GoogleLogin();
            String accessToken = gg.getToken(code, state);
            GoogleAccount acc = gg.getUserInfo(accessToken, state);

            AccountDAO accDAO = new AccountDAO();
            if (accDAO.checkAccountExsit(acc.getEmail())) {
                String message = "Account already exists. Please log in.";
                sendMessageError(request, response, message, "/HomePageController/SignUp");
            } else {
                try {
                    if (accDAO.addNewAccountGoogle(acc)) {
                        if (accDAO.addNewCustomerAccountGoogle(acc)) {
                            // Auto-login after Google signup
                            String email = acc.getEmail();
                            setCookieLogin(request, response, email);
                        }
                    }
                } catch (Exception e) {
                    // If something fails, go back to the signup page
                    response.sendRedirect("/HomePageController/SignUp");
                }
            }
        }

        // Google login
        if ("login".equals(state)) {
            String code = request.getParameter("code");
            GoogleLogin gg = new GoogleLogin();
            String accessToken = gg.getToken(code, state);
            GoogleAccount acc = gg.getUserInfo(accessToken, state);

            AccountDAO accDAO = new AccountDAO();
            if (!accDAO.checkAccountExsit(acc.getEmail()) || accDAO.checkAccountBan(acc.getEmail())) {
                String message = "Account does not exist or is banned. Please register.";
                sendMessageError(request, response, message, "/HomePageController/Login");
            } else {
                String email = acc.getEmail();
                setCookieLogin(request, response, email);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AccountDAO accDao = new AccountDAO();

        // Handle standard (non-Google) logout
        if (request.getParameter("logOut") != null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    // remove userEmail cookie
                    if ("userEmail".equals(cookie.getName())) {
                        cookie.setMaxAge(0);
                        response.addCookie(cookie);
                    }
                    // remove role cookie
                    if ("role".equals(cookie.getName())) {
                        cookie.setMaxAge(0);
                        response.addCookie(cookie);
                    }
                }
            }
            // redirect to homepage after logging out
            response.sendRedirect("/");
        }

        // Standard sign-up
        if (request.getParameter("signUpBtn") != null) {
            String name = request.getParameter("nameTxt");
            String email = request.getParameter("emailTxt");
            String password = request.getParameter("pwdTxt");
            String agree = request.getParameter("agreeBox");
            String currentDate = LocalDate.now().toString();

            // OTP-related data
            String OTP = request.getParameter("OTPResult");
            String emailSendOTP = (String) request.getSession().getAttribute("emailSendOTP");

            if (!email.equals(emailSendOTP)) {
                String message = "The email used does not match the verified email.";
                sendMessageError(request, response, message, "/HomePageController/SignUp");
                return;
            }

            if ("Success".equals(OTP)) {
                if (agree != null) {
                    if (accDao.checkAccountExsit(email)) {
                        String message = "Account already exists. Please log in.";
                        sendMessageError(request, response, message, "/HomePageController/SignUp");
                    } else {
                        // Create user_account and customers row
                        if (accDao.addNewAccount(email, name, password)) {
                            if (accDao.addNewCustomerAccount(email, name)) {
                                // Auto-login after standard signup
                                setCookieLogin(request, response, email);
                            }
                        }
                    }
                }
            } else {
                String message = "Please re-enter the OTP code to verify.";
                sendMessageError(request, response, message, "/HomePageController/Login");
            }
        }

        // Standard login
        if (request.getParameter("loginBtn") != null) {
            String email = request.getParameter("emailTxt");
            String password = request.getParameter("pwdTxt");

            if (!accDao.checkAccountExsit(email)) {
                String message = "Account does not exist. Please register.";
                sendMessageError(request, response, message, "/HomePageController/Login");
            } else {
                // Check if user is admin
                if (!accDao.isAdmin(email)) {
                    // normal user
                    if (accDao.loginAccount(email, password)) {
                        setCookieLogin(request, response, email);
                    } else {
                        String message = "Incorrect password or banned account.";
                        sendMessageError(request, response, message, "/HomePageController/Login");
                    }
                } else {
                    // admin user
                    if (accDao.loginAccount(email, password)) {
                        Cookie userCookie = new Cookie("admin", "true");
                        Cookie userCookie2 = new Cookie("email", email);

                        // half-day session
                        userCookie.setMaxAge(12 * 60 * 60);
                        userCookie.setHttpOnly(true);
                        userCookie.setPath("/");

                        userCookie2.setMaxAge(12 * 60 * 60);
                        userCookie2.setHttpOnly(true);
                        userCookie2.setPath("/");

                        response.addCookie(userCookie);
                        response.addCookie(userCookie2);

                        // redirect admin to the admin dashboard
                        response.sendRedirect("/AdminController/Dashboard");
                    } else {
                        String message = "Incorrect password or email.";
                        sendMessageError(request, response, message, "/HomePageController/Login");
                    }
                }
            }
        }

        // Admin logout
        if (request.getParameter("adminOut") != null) {
            if ("logOut".equals(request.getParameter("adminOut"))) {
                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if ("admin".equals(cookie.getName())) {
                            cookie.setMaxAge(0);
                            response.addCookie(cookie);
                        }
                        if ("email".equals(cookie.getName())) {
                            cookie.setMaxAge(0);
                            response.addCookie(cookie);
                        }
                    }
                }
            }
        }
    }

    /**
     * Set the login cookies for a user, then redirect them to the homepage.
     */
    public void setCookieLogin(HttpServletRequest request, HttpServletResponse response, String email)
            throws IOException {
        AccountDAO accDAO = new AccountDAO();
        String role = accDAO.getRole(email);

        // userEmail cookie
        Cookie userCookie = new Cookie("userEmail", email);
        userCookie.setMaxAge(24 * 60 * 60);  // 1 day
        userCookie.setHttpOnly(true);
        userCookie.setPath("/");

        // role cookie
        Cookie roleCookie = new Cookie("role", role);
        roleCookie.setMaxAge(24 * 60 * 60);
        roleCookie.setHttpOnly(true);
        roleCookie.setPath("/");

        response.addCookie(userCookie);
        response.addCookie(roleCookie);

        // After setting cookies, go to the main screen ("/")
        response.sendRedirect("/");
    }

    /**
     * Helper to put an error message in session then redirect.
     */
    public void sendMessageError(HttpServletRequest request, HttpServletResponse response,
                                 String message, String redirect) throws IOException {
        request.getSession().setAttribute("message", message);
        response.sendRedirect(redirect);
    }

    @Override
    public String getServletInfo() {
        return "LoginController - handles normal & Google sign-up/login flows, sets cookies, etc.";
    }
}
