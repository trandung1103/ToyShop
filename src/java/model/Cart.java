package model;

import dal.CartDAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;

public class Cart {
    private ArrayList<CartItem> items;

    public Cart() {
        items = new ArrayList<>();
    }

    public ArrayList<CartItem> getItems() {
        return items;
    }

    public void addItem(CartItem item, Connection connection, User user) throws SQLException {
        items.add(item);
        CartDAO cartDAO = new CartDAO();
        cartDAO.addToCart(user, item); // Gọi phương thức để thêm sản phẩm vào CSDL
    }

    public void removeItem(CartItem item) {
        items.remove(item);
    }

    public double getTotalPrice() {
        double total = 0;
        for (CartItem item : items) {
            total += item.getProduct().getProduct_price() * item.getQuantity();
        }
        return total;
    }

    public void updateItemQuantity(Product product, int quantity) {
        for (CartItem item : items) {
            if (item.getProduct().getProduct_id()==product.getProduct_id()) {
                item.setQuantity(quantity);
                break;
            }
        }
    }
    public void clearCart(User user) throws SQLException {
        items.clear();
        CartDAO cartDAO = new CartDAO();
        cartDAO.clearCart(user);
    }
}
