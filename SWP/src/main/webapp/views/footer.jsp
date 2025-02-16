<%-- 
    Document   : footer
    Created on : 21 thg 10, 2024, 11:17:29
    Author     : thaii
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"> 
        <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
        <style>
            :root {
                --longthinh-web-mau-nut: #4caf50;   /* mau nut */
                --longthinh-web-mau-text: #ff5722;  /* mau nền text */
                --longthinh-web-trai: 35px; /* bên trái nhập trái 35px; phải auto */
                --longthinh-web-phai: auto; /* bên phải nhập trái auto; phải 35px */
                --longthinh-web-duoi: 35px;
            }
            .dv-social-button{
                display: inline-grid;
                position: fixed;
                bottom: var(--longthinh-web-duoi);
                left: var(--longthinh-web-trai);
                right: var(--longthinh-web-phai);
                min-width: 45px;
                text-align: center;
                z-index: 99999;
            }
            .dv-social-button-content{
                display: none;
            }
            .dv-social-button a {
                margin: 8px 0;
                cursor: pointer;
                position: relative;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 40px;
                height: 40px;
                border-radius: 100%;
                text-decoration: none;
                background: var(--longthinh-web-mau-nut);
            }
            .dv-social-button i {
                color: #fff;
                font-size: 20px;
                display: block;
                position: relative;
                z-index: 1;
            }
            .dv-social-button span{
                display: none;
            }
            .alo-circle {
                animation-iteration-count: infinite;
                animation-duration: 1s;
                animation-fill-mode: both;
                animation-name: zoomIn;
                width: 50px;
                height: 50px;
                top: -5px;
                right: -5px;
                position: absolute;
                background-color: transparent;
                -webkit-border-radius: 100%;
                -moz-border-radius: 100%;
                border-radius: 100%;
                border: 2px solid rgb(30 30 30 / 10%);
                opacity: .1;
                opacity: .5;
                background: var(--longthinh-web-mau-nut);
            }
            .alo-circle-fill {
                animation-iteration-count: infinite;
                animation-duration: 1s;
                animation-fill-mode: both;
                animation-name: pulse;
                width: 60px;
                height: 60px;
                top: -10px;
                right: -10px;
                position: absolute;
                -webkit-transition: all 0.2s ease-in-out;
                -moz-transition: all 0.2s ease-in-out;
                -ms-transition: all 0.2s ease-in-out;
                -o-transition: all 0.2s ease-in-out;
                transition: all 0.2s ease-in-out;
                -webkit-border-radius: 100%;
                -moz-border-radius: 100%;
                border-radius: 100%;
                border: 2px solid transparent;
                opacity: .2;
                background: var(--longthinh-web-mau-nut);
            }
            .dv-social-button-content a:hover > span{
                display: block
            }
            .dv-social-button a span {
                border-radius: 7px;
                text-align: center;
                background: var(--longthinh-web-mau-text);
                padding: 7px 15px;
                display: none;
                width: auto;
                margin-left: 10px;
                position: absolute;
                color: #ffffff;
                z-index: 999;
                top: 2px;
                left: 45px;
                transition: all 0.2s ease-in-out 0s;
                -moz-animation: longthinh_animate 0.7s 1;
                -webkit-animation: longthinh_animate 0.7s 1;
                -o-animation: longthinh_animate 0.7s 1;
                animation: longthinh_animate 0.7s 1;
                white-space: nowrap;
                line-height: 1.3;
            }
            .dv-social-button a span:before {
                content: "";
                width: 0;
                height: 0;
                border-style: solid;
                border-width: 8px 8px 8px 0;
                border-color: transparent var(--longthinh-web-mau-text) transparent transparent;
                position: absolute;
                left: -7px;
                top: 9px;
            }
            .dv-social-button.phai a span {
                left: auto;
                right: 60px;
            }
        </style>
    </head>
    <body>
        <!--Contact link-->
        <div class="dv-social-button">
            <div class="dv-social-button-content">
                <a href="tel:0817771184" class="call-icon" target="_blank" rel="nofollow">
                    <i class="fa fa-phone"></i>
                    <div class="animated alo-circle"></div>
                    <div class="animated alo-circle-fill"></div>
                    <span>Hotline: 0817 771 184</span>
                </a>
                <a href="sms:0817771184" target="_blank" class="sms">
                    <i class="fa fa-weixin"></i>
                    <span>SMS: 0817 771 184</span>
                </a>
                <a href="https://www.facebook.com/hung.dps.2024" target="_blank" class="mes">
                    <i class="fa fa-facebook-square"></i>
                    <span>Nhắn tin Facebook</span>
                </a>
                <a href="http://zalo.me/0817771184" target="_blank" class="zalo">
                    <i class="fa fa-commenting-o"></i>
                    <span>Zalo: 0817 771 184</span>
                </a>
            </div>

            <a class="user-support">
                <i class="fa fa-user-circle-o"></i>
                <div class="animated alo-circle"></div>
                <div class="animated alo-circle-fill"></div>
            </a>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var userSupport = document.querySelector('.user-support');
                var socialButtonContent = document.querySelector('.dv-social-button-content');

                userSupport.addEventListener("click", function (event) {
                    if (window.getComputedStyle(socialButtonContent).display === "none") {
                        socialButtonContent.style.display = "block";
                    } else {
                        socialButtonContent.style.display = "none";
                    }
                });
            });
        </script>
        <div class="row">
            <div class="col-md-3">
                <h5>Company</h5>
                <ul class="list-unstyled">
                    <li class="text-white">About Us</li>
                    <li class="text-white">Blog</li>
                    <li class="text-white">Services</li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Quick Links</h5>
                <ul class="list-unstyled">
                    <li class="text-white text-decoration-none">Get in Touch</li>
                    <li class="text-white">Help Center</li>
                    <li class="text-white">Live Chat</li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Our Brands</h5>
                <ul class="list-unstyled">
                    <li class="text-white">Toyota</li>
                    <li class="text-white">Porsche</li>
                    <li class="text-white">BMW</li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>Vehicle Types</h5>
                <ul class="list-unstyled">
                    <li class="text-white">Sedan</li>
                    <li class="text-white">SUV</li>
                    <li class="text-white">Convertible</li>
                </ul>
            </div>
        </div>
        <hr class="bg-light">
        <p class="text-center">© 2024 Group 8 SE1803 FA24. All rights reserved.</p>
    </body>
</html>