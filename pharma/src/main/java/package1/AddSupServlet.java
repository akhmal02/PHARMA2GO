package package1;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//Force Servlet to run
@WebServlet("/AddSupServlet")
public class AddSupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Get Attributes Value From addEmp.jsp Page
        String supName = request.getParameter("supName");
        String supPhone = request.getParameter("supPhone");
        String supEmail = request.getParameter("supEmail");
        String supAddress = request.getParameter("supAddress");
        String supType = request.getParameter("supType");

        String taxTIN = request.getParameter("taxTIN");
        String country = request.getParameter("country");
        String importLicenseNum = request.getParameter("importLicenseNum");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
        	Class.forName("com.mysql.jdbc.Driver");          
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");

            // Begin Transaction
            con.setAutoCommit(false);

            // Insert Supplier
            String supplierSQL = "INSERT INTO supplier (supName, supPhone, supEmail, supAddress, supType) VALUES (?, ?, ?, ?, ?)";
            ps = con.prepareStatement(supplierSQL, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, supName);
            ps.setString(2, supPhone);
            ps.setString(3, supEmail);
            ps.setString(4, supAddress);
            ps.setString(5, supType);
            ps.executeUpdate();

            // Get Generated supID
            rs = ps.getGeneratedKeys();
            int supID = 0;
            if (rs.next()) supID = rs.getInt(1);

            // Insert Into Child Table
            if ("Local".equalsIgnoreCase(supType)) {
                String localSQL = "INSERT INTO local (supID, taxTIN) VALUES (?, ?)";
                ps = con.prepareStatement(localSQL);
                ps.setInt(1, supID);
                ps.setString(2, taxTIN);
                ps.executeUpdate();
            } else if ("International".equalsIgnoreCase(supType)) {
                String interSQL = "INSERT INTO international (supID, country, importLicenseNum) VALUES (?, ?, ?)";
                ps = con.prepareStatement(interSQL);
                ps.setInt(1, supID);
                ps.setString(2, country);
                ps.setString(3, importLicenseNum);
                ps.executeUpdate();
            }

            // Commit Transaction
            con.commit();

            response.sendRedirect("supplier.jsp?status=added");

        } catch (Exception e) {
            e.printStackTrace();
            // Rollback If Any Exception Occurs
            try { if (con != null) con.rollback(); } catch(Exception ex) {}
            response.sendRedirect("addSupplier.jsp?error=failed");
            
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
    }
}
