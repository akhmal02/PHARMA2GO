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

//Force Servlet to run
@WebServlet("/DeleteProdServlet")
public class DeleteProdServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DeleteProdServlet() {
        super();
       
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get ID Value From product.jsp
		String prodID = request.getParameter("prodID");

        try {
        	// Establish Connection DB 
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Remove Product Record
            String sql = "DELETE FROM product WHERE prodID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, prodID);
            
            ps.executeUpdate();
            con.close();

            response.sendRedirect("product.jsp?status=deleted");
            
        } catch (Exception e) {
        	response.sendRedirect("product.jsp?status=error");
        }
	}

}
