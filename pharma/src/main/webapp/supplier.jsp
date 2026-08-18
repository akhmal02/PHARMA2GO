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

    //CAPTURE FILTER & SEARCH QUERIES
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) searchQuery = "";

    String selectedCategory = request.getParameter("category");
    if (selectedCategory == null) selectedCategory = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Supplier - PHARMA2GO</title>
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
		
		<!-- CONTAINER -->
        <main class="main-content">
            <header class="top-bar">
                <h2>Supplier</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <h1 class="page-title">Manage Supplier</h1>
                
                <!-- SEARCH & FILTER & BUTTON -->
                <div class="toolbar">
                    <div class="search-wrapper">
                        <form method="GET" action="supplier.jsp" style="display: flex; width: 100%; align-items: center;">
                            <svg class="search-icon" viewBox="0 0 24 24">
                                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                            </svg>
                            <input type="hidden" name="category" value="<%= selectedCategory %>">
                            <input type="text" name="search" class="search-input" placeholder="Search Supplier Name or ID..." value="<%= searchQuery %>">
                        </form>
                    </div>
                    
                    <!-- SUPPLIER TABLE -->
                    <div class="actions-wrapper">
                        <form method="GET" action="supplier.jsp" id="filterForm">
                            <input type="hidden" name="search" value="<%= searchQuery %>">
                            <select name="category" class="dropdown-btn" onchange="this.form.submit()" style="margin-top:1rem;">
                                <option value="">All Categories</option>
                                <% 
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conCat = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        Statement stmtCat = conCat.createStatement();
                                        ResultSet rsCat = stmtCat.executeQuery("SELECT DISTINCT supType FROM supplier WHERE supType IS NOT NULL");
                                        while(rsCat.next()) {
                                            String cat = rsCat.getString("supType");
                                            String selectedAttr = (cat.equals(selectedCategory)) ? "selected" : "";
                                            out.println("<option value='" + cat + "' " + selectedAttr + ">" + cat + "</option>");
                                        }
                                        conCat.close();
                                    } catch(Exception e) { }
                                %>
                            </select>
                        </form>
                        <button class="btn-primary btn-add" onclick="window.location.href='addSupplier.jsp'">
                            <svg class="plus-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                            Add Supplier
                        </button>
                    </div>
                </div>
                
                <div class="table-card">
                    <h3 class="card-title">All Suppliers</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Supplier ID</th>
                                    <th>Supplier Name</th>
                                    <th>Phone</th>
                                    <th>Email</th>
                                    <th>Supplier Type</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                // Paginating Logic
                                int limit = 6;
                                int currentPage = 1;
                                if(request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page"));
                                int offset = (currentPage - 1) * limit;
                                int totalRecords = 0;
                                int totalPages = 1;

                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");

                                    // 1. Build Dynamic SQL Logic
                                    StringBuilder queryBuilder = new StringBuilder(" FROM supplier WHERE 1=1");
                                    if (!selectedCategory.isEmpty()) queryBuilder.append(" AND supType = ?");
                                    if (!searchQuery.isEmpty()) queryBuilder.append(" AND (supName LIKE ? OR supID LIKE ?)");

                                    // 2. Count Records for Pagination
                                    PreparedStatement pstmtCount = con.prepareStatement("SELECT COUNT(*)" + queryBuilder.toString());
                                    int pIdx = 1;
                                    if (!selectedCategory.isEmpty()) pstmtCount.setString(pIdx++, selectedCategory);
                                    if (!searchQuery.isEmpty()) {
                                        pstmtCount.setString(pIdx++, "%" + searchQuery + "%");
                                        pstmtCount.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    ResultSet rsCount = pstmtCount.executeQuery();
                                    if(rsCount.next()) totalRecords = rsCount.getInt(1);

                                    // 3. Fetch Paginated Records
                                    PreparedStatement pstmt = con.prepareStatement("SELECT *" + queryBuilder.toString() + " LIMIT ? OFFSET ?");
                                    pIdx = 1;
                                    if (!selectedCategory.isEmpty()) pstmt.setString(pIdx++, selectedCategory);
                                    if (!searchQuery.isEmpty()) {
                                        pstmt.setString(pIdx++, "%" + searchQuery + "%");
                                        pstmt.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    pstmt.setInt(pIdx++, limit);
                                    pstmt.setInt(pIdx, offset);
                                    
                                    ResultSet rs = pstmt.executeQuery();
                                    while (rs.next()) {
                            %>
                                    <tr>
                                        <td class="fw-500"><%= rs.getString("supID") %></td>
                                        <td><%= rs.getString("supName") %></td>
                                        <td><%= rs.getString("supPhone") %></td>
                                        <td><%= rs.getString("supEmail") %></td>
                                        <td><%= rs.getString("supType") %></td> 
                                        <td class="actions-cell">
                                            <form action="updateSupplier.jsp" method="POST" style="display:inline;">
                                                <input type="hidden" name="supID" value="<%= rs.getString("supID") %>">
                                                <button type="submit" class="action-btn edit" title="Edit">
                                                    <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                                </button>
                                            </form>
                                            <form action="DeleteSupServlet" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this supplier?');">
                                                <input type="hidden" name="supID" value="<%= rs.getString("supID") %>">
                                                <button type="submit" class="action-btn delete" title="Delete">
                                                    <svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                                </button>
                                            </form>                               
                                        </td>
                                    </tr>
                            <%
                                    }
                                    totalPages = (int) Math.ceil((double) totalRecords / limit);
                                    if (totalPages <= 0) totalPages = 1;
                                    con.close();
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='6'>Error Loading Data.</td></tr>");
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- PAGINATING -->
                    <div class="pagination">
                        <% String navParams = "&category=" + selectedCategory + "&search=" + searchQuery; %>
                        <button class="page-btn prev" <%= (currentPage <= 1) ? "disabled" : "" %> 
                                onclick="window.location.href='supplier.jsp?page=<%= currentPage - 1 %><%= navParams %>'">
                            <svg viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
                        </button>
                        <span class="page-info">Page <%= currentPage %> of <%= totalPages %></span>
                        <button class="page-btn next" <%= (currentPage >= totalPages) ? "disabled" : "" %> 
                                onclick="window.location.href='supplier.jsp?page=<%= currentPage + 1 %><%= navParams %>'">
                            <svg viewBox="0 0 24 24"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/></svg>
                        </button>
                    </div>
                </div>
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

        if (status === 'added') alert("Success! Supplier record has been created.");
        else if (status === 'updated') alert("Success! Supplier details updated successfully.");
        else if (status === 'deleted') alert("Success! Supplier record has been removed.");
        else if (status === 'error') alert("Error! Please try again.");
        
        // Clean URL to avoid pop-up alerts on refresh
        if (status) window.history.replaceState({}, document.title, window.location.pathname);
    };
    </script>
</body>
</html>