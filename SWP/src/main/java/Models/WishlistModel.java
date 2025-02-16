/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class WishlistModel {
    private int wishlist_id;
    private int customer_id;
    private int car_id;

    public WishlistModel() {
    }

    public WishlistModel(int wishlist_id, int customer_id, int car_id) {
        this.wishlist_id = wishlist_id;
        this.customer_id = customer_id;
        this.car_id = car_id;
    }

    public int getWishlist_id() {
        return wishlist_id;
    }

    public void setWishlist_id(int wishlist_id) {
        this.wishlist_id = wishlist_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getCar_id() {
        return car_id;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    @Override
    public String toString() {
        return "WishlistModel{" + "wishlist_id=" + wishlist_id + ", customer_id=" + customer_id + ", car_id=" + car_id + '}';
    }
        
}
