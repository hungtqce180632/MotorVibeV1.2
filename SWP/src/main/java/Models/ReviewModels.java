/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class ReviewModels {

    private int review_id;
    private int customer_id;
    private int car_id;
    private int rating;
    private String review_text;
    private String review_date;
    private boolean review_status;
    private String customer_name;
    
    public ReviewModels() {
    }

    public ReviewModels(int review_id, int customer_id, int car_id, int rating, String review_text, String review_date, boolean review_status, String customer_name) {
        this.review_id = review_id;
        this.customer_id = customer_id;
        this.car_id = car_id;
        this.rating = rating;
        this.review_text = review_text;
        this.review_date = review_date;
        this.review_status = review_status;
        this.customer_name = customer_name;
    }

    
    
    public ReviewModels(int review_id, int customer_id, int car_id, int rating, String review_text, String review_date, boolean review_status) {
        this.review_id = review_id;
        this.customer_id = customer_id;
        this.car_id = car_id;
        this.rating = rating;
        this.review_text = review_text;
        this.review_date = review_date;
        this.review_status = review_status;
    }

    public int getReview_id() {
        return review_id;
    }

    public void setReview_id(int review_id) {
        this.review_id = review_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getCar_id() {
        return car_id;
    }

    public void setCar_id(int car_id) {
        this.car_id = car_id;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getReview_text() {
        return review_text;
    }

    public void setReview_text(String review_text) {
        this.review_text = review_text;
    }

    public String getReview_date() {
        return review_date;
    }

    public void setReview_date(String review_date) {
        this.review_date = review_date;
    }

    public boolean isReview_status() {
        return review_status;
    }

    public void setReview_status(boolean review_status) {
        this.review_status = review_status;
    }

    public String getCustomer_name() {
        return customer_name;
    }

    public void setCustomer_name(String customer_name) {
        this.customer_name = customer_name;
    }

    @Override
    public String toString() {
        return "ReviewModels{" + "review_id=" + review_id + ", customer_id=" + customer_id + ", car_id=" + car_id + ", rating=" + rating + ", review_text=" + review_text + ", review_date=" + review_date + ", review_status=" + review_status + ", customer_name=" + customer_name + '}';
    }     
    
}
