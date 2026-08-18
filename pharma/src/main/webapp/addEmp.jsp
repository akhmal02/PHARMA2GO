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
    <title>Add Employee - PHARMA2GO</title>
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
                <a href="employee.jsp" class="nav-link active">
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

		<!-- CONTAINER -->
        <main class="main-content">
            <header class="top-bar">
                <h2>Employee</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <h1 class="page-title">Add Employee</h1>
                
                <form action="AddEmpServlet" method="post">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label for="empIC" class="form-label required-field">Identity Number</label>
                            <input type="text" name="empIC" placeholder="040404XXXXXX" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="empName" class="form-label required-field">Full Name</label>
                            <input type="text" name="empName" placeholder="Muhammad Akhmal Bin Mohamad Hussin" required>
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label for="empPhone" class="form-label required-field">Phone</label>
                            <input type="text" name="empPhone" placeholder="011-XXXXXXXX" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="empEmail" class="form-label required-field">Email</label>
                            <input type="email" name="empEmail" placeholder="zabedah@pharma2go.com" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="empHireDate" class="form-label required-field">Hire Date</label>
                            <input type="date" name="empHireDate" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="empAddress" class="form-label required-field">Address</label>
                            <input type="text" name="empAddress" placeholder="No.12, Jalan Bahagia, 08200 Sungai Petani, Kedah" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="supervisorID" class="form-label">Select Supervisor</label>
                            <select name="supervisorID">
                                <option value="" selected>Select Supervisor</option>
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conSup = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        
                                        String sqlSup = "SELECT empID, empName FROM employee";
                                        Statement stmtSup = conSup.createStatement();
                                        ResultSet rsSup = stmtSup.executeQuery(sqlSup);
                                        
                                        while(rsSup.next()) {
                                            String supID = rsSup.getString("empID");
                                            String supName = rsSup.getString("empName");
                                %>
                                            <option value="<%= supID %>"><%= supName %></option>
                                <%
                                        }
                                        conSup.close();
                                    } catch (Exception e) {
                                        out.println("<option value=''>Error loading supervisors</option>");
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label for="password" class="form-label required-field">Password</label>
                            <input type="password" name="password" placeholder="" required>
                        </div>
                        
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label required-field"><a>Please click the boxes to insert your information.</a></label>
                        </div>

                        <div class="col-6">
                            <a href="employee.jsp" class="btn-auth login-btn">Back</a>
                            <button type="submit" class="btn-auth signup-btn">Add Employee</button>
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

	<!-- NOTIFICATIONS -->
    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const error = urlParams.get('error');

            if (error) {
                if (error === 'failed') {
                    alert("Error! Please try again.");
                } else {
                    alert("Error: " + decodeURIComponent(error));
                }
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }
    </script>
</body>
</html>