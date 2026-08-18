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
@WebServlet("/Profile2Servlet")
public class Profile2Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Profile2Servlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get Value From profile2.jsp
        String empID = request.getParameter("empID");
        String name = request.getParameter("empName");
        String IC = request.getParameter("empIC");
        String phone = request.getParameter("empPhone");
        String email = request.getParameter("empEmail");
        String address = request.getParameter("empAddress");
        String password = request.getParameter("password");

        try {
        	//Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Update SQL
            String sql = "UPDATE employee SET empName=?, empIC=?, empPhone=?, empEmail=?, empAddress=?, password=? WHERE empID=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, IC);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setString(5, address);
            ps.setString(6, password);
            ps.setString(7, empID);
            
            int rowsAffected = ps.executeUpdate();
            con.close();

            if (rowsAffected > 0) {             
                response.sendRedirect("profile2.jsp?status=profileUpdated");
            } else {
                response.sendRedirect("profile2.jsp?status=error");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("profile2.jsp?status=error");
        }
    }
}