package package1;

import java.io.IOException;   
import java.sql.Connection;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Force Servlet To Run
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        String email = request.getParameter("custEmail");
        String pass = request.getParameter("password"); 

        String sqlCust = "SELECT * FROM customer WHERE custEmail = ? AND password = ?";
        String sqlEmp = "SELECT * FROM employee WHERE empEmail = ? AND password = ?";
        
        try {
            // Establish ConnectionDB
            Class.forName("com.mysql.jdbc.Driver"); 
            
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root")) {
                
                // Set Attributes
                try (PreparedStatement ps1 = con.prepareStatement(sqlCust)) {
                    ps1.setString(1, email);
                    ps1.setString(2, pass);
                    ResultSet rs1 = ps1.executeQuery();
                    
                    // Check Attributes Existed In Customer DB
                    if (rs1.next()) {
                        HttpSession session = request.getSession();
                        
                        // Assign or Set Role For Session
                        int id = rs1.getInt("custID");
                        session.setAttribute("custID", id);
                        String customerName = rs1.getString("custName"); 
                        
                        session.setAttribute("custEmail", email);
                        session.setAttribute("userName", customerName);
                        session.setAttribute("role", "customer");
                        
                        // Redirect To The Catalogue Page
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Login Successful! Welcome and Enjoy Shopping!');");
                        out.println("window.location.href='catalogue.jsp';");
                        out.println("</script>");
                        return;
                    }
                }

                // Check Attributes Existed In Customer DB
                try (PreparedStatement ps2 = con.prepareStatement(sqlEmp)) {
                    ps2.setString(1, email);
                    ps2.setString(2, pass);
                    ResultSet rs2 = ps2.executeQuery();
                    
                    if (rs2.next()) {
                        HttpSession session = request.getSession();
                        String employeeName = rs2.getString("empName"); 
                        
                        // Assign or Set Role For Session
                        session.setAttribute("custEmail", email);
                        session.setAttribute("userName", employeeName);
                        session.setAttribute("role", "employee");
                        
                        // Redirect To The Dashboard Page
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Login Successful! Welcome " + employeeName + "');");
                        out.println("window.location.href='dashboard.jsp';");
                        out.println("</script>");
                        return;
                    }
                }

                // If An Error Occurred
                out.println("<script type='text/javascript'>");
                out.println("alert('Invalid Email or Password!');");
                out.println("window.location.href='login.jsp';");
                out.println("</script>");

            }
         // If An Error Occurred
        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "'); window.location.href='login.jsp';</script>");
        } finally {
            out.close();
        }
    }
}