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

//Force Servlet to run
@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // 1. Capture Form Data
        String name = request.getParameter("custName");
        String email = request.getParameter("custEmail");
        String address = request.getParameter("custAddress");
        String phone = request.getParameter("custPhone");
        String postcode = request.getParameter("custPostcode");
        String state = request.getParameter("custState");
        String password = request.getParameter("password");

        try {
            // Establish Connection DB
            Class.forName("com.mysql.jdbc.Driver");
            
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root")) {
                
                // Check Email Existed Or Not
                String checkEmailSql = "SELECT custEmail FROM customer WHERE custEmail = ?";
                try (PreparedStatement checkPs = con.prepareStatement(checkEmailSql)) {
                    checkPs.setString(1, email);
                    ResultSet rs = checkPs.executeQuery();

                    if (rs.next()) {
                        // Email Is Found In The Database
                        out.println("<script type='text/javascript'>");
                        out.println("alert('Error! Email " + email + " is already registered.');");
                        out.println("history.back();"); 
                        out.println("</script>");
                    } else {
                        // Insert Into DB Customer Record
                        String insertSql = "INSERT INTO customer (custEmail, custName, custAddress, custPhone, custPostcode, custState, password) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                            insertPs.setString(1, email);
                            insertPs.setString(2, name);
                            insertPs.setString(3, address);
                            insertPs.setString(4, phone);
                            insertPs.setString(5, postcode);
                            insertPs.setString(6, state);
                            insertPs.setString(7, password);

                            int rowCount = insertPs.executeUpdate();
                            if (rowCount > 0) {
                                out.println("<script type='text/javascript'>");
                                out.println("alert('Success! Your account has been created.');");
                                out.println("location='login.jsp';"); // Redirect to login
                                out.println("</script>");
                            }
                        }
                    }
                }
            }
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