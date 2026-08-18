<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //EXISTING SESSION CHECK
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
    <title>Add Product - PHARMA2GO</title>
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
            
            <!-- PRODUCT CONTAINER -->
            <div class="content-area">
                <h1 class="page-title">Add Product</h1>
                
                <form action="AddProdServlet" method="post" enctype="multipart/form-data">
                    <div class="signup-grid">
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodName" class="form-label required-field">Product Name</label>
                            <input type="text" name="prodName" placeholder="Paracetamol 500mg" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodBrand" class="form-label required-field">Brand</label>
                            <input type="text" name="prodBrand" placeholder="Panadol" required>
                        </div>
                                           
                        <div class="form-group shopee-input col-6">
                            <label for="prodDesc" class="form-label required-field">Description</label>
                            <input type="text" name="prodDesc" placeholder="Product Information" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodPicture" class="form-label required-field">Upload Product Picture</label>
                            <input type="file" name="prodPicture" accept="image/*" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodPrice" class="form-label required-field">Price (RM)</label>
                            <input type="text" name="prodPrice" placeholder="12.90" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodCategory" class="form-label">Category</label>
                            <input type="text" name="prodCategory" placeholder="Machine/Supplement/etc" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodExpDate" class="form-label required-field">Expiry Date</label>
                            <input type="date" name="prodExpDate" required>
                        </div>
                        
                        <div class="form-group shopee-input col-6">
                            <label for="prodStock" class="form-label required-field">Quantity (Stock)</label>
                            <input type="number" name="prodStock" placeholder="100" required>
                        </div>
                        
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label required-field"><a>Please click the boxes to insert your information.</a></label>
                        </div>
                       
                        <div class="col-6">
                            <a href="product.jsp" class="btn-auth login-btn" style="text-decoration: none; display: inline-block; text-align: center;">Back</a>
                            <button type="submit" class="btn-auth signup-btn">Add Product</button>
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
</body>
</html>