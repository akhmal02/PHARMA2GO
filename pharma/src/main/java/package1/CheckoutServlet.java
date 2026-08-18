package package1;

import java.io.IOException;
import java.sql.*;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

// Force Servlet To Run
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
    	// Get Session
    	HttpSession session = request.getSession();

        String email = (String) session.getAttribute("custEmail");
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (email == null || cart == null || cart.isEmpty()) {
            response.sendRedirect("login.jsp");
            return;
        }

        Connection con = null;
        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go?useSSL=false&serverTimezone=UTC", "root", "root");
            
            con.setAutoCommit(false);

            int custID = -1;
            String sqlUser = "SELECT custID FROM customer WHERE custEmail = ?";
            try (PreparedStatement psUser = con.prepareStatement(sqlUser)) {
                psUser.setString(1, email);
                try (ResultSet rsUser = psUser.executeQuery()) {
                    if (rsUser.next()) custID = rsUser.getInt("custID");
                }
            }

            // SQL Statement To Store Data Inside RECEIPT Table
            String sqlReceipt = "INSERT INTO receipt (receiptDate, totalAmount, status, payMethod, cardNo, shipmentAddress, shipmentPostcode, shipmentState, custID, empID) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            int receiptID = 0;
            try (PreparedStatement psReceipt = con.prepareStatement(sqlReceipt, Statement.RETURN_GENERATED_KEYS)) {
                String totalStr = request.getParameter("grandTotal");
                double totalValue = (totalStr != null) ? Double.parseDouble(totalStr) : 0.0;
                
                String payMethod = request.getParameter("payMethod");
                String cardData = null;
     
                if ("Credit Card".equals(payMethod) || "Debit Card".equals(payMethod)) {
                    cardData = request.getParameter("cardNo");
                } else if ("Online Banking".equals(payMethod)) {
                    cardData = request.getParameter("bankAccount");
                } else {
                    cardData = null;
                }

                psReceipt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
                psReceipt.setDouble(2, totalValue);
                psReceipt.setString(3, "New");
                psReceipt.setString(4, payMethod);
                
                if (cardData != null && !cardData.trim().isEmpty()) {
                    psReceipt.setString(5, cardData.trim());
                } else {
                    psReceipt.setNull(5, java.sql.Types.VARCHAR);
                }

                psReceipt.setString(6, request.getParameter("shipmentAddress"));
                psReceipt.setString(7, request.getParameter("shipmentPostcode"));
                psReceipt.setString(8, request.getParameter("shipmentState"));
                psReceipt.setInt(9, custID);
                psReceipt.setNull(10, java.sql.Types.INTEGER); 

                psReceipt.executeUpdate();
                try (ResultSet rsKeys = psReceipt.getGeneratedKeys()) {
                    if (rsKeys.next()) receiptID = rsKeys.getInt(1);
                }
            }

            // Decrease Product Quantity (After Transaction is Successful
            String sqlItem = "INSERT INTO receipt_product (receiptID, prodID, qty, price) VALUES (?, ?, ?, ?)";
            String sqlUpdateStock = "UPDATE product SET prodStock = prodStock - ? WHERE prodID = ?";

            try (PreparedStatement psItem = con.prepareStatement(sqlItem);
                 PreparedStatement psStock = con.prepareStatement(sqlUpdateStock)) {
                
                for (CartItem item : cart) {
                    int prodID = Integer.parseInt(item.getId());
                    int qty = item.getQuantity();

                    psItem.setInt(1, receiptID);
                    psItem.setInt(2, prodID);
                    psItem.setInt(3, qty);
                    psItem.setDouble(4, item.getPrice());
                    psItem.addBatch();

                    psStock.setInt(1, qty);
                    psStock.setInt(2, prodID);
                    psStock.addBatch();
                }
                psItem.executeBatch();
                psStock.executeBatch();
            }
            
            // Commit Transaction
            con.commit();
            session.removeAttribute("cart");
            response.sendRedirect("catalogue.jsp?status=success");

        } catch (Exception e) {
            if (con != null) { try { con.rollback(); } catch (SQLException ex) { ex.printStackTrace(); } }
            e.printStackTrace();
            response.sendRedirect("cartView.jsp?status=error");
        } finally {
            if (con != null) { try { con.close(); } catch (SQLException ex) { ex.printStackTrace(); } }
        }
    }
}