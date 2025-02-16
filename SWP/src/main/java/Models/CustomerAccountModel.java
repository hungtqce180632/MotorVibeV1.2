/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class CustomerAccountModel {

    private int customer_id;
    private int user_id;
    private String name;
    private String email;
    private String picture;
    private String phone_number;
    private String cus_id_number;
    private String address;
    private String preferred_contact_method;

    public CustomerAccountModel() {
    }

    public CustomerAccountModel(int customer_id, int user_id, String name, String email, String picture) {
        this.customer_id = customer_id;
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.picture = picture;
    }

    public CustomerAccountModel(int customer_id, int user_id, String name, String email, String picture, String phone_number, String cus_id_number, String address, String preferred_contact_method) {
        this.customer_id = customer_id;
        this.user_id = user_id;
        this.name = name;
        this.email = email;
        this.picture = picture;
        this.phone_number = phone_number;
        this.cus_id_number = cus_id_number;
        this.address = address;
        this.preferred_contact_method = preferred_contact_method;
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

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
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

    public String getPreferred_contact_method() {
        return preferred_contact_method;
    }

    public void setPreferred_contact_method(String preferred_contact_method) {
        this.preferred_contact_method = preferred_contact_method;
    }

    @Override
    public String toString() {
        return "CustomerAccountModel{" + "customer_id=" + customer_id + ", user_id=" + user_id + ", name=" + name + ", email=" + email + ", picture=" + picture + ", phone_number=" + phone_number + ", cus_id_number=" + cus_id_number + ", address=" + address + ", preferred_contact_method=" + preferred_contact_method + '}';
    }

}
