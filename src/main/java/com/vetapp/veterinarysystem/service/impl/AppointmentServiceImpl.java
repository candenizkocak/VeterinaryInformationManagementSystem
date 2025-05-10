package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.repository.AppointmentRepository;
import com.vetapp.veterinarysystem.service.AppointmentService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private final AppointmentRepository appointmentRepository;

    public AppointmentServiceImpl(AppointmentRepository appointmentRepository) {
        this.appointmentRepository = appointmentRepository;
    }

    @Override
    public Appointment createAppointment(Appointment appointment) {
        return appointmentRepository.save(appointment);
    }

    @Override
    public Appointment updateAppointment(Long id, Appointment appointment) {
        Appointment existing = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
        existing.setAppointmentDate(appointment.getAppointmentDate());
        existing.setStatus(appointment.getStatus());
        existing.setPet(appointment.getPet());
        existing.setClinic(appointment.getClinic());
        existing.setVeterinary(appointment.getVeterinary());
        return appointmentRepository.save(existing);
    }

    @Override
    public void deleteAppointment(Long id) {
        appointmentRepository.deleteById(id);
    }

    @Override
    public Appointment getAppointmentById(Long id) {
        return appointmentRepository.findById(id).orElse(null);
    }

    @Override
    public List<Appointment> getAllAppointments() {
        // Tüm ilişkili alanlarla birlikte getirmek için JOIN FETCH kullanabiliriz
        return appointmentRepository.findAllWithDetails();
    }
}
