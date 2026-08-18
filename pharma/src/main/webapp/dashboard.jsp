<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //SECURITY & CACHE CONTROL: Prevent unauthorized back-button access
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    //AUTHENTICATION CHECK
    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }
	
    //INITIALIZE SUMMARY VARIABLES
    int totalEmployees = 0;
    double totalSales = 0.0;
    int totalSuppliers = 0;
    int totalProducts = 0;

    //DATABASE CONNECTION & DATA FETCHING
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        Statement st = con.createStatement();
        
        //Fetch SQL Count for total biz have
        ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM employee");
        if(rs1.next()) totalEmployees = rs1.getInt(1);

        ResultSet rs2 = st.executeQuery("SELECT SUM(totalAmount) As total FROM RECEIPT WHERE DATE(receiptDate) = CURDATE()");
        if(rs2.next()) totalSales = rs2.getDouble("total");

        ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM supplier");
        if(rs3.next()) totalSuppliers = rs3.getInt(1);

        ResultSet rs4 = st.executeQuery("SELECT COUNT(*) FROM product");
        if(rs4.next()) totalProducts = rs4.getInt(1);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - PHARMA2GO</title>
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
                <a href="dashboard.jsp" class="nav-link active">
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
                <h2>Dashboard</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <!-- BIZ SUMMARY CONTAINER -->
            <div class="content-area">
                <h1 class="page-title">Business Summary</h1>
                
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Employees</span>
                            <span class="material-symbols-outlined" style="color:blue;">badge</span>
                        </div>
                        <div class="stat-value"><%= totalEmployees %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Today's Sales</span>
                            <span class="material-symbols-outlined" style="color:green;">money_range</span>
                        </div>
                        <div class="stat-value">RM <%= String.format("%.2f", totalSales) %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Suppliers</span>
                            <span class="material-symbols-outlined" style="color:brown;">local_shipping</span>
                        </div>
                        <div class="stat-value"><%= totalSuppliers %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Products</span>
                            <span class="material-symbols-outlined" style="color:grey;">inventory_2</span>
                        </div>
                        <div class="stat-value"><%= totalProducts %></div>
                    </div>
                </div>
				
				<!-- STOCK NOTIFICATION -->
                <div class="table-card mt-2">
                    <h3 class="card-title">Inventory Alerts (Stock < 20)</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Product Name</th>
                                    <th>Category</th>
                                    <th>Stock Level</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                // Fetch Low Stock Items
                                ResultSet rsAlert = st.executeQuery("SELECT prodName, prodCategory, prodStock FROM product WHERE prodStock < 20 ORDER BY prodStock ASC");
                                boolean hasAlerts = false;
                                while(rsAlert.next()){
                                    hasAlerts = true;
                                    int stock = rsAlert.getInt("prodStock");
                                    String statusClass = (stock <= 5) ? "status-pending" : "status-shipped";
                                    String statusText = (stock <= 5) ? "Critical" : "Low Stock";
                            %>
                                <tr>
                                    <td class="fw-500"><%= rsAlert.getString("prodName") %></td>
                                    <td><%= rsAlert.getString("prodCategory") %></td>
                                    <td><%= stock %></td>
                                    <td><span class="status-badge <%= statusClass %>"><%= statusText %></span></td>
                                </tr>
                            <% } 
                               if(!hasAlerts){ %>
                                <tr><td colspan="4" style="text-align:center;">All stock levels are healthy.</td></tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>

	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>
<%
        con.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
    }
%>
</body>
</html>