<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //SECURITY & CACHE CONTROL: Prevents users from going back to sensitive data after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    //AUTHENTICATION CHECK
    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    //CAPTURE SEARCH QUERY
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) {
        searchQuery = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Employee - PHARMA2GO</title>
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
            
            <div class="content-area">
                <h1 class="page-title">Manage Employee</h1>
                
                <!-- SEARCH & FILTER & BUTTON -->
                <div class="toolbar">
                    <div class="search-wrapper">
                        <form method="GET" action="employee.jsp" style="display: flex; width: 100%; align-items: center;">
                            <svg class="search-icon" viewBox="0 0 24 24">
                                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                            </svg>
                            <input type="text" name="search" class="search-input" placeholder="Search Employee Name or ID..." value="<%= searchQuery %>">
                        </form>
                    </div>
                    
                    <div class="actions-wrapper">
                        <button class="btn-primary btn-add" onclick="window.location.href='addEmp.jsp'" style="padding:16px 16px;">
                            <svg class="plus-icon" viewBox="0 0 24 24">
                                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                            </svg>
                            Add Employee
                        </button>
                    </div>
                </div>
                
                <!-- EMP TABLE DATA -->
                <div class="table-card">
                    <h3 class="card-title">All Employee</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Employee ID</th>
                                    <th>Employee Name</th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                    <th>Hire Date</th>
                                    <th>Supervisor</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                // Paginating Logic
                                int limit = 6; 
                                int currentPage = 1;
                                if(request.getParameter("page") != null) {
                                    currentPage = Integer.parseInt(request.getParameter("page"));
                                }
                                int offset = (currentPage - 1) * limit;
                                int totalRecords = 0;
                
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                    
                                    // Build Dynamic SQL for Search
                                    String whereClause = "";
                                    if (!searchQuery.trim().isEmpty()) {
                                        whereClause = " WHERE empName LIKE ? OR empID LIKE ?";
                                    }

                                    // Fetch Total Count for Pagination
                                    PreparedStatement psCount = con.prepareStatement("SELECT COUNT(*) FROM employee" + whereClause);
                                    if (!searchQuery.trim().isEmpty()) {
                                        psCount.setString(1, "%" + searchQuery + "%");
                                        psCount.setString(2, "%" + searchQuery + "%");
                                    }
                                    ResultSet rsCount = psCount.executeQuery();
                                    if(rsCount.next()) totalRecords = rsCount.getInt(1);
                                    
                                    // etch Employee Records
                                    String sql = "SELECT * FROM employee" + whereClause + " LIMIT ? OFFSET ?";
                                    PreparedStatement ps = con.prepareStatement(sql);
                                    int paramIndex = 1;
                                    if (!searchQuery.trim().isEmpty()) {
                                        ps.setString(paramIndex++, "%" + searchQuery + "%");
                                        ps.setString(paramIndex++, "%" + searchQuery + "%");
                                    }
                                    ps.setInt(paramIndex++, limit);
                                    ps.setInt(paramIndex, offset);
                                    ResultSet rs = ps.executeQuery();
                
                                    while (rs.next()) {
                                        String supervisorID = rs.getString("supervisorID");
                                        if (supervisorID == null || supervisorID.equalsIgnoreCase("null") || supervisorID.trim().isEmpty()) {
                                            supervisorID = "-";
                                        }
                            %>
                                        <tr>
                                            <td class="fw-500"><%= rs.getString("empID") %></td>
                                            <td><%= rs.getString("empName") %></td>
                                            <td><%= rs.getString("empPhone") %></td>
                                            <td><%= rs.getString("empEmail") %></td>
                                            <td><%= rs.getString("empHireDate") %></td>
                                            <td><%= supervisorID %></td>
                                            <td class="actions-cell">
                                                <form action="updateEmp.jsp" method="POST" style="display:inline;">
                                                    <input type="hidden" name="empID" value="<%= rs.getString("empID") %>">
                                                    <button type="submit" class="action-btn edit" title="Edit">
                                                        <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                                    </button>
                                                </form>
                                            
                                                <form action="DeleteEmpServlet" method="POST" onsubmit="return confirm('Are you sure you want to delete this employee?');" style="display:inline;">
                                                    <input type="hidden" name="empID" value="<%= rs.getString("empID") %>">
                                                    <button type="submit" class="action-btn delete" title="Delete">
                                                        <svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                            <%
                                    }
                                    
                                    int totalPages = (int) Math.ceil((double) totalRecords / limit);
                                    if (totalPages <= 0) totalPages = 1;
                                    String searchParam = !searchQuery.isEmpty() ? "&search=" + searchQuery : "";
                                    con.close(); 
                            %>
                            </tbody>
                        </table>
                    </div>
                	
                	<!-- PAGINATION -->
                    <div class="pagination">
                        <button class="page-btn prev" <%= (currentPage <= 1) ? "disabled" : "" %> 
                                onclick="window.location.href='employee.jsp?page=<%= currentPage - 1 %><%= searchParam %>'">
                            <svg viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
                        </button>
                        
                        <span class="page-info">Page <%= currentPage %> of <%= totalPages %></span>
                        
                        <button class="page-btn next" <%= (currentPage >= totalPages) ? "disabled" : "" %> 
                                onclick="window.location.href='employee.jsp?page=<%= currentPage + 1 %><%= searchParam %>'">
                            <svg viewBox="0 0 24 24"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/></svg>
                        </button>
                    </div>
                    <%
                                } catch (Exception e) {
                                    out.println("<p style='color:red;'>Error Loading Data: " + e.getMessage() + "</p>");
                                }
                    %>
                </div>
            </div>
        </main>
    </div>

	<!-- FOOTER -->
    <footer class="catalogue-footer">
        <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>

	<!-- NOTIFICATION -->
    <script>
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');

            if (status === 'added') {
                alert("Success! Employee record has been created.");
            } else if (status === 'updated') {
                alert("Success! Employee details updated successfully.");
            } else if (status === 'deleted') {
                alert("Success! Employee record has been removed.");
            } else if (status === 'error') {
                alert("Error! Please try again.");
            }
            
            // Clean the URL to avoid alert pop-ups on refresh
            if (status) {
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }
    </script>
</body>
</html>