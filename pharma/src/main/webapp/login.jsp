<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - PHARMA2GO</title>
    
    <link rel="icon" type="image/x-icon" href="ico/stethoscope.ico">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
</head>
<body>
 
    <header class="catalogue-header">
    	<!-- TOP MENU -->
        <div class="header-container">
            <div class="brand-section">
                <svg class="brand-icon" viewBox="0 0 16 16">
                    <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                </svg>
                <span class="brand-name">PHARMA2GO</span>
            </div>

            <div class="header-icons">
                <a href="index.jsp" class="icon-btn cart-btn btn-outline" aria-label="Back to Catalogue">
                    <span class="material-icons">arrow_back</span>
                </a>
                <a href="aboutus.html" class="icon-btn cart-btn btn-outline" aria-label="Home">
                    <span class="material-icons">home</span>
                </a>
            </div>
        </div>
    </header>
     
    <!-- LOGIN CONTAINER --> 
    <div class="login-wrapper" style="background-image: url('images/background2.png'); background-size: cover; background-position: center;">
        <div class="login-container shopee-style">
            <div class="login-card">
                <h1 class="brand-title">LOGIN</h1>
                <p class="brand-subtitle">Log in to continue shopping with us</p>

                <form action="LoginServlet" method="post">
                    <div class="form-group shopee-input">
                        <input type="email" name="custEmail" placeholder="Email address" required>
                    </div>

                    <div class="form-group shopee-input">
                        <input type="password" name="password" placeholder="Password" required>
                    </div>

                    <button type="submit" class="btn-primary shopee-btn">LOG IN</button>

                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <a href="signup.jsp" class="btn-outline" style="text-decoration: none; display: block; text-align: center;">
                        Create New Account
                    </a>
                </form>
            </div>
        </div>
    </div>

	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>

    <script>
        // Check for logout success message
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('logout') === 'success') {
            alert('Logout Successful!');
            // Clean the URL to prevent alert on refresh
            window.history.replaceState({}, document.title, "login.jsp");
        }
    </script>
</body>
</html>