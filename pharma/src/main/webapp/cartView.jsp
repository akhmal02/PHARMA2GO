<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="package1.CartItem" %> 
<%
	//SECURITY & CACHE CONTROL
	response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
	
    //AUTHENTICATION CHECK
    String name = (String) session.getAttribute("userName");
    if (name == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    //RETRIEVE CART DATA
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
    if (cart == null) cart = new ArrayList<>();
    
    double grandTotal = 0;
    for (CartItem item : cart) {
        grandTotal += item.getTotal();
    }
    
    //FINAL CALCULATIONS (Subtotal + Shipping Fee = RM 7.50)
    double finalAmount = grandTotal + 7.50;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - PHARMA2GO</title>
    <link rel="icon" type="image/x-icon" href="ico/stethoscope.ico">
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" />
    <style>
        .payment-extra {
            margin-top: 10px;
            padding: 10px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
        }
    </style>
</head>
<body>
    <div class="catalogue-page">
        
        <header class="catalogue-header">
            <div class="header-container">
                <div class="brand-section">
                    <svg class="brand-icon" viewBox="0 0 16 16" xmlns="http://www.w3.org/2000/svg">
                        <path d="M1.828 8.9 8.9 1.827a4 4 0 1 1 5.657 5.657l-7.07 7.071A4 4 0 1 1 1.827 8.9Zm9.128.771 2.893-2.893a3 3 0 1 0-4.243-4.242L6.713 5.429z"/>
                    </svg>
                    <span class="brand-name">PHARMA2GO</span>
                </div>
                
                <div class="header-icons">
                    <span class="user-welcome" style="margin-right: 15px; font-weight: 500; color: #1f2937;">
                        Welcome, <%= name %>
                    </span>
                    <button class="icon-btn" onclick="location.href='catalogue.jsp'" title="Home">
                        <span class="material-symbols-outlined">home</span>
                    </button>
                    <button class="icon-btn cart-btn" onclick="location.href='cartView.jsp'" style="border: 2px solid #3b82f6;">
                        <span class="material-symbols-outlined" style="color: #3b82f6;">shopping_cart</span>
                        <span class="cart-badge"><%= cart.size() %></span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='purchaseHistory.jsp'" title="History">
                         <span class="material-symbols-outlined">bucket_check</span>
                    </button>
                    <button class="icon-btn profile-btn" onclick="location.href='custProfile.jsp'" title="My Profile">
                        <span class="material-symbols-outlined">person</span>
                    </button>
                    <form action="LogoutServlet" method="get" style="display: inline;">
                        <button type="submit" class="icon-btn profile-btn" title="Logout">
                            <span class="material-symbols-outlined">logout</span>
                        </button>
                    </form>
                </div>
            </div>
        </header>
		
        <div class="checkout-container">
            <div class="checkout-section">
                <h2 class="section-heading">Shopping Cart (<%= cart.size() %> items)</h2>
                
                <% if (cart.isEmpty()) { %>
                    <div style="text-align: center; padding: 3rem;">
                        <span class="material-symbols-outlined" style="font-size: 48px; color: #cbd5e1;">production_quantity_limits</span>
                        <p style="margin-top: 1rem; color: var(--text-muted);">Your cart is empty.</p>
                        <a href="catalogue.jsp" class="btn-primary" style="display: inline-block; margin-top: 1rem; width: auto; text-decoration: none;">Browse Products</a>
                    </div>
                <% } else { %>
                    <div class="cart-items">
                        <% for (CartItem item : cart) { 
                            String pImg = item.getPicture();
                            String pName = item.getName();
                        %>
                        <div class="cart-item">
                            <div class="product-image-wrapper" style="width:10%; height:100%">
                                <% if (pImg != null && !pImg.trim().isEmpty()) { %>
                                    <img src="images/<%= pImg %>" alt="<%= pName %>" style="height:150%">
                                <% } else { %>
                                    <span class="material-symbols-outlined" style="font-size: 64px; color: #cbd5e1;">medication</span>
                                <% } %>
                            </div>
                            
                            <div class="item-details">
                                <div class="item-name"><%= pName %></div>
                                <div style="font-size: 0.85rem; color: var(--text-muted);"><%= item.getCategory() %></div>
                            </div>

                            <div class="item-controls">
                                <a href="CartServlet?action=decrease&productId=<%= item.getId() %>" class="qty-btn" title="Decrease">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">remove</span>
                                </a>
                                <span class="item-qty"><%= item.getQuantity() %></span>
                                <a href="CartServlet?action=increase&productId=<%= item.getId() %>" class="qty-btn" title="Increase">
                                    <span class="material-symbols-outlined" style="font-size: 16px;">add</span>
                                </a>
                            </div>

                            <div class="item-price">
                                RM <%= String.format("%.2f", item.getTotal()) %>
                            </div>
                            
                            <a href="CartServlet?action=remove&productId=<%= item.getId() %>" style="margin-left: 1rem; color: #ef4444;" title="Remove Item">
                                <span class="material-symbols-outlined" style="font-size: 20px;">delete</span>
                            </a>
                        </div>
                        <% } %>
                    </div>
                <% } %>
            </div>

            <% if (!cart.isEmpty()) { %>
            <div class="order-total-card">
                <h3 class="subsection-heading">Order Summary</h3>
                <div class="total-row">
                    <span class="total-label">Subtotal</span>
                    <span class="total-value">RM <%= String.format("%.2f", grandTotal) %></span>
                </div>
                <div class="total-row">
                    <span class="total-label">Shipping Fee</span>
                    <span class="total-value">RM 7.50</span>
                </div>
                <div class="total-divider"></div>
                <div class="total-row final">
                    <span class="total-label">Total</span>
                    <span class="total-value">RM <%= String.format("%.2f", finalAmount) %></span>
                </div>
                
                <button class="btn-place-order" onclick="openCheckoutModal()">Proceed to Checkout</button>
                <button class="btn-place-order" onclick="location.href='catalogue.jsp'" style="margin-top: 1rem; background-color: #2563eb;">Back to Catalogue</button>
            </div>
            <% } %>
        </div>
    </div>
    <footer class="catalogue-footer" style="margin-top: auto;">
    	<p>&copy; <%= new java.util.Date().getYear() + 1900 %> PHARMA2GO. All rights reserved..</p>
    </footer>
    
    
    <!-- CHECKOUT FORM -->
    <div id="checkoutModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 class="modal-title">Checkout Details</h3>
                <button type="button" class="modal-close" onclick="closeCheckoutModal()">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <p class="modal-desc">Please enter your shipping and payment information.</p>
            
            <form action="CheckoutServlet" method="post">
                <input type="hidden" name="grandTotal" value="<%= String.format("%.2f", finalAmount) %>">

                <div class="modal-form-group">
                    <label>Address</label>
                    <input type="text" name="shipmentAddress" class="form-input" placeholder="No. 123, Jalan ABC..." required>
                </div>
                <div class="modal-form-group">
                    <label>Postcode</label>
                    <input type="text" name="shipmentPostcode" class="form-input" placeholder="50000" pattern="[0-9]{5}" required>
                </div>
                <div class="modal-form-group">
                    <label>State</label>
                    <select name="shipmentState" class="form-input" style="background-color: #e2e8f0;" required>
                        <option value="Selangor">Selangor</option>
                        <option value="Kuala Lumpur">Kuala Lumpur</option>
                        <option value="Kedah">Kedah</option>
                        <option value="Penang">Penang</option>
                        <option value="Johor">Johor</option>
                        <option value="Perak">Perak</option>
                        <option value="Sabah">Sabah</option>
                        <option value="Sarawak">Sarawak</option>
                        <option value="Perlis">Perlis</option>
                        <option value="Kelantan">Kelantan</option>
                        <option value="Pahang">Pahang</option>
                        <option value="Negeri Sembilan">Negeri Sembilan</option>
                    </select>
                </div>
                
                <div class="modal-form-group">
                    <label>Payment Method</label>
                    <select id="payMethodSelect" name="payMethod" class="form-input" style="background-color: #e2e8f0;" onchange="togglePaymentFields()" required>
                        <option value="">-- Select Method --</option>
                        <option value="Credit Card">Credit Card</option>
                        <option value="Debit Card">Debit Card</option>
                        <option value="Online Banking">Online Banking</option>
                        <option value="E-Wallet">E-Wallet</option>
                        <option value="Cash On Delivery">Cash On Delivery</option>
                    </select>
                </div>

				<!-- CREDIT/DEBOT CARD -->
                <div id="cardFields" class="payment-extra" style="display:none;">
                    <div class="modal-form-group">
                        <label>Card Number</label>
                        <input type="text" name="cardNo" class="form-input" placeholder="XXXX-XXXX-XXXX-XXXX" pattern="[0-9 \-]*">
                    </div>
                </div>

				<!-- ONLINE BANKING -->
                <div id="bankingFields" class="payment-extra" style="display:none;">
                    <div class="modal-form-group">
                        <label>Select Bank</label>
                        <select name="bankName" class="form-input">
                            <option value="Maybank2u">Maybank2u</option>
                            <option value="CIMB Octo">CIMB Clicks</option>
                            <option value="Public Bank">Public Bank</option>
                            <option value="RHB Online">RHB Online</option>
                            <option value="Bank Islam">Bank Islam</option>
                        </select>
                    </div>
                    <div class="modal-form-group">
                        <label>Bank Account Number</label>
                        <input type="text" name="bankAccount" class="form-input" placeholder="Enter Account Number">
                    </div>
                </div>

				<!-- EWALLET -->
                <div id="ewalletFields" class="payment-extra" style="display:none;">
                    <div class="modal-form-group">
                        <label>E-Wallet Type</label>
                        <select name="ewalletType" class="form-input">
                            <option value="Touch 'n Go">Touch 'n Go eWallet</option>
                            <option value="GrabPay">GrabPay</option>
                            <option value="Boost">Boost</option>
                            <option value="ShopeePay">ShopeePay</option>
                        </select>
                    </div>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeCheckoutModal()">Cancel</button>
                    <button type="submit" class="btn-add-cart" style="border:none; padding: 0.75rem 1.5rem; cursor: pointer;">Confirm Order</button>
                </div>
            </form>
        </div>
    </div>
	
	<!-- CHECKOUT BEHAVIOUR -->
    <script>
    function openCheckoutModal() {
        document.getElementById('checkoutModal').classList.add('active');
    }

    function closeCheckoutModal() {
        document.getElementById('checkoutModal').classList.remove('active');
    }

    function togglePaymentFields() {
        var method = document.getElementById("payMethodSelect").value;
        var cardDiv = document.getElementById("cardFields");
        var bankDiv = document.getElementById("bankingFields");
        var walletDiv = document.getElementById("ewalletFields");

        cardDiv.style.display = "none";
        bankDiv.style.display = "none";
        walletDiv.style.display = "none";
        
        document.querySelector('input[name="cardNo"]').required = false;
        document.querySelector('input[name="bankAccount"]').required = false;

        if (method === "Credit Card" || method === "Debit Card") {
            cardDiv.style.display = "block";
            document.querySelector('input[name="cardNo"]').required = true;
        } else if (method === "Online Banking") {
            bankDiv.style.display = "block";
            document.querySelector('input[name="bankAccount"]').required = true;
        } else if (method === "E-Wallet") {
            walletDiv.style.display = "block";
        }
    }
</script>
</body>
</html>