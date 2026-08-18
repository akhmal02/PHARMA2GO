<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	//SECURITY & SESSION CHECK
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }

  	//RETRIEVE PRODUCT ID FROM REQUEST
    String receiptID = request.getParameter("receiptID");
    if (receiptID == null || receiptID.isEmpty()) {
        response.sendRedirect("order.jsp");
        return;
    }

    //INITIALIZE DATA RETRIEVALS
    String receiptDate = "", totalAmount = "", currentStatus = "", payMethod = "", 
           shipmentAddress = "", shipmentPostcode = "", shipmentState = "", 
           empID = "", custID = "", custName = "";

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        
        String sql = "SELECT r.*, c.custName FROM receipt r " +
                     "LEFT JOIN customer c ON r.custID = c.custID " +
                     "WHERE r.receiptID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, receiptID);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            receiptDate = rs.getString("receiptDate");
            totalAmount = rs.getString("totalAmount");
            currentStatus = rs.getString("status");
            payMethod = rs.getString("payMethod");
            shipmentAddress = rs.getString("shipmentAddress");
            shipmentPostcode = rs.getString("shipmentPostcode");
            shipmentState = rs.getString("shipmentState");
            empID = rs.getString("empID");
            custID = rs.getString("custID");
            custName = rs.getString("custName");
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
    <title>Update Order - PHARMA2GO</title>
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
		        <span class="material-symbols-outlined">dashboard</span>
		        Dashboard
		    </a>
		    <a href="employee.jsp" class="nav-link">
		        <span class="material-symbols-outlined">badge</span>
		        Manage Employee
		    </a>
		    <a href="supplier.jsp" class="nav-link">
		        <span class="material-symbols-outlined">local_shipping</span>
		        Manage Supplier
		    </a>
		    <a href="product.jsp" class="nav-link">
		        <span class="material-symbols-outlined">inventory_2</span>
		        Manage Product
		    </a>
		    <a href="order.jsp" class="nav-link active">
		        <span class="material-symbols-outlined">receipt_long</span>
		        Manage Orders
		    </a>
		    <a href="sales.jsp" class="nav-link">
		        <span class="material-symbols-outlined">monitoring</span>
		        Sales Report
		    </a>
		    <a href="profile2.jsp" class="nav-link">
		        <span class="material-symbols-outlined">account_circle</span>
		        Admin Profile
		    </a>
		</nav>
            
            <div class="sidebar-footer">
			    <a href="LogoutServlet" class="nav-link logout-link">
			        <span class="material-symbols-outlined">logout</span>
			        Logout
			    </a>
			</div>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h2>Orders</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <!-- CONTAINER ORDER -->
            <div class="content-area">
                <h1 class="page-title">Update Order</h1>
                
                <form action="UpdateOrderServlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Receipt ID</label>
                            <input type="text" name="receiptID" value="<%= receiptID %>" readonly style="background-color: #e5e7eb;">
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Order Date</label>
                            <input type="text" value="<%= receiptDate %>" readonly style="background-color: #e5e7eb;">
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Order Status</label>
                            <select name="status">
                                <option value="New" <%= "New".equals(currentStatus) ? "selected" : "" %>>New</option>
                                <option value="In Shipment" <%= "In Shipment".equals(currentStatus) ? "selected" : "" %>>In Shipment</option>
                                <option value="Delayed" <%= "Delayed".equals(currentStatus) ? "selected" : "" %>>Delayed</option>
                                <option value="Delivered" <%= "Delivered".equals(currentStatus) ? "selected" : "" %>>Delivered</option>
                            </select>
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Total Amount (RM)</label>
                            <input type="text" name="totalAmount" value="<%= totalAmount %>" readonly style="background-color: #e5e7eb;">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Payment Method</label>
                            <input type="text" name="payMethod" value="<%= payMethod %>" readonly style="background-color: #e5e7eb;">
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Shipment Address</label>
                            <input type="text" name="shipmentAddress" value="<%= shipmentAddress %>" readonly style="background-color: #e5e7eb;">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Postcode</label>
                            <input type="text" name="shipmentPostcode" value="<%= shipmentPostcode %>" readonly style="background-color: #e5e7eb;">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">State</label>
                            <input type="text" name="shipmentState" value="<%= shipmentState %>" readonly style="background-color: #e5e7eb;">
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Assign PIC (Employee)</label>
                            <select name="empID">
                                <%
                                    try {
                                        Connection conEmp = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        ResultSet rsEmp = conEmp.createStatement().executeQuery("SELECT empID, empName FROM employee");
                                        while(rsEmp.next()) {
                                            String eID = rsEmp.getString("empID");
                                            String eName = rsEmp.getString("empName");
                                %>
                                            <option value="<%= eID %>" <%= eID.equals(empID) ? "selected" : "" %>><%= eName %></option>
                                <%
                                        }
                                        conEmp.close();
                                    } catch (Exception e) {}
                                %>
                            </select>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Customer Name</label>
                            <input type="text" value="<%= custName %>" readonly style="background-color: #e5e7eb;">
                            <input type="hidden" name="custID" value="<%= custID %>">
                        </div>

						<div class="form-group shopee-input col-12" style="font-style:italic;">
	                    <label class="form-label required-field"><a>Please click the boxes to modify your information.</a></label>
	                    </div>
                    
                        <div class="col-6">
				        <a href="order.jsp" class="btn-auth login-btn">Back</a>
				        <button type="submit" class="btn-auth signup-btn" >
				            Update Order
				        </button>
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