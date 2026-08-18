<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//EXISTING SESSIOM CHECK
    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Supplier - PHARMA2GO</title>
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
            
            <!-- CONTAINER -->
            <div class="content-area">
                <h1 class="page-title">Add Supplier</h1>
                
                <form action="AddSupServlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label for="supName" class="form-label required-field">Supplier Name</label>
                            <input type="text" name="supName" placeholder="Teguh Berjaya Sdn. Bhd." required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="supPhone" class="form-label required-field">Phone Number</label>
                            <input type="text" name="supPhone" placeholder="03-XXXXXXXXX" required>
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label for="supEmail" class="form-label required-field">Email Address</label>
                            <input type="text" name="supEmail" placeholder="pharma2go@atlas.com" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="supAddress" class="form-label required-field">Office Address</label>
                            <input type="text" name="supAddress" placeholder="Lot.23, Kilang Utama Seremban, 12300 Bangi, Selangor">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="supType" class="form-label required-field">Supplier Type</label>
                            <select name="supType" required>
                                <option value="" disabled selected>Select Supplier Type</option>
                                <option value="LOCAL">Local</option>
                                <option value="INTERNATIONAL">International</option>
                            </select>
                        </div>

						<!-- LOCAL -->
                        <div class="form-group shopee-input col-6" id="localFields" style="display:none;">
                            <label for="taxTIN" class="form-label required-field">Tax TIN</label>
                            <input type="text" name="taxTIN" placeholder="2288374651">
                        </div>
                        
                        <!-- INTERNATIONAL -->
                        <div id="internationalFields" style="display:none;">
                            <div class="form-group shopee-input col-6">
                                <label for="country" class="form-label required-field">Country</label>
                                <input type="text" name="country" placeholder="South Korea">
                            </div>
                            <div class="form-group shopee-input col-6">
                                <label for="importLicenseNum" class="form-label required-field">Import License Number</label>
                                <input type="text" name="importLicenseNum" placeholder="LIC-MED-550-B">
                            </div>
                        </div> 
                        
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label required-field"><a>Please click the boxes to insert your information.</a></label>
                        </div>
                        
                        <div class="col-12">
                            <a href="supplier.jsp" class="btn-auth login-btn" style="text-decoration:none;">Back</a>
                            <button type="submit" class="btn-auth signup-btn">Add Supplier</button>
                        </div>
                    </div>
                </form>
            </div>
        </main>
    </div>

	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>

	<!-- LOCAL & INTERNATIONAL BOX -->
    <script>
        document.querySelector('select[name="supType"]').addEventListener('change', function() {
            const localDiv = document.getElementById('localFields');
            const internationalDiv = document.getElementById('internationalFields');
                       
            if (this.value === 'LOCAL') {
                localDiv.style.display = 'block';
                internationalDiv.style.display = 'none';
            } else if (this.value === 'INTERNATIONAL') {
                localDiv.style.display = 'none';
                internationalDiv.style.display = 'contents';
            } else {
                localDiv.style.display = 'none';
                internationalDiv.style.display = 'none';
            }
        });
    </script>
</body>
</html>