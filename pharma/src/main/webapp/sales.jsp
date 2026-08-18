<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    java.util.Calendar cal = java.util.Calendar.getInstance();
    String selectedMonth = request.getParameter("month");
    String selectedYear = request.getParameter("year");
    if (selectedMonth == null) selectedMonth = String.valueOf(cal.get(java.util.Calendar.MONTH) + 1);
    if (selectedYear == null) selectedYear = String.valueOf(cal.get(java.util.Calendar.YEAR));

    StringBuilder labels = new StringBuilder();      
    StringBuilder data = new StringBuilder();        
    StringBuilder prodNames = new StringBuilder();   
    StringBuilder prodSales = new StringBuilder();
    StringBuilder catNames = new StringBuilder();    
    StringBuilder catSales = new StringBuilder();
    
    double todaySales = 0.0, monthSales = 0.0;
    int monthOrders = 0, totalOrders = 0;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
        
        String trendSql = "SELECT DATE(receiptDate) as d, SUM(totalAmount) as s FROM RECEIPT WHERE MONTH(receiptDate) = ? AND YEAR(receiptDate) = ? GROUP BY d ORDER BY d ASC";
        PreparedStatement psTrend = con.prepareStatement(trendSql);
        psTrend.setString(1, selectedMonth); psTrend.setString(2, selectedYear);
        ResultSet rsTrend = psTrend.executeQuery();
        while(rsTrend.next()) {
            labels.append("'").append(rsTrend.getString("d")).append("',");
            data.append(rsTrend.getDouble("s")).append(",");
        }

        String topProductsSql = "SELECT p.prodName, SUM(rp.qty) as totalQty FROM RECEIPT_PRODUCT rp JOIN PRODUCT p ON rp.prodID = p.prodID JOIN RECEIPT r ON rp.receiptID = r.receiptID WHERE MONTH(r.receiptDate) = ? AND YEAR(r.receiptDate) = ? GROUP BY p.prodName ORDER BY totalQty DESC LIMIT 5";
        PreparedStatement psProd = con.prepareStatement(topProductsSql);
        psProd.setString(1, selectedMonth); psProd.setString(2, selectedYear);
        ResultSet rsTop = psProd.executeQuery();
        while(rsTop.next()) {
            prodNames.append("'").append(rsTop.getString("prodName")).append("',");
            prodSales.append(rsTop.getInt("totalQty")).append(",");
        }

        String catSql = "SELECT p.prodCategory, SUM(rp.qty) as totalQty FROM RECEIPT_PRODUCT rp JOIN PRODUCT p ON rp.prodID = p.prodID JOIN RECEIPT r ON rp.receiptID = r.receiptID WHERE MONTH(r.receiptDate) = ? AND YEAR(r.receiptDate) = ? GROUP BY p.prodCategory";
        PreparedStatement psCat = con.prepareStatement(catSql);
        psCat.setString(1, selectedMonth); psCat.setString(2, selectedYear);
        ResultSet rsCat = psCat.executeQuery();
        while(rsCat.next()) {
            catNames.append("'").append(rsCat.getString("prodCategory")).append("',");
            catSales.append(rsCat.getInt("totalQty")).append(",");
        }

        ResultSet rsT = con.createStatement().executeQuery("SELECT SUM(totalAmount) FROM RECEIPT WHERE DATE(receiptDate) = CURDATE()");
        if(rsT.next()) todaySales = rsT.getDouble(1);

        PreparedStatement psM = con.prepareStatement("SELECT SUM(totalAmount) as totalSales, COUNT(*) as totalOrders FROM RECEIPT WHERE MONTH(receiptDate)=? AND YEAR(receiptDate)=?");
        psM.setString(1, selectedMonth);
        psM.setString(2, selectedYear);
        ResultSet rsM = psM.executeQuery();
        if(rsM.next()) {
            monthOrders = rsM.getInt("totalOrders");
            double grossSales = rsM.getDouble("totalSales");
            double shippingFee = 7.50 * monthOrders;
            monthSales = grossSales - shippingFee; 
        }

        ResultSet rsTot = con.createStatement().executeQuery("SELECT COUNT(*) FROM RECEIPT");
        if(rsTot.next()) totalOrders = rsTot.getInt(1);

        con.close();
    } catch (Exception e) { e.printStackTrace(); }

    String jsLabels = labels.toString().replaceAll(",$", "");
    String jsData = data.toString().replaceAll(",$", "");
    String jsProdNames = prodNames.toString().replaceAll(",$", "");
    String jsProdSales = prodSales.toString().replaceAll(",$", "");
    String jsCatNames = catNames.toString().replaceAll(",$", "");
    String jsCatSales = catSales.toString().replaceAll(",$", "");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sales Report - PHARMA2GO</title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
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
            <nav class="sidebar-nav">
                <a href="dashboard.jsp" class="nav-link"><span class="material-symbols-outlined">dashboard</span> Dashboard</a>
                <a href="employee.jsp" class="nav-link"><span class="material-symbols-outlined">badge</span> Manage Employee</a>
                <a href="supplier.jsp" class="nav-link"><span class="material-symbols-outlined">local_shipping</span> Manage Supplier</a>
                <a href="product.jsp" class="nav-link"><span class="material-symbols-outlined">inventory_2</span> Manage Product</a>
                <a href="order.jsp" class="nav-link"><span class="material-symbols-outlined">receipt_long</span> Manage Orders</a>
                <a href="sales.jsp" class="nav-link active"><span class="material-symbols-outlined">monitoring</span> Sales Report</a>
                <a href="profile2.jsp" class="nav-link"><span class="material-symbols-outlined">account_circle</span> Admin Profile</a>
            </nav>
            <div class="sidebar-footer">
                <a href="LogoutServlet" class="nav-link logout-link"><span class="material-symbols-outlined">logout</span> Logout</a>
            </div>
        </aside>

        <main class="main-content">
            <header class="top-bar">
                <h2>Business Performance</h2>
                <div class="user-info"><%= name %></div>
            </header>
            
            <div class="content-area">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header"><span>Today's Sales</span><span class="material-symbols-outlined">payments</span></div>
                        <div class="stat-value">RM <%= String.format("%.2f", todaySales) %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header"><span>Monthly Revenue</span><span class="material-symbols-outlined">account_balance_wallet</span></div>
                        <div class="stat-value">RM <%= String.format("%.2f", monthSales) %></div>
                        <div class="form-group shopee-input col-12" style="font-style:italic;">
                            <label class="form-label" style="text-style:italic; color:gray;"><a>*After deduct shipping fees</a></label>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header"><span>Monthly Orders</span><span class="material-symbols-outlined">shopping_cart</span></div>
                        <div class="stat-value"><%= monthOrders %></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header"><span>Lifetime Orders</span><span class="material-symbols-outlined">receipt_long</span></div>
                        <div class="stat-value"><%= totalOrders %></div>
                    </div>
                </div>
				
                <div class="toolbar" style="background: white; padding: 15px; border-radius: 8px; margin: 20px 0; border: 1px solid #ddd;">
                    <form id="filterForm" method="GET" style="display: flex; gap: 10px; align-items: center;">
                        <strong>Select Period:</strong>
                        <select name="month" id="monthSelect" class="search-input">
                            <% for(int m=1; m<=12; m++) { %>
                                <option value="<%=m%>" <%= selectedMonth.equals(String.valueOf(m)) ? "selected" : "" %>><%= java.time.Month.of(m).name() %></option>
                            <% } %>
                        </select>
                        <select name="year" id="yearSelect" class="search-input">
                            <option value="2024" <%= selectedYear.equals("2024") ? "selected" : "" %>>2024</option>
                            <option value="2025" <%= selectedYear.equals("2025") ? "selected" : "" %>>2025</option>
                            <option value="2026" <%= selectedYear.equals("2026") ? "selected" : "" %>>2026</option>
                        </select>
                        <button type="submit" class="btn-primary" style="margin:0; width: auto; padding: 10px 20px;">Submit</button>
                        <button type="button" class="btn-primary" onclick="printReport()" style="margin:0; width: auto; padding: 10px 20px; background-color: #6c757d; border-color: #6c757d;">
                            Report
                        </button>
                    </form>
                </div>
				
                <div class="charts-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="card" style="grid-column: span 2;">
                        <h3 style="padding: 15px;">Revenue Trend</h3>
                        <div style="height: 300px; padding: 15px;"><canvas id="dailySalesChart"></canvas></div>
                    </div>
                    <div class="card">
                        <h3 style="padding: 15px;">Top 5 Products</h3>
                        <div style="height: 350px; padding: 15px;"><canvas id="topProductChart"></canvas></div>
                    </div>
                    <div class="card">
                        <h3 style="padding: 15px;">Category Distribution</h3>
                        <div style="height: 350px; padding: 15px;"><canvas id="categoryPieChart"></canvas></div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script>
        function printReport() {
            const month = document.getElementById('monthSelect').value;
            const year = document.getElementById('yearSelect').value;
            window.open('printSalesReport.jsp?month=' + month + '&year=' + year, '_blank');
        }

        Chart.register(ChartDataLabels);

        new Chart(document.getElementById('dailySalesChart'), {
            type: 'line',
            data: {
                labels: [<%= jsLabels %>],
                datasets: [{
                    label: 'Revenue (RM)',
                    data: [<%= jsData %>],
                    borderColor: '#2563eb',
                    backgroundColor: 'rgba(37, 99, 235, 0.1)',
                    fill: true, tension: 0.3
                }]
            },
            options: {
                responsive: true, maintainAspectRatio: false,
                plugins: { datalabels: { display: false } },
                scales: {
                    x: { title: { display: true, text: 'Transaction Date' } },
                    y: { title: { display: true, text: 'Amount (RM)' }, beginAtZero: true }
                }
            }
        });

        new Chart(document.getElementById('topProductChart'), {
            type: 'bar',
            data: {
                labels: [<%= jsProdNames %>],
                datasets: [{
                    label: 'Units Sold',
                    data: [<%= jsProdSales %>],
                    backgroundColor: ['#3b82f6', '#6366f1', '#8b5cf6', '#ec4899', '#f43f5e'],
                    borderRadius: 5
                }]
            },
            options: { 
                responsive: true, maintainAspectRatio: false,
                plugins: { legend: { display: false }, datalabels: { display: false } },
                scales: {
                    x: { title: { display: true, text: 'Product Name' } },
                    y: { title: { display: true, text: 'Quantity Sold' }, beginAtZero: true }
                }
            }
        });

        new Chart(document.getElementById('categoryPieChart'), {
            type: 'pie',
            data: {
                labels: [<%= jsCatNames %>],
                datasets: [{
                    data: [<%= jsCatSales %>],
                    backgroundColor: ['#10b981', '#f59e0b', '#3b82f6', '#6366f1', '#8b5cf6']
                }]
            },
            options: { 
                responsive: true, maintainAspectRatio: false,
                plugins: { 
                    legend: { position: 'bottom' },
                    datalabels: {
                        color: '#fff',
                        font: { weight: 'bold' },
                        formatter: (value, ctx) => {
                            let sum = 0;
                            let dataArr = ctx.chart.data.datasets[0].data;
                            dataArr.map(data => { sum += data; });
                            return (value * 100 / sum).toFixed(1) + "%";
                        }
                    }
                }
            }
        });
    </script>
    <footer class="catalogue-footer">
    	<p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved.</p>
   	</footer>
</body>
</html>