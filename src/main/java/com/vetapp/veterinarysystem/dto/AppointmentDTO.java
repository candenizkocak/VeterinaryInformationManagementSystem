package com.vetapp.veterinarysystem.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class AppointmentDTO {
    private Long appointmentId;
    private String appointmentDate;
    private String status;
    private String petName;
    private String clientName;
    private String veterinaryName;
    private String clinicName;

    public AppointmentDTO() {}

    public AppointmentDTO(Long appointmentId, LocalDateTime appointmentDate, String status, String petName, String clientName, String veterinaryName, String clinicName) {
        this.appointmentId = appointmentId;
        this.appointmentDate = appointmentDate.format(DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm"));
        this.status = status;
        this.petName = petName;
        this.clientName = clientName;
        this.veterinaryName = veterinaryName;
        this.clinicName = clinicName;
    }

    public Long getAppointmentId() {
        return appointmentId;
    }

    public void setAppointmentId(Long appointmentId) {
        this.appointmentId = appointmentId;
    }

    public String getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(String appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPetName() {
        return petName;
    }

    public void setPetName(String petName) {
        this.petName = petName;
    }

    public String getClientName() {
        return clientName;
    }

    public void setClientName(String clientName) {
        this.clientName = clientName;
    }

    public String getVeterinaryName() {
        return veterinaryName;
    }

    public void setVeterinaryName(String veterinaryName) {
        this.veterinaryName = veterinaryName;
    }

    public String getClinicName() {
        return clinicName;
    }

    public void setClinicName(String clinicName) {
        this.clinicName = clinicName;
    }
}
