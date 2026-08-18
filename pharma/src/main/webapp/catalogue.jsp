<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="package1.CartItem" %>  
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
    
    //CART DATA FOR BADGE
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.size() : 0;

    //FILTER PARAMETERS
    String searchKeyword = request.getParameter("search");
    String selectedCategory = request.getParameter("category");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogue - PHARMA2GO</title>
    <link rel="icon" type="image/x-icon" href="ico/stethoscope.ico">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
</head>
<body>
    <div class="catalogue-page">
        
        <header class="catalogue-header">
            <div class="header-container">
                <div class="brand-section">
                    <svg class="brand-icon" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
                        <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                    </svg>
                    <span class="brand-name">PHARMA2GO</span>
                </div>
                
                <!-- MENU -->
                <div class="header-icons">
                    <span class="user-welcome" style="margin-right: 15px; font-weight: 500; color: #1f2937;">
                        Welcome, <%= name %>
                    </span>
                    <button class="icon-btn" onclick="location.href='catalogue.jsp'" style="border: 2px solid #3b82f6;">
                        <span class="material-symbols-outlined" style="color: #3b82f6;">home</span>
                    </button>
                    <button class="icon-btn cart-btn" onclick="location.href='cartView.jsp'">
                        <span class="material-symbols-outlined">shopping_cart</span>
                        <span class="cart-badge" id="cartBadge"><%= cartCount %></span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='purchaseHistory.jsp'">
                        <span class="material-symbols-outlined">bucket_check</span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='custProfile.jsp'">
                        <span class="material-symbols-outlined">person</span>
                    </button>
                    <form action="LogoutServlet" method="get" style="display: inline;">
                        <button type="submit" class="icon-btn profile-btn"><span class="material-symbols-outlined">logout</span></button>
                    </form>
                </div>
            </div>
        </header>

		<!-- BANNER -->
        <section class="hero-section">
            <div class="hero-container">
                <div class="hero-content">
                    <h1 class="hero-title">Discover Your<br>Health<br>Essentials</h1>
                    <p class="hero-description">Explore a wide range of pharmaceutical products and wellness items curated for your health.</p>
                    <button class="btn-hero" onclick="window.scrollTo({top: 800, behavior: 'smooth'});">Browse Product</button>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&h=400&fit=crop" alt="Medicine Products" class="product-showcase">
                </div>
            </div>
        </section>
        
        <!-- SEARCH & FILTER -->
        <section class="filters-section">
             <form action="catalogue.jsp" method="get" class="filters-container" id="filterForm">
                <div class="filter-box search-filter">
                    <svg class="filter-icon" viewBox="0 0 24 24" style="width:20px; fill:#64748b; margin-right:8px;">
                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                    <input type="text" name="search" class="filter-input" placeholder="Search products..." value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                </div>

                <div class="filter-box category-filter">
                    <span class="material-symbols-outlined filter-icon">category</span>
                    <select name="category" class="filter-input dropdown-select" onchange="this.form.submit()">
                        <option value="">All Categories</option>
                        <%
                            try (Connection catCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                                 Statement stmt = catCon.createStatement();
                                 ResultSet rsCat = stmt.executeQuery("SELECT DISTINCT prodCategory FROM product")) {
                                while(rsCat.next()){
                                    String cat = rsCat.getString("prodCategory");
                                    String isSelected = (cat.equals(selectedCategory)) ? "selected" : "";
                                    out.println("<option value='" + cat + "' " + isSelected + ">" + cat + "</option>");
                                }
                            } catch(Exception e) {}
                        %>
                    </select>
                </div>
            </form>
        </section>

		<!-- PRODUCT INFO CARD -->
        <section class="products-section">
            <div class="products-container">
                <%
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                        
                        // SQL Construction based on filters
                        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1 AND prodStock >=1");
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            sql.append(" AND (prodName LIKE ? OR prodDesc LIKE ?)");
                        }
                        if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                            sql.append(" AND prodCategory = ?");
                        }

                        PreparedStatement pstmt = con.prepareStatement(sql.toString());
                        int pIdx = 1;
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            pstmt.setString(pIdx++, "%" + searchKeyword + "%");
                            pstmt.setString(pIdx++, "%" + searchKeyword + "%");
                        }
                        if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                            pstmt.setString(pIdx++, selectedCategory);
                        }
                  
                        ResultSet rs = pstmt.executeQuery();
                        boolean hasResults = false;

                        while (rs.next()) {
                            hasResults = true;
                            String pID = rs.getString("prodID");
                            String pName = rs.getString("prodName");
                            String pCat = rs.getString("prodCategory");
                            String pDesc = rs.getString("prodDesc");
                            double pPrice = rs.getDouble("prodPrice");
                            int pStock = rs.getInt("prodStock");
                            String pImg = rs.getString("prodPicture");

                            // Stock status logic
                            boolean isOutOfStock = (pStock <= 0);
                            String badgeClass = isOutOfStock ? "badge-out" : (pStock < 10 ? "badge-low" : "badge-instock");
                            String badgeText = isOutOfStock ? "Sold Out" : (pStock < 10 ? "Low Stock: " + pStock : "In Stock: " + pStock);
                %>
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <span class="stock-badge <%= badgeClass %>"><%= badgeText %></span>
                        <% if (pImg != null && !pImg.trim().isEmpty()) { %>
                            <img src="images/<%= pImg %>" alt="<%= pName %>" <%= isOutOfStock ? "style='filter: grayscale(1); opacity: 0.6;'" : "" %>>
                        <% } else { %>
                            <span class="material-symbols-outlined" style="font-size: 64px; color: #cbd5e1;">medication</span>
                        <% } %>
                    </div>
                    
                    <div class="product-info">
                        <span class="product-category"><%= pCat %></span>
                        <h3 class="product-name"><%= pName %></h3>
                        <p class="product-description" style="font-size:12px; height: 3em; overflow: hidden; color: #64748b;"><%= pDesc %></p>
                        
                        <div class="product-footer" style="display: flex; flex-direction: column; gap: 10px; align-items: flex-start;">
                            <span class="product-price">RM <%= String.format("%.2f", pPrice) %></span>
                            <form class="ajax-cart-form" style="display: flex; gap: 5px; width: 100%;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="productId" value="<%= pID %>">
                                <input type="number" name="quantity" value="<%= isOutOfStock ? 0 : 1 %>" 
                                       min="<%= isOutOfStock ? 0 : 1 %>" 
                                       data-stock="<%= pStock %>"
                                       <%= isOutOfStock ? "disabled" : "" %>
                                       style="width: 60px; padding: 5px; border: 1px solid #ccc; border-radius: 5px;">
                                
                                <button type="submit" class="btn-add-cart" 
                                        <%= isOutOfStock ? "disabled" : "" %>
                                        style="border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; flex: 1; <%= isOutOfStock ? "background:#94a3b8; cursor:not-allowed;" : "" %>">
                                    <%= isOutOfStock ? "Out of Stock" : "Add to Cart" %>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                        }
                        if (!hasResults) {
                            out.println("<div style='grid-column: 1/-1; text-align: center; padding: 50px; color: #64748b;'><h3>No products found.</h3><a href='catalogue.jsp' style='color:#3b82f6;'>Clear Filters</a></div>");
                        }
                        con.close();
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
        </section>

		<!-- FOOTER -->
        <footer class="catalogue-footer">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
        </footer>
    </div>

	<!-- SEARCH & FILTER FUNCTION -->
    <script>
    // Handle AJAX Add to Cart without refreshing page
    document.querySelectorAll('.ajax-cart-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const qtyInput = this.querySelector('input[name="quantity"]');
            const requestedQty = parseInt(qtyInput.value);
            const availableStock = parseInt(qtyInput.getAttribute('data-stock'));
            const pName = this.closest('.product-card').querySelector('.product-name').innerText;

            // Stock Check
            if (requestedQty > availableStock) {
                alert("Limited stock available!\nMaximum allowed: " + availableStock);
                qtyInput.value = availableStock;
                return;
            }

            if (requestedQty <= 0) {
                alert("Please select at least 1 unit.");
                return;
            }

            // Execute Request
            const formData = new URLSearchParams(new FormData(this));
            fetch('CartServlet?' + formData.toString(), { method: 'GET' })
            .then(response => {
                if (response.ok) {
                    alert(pName + " added to cart!");
                    const badge = document.getElementById('cartBadge');
                    badge.innerText = (parseInt(badge.innerText) || 0) + requestedQty;
                } else {
                    alert("Error adding product to cart.");
                }
            })
            .catch(error => alert("Could not connect to server."));
        });
    });

    // Check for success redirect after checkout
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('status') === 'success') {
        alert("Success! Your order has been created successfully.");
        window.history.replaceState({}, document.title, window.location.pathname);
    }
    </script>
</body>
</html>