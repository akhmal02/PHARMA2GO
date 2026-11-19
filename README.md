# 💊 PHARMA2GO — Online Pharmacy & Over-The-Counter (OTC) E-Commerce System

![Platform](https://img.shields.io/badge/Platform-Java%20EE%20Web%20Application%20(JSP%20%2B%20Servlets)-0D47A1?style=for-the-badge&logo=java)
![Database](https://img.shields.io/badge/Database-MySQL%20Relational%20DB%20(JDBC)-00758F?style=for-the-badge&logo=mysql)
![Architecture](https://img.shields.io/badge/Architecture-MVC%20%2B%20DAO%20%2B%20JavaBean-10B981?style=for-the-badge)
![Server](https://img.shields.io/badge/Server-Apache%20Tomcat%2010%2B%20(Jakarta%20EE)-F8DC75?style=for-the-badge&logo=apachetomcat)

**PHARMA2GO** is a full-stack web-based pharmacy e-commerce and inventory management platform built using **Java Servlets, JavaServer Pages (JSP), JavaBeans, Data Access Objects (DAO), JDBC, and MySQL**. It digitalizes the traditional pharmacy experience by allowing customers to browse verified Over-The-Counter (OTC) medications, health supplements, and first-aid products online while equipping pharmacy administrators and employees with real-time stock, supplier, employee, order, and sales analytics management.

---

## 🌟 Key Features

### 1. 🛒 Customer E-Commerce Portal
- **Role-Based Authentication & Session Security (`LoginServlet`, `SignUpServlet`, `LogoutServlet`)**:
  - Unified sign-in portal that automatically detects and routes **Customers** to the online product catalogue (`catalogue.jsp`) and **Employees/Pharmacists** to the administrative dashboard (`dashboard.jsp`).
- **Interactive Medicine & Supplement Catalogue (`index.jsp`, `catalogue.jsp`)**:
  - Browse OTC medicines, vitamins, pain relievers, and first-aid supplies with live stock counts, brand details, product categories, expiry dates, and pricing (`RM`).
- **Dynamic Shopping Cart & Checkout Engine (`CartServlet`, `CartItem`, `CheckoutServlet`)**:
  - Add items to cart, adjust quantities with real-time stock validation, remove items, and complete orders with automatic invoice/receipt generation and stock deduction.
- **Order Tracking & Purchase History (`purchaseHistory.jsp`, `viewOrder.jsp`)**:
  - View historical purchases, order statuses, and printable digital pharmacy receipts.
- **Customer Profile & Password Management (`custProfile.jsp`, `UpdateProfileServlet`, `UpdatePasswordServlet`)**:
  - Manage personal delivery address, phone number, email, and account security credentials.

### 2. 🏥 Pharmacy Staff & Administrative Portal
- **Executive Dashboard (`dashboard.jsp`)**:
  - Real-time overview of total products, active suppliers, customer orders, employee records, and sales performance.
- **Product & Inventory Management (`ProductDAO`, `AddProdServlet`, `UpdateProdServlet`, `DeleteProdServlet`)**:
  - Full CRUD operations for pharmacy inventory including product code, brand, category, description, product image, unit price, expiration date, and available stock levels.
- **Supplier Management — Local & International (`AddSupServlet`, `UpdateSupServlet`, `DeleteSupServlet`)**:
  - Tracks both **Local** (`pharma2go_local`) and **International** (`pharma2go_international`) pharmaceutical suppliers and their product-supplier linkages (`pharma2go_product_supplier`).
- **Employee & Pharmacist Management (`AddEmpServlet`, `UpdateEmpServlet`, `DeleteEmpServlet`)**:
  - Manage pharmacy staff profiles, roles, supervisor assignments, and credentials.
- **Order Fulfillment & Sales Reporting (`order.jsp`, `UpdateOrderServlet`, `sales.jsp`, `printSalesReport.jsp`)**:
  - Update customer order statuses and generate printable revenue and sales reports.

---

## 🛠️ System Architecture & Tech Stack

| Layer | Technology Used |
| :--- | :--- |
| **Backend Logic & Controllers** | Java EE / Jakarta Servlets (`jakarta.servlet.http.HttpServlet`) |
| **Data Access Layer** | JDBC (`com.mysql.jdbc.Driver`) + DAO Pattern (`ProductDAO.java`) + JavaBeans (`Product.java`, `CartItem.java`) |
| **Frontend Presentation** | JSP (`JavaServer Pages`), HTML5, CSS3 (`style.css`), JavaScript |
| **Relational Database** | **MySQL 8.0+** (`jdbc:mysql://localhost:3306/pharma2go`) |
| **Application Server** | **Apache Tomcat 10.x+** |
| **IDE** | Eclipse IDE for Enterprise Java and Web Developers |

---

## 🗄️ MySQL Database Schema (`database/`)

The relational database `pharma2go` consists of **9 normalized tables** located in the [`database/`](database/) folder:

| SQL Script File | Table Name | Description |
| :--- | :--- | :--- |
| `pharma2go_customer.sql` | `customer` | Customer accounts, contact details, delivery addresses & credentials |
| `pharma2go_employee.sql` | `employee` | Pharmacy staff records, roles, contact details & login credentials |
| `pharma2go_product.sql` | `product` | OTC medication catalogue, brand, category, price, expiry date & stock count |
| `pharma2go_supplier.sql` | `supplier` | Master supplier directory & contact information |
| `pharma2go_local.sql` | `local` | Subtype table for domestic Malaysian pharmaceutical suppliers |
| `pharma2go_international.sql` | `international` | Subtype table for international pharmaceutical distributors |
| `pharma2go_product_supplier.sql` | `product_supplier` | Many-to-many associative table linking products and suppliers |
| `pharma2go_receipt.sql` | `receipt` | Customer order headers, payment timestamps, total amounts & statuses |
| `pharma2go_receipt_product.sql` | `receipt_product` | Order line items linking receipts to purchased product quantities |

---

## 📂 Project Directory Structure

```text
PHARMA2GO/
├── database/                                      # Complete MySQL Database Schema & Seed Data
│   ├── pharma2go_customer.sql
│   ├── pharma2go_employee.sql
│   ├── pharma2go_international.sql
│   ├── pharma2go_local.sql
│   ├── pharma2go_product.sql
│   ├── pharma2go_product_supplier.sql
│   ├── pharma2go_receipt.sql
│   ├── pharma2go_receipt_product.sql
│   └── pharma2go_supplier.sql
├── pharma/
│   ├── src/main/
│   │   ├── java/package1/                         # Java Servlets, DAO & JavaBean Models
│   │   │   ├── AddEmpServlet.java
│   │   │   ├── AddProdServlet.java
│   │   │   ├── AddSupServlet.java
│   │   │   ├── CartItem.java
│   │   │   ├── CartServlet.java
│   │   │   ├── CheckoutServlet.java
│   │   │   ├── DeleteEmpServlet.java
│   │   │   ├── DeleteProdServlet.java
│   │   │   ├── DeleteSupServlet.java
│   │   │   ├── LoginServlet.java
│   │   │   ├── LogoutServlet.java
│   │   │   ├── Product.java
│   │   │   ├── ProductDAO.java
│   │   │   ├── Profile2Servlet.java
│   │   │   ├── SignUpServlet.java
│   │   │   ├── UpdateEmpServlet.java
│   │   │   ├── UpdateOrderServlet.java
│   │   │   ├── UpdatePasswordServlet.java
│   │   │   ├── UpdateProdServlet.java
│   │   │   ├── UpdateProfileServlet.java
│   │   │   └── UpdateSupServlet.java
│   │   └── webapp/                                # JSP Views, HTML, CSS & Web Assets
│   │       ├── images/                            # Product & UI Images
│   │       ├── WEB-INF/                           # Deployment Descriptor & MySQL Connector JAR
│   │       ├── aboutus.html
│   │       ├── addEmp.jsp
│   │       ├── addProduct.jsp
│   │       ├── addSupplier.jsp
│   │       ├── cartView.jsp
│   │       ├── catalogue.jsp
│   │       ├── custProfile.jsp
│   │       ├── dashboard.jsp
│   │       ├── employee.jsp
│   │       ├── index.jsp
│   │       ├── login.jsp
│   │       ├── order.jsp
│   │       ├── printSalesReport.jsp
│   │       ├── product.jsp
│   │       ├── profile2.jsp
│   │       ├── purchaseHistory.jsp
│   │       ├── sales.jsp
│   │       ├── signup.jsp
│   │       ├── style.css
│   │       ├── supplier.jsp
│   │       ├── updateEmp.jsp
│   │       ├── updateOrder.jsp
│   │       ├── updateProduct.jsp
│   │       ├── updateSupplier.jsp
│   │       └── viewOrder.jsp
└── README.md
```

---

## 🚀 Getting Started (Installation & Deployment Guide)

### Prerequisites
- **Java Development Kit (JDK 17+)**
- **Eclipse IDE for Enterprise Java and Web Developers**
- **Apache Tomcat 10.x+**
- **MySQL Server 8.0+** & **MySQL Workbench** (or XAMPP / phpMyAdmin)

### Step 1: Clone the Repository
```bash
git clone https://github.com/akhmal02/PHARMA2GO.git
cd PHARMA2GO
```

### Step 2: Set Up the MySQL Database (`pharma2go`)
1. Open **MySQL Workbench** (or phpMyAdmin) and create a new schema named `pharma2go`:
   ```sql
   CREATE DATABASE IF NOT EXISTS pharma2go;
   USE pharma2go;
   ```
2. Import the SQL scripts from the [`database/`](database/) directory in the following order:
   1. `pharma2go_customer.sql`
   2. `pharma2go_employee.sql`
   3. `pharma2go_supplier.sql`
   4. `pharma2go_local.sql`
   5. `pharma2go_international.sql`
   6. `pharma2go_product.sql`
   7. `pharma2go_product_supplier.sql`
   8. `pharma2go_receipt.sql`
   9. `pharma2go_receipt_product.sql`
3. By default, the JDBC connection uses:
   - **URL**: `jdbc:mysql://localhost:3306/pharma2go`
   - **Username**: `root`
   - **Password**: `root`

### Step 3: Run on Apache Tomcat in Eclipse
1. Open **Eclipse IDE** → **File** → **Import** → **Existing Projects into Workspace**.
2. Select the `PHARMA2GO/pharma` folder and click **Finish**.
3. Configure **Apache Tomcat 10.x** in the Eclipse **Servers** tab.
4. Right-click the `pharma` project → **Run As** → **Run on Server**.
5. Access the application in your browser at:
   ```text
   http://localhost:8080/pharma/index.jsp
   ```
