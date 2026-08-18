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

    //FILTER & SEARCH LOGIC
    String urlStatus = request.getParameter("status");
    String selectedStatus = ""; 
    if (urlStatus != null && !urlStatus.equals("updated") && !urlStatus.equals("error")) {
        selectedStatus = urlStatus;
    }
    
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) {
        searchQuery = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - PHARMA2GO</title>
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
                <a href="order.jsp" class="nav-link active">
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
                <h2>Orders</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <h1 class="page-title">Summary Orders</h1>
                
                <div class="toolbar">
                
                	<!-- SEARCH & FILTER & BUTTON -->
                    <div class="search-wrapper">
                        <form method="GET" action="order.jsp" style="display: flex; width: 100%; align-items: center;">
                            <svg class="search-icon" viewBox="0 0 24 24">
                                <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                            </svg>
                            <input type="hidden" name="status" value="<%= selectedStatus %>">
                            <input type="text" name="search" class="search-input" placeholder="Search Receipt ID or Customer..." value="<%= searchQuery %>">
                        </form>
                    </div>
                    
                    <div class="actions-wrapper">
                        <form method="GET" action="order.jsp" id="filterForm">
                            <input type="hidden" name="search" value="<%= searchQuery %>">
                            <select name="status" class="dropdown-btn" onchange="this.form.submit()" style="margin-top:1rem; padding: 16px 16px;">
                                <option value="">All Statuses</option>
                                <% 
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conCat = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        Statement stmtCat = conCat.createStatement();
                                        ResultSet rsCat = stmtCat.executeQuery("SELECT DISTINCT status FROM receipt WHERE status IS NOT NULL");
                                        while(rsCat.next()) {
                                            String s = rsCat.getString("status");
                                            String isSelected = (s.equals(selectedStatus)) ? "selected" : "";
                                            out.println("<option value='" + s + "' " + isSelected + ">" + s + "</option>");
                                        }
                                        conCat.close();
                                    } catch(Exception e) { }
                                %>
                            </select>
                        </form>
                    </div>
                </div>
                
                <!-- ORDER TABLE -->
                <div class="table-card">
                    <h3 class="card-title">Customer Receipts</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Receipt ID</th>
                                    <th>Receipt Date</th>
                                    <th>Customer Name</th>
                                    <th>Total (RM)</th>
                                    <th>Employee ID</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                // Pagination Logic
                                int limit = 6; 
                                int currentPage = 1;
                                if(request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page"));
                                int offset = (currentPage - 1) * limit;
                                int totalRecords = 0;
                        
                                try {
                                    Class.forName("com.mysql.jdbc.Driver");
                                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                    
                                    // 1. Build Dynamic Query
                                    StringBuilder queryBase = new StringBuilder(" FROM receipt r JOIN customer c ON r.custID = c.custID WHERE 1=1");
                                    if (selectedStatus != null && !selectedStatus.isEmpty()) {
                                        queryBase.append(" AND r.status = ?");
                                    }
                                    if (searchQuery != null && !searchQuery.isEmpty()) {
                                        queryBase.append(" AND (r.receiptID LIKE ? OR c.custName LIKE ?)");
                                    }
                        
                                    // 2. Get Total Count
                                    PreparedStatement psCount = con.prepareStatement("SELECT COUNT(*)" + queryBase.toString());
                                    int pIdx = 1;
                                    if (selectedStatus != null && !selectedStatus.isEmpty()) psCount.setString(pIdx++, selectedStatus);
                                    if (searchQuery != null && !searchQuery.isEmpty()) {
                                        psCount.setString(pIdx++, "%" + searchQuery + "%");
                                        psCount.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    ResultSet rsCount = psCount.executeQuery();
                                    if(rsCount.next()) totalRecords = rsCount.getInt(1);
                                    
                                    // 3. Fetch Paginated Records
                                    String sql = "SELECT r.*, c.custName " + queryBase.toString() + " ORDER BY r.receiptDate DESC LIMIT ? OFFSET ?";
                                    PreparedStatement psData = con.prepareStatement(sql);
                                    pIdx = 1;
                                    if (selectedStatus != null && !selectedStatus.isEmpty()) psData.setString(pIdx++, selectedStatus);
                                    if (searchQuery != null && !searchQuery.isEmpty()) {
                                        psData.setString(pIdx++, "%" + searchQuery + "%");
                                        psData.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    psData.setInt(pIdx++, limit);
                                    psData.setInt(pIdx, offset);
                                    
                                    ResultSet rs = psData.executeQuery();
                                    while (rs.next()) {
                                        String rStatus = rs.getString("status");
                                        
                                        // UI Logic for Status Badges
                                        String badgeClass = "status-pending";
                                        String badgeColor = "#64748b"; 
                                        String bgColor = "#f1f5f9";
                        
                                        if (rStatus != null) {
                                            switch(rStatus.toLowerCase()) {
                                                case "new":
                                                    badgeClass = "status-new";
                                                    badgeColor = "#2563eb"; 
                                                    bgColor = "#eff6ff";
                                                    break;
                                                case "in shipment":
                                                    badgeClass = "status-shipped";
                                                    badgeColor = "#854d0e"; 
                                                    bgColor = "#fefce8";
                                                    break;
                                                case "delivered":
                                                    badgeClass = "status-delivered";
                                                    badgeColor = "#166534"; 
                                                    bgColor = "#f0fdf4";
                                                    break;
                                                case "delayed":
                                                    badgeClass = "status-delayed";
                                                    badgeColor = "#991b1b"; 
                                                    bgColor = "#fef2f2";
                                                    break;
                                            }
                                        }
                            %>
                                        <tr>
                                            <td class="fw-500"><%= rs.getString("receiptID") %></td>
                                            <td><%= rs.getString("receiptDate") %></td>                                        
                                            <td><%= rs.getString("custName") %></td>
                                            <td><%= String.format("%.2f", rs.getDouble("totalAmount")) %></td>
                                            <td><%= rs.getString("empID") %></td>
                                            <td>
                                                <span class="status-badge <%= badgeClass %>" 
                                                      style="color: <%= badgeColor %>; background-color: <%= bgColor %>; padding: 4px 12px; border-radius: 9999px; font-weight: 500; font-size: 0.85rem;">
                                                    <%= rStatus %>
                                                </span>
                                            </td>
                                            <td class="actions-cell">
                                                <form action="updateOrder.jsp" method="POST" style="display:inline;">
                                                    <input type="hidden" name="receiptID" value="<%= rs.getString("receiptID") %>">
                                                    <button type="submit" class="action-btn edit" title="Edit">
                                                        <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                                    </button>
                                                </form>
                                                <button type="button" class="action-btn view" title="View" 
                                                        onclick="window.location.href='viewOrder.jsp?receiptID=<%= rs.getString("receiptID") %>'">
                                                    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>
                                                </button>
                                            </td>
                                        </tr>
                            <%
                                    }
                                    int totalPages = (int) Math.ceil((double) totalRecords / limit);
                                    if (totalPages <= 0) totalPages = 1;
                                    con.close(); 
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='7' style='color:red;'>Error Loading Orders.</td></tr>");
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
					
					<!-- PAGINATING -->
                    <div class="pagination">
                        <% String navParams = "&status=" + selectedStatus + "&search=" + searchQuery; %>
                        <button class="page-btn prev" <%= (currentPage <= 1) ? "disabled" : "" %> 
                                onclick="window.location.href='order.jsp?page=<%= currentPage - 1 %><%= navParams %>'">
                            <span class="material-symbols-outlined">chevron_left</span>
                        </button>
                        <span class="page-info">Page <%= currentPage %> of <%= (int)Math.ceil((double)totalRecords/limit) > 0 ? (int)Math.ceil((double)totalRecords/limit) : 1 %></span>
                        <button class="page-btn next" <%= (currentPage >= (int)Math.ceil((double)totalRecords/limit)) ? "disabled" : "" %> 
                                onclick="window.location.href='order.jsp?page=<%= currentPage + 1 %><%= navParams %>'">
                            <span class="material-symbols-outlined">chevron_right</span>
                        </button>
                    </div>
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
        const statusFlag = urlParams.get('status');

        if (statusFlag === 'updated') {
            alert("Success! Order record has been updated.");
            window.history.replaceState({}, document.title, window.location.pathname);
        } else if (statusFlag === 'error') {
            alert("Error updating order. Please try again.");
            window.history.replaceState({}, document.title, window.location.pathname);
        }
    }; 
    </script>
</body>
</html>