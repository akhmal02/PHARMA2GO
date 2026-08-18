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
    <title>Product - PHARMA2GO</title>
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
                <a href="product.jsp" class="nav-link active">
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
                <h2>Product</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <h1 class="page-title">Manage Product</h1>
                
                <!-- SEARCH & FILTER & BUTTON -->
                <div class="toolbar">
                    <div class="search-wrapper">
                        <form method="GET" action="product.jsp" style="display: flex; width: 100%; align-items: center;">
                            <svg class="search-icon" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
                            <input type="hidden" name="category" value="<%= selectedCategory %>">
                            <input type="text" name="search" class="search-input" placeholder="Search Product Name or ID..." value="<%= searchQuery %>">
                        </form>
                    </div>
                    
                    <div class="actions-wrapper">
                        <form method="GET" action="product.jsp" id="filterForm">
                            <input type="hidden" name="search" value="<%= searchQuery %>">
                            <select name="category" class="dropdown-btn" onchange="this.form.submit()" style="margin-top:1rem;">
                                <option value="">All Categories</option>
                                <% 
                                    try {
                                        Class.forName("com.mysql.jdbc.Driver");
                                        Connection conCat = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                        Statement stmtCat = conCat.createStatement();
                                        ResultSet rsCat = stmtCat.executeQuery("SELECT DISTINCT prodCategory FROM product WHERE prodCategory IS NOT NULL");
                                        while(rsCat.next()) {
                                            String cat = rsCat.getString("prodCategory");
                                            String selectedAttr = (cat.equals(selectedCategory)) ? "selected" : "";
                                            out.println("<option value='" + cat + "' " + selectedAttr + ">" + cat + "</option>");
                                        }
                                        conCat.close();
                                    } catch(Exception e) { }
                                %>
                            </select>
                        </form>
                        
                        <button class="btn-primary btn-add" onclick="window.location.href='addProduct.jsp'">
                            <svg class="plus-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                            Add Product
                        </button>
                    </div>
                </div>
                
                <!-- PRODUCT TABLE -->
                <div class="table-card">
                    <h3 class="card-title">All Product</h3>
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Product ID</th>
                                    <th>Product Name</th>
                                    <th>Brand</th>
                                    <th>Price (RM)</th>
                                    <th>Category</th>
                                    <th>Exp. Date</th>
                                    <th>Stock</th>
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
                                    
                                    // 1. Build Dynamic SQL WHERE Clause
                                    StringBuilder queryBase = new StringBuilder(" FROM product WHERE 1=1");
                                    if (!selectedCategory.isEmpty()) {
                                        queryBase.append(" AND prodCategory = ?");
                                    }
                                    if (!searchQuery.isEmpty()) {
                                        queryBase.append(" AND (prodName LIKE ? OR prodID LIKE ?)");
                                    }

                                    // 2. Fetch Total Record Count
                                    PreparedStatement psCount = con.prepareStatement("SELECT COUNT(*)" + queryBase.toString());
                                    int pIdx = 1;
                                    if (!selectedCategory.isEmpty()) psCount.setString(pIdx++, selectedCategory);
                                    if (!searchQuery.isEmpty()) {
                                        psCount.setString(pIdx++, "%" + searchQuery + "%");
                                        psCount.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    ResultSet rsCount = psCount.executeQuery();
                                    if(rsCount.next()) totalRecords = rsCount.getInt(1);
                                    
                                    totalPages = (int) Math.ceil((double) totalRecords / limit);
                                    if (totalPages <= 0) totalPages = 1;

                                    // 3. Fetch Paginated Records
                                    PreparedStatement psData = con.prepareStatement("SELECT *" + queryBase.toString() + " LIMIT ? OFFSET ?");
                                    pIdx = 1;
                                    if (!selectedCategory.isEmpty()) psData.setString(pIdx++, selectedCategory);
                                    if (!searchQuery.isEmpty()) {
                                        psData.setString(pIdx++, "%" + searchQuery + "%");
                                        psData.setString(pIdx++, "%" + searchQuery + "%");
                                    }
                                    psData.setInt(pIdx++, limit);
                                    psData.setInt(pIdx, offset);
                                    
                                    ResultSet rs = psData.executeQuery();

                                    while (rs.next()) {
                                        String exp = rs.getString("prodExpDate");
                            %>
                                <tr>
                                    <td class="fw-500"><%= rs.getString("prodID") %></td>
                                    <td><%= rs.getString("prodName") %></td>
                                    <td><%= rs.getString("prodBrand") %></td>
                                    <td><%= String.format("%.2f", rs.getDouble("prodPrice")) %></td>
                                    <td><%= rs.getString("prodCategory") %></td>
                                    <td><%= (exp == null || exp.isEmpty()) ? "-" : exp %></td>
                                    <td><%= rs.getString("prodStock") %></td>
                                    <td class="actions-cell">
                                        <form action="updateProduct.jsp" method="POST" style="display:inline;">
                                            <input type="hidden" name="prodID" value="<%= rs.getString("prodID") %>">
                                            <button type="submit" class="action-btn edit" title="Edit">
                                                <svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>
                                            </button>
                                        </form>
                                        
                                        <form action="DeleteProdServlet" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this product?');">
                                            <input type="hidden" name="prodID" value="<%= rs.getString("prodID") %>">
                                            <button type="submit" class="action-btn delete" title="Delete">
                                                <svg viewBox="0 0 24 24"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <%
                                    }
                                    con.close();
                                } catch (Exception e) {
                                    out.println("<tr><td colspan='8' style='color:red;'>Error Loading Data.</td></tr>");
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
	
					<!-- PAGINATING -->
                    <div class="pagination">
                        <% String navParams = "&category=" + selectedCategory + "&search=" + searchQuery; %>
                        <button class="page-btn prev" <%= (currentPage <= 1) ? "disabled" : "" %> 
                                onclick="window.location.href='product.jsp?page=<%= currentPage - 1 %><%= navParams %>'">
                            <svg viewBox="0 0 24 24"><path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/></svg>
                        </button>
                        
                        <span class="page-info">Page <%= currentPage %> of <%= totalPages %></span>
                        
                        <button class="page-btn next" <%= (currentPage >= totalPages) ? "disabled" : "" %> 
                                onclick="window.location.href='product.jsp?page=<%= currentPage + 1 %><%= navParams %>'">
                            <svg viewBox="0 0 24 24"><path d="M10 6L8.59 7.41 13.17 12l-4.58 4.59L10 18l6-6z"/></svg>
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
        const status = urlParams.get('status');
        
        if (status === 'added') alert("Success! Product record has been created.");
        else if (status === 'updated') alert("Success! Product details updated successfully.");
        else if (status === 'deleted') alert("Success! Product record has been removed.");
        else if (status === 'error') alert("Error! Please try again.");
        
        // Clean URL to avoid alert pop-ups on refresh
        if (status) window.history.replaceState({}, document.title, window.location.pathname);
    };
    </script>
</body>
</html>