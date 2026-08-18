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

    //RETRIEVE EMPLOYEE ID
    String empID = request.getParameter("empID");
    if (empID == null || empID.isEmpty()) {
        response.sendRedirect("employee.jsp");
        return;
    }

    String empName = "", empPhone = "", empEmail = "", empAddress = "", empIC = "", empHireDate = "", supervisorID = "";

    //DATABASE FETCH
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        
        String sql = "SELECT * FROM employee WHERE empID = ?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, empID);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            empName = rs.getString("empName");
            empIC = rs.getString("empIC");
            empPhone = rs.getString("empPhone");
            empEmail = rs.getString("empEmail");
            empAddress = rs.getString("empAddress");
            empHireDate = rs.getString("empHireDate");
            supervisorID = rs.getString("supervisorID");
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
    <title>Update Employee - PHARMA2GO</title>
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

        <main class="main-content">
            <header class="top-bar">
                <h2>Employee</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <!-- EMP CONTAINER -->
            <div class="content-area">
                <h1 class="page-title">Update Employee</h1>
                
                <form action="UpdateEmpServlet" method="post">
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
                            <label for="supervisorID" class="form-label">Select Supervisor</label>
                            <select name="supervisorID">
                                <option value="">No Supervisor</option>
                                <%
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conSup = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        
                                        String sqlSup = "SELECT empID, empName FROM employee";
                                        Statement stmtSup = conSup.createStatement();
                                        ResultSet rsSup = stmtSup.executeQuery(sqlSup);
                                        
                                        while(rsSup.next()) {
                                            String currentLoopID = rsSup.getString("empID");
                                            String currentLoopName = rsSup.getString("empName");
                                            
                                            String selected = (supervisorID != null && supervisorID.equals(currentLoopID)) ? "selected" : "";
                                            
                                            // Prevent self-supervision
                                            if (!currentLoopID.equals(empID)) {
                                %>
                                                <option value="<%= currentLoopID %>" <%= selected %>><%= currentLoopName %></option>
                                <%
                                            }
                                        }
                                        conSup.close();
                                    } catch (Exception e) {
                                        out.println("<option value=''>Error loading supervisors</option>");
                                    }
                                %>
                            </select>
                        </div>

                        <div class="form-group shopee-input col-6">
                            <label class="form-label required-field">Hire Date</label>
                            <input type="text" value="<%= empHireDate %>" readonly style="background-color: #e5e7eb;">
                        </div>
                        
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label required-field"><a>Please modify the information above to update the record.</a></label>
                        </div>

                        <div class="col-12">
                            <a href="employee.jsp" class="btn-auth login-btn" style="text-decoration: none; text-align: center; display: inline-block;">
                                Back
                            </a>
                            <button type="submit" class="btn-auth signup-btn">
                                Update Employee
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

	<!-- NOTIFICATION -->
    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');

            if (status === 'error') {
                alert("Error updating record! Please try again.");
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }
    </script>
</body>
</html>