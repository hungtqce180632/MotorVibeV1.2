/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class ModelsCarModel {
    private int model_id;
    private String model_name;

    public ModelsCarModel() {
    }

    public ModelsCarModel(int model_id, String model_name) {
        this.model_id = model_id;
        this.model_name = model_name;
    }

    public int getModel_id() {
        return model_id;
    }

    public void setModel_id(int model_id) {
        this.model_id = model_id;
    }

    public String getModel_name() {
        return model_name;
    }

    public void setModel_name(String model_name) {
        this.model_name = model_name;
    }

    @Override
    public String toString() {
        return "ModelsCarModel{" + "model_id=" + model_id + ", model_name=" + model_name + '}';
    }
    
    
}
