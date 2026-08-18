<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String month = request.getParameter("month");
    String year = request.getParameter("year");
    String monthName = (month != null) ? java.time.Month.of(Integer.parseInt(month)).name() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PHARMA2GO - Sales Report <%= monthName %> <%= year %></title>
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    
    <style>
        body { 
            background: #f4f4f7; 
            padding: 40px; 
            font-family: 'Inter', sans-serif;
            color: #1a1a1a; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
        }
        
        .report-wrapper { 
            background: white;
            width: 100%; 
            max-width: 900px; 
            padding: 60px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            border-radius: 8px;
        }
        
        .report-header { 
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            border-bottom: 2px solid #000;
            padding-bottom: 20px;
            margin-bottom: 40px;
        }

        .brand-section h1 { font-size: 32px; font-weight: 800; margin: 0; color: #2563eb; letter-spacing: -1px; }
        .info-section { text-align: right; }
        .info-section h2 { font-size: 14px; text-transform: uppercase; color: #6b7280; margin: 0; letter-spacing: 1px; }
        .info-section p { font-size: 20px; font-weight: 600; margin: 5px 0 0 0; }
        
        .print-controls { 
            display: flex; 
            gap: 12px; 
            margin-bottom: 20px; 
        }
        
        table { 
            width: 100%; 
            border-collapse: collapse; 
            margin-top: 10px;
        }
        
        th { 
            text-align: left; 
            font-size: 12px; 
            text-transform: uppercase;
            color: #6b7280;
            padding: 15px 10px;
            border-bottom: 1px solid #e5e7eb;
        }
        
        td { 
            padding: 20px 10px; 
            border-bottom: 1px solid #f3f4f6; 
            font-size: 15px; 
        }

        /* TOTAL SECTION DESIGN */
        .summary-container {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
        }

        .total-box {
            background: white;
            color: black;
            padding: 30px;
            border-radius: 4px;
            min-width: 300px;
            text-align: right;
        }

        .total-label { font-size: 12px; text-transform: uppercase; color: #9ca3af; margin-bottom: 10px; }
        .total-amount { font-size: 32px; font-weight: 800; display: block; }

        @media print {
            body { background: white; padding: 0; }
            .report-wrapper { box-shadow: none; max-width: 100%; padding: 40px; }
            .no-print { display: none !important; }
            .total-box { background: #000 !important; color: white !important; -webkit-print-color-adjust: exact; }
        }
    </style>
</head>
<body>

    <div class="print-controls no-print">
        <button onclick="window.print()" class="btn-primary" style="width: auto; padding: 10px 24px; cursor: pointer; border-radius: 6px;">
            Print Report
        </button>
        <button onclick="window.close()" class="btn-primary" style="width: auto; padding: 10px 24px; background: #fff; color: #374151; border: 1px solid #d1d5db; cursor: pointer; border-radius: 6px;">
            Close
        </button>
    </div>

    <div class="report-wrapper">
        <div class="report-header">
            <div class="brand-section">
                <h1>PHARMA2GO</h1>
                <p style="color: #6b7280; font-size: 14px; margin-top: 5px;">Official Sales Record</p>
            </div>
            <div class="info-section">
                <h2>Reporting Period</h2>
                <p><%= monthName %> <%= year %></p>
            </div>
        </div>

        <table>
            <thead>
                <tr>
                    <th style="width: 15%;">ID</th>
                    <th style="width: 40%;">Transaction Date</th>
                    <th style="width: 20%;">Payment</th>
                    <th style="text-align: right; width: 25%;">Amount</th>
                </tr>
            </thead>
            <tbody>
                <%
                    double grandTotal = 0;
                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
                        String sql = "SELECT receiptID, receiptDate, payMethod, totalAmount FROM RECEIPT WHERE MONTH(receiptDate) = ? AND YEAR(receiptDate) = ? ORDER BY receiptDate ASC";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ps.setString(1, month); ps.setString(2, year);
                        ResultSet rs = ps.executeQuery();
                        while(rs.next()) {
                            double amt = rs.getDouble("totalAmount");
                            grandTotal += amt;
                %>
                <tr>
                    <td style="font-weight: 600;">#<%= rs.getString("receiptID") %></td>
                    <td style="color: #4b5563;"><%= rs.getTimestamp("receiptDate") %></td>
                    <td><span style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-size: 12px;"><%= rs.getString("payMethod") != null ? rs.getString("payMethod") : "N/A" %></span></td>
                    <td style="text-align: right; font-weight: 600;">RM <%= String.format("%.2f", amt) %></td>
                </tr>
                <% 
                        }
                        con.close();
                    } catch (Exception e) { e.printStackTrace(); }
                %>
            </tbody>
        </table>

        <div class="summary-container">
            <div class="total-box">
                <div class="total-label">Total Gross Revenue</div>
                <div class="total-amount">RM <%= String.format("%.2f", grandTotal) %></div>
            </div>
        </div>
        
        <div style="margin-top: 80px; font-size: 12px; color: #9ca3af; display: flex; justify-content: space-between;">
            <span>Generated on: <%= new java.util.Date() %></span>
            <span>PHARMA2GO Internal Audit</span>
        </div>
    </div>

</body>
</html>