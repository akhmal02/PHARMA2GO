<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.List"%>
<%@ page import="package1.CartItem"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    String name = (String) session.getAttribute("userName");
    Integer currentCustID = (Integer) session.getAttribute("custID");

    if (name == null || currentCustID == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    int cartCount = (cart != null) ? cart.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Purchase History - PHARMA2GO</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        .status-badge { padding: 6px 14px; border-radius: 50px; font-size: 0.85rem; font-weight: 600; display: inline-block; }
        .view-btn { background-color: #3b82f6; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; transition: 0.2s; }
        .view-btn:hover { background-color: #1d4ed8; }

        .modal {
            display: none; 
            position: fixed; 
            z-index: 9999; 
            left: 0; top: 0;
            width: 100%; height: 100%; 
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(4px);
            overflow-y: auto;
        }
        .modal-content {
            background-color: #ffffff;
            margin: 2% auto; 
            width: 80%; 
            max-width: 950px;
            border-radius: 12px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        .modal-header { padding: 15px 25px; background-color: #f8fafc; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .close-icon { color: #64748b; font-size: 28px; font-weight: bold; cursor: pointer; }

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
            body * { visibility: hidden; }
            .modal.show-print, 
            .modal.show-print .modal-content, 
            .modal.show-print .invoice-box,
            .modal.show-print .invoice-box * {
                visibility: visible !important;
            }
            .modal.show-print {
                position: absolute;
                left: 0; top: 0;
                width: 100% !important;
                display: block !important;
                background: white !important;
            }
            .modal.show-print .modal-content {
                box-shadow: none !important;
                margin: 0 !important;
                width: 100% !important;
                max-width: 100% !important;
                border-radius: 0 !important;
            }
            .modal.show-print .invoice-box {
                box-shadow: none !important;
                margin: 0 !important;
                padding: 20px !important;
                width: 100% !important;
            }
            .no-print, .modal-header, .close-icon { display: none !important; }
            .invoice-table th { background: #f0f0f0 !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>
    <div class="catalogue-page no-print">
        <header class="catalogue-header">
            <div class="header-container">
                <div class="brand-section">
                    <svg class="brand-icon" viewBox="0 0 16 16"><path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/></svg>
                    <span class="brand-name">PHARMA2GO</span>
                </div>
                <!-- MENU -->
                <div class="header-icons">
                    <span class="user-welcome" style="margin-right: 15px; font-weight: 500; color: #1f2937;">
                        Welcome, <%= name %>
                    </span>
                    <button class="icon-btn" onclick="location.href='catalogue.jsp'" title="Home">
                        <span class="material-symbols-outlined">home</span>
                    </button>
                    <button class="icon-btn cart-btn" onclick="location.href='cartView.jsp'">
                        <span class="material-symbols-outlined">shopping_cart</span>
                        <span class="cart-badge"><%= cartCount %></span>
                    </button>
                    <button class="icon-btn profile-btn" style="border: 2px solid #3b82f6;">
                         <span class="material-symbols-outlined" style="color: #3b82f6;">bucket_check</span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='custProfile.jsp'">
                        <span class="material-symbols-outlined">person</span>
                    </button>
                    <form action="LogoutServlet" method="get" style="display: inline;">
                        <button type="submit" class="icon-btn">
                            <span class="material-symbols-outlined">logout</span>
                        </button>
                    </form>
                </div>
            </div>
        </header>

		<!-- PURCHASE HISTORY TABLE -->
        <div class="content-area" style="max-width: 1100px; margin: 40px auto; padding: 0 20px;">
            <h2 style="margin-bottom: 20px;">My Purchase History</h2>
            <div style="background: white; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); overflow: hidden;">
                <table style="width: 100%; border-collapse: collapse;">
                    <thead>
                        <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                            <th style="padding: 18px; text-align: left;">NO.</th>
                            <th style="padding: 18px; text-align: left;">DATE</th>
                            <th style="padding: 18px; text-align: left;">METHOD</th>
                            <th style="padding: 18px; text-align: left;">AMOUNT</th>
                            <th style="padding: 18px; text-align: left;">STATUS</th>
                            <th style="padding: 18px; text-align: center;">ACTION</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try {
                            Class.forName("com.mysql.jdbc.Driver");
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                            String sql = "SELECT * FROM receipt WHERE custID = ? ORDER BY receiptDate DESC";
                            PreparedStatement pstmt = con.prepareStatement(sql);
                            pstmt.setInt(1, currentCustID);
                            ResultSet rs = pstmt.executeQuery();
                            int i = 1;
                            while (rs.next()) {
                                int rID = rs.getInt("receiptID");
                                String status = rs.getString("status");
                                
                                String badgeColor = "#64748b"; String bgColor = "#f1f5f9";    
                                if (status != null) {
                                    switch(status.toLowerCase()) {
                                        case "delivered": badgeColor = "#166534"; bgColor = "#f0fdf4"; break;
                                        case "delayed": badgeColor = "#991b1b"; bgColor = "#fef2f2"; break;
                                        case "new": badgeColor = "#2563eb"; bgColor = "#eff6ff"; break;
                                        case "in progress": badgeColor = "#854d0e"; bgColor = "#fefce8"; break;
                                    }
                                }
						%>
						<tr style="border-bottom: 1px solid #f1f5f9;">
						    <td style="padding: 18px;"><%= i++ %></td>
						    <td style="padding: 18px;"><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(rs.getTimestamp("receiptDate")) %></td>
						    <td style="padding: 18px;"><%= rs.getString("payMethod") %></td>
						    <td style="padding: 18px; font-weight: bold;">RM <%= String.format("%.2f", rs.getDouble("totalAmount")) %></td>
						    <td style="padding: 18px;">
						        <span class="status-badge" style="color: <%= badgeColor %>; background-color: <%= bgColor %>;">
						            <%= status %>
						        </span>
						    </td>
						    <td style="padding: 18px; text-align: center;">
						        <button class="view-btn" onclick="openModal('modal_<%= rID %>')">View Invoice</button>
						    </td>
						</tr>
                        <% } con.close(); } catch (Exception e) { out.print(e.getMessage()); } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- FOOTER -->
    <footer class="catalogue-footer">
    	<p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
    </footer>
   

    <%
    try {
        Connection conM = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        String sqlM = "SELECT r.*, c.custName, c.custAddress, c.custPostcode, c.custState, c.custPhone, c.custEmail FROM receipt r JOIN customer c ON r.custID = c.custID WHERE r.custID = ?";
        PreparedStatement psM = conM.prepareStatement(sqlM);
        psM.setInt(1, currentCustID);
        ResultSet rsM = psM.executeQuery();

        while (rsM.next()) {
            int rID = rsM.getInt("receiptID");
            double totalAmtFromDB = rsM.getDouble("totalAmount");
    %>
    <div id="modal_<%= rID %>" class="modal">
        <div class="modal-content">
            <div class="modal-header no-print">
                <span style="font-weight: bold;">Order #<%= rID %></span>
                <span class="close-icon" onclick="closeModal('modal_<%= rID %>')">&times;</span>
            </div>
            
            
            <!-- INVOICE -->
            <div class="invoice-box">
                <div class="invoice-header">
                    <div class="company-info">
                        <h1>PHARMA2GO</h1>
                        <p>Lot.13 Bangunan Megah Tegah Mengah Holdings, </p>
                        <p>56000 Kuala Lumpur, Malaysia</p>
                        <p>Phone: +603 9657 1019 | Email: admin@pharma2go.com</p>
                    </div>     
                    <div class="order-meta">
                        <h2>INVOICE</h2>
                        <p><strong>Order ID:</strong> #<%= rID %></p>
                        <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(rsM.getTimestamp("receiptDate")) %></p>
                    </div>                 
                </div>
                
                <div class="invoice-header">
                    <div class="company-info">
                   		<p><strong>Billed To:</strong></p>
                        <p>Name: <%= rsM.getString("custName") %></p>
                        <p>Address: <%= rsM.getString("custAddress") %>, <%= rsM.getString("custPostcode") %>, <%= rsM.getString("custState") %></p>
                        <p>Phone: <%= rsM.getString("custPhone") %></p>
                        <p>Email: <%= rsM.getString("custEmail") %></p>
                    </div>
                </div>

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
                        double runningSubtotal = 0;
                        Connection conI = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                        String sqlI = "SELECT p.prodName, rp.price, rp.qty FROM RECEIPT_PRODUCT rp JOIN PRODUCT p ON rp.prodID = p.prodID WHERE rp.receiptID = ?";
                        PreparedStatement psI = conI.prepareStatement(sqlI);
                        psI.setInt(1, rID);
                        ResultSet rsI = psI.executeQuery();
                        int num = 0;
                        while (rsI.next()) {
                            double p = rsI.getDouble("price");
                            int q = rsI.getInt("qty");
                            runningSubtotal += (p * q);
                            num++;
                    %>
                        <tr>
                            <td><%= num %></td>
                            <td style="font-weight: 500;"><%= rsI.getString("prodName") %></td>
                            <td class="text-right"><%= String.format("%.2f", p) %></td>
                            <td class="text-center"><%= q %></td>
                            <td class="text-right">RM <%= String.format("%.2f", p * q) %></td>
                        </tr>
                    <% } conI.close(); %>
                        <tr>
                            <td colspan="4" class="text-right">Subtotal:</td>
                            <td class="text-right">RM <%= String.format("%.2f", runningSubtotal) %></td>
                        </tr>
                        <tr>
                            <td colspan="4" class="text-right">Shipping Fee:</td>
                            <td class="text-right">RM 7.50</td>
                        </tr>
                        <tr class="grand-total-row">
                            <td colspan="4" class="text-right">Grand Total:</td>
                            <td class="text-right total-price">RM <%= String.format("%.2f", totalAmtFromDB) %></td>
                        </tr>
                    </tbody>
                </table>
                
                <div class="no-print" style="margin-top: 30px; text-align: right;">
                    <button class="view-btn" onclick="window.print()" style="background-color: #1a73e8;">Print Invoice</button>
                </div>
            </div>
        </div>
    </div>
    <% } conM.close(); } catch (Exception e) {} %>

	<!-- PRINT INVOICE -->
    <script>
        function openModal(id) { 
            document.querySelectorAll('.modal').forEach(m => m.classList.remove('show-print'));
            const modal = document.getElementById(id);
            modal.style.display = "block"; 
            modal.classList.add('show-print'); 
            document.body.style.overflow = "hidden";
        }
        function closeModal(id) { 
            const modal = document.getElementById(id);
            modal.style.display = "none"; 
            modal.classList.remove('show-print');
            document.body.style.overflow = "auto";
        }
        window.onclick = function(e) { 
            if (e.target.className.includes('modal')) {
                e.target.style.display = "none";
                e.target.classList.remove('show-print');
                document.body.style.overflow = "auto";
            }
        }
    </script>
</body>
</html>