/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class WarrantyModel {

    private int warranty_id;
    private int order_id;
    private String warranty_details;
    private String warranty_expiry;

    public WarrantyModel() {
    }

    public WarrantyModel(int warranty_id, int order_id, String warranty_details, String warranty_expiry) {
        this.warranty_id = warranty_id;
        this.order_id = order_id;
        this.warranty_details = warranty_details;
        this.warranty_expiry = warranty_expiry;
    }

    public int getWarranty_id() {
        return warranty_id;
    }

    public void setWarranty_id(int warranty_id) {
        this.warranty_id = warranty_id;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public String getWarranty_details() {
        return warranty_details;
    }

    public void setWarranty_details(String warranty_details) {
        this.warranty_details = warranty_details;
    }

    public String getWarranty_expiry() {
        return warranty_expiry;
    }

    public void setWarranty_expiry(String warranty_expiry) {
        this.warranty_expiry = warranty_expiry;
    }

    @Override
    public String toString() {
        return "WarrantyModel{" + "warranty_id=" + warranty_id + ", order_id=" + order_id + ", warranty_details=" + warranty_details + ", warranty_expiry=" + warranty_expiry + '}';
    }

}
