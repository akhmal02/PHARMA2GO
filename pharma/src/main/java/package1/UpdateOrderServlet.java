package package1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

// Force Servlet to run
@WebServlet("/UpdateOrderServlet")
public class UpdateOrderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateOrderServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get Value From updateOrder.jsp
        String receiptID = request.getParameter("receiptID");
        String status = request.getParameter("status");
        String empID = request.getParameter("empID");
        
        try {
        	// Establish Connection DB
        	Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Update SQL Statement
            String sql = "UPDATE receipt SET status=?, empID=? WHERE receiptID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, empID);
            ps.setString(3, receiptID);
            
            ps.executeUpdate();
            con.close();
            
            // If Successful Update 
            response.sendRedirect("order.jsp?status=updated");
            
        } catch (Exception e) {
        	// If Error Occurred 
            e.printStackTrace();
            response.sendRedirect("updateOrder.jsp?status=error");
        }
	}
}
