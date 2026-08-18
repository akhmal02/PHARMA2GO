package package1;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//Force Servlet to run
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get Value From Cart Item
    	String action = request.getParameter("action");
        String prodID = request.getParameter("productId");
        
        int quantity = 1;
        try {
            String qtyStr = request.getParameter("quantity");
            if (qtyStr != null && !qtyStr.isEmpty()) {
                quantity = Integer.parseInt(qtyStr);
            }
        } catch (NumberFormatException e) {
            quantity = 1;
        }

        // Get Session
        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        // Check Stock Quantity Available
        if ("add".equals(action)) {
            int currentStock = getStockFromDB(prodID);
            int inCart = getQuantityInCart(cart, prodID);

            if (inCart + quantity > currentStock) {
                sendJSNotification(response, "Only " + currentStock + " units available in stock!", "catalogue.jsp");
            } else {
                addToCartLogic(cart, prodID, quantity);
                session.setAttribute("cart", cart);
                response.sendRedirect("catalogue.jsp?status=added");
            }
        } 
        // Increase Quantity Product
        else if ("increase".equals(action)) {
            int currentStock = getStockFromDB(prodID);
            int inCart = getQuantityInCart(cart, prodID);

            if (inCart + 1 > currentStock) {
                sendJSNotification(response, "Maximum stock reached!", "cartView.jsp");
            } else {
                updateQuantitySimple(cart, prodID, 1);
                session.setAttribute("cart", cart);
                response.sendRedirect("cartView.jsp");
            }
        } 
        // Decrease Quantity Product
        else if ("decrease".equals(action)) {
            updateQuantitySimple(cart, prodID, -1);
            session.setAttribute("cart", cart);
            response.sendRedirect("cartView.jsp");
        } 
        // Remove Product From Cart
        else if ("remove".equals(action)) {
            removeFromCart(cart, prodID);
            session.setAttribute("cart", cart);
            response.sendRedirect("cartView.jsp?status=removed");
        }
    }

    // Check DB Stock
    private int getStockFromDB(String id) {
        int stock = 0;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root")) {
                String sql = "SELECT prodStock FROM product WHERE prodID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) stock = rs.getInt("prodStock");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stock;
    }
    
    // Get Total In Cart
    private int getQuantityInCart(List<CartItem> cart, String id) {
        for (CartItem item : cart) {
            if (item.getId().equals(id)) return item.getQuantity();
        }
        return 0;
    }

    // Add To Cart Logic
    private void addToCartLogic(List<CartItem> cart, String id, int qtyToAdd) {
        for (CartItem item : cart) {
            if (item.getId().equals(id)) {
                item.setQuantity(item.getQuantity() + qtyToAdd);
                return;
            }
        }
        try {
            Class.forName("com.mysql.jdbc.Driver");
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharma2go", "root", "root")) {
                String sql = "SELECT prodName, prodPrice, prodCategory, prodPicture FROM product WHERE prodID = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    cart.add(new CartItem(id, rs.getString("prodName"), rs.getDouble("prodPrice"), qtyToAdd, rs.getString("prodCategory"), rs.getString("prodPicture")));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
    }
    
    // Update Quantity
    private void updateQuantitySimple(List<CartItem> cart, String id, int change) {
        for (int i = 0; i < cart.size(); i++) {
            CartItem item = cart.get(i);
            if (item.getId().equals(id)) {
                int newQty = item.getQuantity() + change;
                if (newQty <= 0) cart.remove(i);
                else item.setQuantity(newQty);
                break;
            }
        }
    }

    // Remove Product From List
    private void removeFromCart(List<CartItem> cart, String id) {
        cart.removeIf(item -> item.getId().equals(id));
    }

    // Notification
    private void sendJSNotification(HttpServletResponse response, String message, String redirectUrl) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<script type='text/javascript'>");
        out.println("alert('" + message + "');");
        out.println("location='" + redirectUrl + "';");
        out.println("</script>");
    }
}