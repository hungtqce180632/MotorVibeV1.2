/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class BrandModel {
    private int brand_id;
    private String brand_name;
    private String country_of_origin;
    private String description;

    public BrandModel() {
    }    
    
    public BrandModel(int brand_id, String brand_name, String country_of_origin, String description) {
        this.brand_id = brand_id;
        this.brand_name = brand_name;
        this.country_of_origin = country_of_origin;
        this.description = description;
    }

    public int getBrand_id() {
        return brand_id;
    }

    public void setBrand_id(int brand_id) {
        this.brand_id = brand_id;
    }

    public String getBrand_name() {
        return brand_name;
    }

    public void setBrand_name(String brand_name) {
        this.brand_name = brand_name;
    }

    public String getCountry_of_origin() {
        return country_of_origin;
    }

    public void setCountry_of_origin(String country_of_origin) {
        this.country_of_origin = country_of_origin;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String desciption) {
        this.description = desciption;
    }

    @Override
    public String toString() {
        return "BrandModel{" + "brand_id=" + brand_id + ", brand_name=" + brand_name + ", country_of_origin=" + country_of_origin + ", desciption=" + description + '}';
    }
    
}
