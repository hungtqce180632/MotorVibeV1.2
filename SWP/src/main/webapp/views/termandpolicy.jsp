
<%-- 
    Document   : termAndPolicy
    Created on : 03-Nov-2024, 22:44:03
    Author     : nguyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Terms & Policy | MotoVibe</title>
        <style>
            * {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: "Arial", sans-serif; /* Modern font */
                color: #2c3e50; /* Dark text color */
                background-color: #e7e9eb; /* Light gray background for a clean look */
            }

            .container {
                max-width: 800px;
                margin: 40px auto;
                padding: 30px;
                background: linear-gradient(135deg, #ffffff, #f2f2f2); /* Soft gradient for the container */
                border-radius: 15px; /* Rounded corners */
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); /* Subtle shadow for depth */
                border: 2px solid #3498db; /* Vibrant border color */
            }

            header {
                text-align: center;
            }

            header h1 {
                font-size: 36px; /* Prominent heading size */
                color: #3498db; /* Vibrant heading color */
                margin-bottom: 15px;
                font-weight: bold;
            }

            header p {
                font-size: 18px;
                color: #555; /* Slightly lighter paragraph color */
                margin-bottom: 25px;
            }

            .menu {
                text-align: center;
                margin-bottom: 20px;
            }

            .menu ul {
                list-style-type: none;
                padding: 0; /* Remove default padding */
            }

            .menu ul li {
                display: inline;
                margin: 0 10px; /* Adjust margin for better spacing */
            }

            .menu-button {
                display: inline-block;
                padding: 12px 20px; /* Padding for the button */
                font-size: 18px; /* Increased link size */
                color: #ffffff; /* White text for contrast */
                background-color: #3498db; /* Button color */
                border-radius: 30px; /* Rounded corners for buttons */
                text-decoration: none; /* Remove underline */
                transition: background-color 0.3s, transform 0.3s; /* Transition effects */
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Button shadow */
            }

            .menu-button:hover {
                background-color: #2980b9; /* Darker on hover */
                transform: translateY(-2px); /* Slight lift effect on hover */
            }

            .content-section {
                margin-top: 30px;
            }

            .content-section h2 {
                font-size: 28px; /* Increased section heading size */
                color: #2c3e50; /* Darker color for better contrast */
                margin-top: 20px;
                margin-bottom: 10px;
            }

            .content-section h3 {
                font-size: 22px; /* Subheading size */
                color: #2c3e50;
                margin-top: 15px;
            }

            .content-section p {
                font-size: 16px;
                color: #555; /* Standard body text color */
                line-height: 1.8;
                margin-bottom: 15px;
            }

            .footer-section {
                text-align: center;
                margin-top: 30px;
            }

            .footer-section p {
                font-size: 16px;
                color: #555; /* Footer text color */
            }

            .back-button {
                display: inline-block;
                margin-top: 15px;
                padding: 12px 30px;
                font-size: 16px;
                font-weight: bold;
                text-decoration: none;
                color: #ffffff;
                background-color: #3498db; /* Button color */
                border-radius: 5px;
                transition: background-color 0.3s, transform 0.2s; /* Added transform for hover effect */
            }

            .back-button:hover {
                background-color: #c81818; /* Darker on hover */
                transform: scale(1.05); /* Slightly enlarge on hover */
            }

        </style>
    </head>
    <body>
        <div class="container">
            <header>
                <h1>MotoVibe Terms & Policies</h1>
                <p>Welcome to MotoVibe. Please choose an option below to review our terms or policy.</p>
            </header>

            <div class="menu">
                <ul>
                    <li><a class="menu-button" href="#terms" onclick="showSection('terms');">View Terms</a></li>
                    <li><a class="menu-button" href="#policy" onclick="showSection('policy');">View Policy</a></li>
                </ul>
            </div>

            <section id="terms" class="content-section" style="display: none;">
                <h2>Terms of Service</h2>
                <p>By using MotoVibe, you agree to the following terms:</p>
                <h3>1. Account Creation & Responsibilities</h3>
                <p>By creating an account, you agree to provide accurate information. MotoVibe reserves the right to terminate any account found in violation of our terms or if fraudulent activity is detected.</p>

                <h3>2. Privacy and Data Usage</h3>
                <p>We value your privacy. MotoVibe collects and uses data according to our Privacy Policy to enhance your experience. Collected data may include contact details, browsing history, and preferences.</p>

                <h3>3. Vehicle Listings and Pricing</h3>
                <p>While MotoVibe strives to present accurate vehicle data, it is not liable for discrepancies. Prices and availability are subject to change without notice.</p>

                <h3>4. Transactions and Order Management</h3>
                <p>All transactions on MotoVibe are securely processed. MotoVibe reserves the right to cancel orders based on availability, user eligibility, or payment issues.</p>

                <h3>5. Review and Feedback</h3>
                <p>MotoVibe encourages genuine reviews. We reserve the right to moderate or remove reviews that breach our guidelines.</p>

                <h3>6. Liability Disclaimer</h3>
                <p>MotoVibe is not responsible for damages or losses caused by website downtime, errors, or third-party issues. Users agree to use MotoVibe at their own risk.</p>

                <h3>7. Amendments to Terms & Policies</h3>
                <p>MotoVibe may update these terms at any time. Significant updates will be communicated to registered users by email or on the website.</p>

                <h3>8. Governing Law</h3>
                <p>These terms are governed by the laws of the jurisdiction in which MotoVibe operates. Users agree to submit to the exclusive jurisdiction of the courts therein.</p>
            </section>

            <section id="policy" class="content-section" style="display: none;">
                <h2>Privacy Policy</h2>
                <p>Your privacy is important to us. This policy explains how we handle your information:</p>
                <h3>1. Information Collection</h3>
                <p>MotoVibe collects personal information when you register, make a purchase, or interact with our services. This information may include your name, email, address, and payment details.</p>

                <h3>2. Use of Information</h3>
                <p>The information we collect is used to provide, improve, and personalize our services. We may also use your information to communicate with you about offers, promotions, and updates.</p>

                <h3>3. Data Protection</h3>
                <p>MotoVibe employs industry-standard security measures to protect your information from unauthorized access or disclosure. However, no method of transmission over the Internet is 100% secure.</p>

                <h3>4. Sharing Information</h3>
                <p>We do not sell or rent your personal information to third parties. Your data may be shared with service providers who assist us in operating our website or conducting our business.</p>

                <h3>5. User Rights</h3>
                <p>You have the right to access, correct, or delete your personal information. If you wish to exercise these rights, please contact us.</p>

                <h3>6. Changes to Privacy Policy</h3>
                <p>MotoVibe may update this policy occasionally. Users will be notified of significant changes via email or through our website.</p>
            </section>

            <footer class="footer-section">
                <p>By proceeding, you acknowledge and accept these terms and policies. Contact support if you have questions.</p>


                <button class="back-button" onclick="closeWindow()">Close</button>


            </footer>
        </div>

        <script>
            function showSection(section) {
                // Hide all sections
                document.getElementById('terms').style.display = 'none';
                document.getElementById('policy').style.display = 'none';

                // Show the selected section
                document.getElementById(section).style.display = 'block';
            }
            function closeWindow() {
                window.close();
            }

        </script>
    </body>
</html>