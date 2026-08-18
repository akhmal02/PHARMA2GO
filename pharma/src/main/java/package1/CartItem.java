package package1;

import java.io.Serializable;

public class CartItem implements Serializable {
    
	// Initialize Attributes
	private String id;
    private String name;
    private double price;
    private int quantity;
    private String category;
    private String picture; 

    // Normal Constructor
    public CartItem(String id, String name, double price, int quantity, String category, String picture) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.category = category;
        this.picture = picture;
    }

    // Getter Method
    public String getId() { return id; }
    public String getName() { return name; }
    public double getPrice() { return price; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getCategory() { return category; }
    public String getPicture() { return picture; }    
    public double getTotal() { return price * quantity; }
}