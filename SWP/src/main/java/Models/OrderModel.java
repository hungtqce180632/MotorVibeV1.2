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
public class OrderModel {

    private int order_id;
    private int customer_id;
    private int employee_id;
    private int car_id;
    private String create_date;
    private String payment_method;
    private BigDecimal total_amount;
    private boolean deposit_status;
    private boolean order_status;
    private String date_start;
    private String date_end;
    private boolean has_warranty;
    private int warranty_id;

    public OrderModel() {
    }

    public OrderModel(int order_id, int customer_id, int employee_id, int car_id, String create_date, String payment_method, BigDecimal total_amount, boolean deposit_status, boolean order_status, String date_start, String date_end, boolean has_warranty, int warranty_id) {
        this.order_id = order_id;
        this.customer_id = customer_id;
        this.employee_id = employee_id;
        this.car_id = car_id;
        this.create_date = create_date;
        this.payment_method = payment_method;
        this.total_amount = total_amount;
        this.deposit_status = deposit_status;
        this.order_status = order_status;
        this.date_start = date_start;
        this.date_end = date_end;
        this.has_warranty = has_warranty;
        this.warranty_id = warranty_id;
    }

    public OrderModel(int order_id, int customer_id, int employee_id, int car_id, String create_date, String payment_method, BigDecimal total_amount, boolean deposit_status, boolean order_status, String date_start, String date_end) {
        this.order_id = order_id;
        this.customer_id = customer_id;
        this.employee_id = employee_id;
        this.car_id = car_id;
        this.create_date = create_date;
        this.payment_method = payment_method;
        this.total_amount = total_amount;
        this.deposit_status = deposit_status;
        this.order_status = order_status;
        this.date_start = date_start;
        this.date_end = date_end;
    }

    public int getOrder_id() {
        return order_id;
    }

    public void setOrder_id(int order_id) {
        this.order_id = order_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getEmployee_id() {
        return employee_id;
    }

    public void setEmployee_id(int employee_id) {
        this.employee_id = employee_id;
    }

    public int getCar_id() {
        return car_id;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    public String getCreate_date() {
        return create_date;
    }

    public void setCreate_date(String create_date) {
        this.create_date = create_date;
    }

    public String getPayment_method() {
        return payment_method;
    }

    public void setPayment_method(String payment_method) {
        this.payment_method = payment_method;
    }

    public BigDecimal getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(BigDecimal total_amount) {
        this.total_amount = total_amount;
    }

    public boolean isDeposit_status() {
        return deposit_status;
    }

    public void setDeposit_status(boolean deposit_status) {
        this.deposit_status = deposit_status;
    }

    public boolean isOrder_status() {
        return order_status;
    }

    public void setOrder_status(boolean order_status) {
        this.order_status = order_status;
    }

    public String getDate_start() {
        return date_start;
    }

    public void setDate_start(String date_start) {
        this.date_start = date_start;
    }

    public String getDate_end() {
        return date_end;
    }

    public void setDate_end(String date_end) {
        this.date_end = date_end;
    }

    public boolean isHas_warranty() {
        return has_warranty;
    }

    public void setHas_warranty(boolean has_warranty) {
        this.has_warranty = has_warranty;
    }

    public int getWarranty_id() {
        return warranty_id;
    }

    public void setWarranty_id(int warranty_id) {
        this.warranty_id = warranty_id;
    }

    @Override
    public String toString() {
        return "OrderModel{" + "order_id=" + order_id + ", customer_id=" + customer_id + ", employee_id=" + employee_id + ", car_id=" + car_id + ", create_date=" + create_date + ", payment_method=" + payment_method + ", total_amount=" + total_amount + ", deposit_status=" + deposit_status + ", order_status=" + order_status + ", date_start=" + date_start + ", date_end=" + date_end + '}';
    }

}
