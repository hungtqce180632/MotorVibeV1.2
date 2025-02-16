/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.io.InputStream;

/**
 *
 * @author thaii
 */
public class EventModels {

    private int event_id;
    private String event_name;
    private String event_details;
    private InputStream image;
    private String date_start;
    private String date_end;
    private boolean event_status;

    public EventModels() {
    }

    public EventModels(String event_name, String event_details, InputStream image, String date_start, String date_end) {
        this.event_name = event_name;
        this.event_details = event_details;
        this.image = image;
        this.date_start = date_start;
        this.date_end = date_end;
    }

    public EventModels(String event_name, String event_details, InputStream image, String date_start, String date_end, boolean event_status) {
        this.event_name = event_name;
        this.event_details = event_details;
        this.image = image;
        this.date_start = date_start;
        this.date_end = date_end;
        this.event_status = event_status;
    }

    public EventModels(String event_name, String event_details, String date_start, String date_end) {
        this.event_name = event_name;
        this.event_details = event_details;
        this.date_start = date_start;
        this.date_end = date_end;
    }

    public int getEvent_id() {
        return event_id;
    }

    public void setEvent_id(int event_id) {
        this.event_id = event_id;
    }

    public String getEvent_name() {
        return event_name;
    }

    public void setEvent_name(String event_name) {
        this.event_name = event_name;
    }

    public String getEvent_details() {
        return event_details;
    }

    public void setEvent_details(String event_details) {
        this.event_details = event_details;
    }

    public InputStream getImage() {
        return image;
    }

    public void setImage(InputStream image) {
        this.image = image;
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

    public boolean isEvent_status() {
        return event_status;
    }

    public void setEvent_status(boolean event_status) {
        this.event_status = event_status;
    }

    @Override
    public String toString() {
        return "EventModels{" + "event_id=" + event_id + ", event_name=" + event_name + ", event_details=" + event_details + ", image=" + image + ", date_start=" + date_start + ", date_end=" + date_end + ", event_status=" + event_status + '}';
    }
}
