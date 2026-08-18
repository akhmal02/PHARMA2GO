<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - PHARMA2GO</title>
    
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
			
			<!-- TOP MENU -->
            <div class="header-icons">
                <a href="login.jsp" class="icon-btn cart-btn btn-outline" aria-label="Back to Login">
                    <span class="material-icons">arrow_back</span>
                </a>
                <a href="aboutus.html" class="icon-btn cart-btn btn-outline" aria-label="Home">
                    <span class="material-icons">home</span>
                </a>
            </div>
        </div>
    </header>
    
    <!-- SIGNUP CONTAINER -->  
    <div class="login-wrapper" style="background-image: url('images/background2.png'); background-size: cover; background-position: center;">
        <div class="login-container shopee-style signup-wide">
            <div class="login-card">
                <h1 class="brand-title">SIGN UP</h1>
                <p class="brand-subtitle">Create your account to continue shopping</p>

                <form action="SignUpServlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <input type="text" name="custName" placeholder="Full Name" required>
                        </div>

                        <div class="form-group shopee-input col-6">
                            <input type="text" name="custPhone" placeholder="Phone" required>
                        </div>
                        
                        <div class="form-group shopee-input col-12">
                            <input type="text" name="custAddress" placeholder="Address" required>
                        </div>
                                          
                        <div class="form-group shopee-input col-6">
                            <input type="text" name="custPostcode" placeholder="Postcode" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <select name="custState" required>
                                <option value="" disabled selected>Select State</option>
                                <option value="Johor">Johor</option>
                                <option value="Kedah">Kedah</option>
                                <option value="Kelantan">Kelantan</option>
                                <option value="Melaka">Melaka</option>
                                <option value="Negeri Sembilan">Negeri Sembilan</option>
                                <option value="Pahang">Pahang</option>
                                <option value="Perak">Perak</option>
                                <option value="Perlis">Perlis</option>
                                <option value="Pulau Pinang">Pulau Pinang</option>
                                <option value="Sabah">Sabah</option>
                                <option value="Sarawak">Sarawak</option>
                                <option value="Selangor">Selangor</option>
                                <option value="Terengganu">Terengganu</option>
                                <option value="Kuala Lumpur">W.P. Kuala Lumpur</option>
                                <option value="Labuan">W.P. Labuan</option>
                                <option value="Putrajaya">W.P. Putrajaya</option>
                            </select>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <input type="email" name="custEmail" placeholder="Email" required>
                        </div>

                        <div class="form-group shopee-input col-6">
                            <input type="password" name="password" placeholder="Password" required>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn-primary shopee-btn">
                                SIGN UP
                            </button>
                        </div>
                    </div>

                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <a href="login.jsp" class="btn-outline" style="text-decoration: none; display: block; text-align: center;">
                        Already have an account? Log In
                    </a>
                </form>
            </div>
        </div>
    </div>

	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>

</body>
</html>