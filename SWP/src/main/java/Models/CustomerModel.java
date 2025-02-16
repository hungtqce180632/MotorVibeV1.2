/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author counh
 */
public class CustomerModel {
    private int customer_id;
    private int user_id;
    private String name;
    private String email;
    private String phone_number;
    private String cus_id_number;
    private String address;
    private boolean status;

    public CustomerModel() {
    }

    public CustomerModel(int customer_id, int user_id, String name, String email, String phone_number, String cus_id_number, String address, boolean status) {
        this.customer_id = customer_id;
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.phone_number = phone_number;
        this.cus_id_number = cus_id_number;
        this.address = address;
        this.status = status;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone_number() {
        return phone_number;
    }

    public void setPhone_number(String phone_number) {
        this.phone_number = phone_number;
    }

    public String getCus_id_number() {
        return cus_id_number;
    }

    public void setCus_id_number(String cus_id_number) {
        this.cus_id_number = cus_id_number;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }
    
    
}
