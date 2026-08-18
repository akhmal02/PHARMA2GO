package package1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Force Servlet to run
@WebServlet("/UpdateSupServlet")
public class UpdateSupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateSupServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");

        // Get Values / Parameters From JSP Form
        String supID = request.getParameter("supID");
        String supName = request.getParameter("supName");
        String supPhone = request.getParameter("supPhone");
        String supEmail = request.getParameter("supEmail");
        String supAddress = request.getParameter("supAddress");
        String supType = request.getParameter("supType");

        // Sub Classes Attributes
        String taxTIN = request.getParameter("taxTIN");
        String country = request.getParameter("country");
        String importLicenseNum = request.getParameter("importLicenseNum");

        Connection con = null;
        PreparedStatement ps = null;

        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");

            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/pharma2go?useSSL=false&serverTimezone=UTC",
                "root",
                "root"
            );

            // Update Supplier SQL Statement
            String updateSupplierSQL =
                "UPDATE supplier SET supName=?, supPhone=?, supEmail=?, supAddress=?, supType=? " +
                "WHERE supID=?";

            // Set Values
            ps = con.prepareStatement(updateSupplierSQL);
            ps.setString(1, supName);
            ps.setString(2, supPhone);
            ps.setString(3, supEmail);
            ps.setString(4, supAddress);
            ps.setString(5, supType);
            ps.setString(6, supID);
            ps.executeUpdate();

            // Update If supType = Local
            if ("Local".equalsIgnoreCase(supType)) {
                String updateLocalSQL = "UPDATE local SET taxTIN=? WHERE supID=?";
                ps = con.prepareStatement(updateLocalSQL);
                ps.setString(1, taxTIN);
                ps.setString(2, supID);
                ps.executeUpdate();

            } 
         // Update If supType = International
            else if ("International".equalsIgnoreCase(supType)) {
                String updateInterSQL =
                    "UPDATE international SET country=?, importLicenseNum=? WHERE supID=?";
                ps = con.prepareStatement(updateInterSQL);
                ps.setString(1, country);
                ps.setString(2, importLicenseNum);
                ps.setString(3, supID);
                ps.executeUpdate();
            }

            // If Update Successful
            response.sendRedirect("supplier.jsp?status=updated");
            
        } catch (Exception e) {
            e.printStackTrace();
            // If Error Occurred
            response.sendRedirect("updateSupplier.jsp?error=" + e.getMessage() + "&supID=" + supID);
        } finally {
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
	}

}
