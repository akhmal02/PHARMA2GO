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
@WebServlet("/DeleteEmpServlet")
public class DeleteEmpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public DeleteEmpServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get ID Value From employee.jsp
		String empID = request.getParameter("empID");

        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            String sql = "DELETE FROM employee WHERE empID = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, empID);
            
            ps.executeUpdate();
            con.close();

            response.sendRedirect("employee.jsp?status=deleted");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("employee.jsp?status=error");
        }
	}

}
