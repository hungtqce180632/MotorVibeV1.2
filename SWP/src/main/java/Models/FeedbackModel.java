/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class FeedbackModel {

    private int feedback_id;
    private int order_id;
    private int customer_id;
    private String feedback_content;
    private boolean feedback_status;
    private String date_create;

    public FeedbackModel(int feedback_id, int order_id, int customer_id, String feedback_content, boolean feedback_status, String date_create) {
        this.feedback_id = feedback_id;
        this.order_id = order_id;
        this.customer_id = customer_id;
        this.feedback_content = feedback_content;
        this.feedback_status = feedback_status;
        this.date_create = date_create;
    }

    public FeedbackModel() {
    }

    public String getDate_create() {
        return date_create;
    }

    public void setDate_create(String date_create) {
        this.date_create = date_create;
    }

    public int getFeedback_id() {
        return feedback_id;
    }

    public void setFeedback_id(int feedback_id) {
        this.feedback_id = feedback_id;
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

    public String getFeedback_content() {
        return feedback_content;
    }

    public void setFeedback_content(String feedback_content) {
        this.feedback_content = feedback_content;
    }

    public boolean isFeedback_status() {
        return feedback_status;
    }

    public void setFeedback_status(boolean feedback_status) {
        this.feedback_status = feedback_status;
    }

    @Override
    public String toString() {
        return "FeedbackModel{" + "feedback_id=" + feedback_id + ", order_id=" + order_id + ", customer_id=" + customer_id + ", feedback_content=" + feedback_content + ", feedback_status=" + feedback_status + ", date_create=" + date_create + '}';
    }

}
