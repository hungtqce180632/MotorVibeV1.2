/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class FuelModel {
    private int fuel_id;
    private String fuel_name;

    public FuelModel() {
    }

    public FuelModel(int fuel_id, String fuel_name) {
        this.fuel_id = fuel_id;
        this.fuel_name = fuel_name;
    }

    public int getFuel_id() {
        return fuel_id;
    }

    public void setFuel_id(int fuel_id) {
        this.fuel_id = fuel_id;
    }

    public String getFuel_name() {
        return fuel_name;
    }

    public void setFuel_name(String fuel_name) {
        this.fuel_name = fuel_name;
    }

    @Override
    public String toString() {
        return "FuelModel{" + "fuel_id=" + fuel_id + ", fuel_name=" + fuel_name + '}';
    }
        
}
