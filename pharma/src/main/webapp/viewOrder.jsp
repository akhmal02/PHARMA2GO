<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    //SECURITY & CACHE CONTROL
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    
    //AUTHENTICATION CHECK
    String name = (String) session.getAttribute("userName");
    String receiptID = request.getParameter("receiptID");
    
    if (name == null) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    if (receiptID == null) { 
        response.sendRedirect("order.jsp"); 
        return; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice #<%= receiptID %> - PHARMA2GO</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        .invoice-box {
            background: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            max-width: 900px;
            margin: 20px auto;
            color: #333;
        }
        .invoice-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 25px;
            margin-bottom: 30px;
        }
        .customer-info-section {
            border-bottom: 2px solid #f0f0f0;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }
        .company-info h1 { margin: 0; color: #1a73e8; font-size: 2rem; }
        .company-info p { margin: 5px 0; color: #666; font-size: 0.9rem; }
        .order-meta { text-align: right; }
        .order-meta h2 { margin: 0; color: #333; }
        
        .invoice-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .invoice-table th { background: #f8f9fa; padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        .invoice-table td { padding: 15px; border-bottom: 1px solid #eee; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .grand-total-row { background: #fdfdfd; font-weight: bold; }
        .total-price { font-size: 1.4rem; color: #1a73e8; }

        @media print {
            .sidebar, .top-bar, .toolbar, .no-print, .catalogue-footer {
                display: none !important;
            }
            .main-content { margin: 0 !important; padding: 0 !important; width: 100% !important; }
            .dashboard-container { display: block !important; }
            
            .invoice-box {
                box-shadow: none !important;
                margin: 0 !important;
                padding: 0 !important;
                max-width: 100% !important;
                width: 100% !important;
            }
            .invoice-header { border-bottom: 1px solid #000; }
            .invoice-table th { background: #eee !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <aside class="sidebar no-print">
            <div class="sidebar-header">
                <svg class="brand-icon-small" viewBox="0 0 16 16">
                    <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                </svg>
                <span class="brand-text">PHARMA2GO</span>
            </div>
            
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-link"><span class="material-symbols-outlined">dashboard</span>Dashboard</a>
                <a href="employee.jsp" class="nav-link"><span class="material-symbols-outlined">badge</span>Manage Employee</a>
                <a href="supplier.jsp" class="nav-link"><span class="material-symbols-outlined">local_shipping</span>Manage Supplier</a>
                <a href="product.jsp" class="nav-link"><span class="material-symbols-outlined">inventory_2</span>Manage Product</a>
                <a href="order.jsp" class="nav-link active"><span class="material-symbols-outlined">receipt_long</span>Manage Orders</a>
                <a href="sales.jsp" class="nav-link"><span class="material-symbols-outlined">monitoring</span>Sales Report</a>
                <a href="profile2.jsp" class="nav-link"><span class="material-symbols-outlined">account_circle</span>Admin Profile</a>
            </nav>
            
            <div class="sidebar-footer">
                <a href="LogoutServlet" class="nav-link logout-link">
                    <span class="material-symbols-outlined">logout</span>Logout
                </a>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-bar no-print">
                <h2>Invoice Details</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
           <div class="content-area">
                <div class="row no-print">
                    <div class="col-12" style="margin: 1rem 0; display: flex; gap: 10px;">
                        <a href="order.jsp" class="btn-auth login-btn" style="text-decoration: none; padding: 10px 20px; border-radius: 4px; border: 1px solid #ccc; color: #333;">Back</a>
                        <button type="button" class="btn-auth signup-btn" onclick="window.print()" style="cursor: pointer; background: #1a73e8; color: white; border: none; padding: 10px 20px; border-radius: 4px;">
                            Print Invoice
                        </button>
                    </div>
                </div>
                
                <div class="invoice-box">
                    <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");

                            // Fetch Customer and Receipt Header Info
                            String sqlM = "SELECT r.*, c.custName, c.custAddress, c.custPostcode, c.custState, c.custPhone, c.custEmail " +
                                          "FROM receipt r JOIN customer c ON r.custID = c.custID WHERE r.receiptID = ?";
                            PreparedStatement psM = con.prepareStatement(sqlM);
                            psM.setString(1, receiptID);
                            ResultSet rsM = psM.executeQuery();

                            if (rsM.next()) {
                    %>
                    <div class="invoice-header">
                        <div class="company-info">
                            <h1>PHARMA2GO</h1>
                            <p>Lot.13 Bangunan Megah Tegah Mengah Holdings, </p>
                            <p>56000 Kuala Lumpur, Malaysia</p>
                            <p>Phone: +603 9657 1019 | Email: admin@pharma2go.com</p>
                        </div>
                        <div class="order-meta">
                            <h2>INVOICE</h2>
                            <p><strong>Order ID:</strong> #<%= receiptID %></p>
                            <p><strong>Printed Date:</strong> <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></p>
                        </div>
                    </div>
			
                    <div class="customer-info-section">
                        <div class="company-info">
                            <p><strong>Billed To:</strong></p>
                            <p>Name: <%= rsM.getString("custName") %></p>
                            <p>Address: <%= rsM.getString("custAddress") %>, <%= rsM.getString("custPostcode") %>, <%= rsM.getString("custState") %></p>
                            <p>Phone: <%= rsM.getString("custPhone") %></p>
                            <p>Email: <%= rsM.getString("custEmail") %></p>
                        </div>
                    </div>
                    <%
                            }

                            // Fetch Product Lines
                            String sqlI = "SELECT p.prodName, rp.price, rp.qty " +
                                         "FROM RECEIPT_PRODUCT rp " +
                                         "JOIN PRODUCT p ON rp.prodID = p.prodID " +
                                         "WHERE rp.receiptID = ?";
                            PreparedStatement psI = con.prepareStatement(sqlI);
                            psI.setString(1, receiptID);
                            ResultSet rsI = psI.executeQuery();
                    %>
                    
                    <table class="invoice-table">
                        <thead>
                            <tr>
                                <th>Bil</th>
                                <th>Product Name</th>
                                <th class="text-right">Price (RM)</th>
                                <th class="text-center">Qty</th>
                                <th class="text-right">Subtotal (RM)</th>
                            </tr>
                        </thead>
                        <tbody>
                        <%
                                double subtotalAccumulator = 0;
                                double shippingFee = 7.50; 
                                int num = 0;
                                
                                while (rsI.next()) {
                                    double unitPrice = rsI.getDouble("price");
                                    int quantity = rsI.getInt("qty");
                                    double lineTotal = unitPrice * quantity;
                                    subtotalAccumulator += lineTotal;                                                               
                                    num++;
                        %>
                                    <tr>
                                        <td><%= num %></td>
                                        <td style="font-weight: 500;"><%= rsI.getString("prodName") %></td>
                                        <td class="text-right"><%= String.format("%.2f", unitPrice) %></td>
                                        <td class="text-center"><%= quantity %></td>
                                        <td class="text-right">RM <%= String.format("%.2f", lineTotal) %></td>
                                    </tr>
                        <%
                                }
                                double grandTotal = subtotalAccumulator + shippingFee;
                        %>
                            <tr>
                                <td colspan="4" class="text-right" style="border-bottom: none; padding-top: 20px;">Subtotal:</td>
                                <td class="text-right" style="border-bottom: none; padding-top: 20px;">RM <%= String.format("%.2f", subtotalAccumulator) %></td>
                            </tr>
                            <tr>
                                <td colspan="4" class="text-right" style="border-bottom: none;">Shipping Fee:</td>
                                <td class="text-right" style="border-bottom: none;">RM <%= String.format("%.2f", shippingFee) %></td>
                            </tr>
                            <tr class="grand-total-row">
                                <td colspan="4" class="text-right">Grand Total:</td>
                                <td class="text-right total-price">RM <%= String.format("%.2f", grandTotal) %></td>
                            </tr>
                        </tbody>
                    </table>
                    <%
                            con.close();
                        } catch (Exception e) {
                            out.println("<p style='color:red;'>Error Loading Invoice: " + e.getMessage() + "</p>");
                        }
                    %>
                </div>
            </div>
        </main>
    </div>
    
    <footer class="catalogue-footer no-print">
   	  <p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
   	</footer>
</body>
</html>