package model;

public class Product {

    private int product_id;
    private String product_name;
    private double product_price;
    private int product_quantity;
    private String product_description;
    private String categoryID;
    private String image_url;
    private int sold_quantity;

    // Constructor
    public Product() {

    }

    public Product(int product_id, String product_name, double product_price, int product_quantity, String product_description, String categoryID, String image_url) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.product_price = product_price;
        this.product_quantity = product_quantity;
        this.product_description = product_description;
        this.categoryID = categoryID;
        this.image_url = image_url;
    }

    public Product(int product_id, String product_name, double product_price, int product_quantity, String product_description, String categoryID, String image_url, int sold_quantity) {
        this.product_id = product_id;
        this.product_name = product_name;
        this.product_price = product_price;
        this.product_quantity = product_quantity;
        this.product_description = product_description;
        this.categoryID = categoryID;
        this.image_url = image_url;
        this.sold_quantity = sold_quantity;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public String getProduct_name() {
        return product_name;
    }

    public void setProduct_name(String product_name) {
        this.product_name = product_name;
    }

    public double getProduct_price() {
        return product_price;
    }

    public void setProduct_price(double product_price) {
        this.product_price = product_price;
    }

    public int getProduct_quantity() {
        return product_quantity;
    }

    public void setProduct_quantity(int product_quantity) {
        this.product_quantity = product_quantity;
    }

    public String getProduct_description() {
        return product_description;
    }

    public void setProduct_description(String product_description) {
        this.product_description = product_description;
    }

    public String getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(String categoryID) {
        this.categoryID = categoryID;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public int getSold_quantity() {
        return sold_quantity;
    }

    public void setSold_quantity(int sold_quantity) {
        this.sold_quantity = sold_quantity;
    }

}
