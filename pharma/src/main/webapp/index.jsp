<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //CAPTURE FILTER PARAMETER
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
                
                 <!-- LOGIN & SINGUP BUTTON -->
                <div class="header-auth-buttons">
                    <a href="login.jsp" class="btn-auth login-btn">Login</a>
                    <a href="signup.jsp" class="btn-auth signup-btn">Sign Up</a>
                </div>
            </div>
        </header>
 		
 		<!-- BANNER -->
        <section class="hero-section">
            <div class="hero-container">
                <div class="hero-content">
                    <h1 class="hero-title">Discover Your<br>Health<br>Essentials</h1>
                    <p class="hero-description">Explore a wide range of pharmaceutical products, vitamins and wellness items curated for your health.</p>
                    <button class="btn-hero" onclick="window.scrollTo({top: 800, behavior: 'smooth'});">Browse Product</button>
                </div>
                <div class="hero-image">
                    <img src="https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=600&h=400&fit=crop" alt="Medicine Products" class="product-showcase">
                </div>
            </div>
        </section>
		
		 <!-- SEARCH & FILTER -->
        <section class="filters-section">
            <form action="index.jsp" method="get" class="filters-container" id="filterForm">
                <div class="filter-box search-filter">
                    <svg class="filter-icon" viewBox="0 0 24 24" style="width:20px; fill:#64748b;">
                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                    </svg>
                    <input type="text" name="search" class="filter-input" placeholder="Search products..." value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                </div>

                <div class="filter-box category-filter">
                    <span class="material-symbols-outlined filter-icon">category</span>
                    <select name="category" class="filter-input dropdown-select" onchange="this.form.submit()">
                        <option value="">All Categories</option>
                        <%
                            // Fetch dynamic categories from database
                            try {
                                Connection catCon = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go?useSSL=false&serverTimezone=UTC", "root", "root");
                                Statement stmt = catCon.createStatement();
                                ResultSet rsCat = stmt.executeQuery("SELECT DISTINCT prodCategory FROM product");
                                while(rsCat.next()){
                                    String cat = rsCat.getString("prodCategory");
                                    String isSelected = (cat.equals(selectedCategory)) ? "selected" : "";
                                    out.println("<option value='" + cat + "' " + isSelected + ">" + cat + "</option>");
                                }
                                catCon.close();
                            } catch(Exception e) {
                                // Silent catch for category dropdown
                            }
                        %>
                    </select>
                </div>
            </form>
        </section>

		 <!-- PRODUCT CARD -->
        <section class="products-section">
            <div class="products-container">
                <%
                    Connection con = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection(
                            "jdbc:mysql://localhost:3306/pharma2go?useSSL=false&serverTimezone=UTC",
                            "root","root"
                        );

                        // Build dynamic SQL
                        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1");

                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            sql.append(" AND (prodName LIKE ? OR prodDesc LIKE ?)");
                        }
                        if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                            sql.append(" AND prodCategory = ?");
                        }

                        pstmt = con.prepareStatement(sql.toString());
                        int idx = 1;
                        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                            pstmt.setString(idx++, "%" + searchKeyword + "%");
                            pstmt.setString(idx++, "%" + searchKeyword + "%");
                        }
                        if (selectedCategory != null && !selectedCategory.trim().isEmpty()) {
                            pstmt.setString(idx++, selectedCategory);
                        }

                        rs = pstmt.executeQuery();
                        if (!rs.isBeforeFirst()) {
                            out.println("<p style='grid-column: 1/-1; text-align:center; padding: 50px; color:#64748b;'>No products found matching your criteria.</p>");
                        }

                        while(rs.next()) {
                            String pID = rs.getString("prodID");
                            String pName = rs.getString("prodName");
                            String pCat = rs.getString("prodCategory");
                            String pDesc = rs.getString("prodDesc");
                            double pPrice = rs.getDouble("prodPrice");
                            int pStock = rs.getInt("prodStock");
                            String pImg = rs.getString("prodPicture");

                            // Stock status UI logic
                            String badgeClass = (pStock < 10) ? "badge-low" : "badge-instock";
                            String badgeText = (pStock < 10) ? "Low Stock: " + pStock : "In Stock: " + pStock;
                %>
                <div class="product-card">
                    <div class="product-image-wrapper">
                        <span class="stock-badge <%= badgeClass %>"><%= badgeText %></span>
                        <% if (pImg != null && !pImg.trim().isEmpty()) { %>
                            <img src="images/<%= pImg %>" alt="<%= pName %>">
                        <% } else { %>
                            <span class="material-symbols-outlined" style="font-size:64px;color:#cbd5e1;">medication</span>
                        <% } %>
                    </div>
                    
                    <div class="product-info">
                        <span class="product-category"><%= pCat %></span>
                        <h3 class="product-name"><%= pName %></h3>
                        <p class="product-description" style="font-size:12px; height:3em; overflow:hidden; color:#64748b;"><%= pDesc %></p>
                        
                        <div class="product-footer" style="display:flex;flex-direction:column;gap:10px;align-items:flex-start;">
                            <span class="product-price">RM <%= String.format("%.2f", pPrice) %></span>
                            <form action="login.jsp" method="POST" style="display:flex;gap:5px;width:100%;">
                                <input type="hidden" name="productId" value="<%= pID %>">
                                <input type="number" name="quantity" value="1" min="1" style="width:60px;padding:5px;border:1px solid #ccc;border-radius:5px;">
                                <button type="submit" class="btn-add-cart" style="border:none;cursor:pointer;flex:1;">Add to Cart</button>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                        }
                    } catch(Exception e) {
                        out.println("<p style='color:red;'>Database Error: " + e.getMessage() + "</p>");
                    } finally {
                        try{ if(rs!=null) rs.close(); } catch(Exception ignore){}
                        try{ if(pstmt!=null) pstmt.close(); } catch(Exception ignore){}
                        try{ if(con!=null) con.close(); } catch(Exception ignore){}
                    }
                %>
            </div>
        </section>

		 <!-- FOOTER -->
        <footer class="catalogue-footer">
            <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
        </footer>
    </div>
</body>
</html>