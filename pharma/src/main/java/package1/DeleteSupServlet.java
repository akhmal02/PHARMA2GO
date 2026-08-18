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

//Force Servlet to run
@WebServlet("/DeleteSupServlet")
public class DeleteSupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;   

    public DeleteSupServlet() {
        super();    
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get ID Value From supplier.jsp
		String supID = request.getParameter("supID");

        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Delete Supplier Record
            String sql = "DELETE FROM supplier WHERE supID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, supID);
            
            ps.executeUpdate();
            con.close();

            response.sendRedirect("supplier.jsp?status=deleted");
            
        } catch (Exception e) {
        	response.sendRedirect("supplier.jsp?status=error");
        }
	}
}
