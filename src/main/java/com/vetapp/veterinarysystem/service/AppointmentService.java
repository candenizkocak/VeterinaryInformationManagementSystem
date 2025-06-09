package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Appointment;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentService {
    Appointment createAppointment(Appointment appointment) throws IllegalArgumentException;
    Appointment updateAppointment(Long id, Appointment appointment) throws IllegalArgumentException;
    void deleteAppointment(Long id);
    Appointment getAppointmentById(Long id);
    List<Appointment> getAllAppointments();
    List<LocalDateTime> getAvailableTimeSlots(Long clinicId, Long veterinaryId, LocalDate date);

    List<Appointment> getAppointmentsByVeterinaryId(Long veterinaryId); // Added

    void cancelAppointment(Long appointmentId, Long clientId) throws IllegalArgumentException;

    void updateAppointmentStatus(Long appointmentId, String newStatus);
}