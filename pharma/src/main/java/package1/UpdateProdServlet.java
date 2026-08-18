package package1;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

// Force Servlet to run
@WebServlet("/UpdateProdServlet")

// Handle Image Size
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, 
    maxFileSize = 1024 * 1024 * 10,      
    maxRequestSize = 1024 * 1024 * 50    
)
public class UpdateProdServlet extends HttpServlet {
    private ProductDAO productDAO;

    public void init() {
    	// Create Object DAO
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Create Object Product
        Product prod = new Product();
        
        // Set Attributes In Object Product
        prod.setProdID(request.getParameter("prodID"));
        prod.setProdName(request.getParameter("prodName"));
        prod.setProdBrand(request.getParameter("prodBrand"));
        prod.setProdDesc(request.getParameter("prodDesc"));
        prod.setProdPrice(Double.parseDouble(request.getParameter("prodPrice")));
        prod.setProdCategory(request.getParameter("prodCategory"));
        prod.setProdExpDate(request.getParameter("prodExpDate"));
        prod.setProdStock(Integer.parseInt(request.getParameter("prodStock")));

        // Handle Image
        String existingPicture = request.getParameter("existingPicture");
        Part filePart = request.getPart("prodPicture");
        String fileName = filePart.getSubmittedFileName();

        if (fileName != null && !fileName.isEmpty()) {
            prod.setProdPicture(fileName);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
        } else {
            prod.setProdPicture(existingPicture);
        }

        try {
        	// If Update Successful
            if (productDAO.updateProduct(prod)) {
                response.sendRedirect("product.jsp?status=updated");
            } else {
            	// If Error Occurred
                response.sendRedirect("product.jsp?status=error");
            }
        } catch (SQLException e) {
        	// If Error Occurred
            throw new ServletException(e);
        }
    }
}