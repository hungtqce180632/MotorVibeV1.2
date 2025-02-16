/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.math.BigDecimal;

/**
 *
 * @author thaii
 */
public class CarModel {

    private int car_id;
    private int brand_id;
    private int model_id;
    private String car_name;
    private String date_start;
    private String color;
    private BigDecimal price;
    private int fuel_id;
    private boolean status;
    private String description;
    private int quantity;

    public CarModel() {
    }

    public CarModel(int car_id, int brand_id, int model_id, String car_name, String date_start, String color, BigDecimal price, int fuel_id, boolean status, String description) {
        this.car_id = car_id;
        this.brand_id = brand_id;
        this.model_id = model_id;
        this.car_name = car_name;
        this.date_start = date_start;
        this.color = color;
        this.price = price;
        this.fuel_id = fuel_id;
        this.status = status;
        this.description = description;
    }

    public CarModel(int brand_id, int model_id, String car_name, String date_start, String color, BigDecimal price, int fuel_id, boolean status, String description) {
        this.brand_id = brand_id;
        this.model_id = model_id;
        this.car_name = car_name;
        this.date_start = date_start;
        this.color = color;
        this.price = price;
        this.fuel_id = fuel_id;
        this.status = status;
        this.description = description;
    }

    public CarModel(int car_id, int brand_id, int model_id, String car_name, String date_start, String color, BigDecimal price, int fuel_id, boolean status, String description, int quantity) {
        this.car_id = car_id;
        this.brand_id = brand_id;
        this.model_id = model_id;
        this.car_name = car_name;
        this.date_start = date_start;
        this.color = color;
        this.price = price;
        this.fuel_id = fuel_id;
        this.status = status;
        this.description = description;
        this.quantity = quantity;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
            
    public int getCar_id() {
        return car_id;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    public int getBrand_id() {
        return brand_id;
    }

    public void setBrand_id(int brand_id) {
        this.brand_id = brand_id;
    }

    public int getModel_id() {
        return model_id;
    }

    public void setModel_id(int model_id) {
        this.model_id = model_id;
    }

    public String getCar_name() {
        return car_name;
    }

    public void setCar_name(String car_name) {
        this.car_name = car_name;
    }

    public String getDate_start() {
        return date_start;
    }

    public void setDate_start(String date_start) {
        this.date_start = date_start;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getFuel_id() {
        return fuel_id;
    }

    public void setFuel_id(int fuel_id) {
        this.fuel_id = fuel_id;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "CarModel{" + "car_id=" + car_id + ", brand_id=" + brand_id + ", model_id=" + model_id + ", car_name=" + car_name + ", date_start=" + date_start + ", color=" + color + ", price=" + price + ", fuel_id=" + fuel_id + ", status=" + status + ", description=" + description + '}';
    }

}
