package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Appointment;

import java.util.List;

public interface AppointmentService {
    Appointment createAppointment(Appointment appointment);
    Appointment updateAppointment(Long id, Appointment appointment);
    void deleteAppointment(Long id);
    Appointment getAppointmentById(Long id);
    List<Appointment> getAllAppointments();
}
