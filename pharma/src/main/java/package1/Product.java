package package1;

public class Product {
	// Initialize Attributes
	private String prodID;
    private String prodName;
    private String prodBrand;
    private String prodDesc;
    private String prodPicture;
    private double prodPrice;
    private String prodCategory;
    private String prodExpDate;
    private int prodStock;
    
    // Default Constructor
    public Product() {}
    
    // Getters
    public String getProdID() { return prodID; }
    public String getProdName() { return prodName; }
    public String getProdBrand() { return prodBrand; }
    public String getProdDesc() { return prodDesc; }
    public String getProdPicture() { return prodPicture; }
    public double getProdPrice() { return prodPrice; }
    public String getProdCategory() { return prodCategory; }
    public String getProdExpDate() { return prodExpDate; }
    public int getProdStock() { return prodStock; }

    // Setters
    public void setProdID(String prodID) { this.prodID = prodID; }
    public void setProdName(String prodName) { this.prodName = prodName; }
    public void setProdBrand(String prodBrand) { this.prodBrand = prodBrand; }
    public void setProdDesc(String prodDesc) { this.prodDesc = prodDesc; }
    public void setProdPicture(String prodPicture) { this.prodPicture = prodPicture; }
    public void setProdPrice(double prodPrice) { this.prodPrice = prodPrice; }
    public void setProdCategory(String prodCategory) { this.prodCategory = prodCategory; }
    public void setProdExpDate(String prodExpDate) { this.prodExpDate = prodExpDate; }
    public void setProdStock(int prodStock) { this.prodStock = prodStock; }
}
