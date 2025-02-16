/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author counh
 */
public class CarStaticModel {
    private String car_name;
    private String revenue_date;

    public CarStaticModel() {
    }

    public CarStaticModel(String car_name, String revenue_date) {
        this.car_name = car_name;
        this.revenue_date = revenue_date;
    }

    public String getCar_name() {
        return car_name;
    }

    public void setCar_name(String car_name) {
        this.car_name = car_name;
    }

    public String getRevenue_date() {
        return revenue_date;
    }

    public void setRevenue_date(String revenue_date) {
        this.revenue_date = revenue_date;
    }
    
    
}
