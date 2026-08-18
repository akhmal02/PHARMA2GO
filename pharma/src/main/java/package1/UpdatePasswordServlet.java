package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Force Servlet to run
@WebServlet("/UpdatePasswordServlet")
public class UpdatePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Get Session 
        HttpSession session = request.getSession(false);
        String sessionEmail = (session != null) ? (String) session.getAttribute("custEmail") : null;
        
        if (sessionEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get Value From custProfile.jsp
        String oldPass = request.getParameter("oldPass");
        String newPass = request.getParameter("newPass");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root");
            
            // Verify Old Password
            String checkSql = "SELECT password FROM customer WHERE custEmail = ?";
            PreparedStatement checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, sessionEmail);
            ResultSet rs = checkPs.executeQuery();

            boolean passwordCorrect = false;
            if (rs.next()) {
                String currentDbPass = rs.getString("password");
                if (currentDbPass.equals(oldPass)) {
                    passwordCorrect = true;
                }
            }

            // Update Password If Verification Passed
            if (passwordCorrect) {
                String updateSql = "UPDATE customer SET password = ? WHERE custEmail = ?";
                PreparedStatement updatePs = con.prepareStatement(updateSql);
                updatePs.setString(1, newPass);
                updatePs.setString(2, sessionEmail);
                updatePs.executeUpdate();
                
                // If Successful Update 
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Password changed successfully!');");
                out.println("location='custProfile.jsp';");
                out.println("</script>");
            } else {
            	// If Password Doesn't Match
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Error: Old password does not match.');");
                out.println("location='custProfile.jsp';");
                out.println("</script>");
            }
            con.close();

        } catch (Exception e) {
        	// If Error Occurred 
            e.printStackTrace();
            out.println("<script>alert('Error: " + e.getMessage() + "'); location='custProfile.jsp';</script>");
        }
    }
}