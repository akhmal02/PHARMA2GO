<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 1. SECURITY & CACHE CONTROL: Prevent unauthorized back-button access
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 2. AUTHENTICATION: Ensure the admin session is valid
    String sessionUser = (String) session.getAttribute("userName");
    String name = sessionUser; 

    if (sessionUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 3. INITIALIZE VARIABLES
    String empID = "", empName = "", empPhone = "", empEmail = "", 
           empAddress = "", empIC = "", empHireDate = "", 
           supervisorID = "", password = "";

    // 4. DATABASE RETRIEVAL: Fetch current admin details
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        
        String sql = "SELECT * FROM employee WHERE empID = ? OR empName = ?"; 
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, sessionUser);
        ps.setString(2, sessionUser);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            empID = rs.getString("empID");
            empName = rs.getString("empName");
            empIC = rs.getString("empIC");
            empPhone = rs.getString("empPhone");
            empEmail = rs.getString("empEmail");
            empAddress = rs.getString("empAddress");
            empHireDate = rs.getString("empHireDate");
            supervisorID = rs.getString("supervisorID");
            password = rs.getString("password");
        }
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Profile - PHARMA2GO</title>
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
                <a href="supplier.jsp" class="nav-link">
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
                <a href="profile2.jsp" class="nav-link active">
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
                <h2>Admin Profile</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <!-- CONTAINER -->
            <div class="content-area">
                <h1 class="page-title">Update Profile</h1>
                
                <form action="Profile2Servlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Employee ID</label>
                            <input type="text" name="empID" value="<%= empID %>" readonly style="background-color: #e5e7eb;">
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Employee Name</label>
                            <input type="text" name="empName" value="<%= empName %>" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Identity Number</label>
                            <input type="text" name="empIC" value="<%= empIC %>" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Phone</label>
                            <input type="text" name="empPhone" value="<%= empPhone %>" required>
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Email</label>
                            <input type="email" name="empEmail" value="<%= empEmail %>" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Address</label>
                            <input type="text" name="empAddress" value="<%= empAddress %>" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label">Supervisor Name</label>
                            <%
                                String displaySupervisorName = "No Supervisor Assigned"; 
                                if (supervisorID != null && !supervisorID.trim().isEmpty() && !supervisorID.equals("-")) {
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conView = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        
                                        String sqlView = "SELECT empName FROM employee WHERE empID = ?";
                                        PreparedStatement psView = conView.prepareStatement(sqlView);
                                        psView.setString(1, supervisorID);
                                        ResultSet rsView = psView.executeQuery();
                                        
                                        if (rsView.next()) {
                                            displaySupervisorName = rsView.getString("empName");
                                        }
                                        conView.close();
                                    } catch (Exception e) {
                                        displaySupervisorName = "Error loading name";
                                    }
                                }
                            %>
                            <input type="text" value="<%= displaySupervisorName %>" readonly style="background-color: #e5e7eb; cursor: not-allowed;">
                            <input type="hidden" name="supervisorID" value="<%= supervisorID %>">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Password</label>
                            <input type="password" name="password" value="<%= password %>" required>
                        </div> 
                                          
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label required-field"><a>Please click the boxes to update your information.</a></label>
                        </div>

                        <div class="col-6">
                            <button type="submit" class="btn-auth signup-btn">Update Profile</button>
                        </div>
                    </div> 
                </form>
            </div>
        </main>
    </div>

	<!-- FOOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>
	
	<!-- NOTIFICATION -->
    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');

            if (status === 'profileUpdated') {
                alert("Success! Your profile and password have been updated.\n\nYou will now be logged out for security.");
                window.location.href = 'LogoutServlet'; 
            } else if (status === 'error') {
                alert("Update failed! Please check your connection or data format.");
            }
        };
    </script>
</body>
</html>