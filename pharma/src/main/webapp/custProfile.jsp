<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="package1.CartItem" %> 
<%
    //SECURITY & CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
	
    //AUTHENTICATION CHECK
    String sessionName = (String) session.getAttribute("userName");
    String custEmailFromSession = (String) session.getAttribute("custEmail"); 
    
    if (custEmailFromSession == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    //CART DATA FOR BADGE
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.size() : 0;
    
    //DATA INITIALIZATION
    String custName = "", custEmail = "", custPhone = "";
    String custAddress = "", custPostcode = "", custState = "";

    //DATABASE RETRIEVAL
    Connection con = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        
        String sql = "SELECT custName, custEmail, custPhone, custAddress, custPostcode, custState FROM customer WHERE custEmail = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, custEmailFromSession);
        
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            custName = rs.getString("custName");
            custEmail = rs.getString("custEmail");
            custPhone = (rs.getString("custPhone") != null) ? rs.getString("custPhone") : "";
            custAddress = (rs.getString("custAddress") != null) ? rs.getString("custAddress") : "";
            custPostcode = (rs.getString("custPostcode") != null) ? rs.getString("custPostcode") : "";
            custState = (rs.getString("custState") != null) ? rs.getString("custState") : "";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (con != null) try { con.close(); } catch (SQLException ignore) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - PHARMA2GO</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        .profile-container-center {
            max-width: 1000px;
            margin: 0 auto;
            padding: 3rem 2rem;
            display: flex;
            justify-content: center;
        }
        .form-input { 
            width: 100%; 
            padding: 10px; 
            border: 1px solid #ddd; 
            border-radius: 5px; 
            margin-top: 5px; 
            box-sizing: border-box; 
        }
        .form-row { display: flex; gap: 20px; margin-bottom: 15px; }
        .form-group-vertical { flex: 1; display: flex; flex-direction: column; }
        .card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); margin-bottom: 2rem; }
    </style>
</head>
<body>
    <div class="catalogue-page">
        
        <header class="catalogue-header">
            <div class="header-container">
                <div class="brand-section">
                    <svg class="brand-icon" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg" style="width:30px;">
                        <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                    </svg>
                    <span class="brand-name">PHARMA2GO</span>
                </div>
                
                <!-- MENU -->
                <div class="header-icons">
                    <span class="user-welcome" style="margin-right: 15px; font-weight: 500; color: #1f2937;">
                        Welcome, <%= sessionName %>
                    </span>
                    <button class="icon-btn" onclick="location.href='catalogue.jsp'" title="Home">
                        <span class="material-symbols-outlined">home</span>
                    </button>
                    <button class="icon-btn cart-btn" onclick="location.href='cartView.jsp'">
                        <span class="material-symbols-outlined">shopping_cart</span>
                        <span class="cart-badge"><%= cartCount %></span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='purchaseHistory.jsp'">
                         <span class="material-symbols-outlined">bucket_check</span>
                    </button>
                    <button class="icon-btn profile-btn" style="border: 2px solid #3b82f6;">
                        <span class="material-symbols-outlined" style="color: #3b82f6;">person</span>
                    </button>
                    <form action="LogoutServlet" method="get" style="display: inline;">
                        <button type="submit" class="icon-btn">
                            <span class="material-symbols-outlined">logout</span>
                        </button>
                    </form>
                </div>
            </div>
        </header>
		
		<!-- CONTAINER -->
        <section class="profile-container-center">
            <div class="profile-grid" style="width: 100%;">
                
                <div class="card">
                    <div class="card-header">
                        <div class="card-title-text" style="font-weight: bold; font-size: 1.2rem;">Profile</div>
                        <div class="card-subtitle" style="color: #6b7280; font-size: 0.9rem; margin-bottom: 20px;">Manage your personal information</div>
                    </div>
                    
                    <!-- FORM PROFILE CONTAINER -->
                    <form action="UpdateProfileServlet" method="post">
                        <div class="profile-content">
                            <div class="profile-form">
                                <div class="form-row">
                                    <div class="form-group-vertical">
                                        <label>Full Name</label>
                                        <input type="text" class="form-input" name="custName" value="<%= custName %>" required style="background-color: #f9fafb">
                                    </div>
                                    <div class="form-group-vertical">
                                        <label>Phone Number</label>
                                        <input type="text" class="form-input" name="custPhone" value="<%= custPhone %>" required  placeholder="+60 12-345 6789" style="background-color: #f9fafb">
                                    </div>
                                </div>

                                <div class="form-group-vertical">
                                    <label>Email Address</label>
                                    <input type="email" class="form-input" name="custEmail" value="<%= custEmail %>" required  placeholder="akhmal@gmail.com" style="background-color: #f9fafb">
                                </div>
                                
                                <div class="form-group-vertical" style="margin-top: 1rem;">
                                    <label>Address</label>
                                    <input type="text" class="form-input" name="custAddress" value="<%= custAddress %>" required  placeholder="No. 123, Jalan Example..." style="background-color: #f9fafb">
                                </div>

                                <div class="form-row">
                                    <div class="form-group-vertical">
                                        <label>Postcode</label>
                                        <input type="text" class="form-input" name="custPostcode" value="<%= custPostcode %>" required  placeholder="50000" style="background-color: #f9fafb">
                                    </div>
                                    <div class="form-group-vertical">
                                        <label>State</label>
                                        <select name="custState" class="form-input" required style="background-color: #f9fafb">
                                            <option value="" disabled <%= custState.isEmpty() ? "selected" : "" %>>Select State</option>
                                            <% 
                                                String[] states = {"Johor", "Kedah", "Kelantan", "Melaka", "Negeri Sembilan", "Pahang", "Perak", "Perlis", "Pulau Pinang", "Sabah", "Sarawak", "Selangor", "Terengganu", "Kuala Lumpur", "Labuan", "Putrajaya"};
                                                for (String state : states) {
                                                    String selected = (state.equals(custState)) ? "selected" : "";
                                            %>
                                                <option value="<%= state %>" <%= selected %>><%= state %></option>
                                            <% } %>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group shopee-input col-12" style="font-style:italic;">
			                        <label class="form-label required-field"><a>Please click the boxes to insert your information.</a></label>
			                    </div>
                                
                                <div style="text-align: right; margin-top: 1rem;">
                                    <button type="submit" class="btn-primary" style="width: auto; padding: 10px 2rem; background: #3b82f6; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 500;">Save Changes</button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
				
				<!-- PASS CONTAINER -->
                <div class="card security-card">
                    <div class="card-header">
                        <div class="card-title-text" style="font-weight: bold; font-size: 1.2rem;">Security</div>
                        <div class="card-subtitle" style="color: #6b7280; font-size: 0.9rem; margin-bottom: 20px;" >Update your password</div>
                    </div>
                    <div class="card-body">
                        <form action="UpdatePasswordServlet" method="post">
                            <div class="form-row">
                                <div class="form-group-vertical">
                                    <label>Current Password</label>
                                    <input type="password" class="form-input" name="oldPass" required style="background-color: #f9fafb">
                                </div>
                                <div class="form-group-vertical">
                                    <label>New Password</label>
                                    <input type="password" class="form-input" name="newPass" required style="background-color: #f9fafb">
                                </div>
                            </div>
                            <div style="text-align: right; margin-top: 1rem;">
                                <button type="submit" class="btn-primary" style="width: auto; padding: 10px 2rem; background: #3b82f6; color: white; border: none; border-radius: 5px; cursor: pointer; font-weight: 500;">Update Password</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
		
		<!-- FOOTER -->
        <footer class="catalogue-footer">
        	<p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
   		</footer>
    </div>
</body>
</html>