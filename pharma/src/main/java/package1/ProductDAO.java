package package1;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	// Establish Connection DB
    private String jdbcURL = "jdbc:mysql://localhost:3306/pharma2go";
    private String jdbcUsername = "root";
    private String jdbcPassword = "root";

    protected Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return connection;
    }

    // Insert New Product
    public boolean insertProduct(Product product) throws SQLException {
        String sql = "INSERT INTO product (prodID, prodName, prodBrand, prodDesc, prodPicture, prodPrice, prodCategory, prodExpDate, prodStock) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProdID());
            ps.setString(2, product.getProdName());
            ps.setString(3, product.getProdBrand());
            ps.setString(4, product.getProdDesc());
            ps.setString(5, product.getProdPicture());
            ps.setDouble(6, product.getProdPrice());
            ps.setString(7, product.getProdCategory());
            ps.setString(8, product.getProdExpDate());
            ps.setInt(9, product.getProdStock());
            
            return ps.executeUpdate() > 0;
        }
    }

    // Get Product By ID
    public Product getProductByID(String prodID) {
        Product product = null;
        String sql = "SELECT * FROM product WHERE prodID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prodID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                product = new Product();
                product.setProdID(rs.getString("prodID"));
                product.setProdName(rs.getString("prodName"));
                product.setProdBrand(rs.getString("prodBrand"));
                product.setProdDesc(rs.getString("prodDesc"));
                product.setProdPicture(rs.getString("prodPicture"));
                product.setProdPrice(rs.getDouble("prodPrice"));
                product.setProdCategory(rs.getString("prodCategory"));
                product.setProdExpDate(rs.getString("prodExpDate"));
                product.setProdStock(rs.getInt("prodStock"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return product;
    }

    // Update Existing Product
    public boolean updateProduct(Product product) throws SQLException {
        String sql = "UPDATE product SET prodName=?, prodBrand=?, prodDesc=?, prodPicture=?, prodPrice=?, prodCategory=?, prodExpDate=?, prodStock=? WHERE prodID=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getProdName());
            ps.setString(2, product.getProdBrand());
            ps.setString(3, product.getProdDesc());
            ps.setString(4, product.getProdPicture());
            ps.setDouble(5, product.getProdPrice());
            ps.setString(6, product.getProdCategory());
            ps.setString(7, product.getProdExpDate());
            ps.setInt(8, product.getProdStock());
            ps.setString(9, product.getProdID());

            return ps.executeUpdate() > 0;
        }
    }
}