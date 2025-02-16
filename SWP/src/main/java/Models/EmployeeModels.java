package Models;

/**
 * EmployeeModel - Represents an employee entity. Author: counh
 */
public class EmployeeModels {

    private int employeeId;
    private int userId;
    private String name;
    private String email;
    private String phoneNumber;
    private boolean status;

    public EmployeeModels() {
    }

    public EmployeeModels(int employeeId, int userId, String name, String email, String phoneNumber, boolean status) {
        this.employeeId = employeeId;
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.status = status;
    }

    public int getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(int employeeId) {
        this.employeeId = employeeId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
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

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

}
