/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.sql.Date;

/**
 *
 * @author tiend
 */
public class Motorbike {
    private int motorbikeId;
    private int brandId;
    private int modelId;
    private String name;
    private Date dateStart;
    private String color;
    private double price;
    private int fuelId;
    private boolean status;
    private String description;

    public Motorbike() {
    }

    public Motorbike(int motorbikeId, int brandId, int modelId, String name, Date dateStart, String color, double price, int fuelId, boolean status, String description) {
        this.motorbikeId = motorbikeId;
        this.brandId = brandId;
        this.modelId = modelId;
        this.name = name;
        this.dateStart = dateStart;
        this.color = color;
        this.price = price;
        this.fuelId = fuelId;
        this.status = status;
        this.description = description;
    }

    public int getMotorbikeId() {
        return motorbikeId;
    }

    public void setMotorbikeId(int motorbikeId) {
        this.motorbikeId = motorbikeId;
    }

    public int getBrandId() {
        return brandId;
    }

    public void setBrandId(int brandId) {
        this.brandId = brandId;
    }

    public int getModelId() {
        return modelId;
    }

    public void setModelId(int modelId) {
        this.modelId = modelId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDateStart() {
        return dateStart;
    }

    public void setDateStart(Date dateStart) {
        this.dateStart = dateStart;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getFuelId() {
        return fuelId;
    }

    public void setFuelId(int fuelId) {
        this.fuelId = fuelId;
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
    
}
