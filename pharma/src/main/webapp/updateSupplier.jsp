<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //SECURITY & CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    //AUTHENTICATION CHECK
    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    //RETRIEVE SUPPLIER ID
    String supID = request.getParameter("supID");
    if (supID == null || supID.isEmpty()) {
        response.sendRedirect("supplier.jsp");
        return;
    }

    //INITIALIZE DATA RETRIEVALS
    String supName = "", supPhone = "", supEmail = "", supAddress = "", supType = "";
    String taxTIN = "", country = "", importLicenseNum = "";

    //DATABASE RETRIEVAL
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");

        // Fetch primary supplier details
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM supplier WHERE supID=?");
        ps.setString(1, supID);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            supName = rs.getString("supName");
            supPhone = rs.getString("supPhone");
            supEmail = rs.getString("supEmail");
            supAddress = rs.getString("supAddress");
            supType = rs.getString("supType");
        }

        // Fetch specific details based on type (Local vs International)
        if ("local".equalsIgnoreCase(supType)) {
            ps = conn.prepareStatement("SELECT taxTIN FROM local WHERE supID=?");
        } else {
            ps = conn.prepareStatement("SELECT country, importLicenseNum FROM international WHERE supID=?");
        }

        ps.setString(1, supID);
        rs = ps.executeQuery();

        if (rs.next()) {
            if ("local".equalsIgnoreCase(supType)) {
                taxTIN = rs.getString("taxTIN");
            } else {
                country = rs.getString("country");
                importLicenseNum = rs.getString("importLicenseNum");
            }
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Supplier - PHARMA2GO</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
    <div class="dashboard-container">
        
        <aside class="sidebar">
            <div class="sidebar-header">
                <svg class="brand-icon-small" viewBox="0 0 16 16">
                    <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                </svg>
                <span class="brand-text">PHARMA2GO</span>
            </div>
            
            <!-- MENU -->
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-link">
                    <span class="material-symbols-outlined">dashboard</span> Dashboard
                </a>
                <a href="employee.jsp" class="nav-link">
                    <span class="material-symbols-outlined">badge</span> Manage Employee
                </a>
                <a href="supplier.jsp" class="nav-link active">
                    <span class="material-symbols-outlined">local_shipping</span> Manage Supplier
                </a>
                <a href="product.jsp" class="nav-link">
                    <span class="material-symbols-outlined">inventory_2</span> Manage Product
                </a>
                <a href="order.jsp" class="nav-link">
                    <span class="material-symbols-outlined">receipt_long</span> Manage Orders
                </a>
                <a href="sales.jsp" class="nav-link">
                    <span class="material-symbols-outlined">monitoring</span> Sales Report
                </a>
                <a href="profile2.jsp" class="nav-link">
                    <span class="material-symbols-outlined">account_circle</span> Admin Profile
                </a>
            </nav>
            
            <div class="sidebar-footer">
                <a href="LogoutServlet" class="nav-link logout-link">
                    <span class="material-symbols-outlined">logout</span> Logout
                </a>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h2>Supplier</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <h1 class="page-title">Update Supplier</h1>
                
                <!-- SUP CONTAINER -->
                <form action="UpdateSupServlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Supplier ID</label>
                            <input type="text" name="supID" value="<%= supID %>" readonly style="background-color: #e5e7eb;"> 
                        </div>
    
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Supplier Name</label>
                            <input type="text" name="supName" value="<%= supName %>" required> 
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Phone Number</label>
                            <input type="text" name="supPhone" value="<%= supPhone %>" required> 
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Email Address</label>
                            <input type="text" name="supEmail" value="<%= supEmail %>" required> 
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Office Address</label>
                            <input type="text" name="supAddress" value="<%= supAddress %>"> 
                        </div>
	                   
                        <div class="form-group col-6">
                            <label class="form-label required-field">Supplier Type</label>
                            <input type="text" class="form-input" value="<%= supType %>" readonly style="background-color: #e5e7eb;">
                            <input type="hidden" name="supType" value="<%= supType %>">
                        </div>
	
                        <% if ("local".equalsIgnoreCase(supType)) { %>
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Tax TIN</label>
                            <input type="text" name="taxTIN" value="<%= taxTIN %>" required>
                        </div>
                        <% } %>
	
                        <% if ("international".equalsIgnoreCase(supType)) { %>
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Country</label>
                            <input type="text" name="country" value="<%= country %>" required>
                        </div>
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Import License Number</label>
                            <input type="text" name="importLicenseNum" value="<%= importLicenseNum %>" required>
                        </div>
                        <% } %>
                        
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label"><a>Please click the boxes to modify your information.</a></label>
                        </div>
                    
                        <div class="col-12">
                            <a href="supplier.jsp" class="btn-auth login-btn" style="text-decoration: none; text-align: center; display: inline-block;">Back</a>
                            <button type="submit" class="btn-auth signup-btn">Update Supplier</button> 
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>
	
	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; 2026 PHARMA2GO. All rights reserved.</p> 
    </footer>
</body>
</html>