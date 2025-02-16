/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class InventoryModel {
    private int inventory_id;
    private int car_id;
    private int quantity;

    public InventoryModel() {
    }

    public InventoryModel(int car_id, int quantity) {
        this.car_id = car_id;
        this.quantity = quantity;        
    }

    public int getInventory_id() {
        return inventory_id;
    }

    public void setInventory_id(int inventory_id) {
        this.inventory_id = inventory_id;
    }

    public int getCar_id() {
        return car_id;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "InventoryModel{" + "inventory_id=" + inventory_id + ", car_id=" + car_id + ", quantity=" + quantity + '}';
    }
        
}
