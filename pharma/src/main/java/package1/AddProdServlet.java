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
@WebServlet("/AddProdServlet")

// Handle Picture Format View
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50)

public class AddProdServlet extends HttpServlet {
    private ProductDAO productDAO;
    
    // Implement Product DAO
    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Map Form To Bean
        Product prod = new Product();
        prod.setProdName(request.getParameter("prodName"));
        prod.setProdBrand(request.getParameter("prodBrand"));
        prod.setProdDesc(request.getParameter("prodDesc"));
        prod.setProdPrice(Double.parseDouble(request.getParameter("prodPrice")));
        prod.setProdCategory(request.getParameter("prodCategory"));
        prod.setProdExpDate(request.getParameter("prodExpDate"));
        prod.setProdStock(Integer.parseInt(request.getParameter("prodStock")));

        // Handle File
        Part filePart = request.getPart("prodPicture");
        String fileName = filePart.getSubmittedFileName();
        
        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + fileName);
            prod.setProdPicture("images/" + fileName); 
        }

        // Call ProductDAO
        try {
            if (productDAO.insertProduct(prod)) {
                response.sendRedirect("product.jsp?status=added");
            } else {
                response.sendRedirect("addProduct.jsp?error=failed");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("addProduct.jsp?error=" + e.getMessage());
        }
    }
}