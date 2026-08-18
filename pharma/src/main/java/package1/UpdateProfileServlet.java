package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Force Servlet To Run
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        // Get Current Session
        HttpSession session = request.getSession(false);
        String sessionEmail = (session != null) ? (String) session.getAttribute("custEmail") : null;
        
        if (sessionEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get Value Attributed
        String custName = request.getParameter("custName");
        String custPhone = request.getParameter("custPhone");
        String custEmail = request.getParameter("custEmail");
        String custAddress = request.getParameter("custAddress");
        String custPostcode = request.getParameter("custPostcode");
        String custState = request.getParameter("custState");


        try {
        	// Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver"); 
            String url = "jdbc:mysql://localhost:3306/pharma2go?useSSL=false&allowPublicKeyRetrieval=true";
            
            try (Connection con = DriverManager.getConnection(url, "root", "root")) {
                String sql = "UPDATE customer SET custName=?, custPhone=?, custEmail=?, custAddress=?, custPostcode=?, custState=? WHERE custEmail=?";
                
                // Set Update Attributes
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, custName);
                    ps.setString(2, custPhone);
                    ps.setString(3, custEmail);
                    ps.setString(4, custAddress);
                    ps.setString(5, custPostcode);
                    ps.setString(6, custState);
                    ps.setString(7, sessionEmail); 

                    int rowCount = ps.executeUpdate();

                    if (rowCount > 0) {
                    	// Set Updated Session
                        session.setAttribute("userName", custName);
                        session.setAttribute("custEmail", custEmail); 
                        
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Profile updated successfully!');");
                        out.println("location='custProfile.jsp';");
                        out.println("</script>");
                    } else {
                    	// If An Error Occurred
                        out.println("<script>alert('Update failed. No record found.'); location='custProfile.jsp';</script>");
                    }
                }
            }
          // If An Error Occurred
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('Error: " + e.getMessage().replace("'", "\\'") + "'); location='custProfile.jsp';</script>");
        }
    }
}