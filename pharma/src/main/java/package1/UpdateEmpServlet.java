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
@WebServlet("/UpdateEmpServlet")
public class UpdateEmpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public UpdateEmpServlet() {
        super();
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Get Value From employee.jsp
		String empID = request.getParameter("empID");
        String name = request.getParameter("empName");
        String IC = request.getParameter("empIC");
        String phone = request.getParameter("empPhone");
        String email = request.getParameter("empEmail");
        String address = request.getParameter("empAddress");
        String supervisorID = request.getParameter("supervisorID");

        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Update SQL Record
            String sql = "UPDATE employee SET empName=?, empIC=?, empPhone=?, empEmail=?, empAddress=?, supervisorID=? WHERE empID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, IC);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setString(5, address);
            ps.setString(6, (supervisorID == null || supervisorID.trim().isEmpty()) ? null : supervisorID);
            ps.setString(7, empID);
            
            ps.executeUpdate();
            con.close();
            
            // If Successful Update 
            response.sendRedirect("employee.jsp?status=updated");
            
        } catch (Exception e) {
            e.printStackTrace();
            // If Error Occurred
            response.sendRedirect("employee.jsp?status=error");
        }
	}

}
