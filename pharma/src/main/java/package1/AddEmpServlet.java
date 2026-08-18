package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


// Force Servlet to run
@WebServlet("/AddEmpServlet")
public class AddEmpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Get Attributes Value From addEmp.jsp Page
        String empIC = request.getParameter("empIC");
        String empName = request.getParameter("empName");
        String empPhone = request.getParameter("empPhone");
        String empEmail = request.getParameter("empEmail");
        String empHireDate = request.getParameter("empHireDate");
        String empAddress = request.getParameter("empAddress");
        String supervisorID = request.getParameter("supervisorID");
        String password = request.getParameter("password");

        try {
        	//Establish PHARMA2GO DB Connection
            Class.forName("com.mysql.jdbc.Driver");          
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root")) {
                
            	//Check If Email Already Existed In DB Or Not Yet (Avoid Duplicate Email)
                String checkEmailSql = "SELECT empEmail FROM employee WHERE empEmail = ?";
                try (PreparedStatement checkPs = con.prepareStatement(checkEmailSql)) {
                    checkPs.setString(1, empEmail);
                    ResultSet rs = checkPs.executeQuery();

                    if (rs.next()) {
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Error! Email " + empEmail + " is already registered.');");
                        out.println("history.back();");
                        out.println("</script>");
                    } else {
                    	
                    	// Add New Emp Records
                        String insertSql = "INSERT INTO employee (empIC, empName, empPhone, empEmail, empHireDate, empAddress, supervisorID, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                            insertPs.setString(1, empIC);
                            insertPs.setString(2, empName);
                            insertPs.setString(3, empPhone);
                            insertPs.setString(4, empEmail);
                            insertPs.setString(5, empHireDate);
                            insertPs.setString(6, empAddress);
                            
                            // Handle Value If Supervisor Is Not Selected = Null
                            if (supervisorID == null || supervisorID.trim().isEmpty()) {
                                insertPs.setNull(7, Types.VARCHAR);
                            } else {
                                insertPs.setString(7, supervisorID);
                            }

                            insertPs.setString(8, password);

                            int rowCount = insertPs.executeUpdate();
                            
                            // Display Message If Success 
                            if (rowCount > 0) {
                                out.println("<script type='text/javascript'>");
                                out.println("alert('Success! Employee has been added.');");
                                out.println("location='employee.jsp';");
                                out.println("</script>");
                            }
                        }
                    }
                }
            }
         // Display Message If Not Success 
        } catch (Exception e) {
            out.println("<script type='text/javascript'>");
            out.println("alert('System Error: " + e.getMessage().replace("'", "\\'") + "');");
            out.println("history.back();");
            out.println("</script>");
            e.printStackTrace();
        } finally {
            out.close();
        }
    }
}