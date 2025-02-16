/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author thaii
 */
public class AppointmentModel {

    private int appointment_id;
    private int customer_id;
    private int employee_id;
    private String date_start;
    private String date_end;
    private String note;
    private Boolean appointment_status;

    public AppointmentModel() {
    }

    public AppointmentModel(int appointment_id, int customer_id, int employee_id, String date_start, String date_end, String note, Boolean appointment_status) {
        this.appointment_id = appointment_id;
        this.customer_id = customer_id;
        this.employee_id = employee_id;
        this.date_start = date_start;
        this.date_end = date_end;
        this.note = note;
        this.appointment_status = appointment_status;
    }

    public int getAppointment_id() {
        return appointment_id;
    }

    public void setAppointment_id(int appointment_id) {
        this.appointment_id = appointment_id;
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

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Boolean getAppointment_status() {
        return appointment_status;
    }

    public void setAppointment_status(Boolean appointment_status) {
        this.appointment_status = appointment_status;
    }

    @Override
    public String toString() {
        return "AppointmentModel{" + "appointment_id=" + appointment_id + ", customer_id=" + customer_id + ", employee_id=" + employee_id + ", date_start=" + date_start + ", date_end=" + date_end + ", note=" + note + ", appointment_status=" + appointment_status + '}';
    }

}
