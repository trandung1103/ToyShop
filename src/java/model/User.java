package model;

public class User {
    private int id;
    private String username;
    private String password;
    private String role;
    private String displayName;
    
    private Cart cart;
    
    // Constructor, getters, and setters

    public User(){
        this.cart = new Cart();
    }
    
    public User(int id,String username, String password, String role, String displayName) {
        this.id=id;
        this.username = username;
        this.password = password;
        this.role = role;
        this.displayName = displayName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    
    
    
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }
}
