package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.model.Clinic;
import com.vetapp.veterinarysystem.model.Veterinary;
import com.vetapp.veterinarysystem.repository.AppointmentRepository;
import com.vetapp.veterinarysystem.repository.ClinicRepository;
import com.vetapp.veterinarysystem.repository.VeterinaryRepository;
import com.vetapp.veterinarysystem.service.AppointmentService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private static final Logger logger = LoggerFactory.getLogger(AppointmentServiceImpl.class);

    private final AppointmentRepository appointmentRepository;
    private final ClinicRepository clinicRepository;
    private final VeterinaryRepository veterinaryRepository;

    public AppointmentServiceImpl(AppointmentRepository appointmentRepository,
                                  ClinicRepository clinicRepository,
                                  VeterinaryRepository veterinaryRepository) {
        this.appointmentRepository = appointmentRepository;
        this.clinicRepository = clinicRepository;
        this.veterinaryRepository = veterinaryRepository;
    }

    @Override
    public Appointment createAppointment(Appointment appointment) {
        logger.info("createAppointment() called with Pet: {}, Clinic: {}, Veterinary: {}, Date: {}, Status: {}",
                appointment.getPet() != null ? appointment.getPet().getPetID() : "NULL",
                appointment.getClinic() != null ? appointment.getClinic().getClinicId() : "NULL",
                appointment.getVeterinary() != null ? appointment.getVeterinary().getVeterinaryId() : "NULL",
                appointment.getAppointmentDate(),
                appointment.getStatus());

        if (appointment.getClinic() == null || appointment.getClinic().getClinicId() == null)
            throw new IllegalArgumentException("Clinic ID is missing");
        if (appointment.getVeterinary() == null || appointment.getVeterinary().getVeterinaryId() == null)
            throw new IllegalArgumentException("Veterinary ID is missing");
        if (appointment.getPet() == null)
            throw new IllegalArgumentException("Pet is missing");

        Clinic clinic = clinicRepository.findById(appointment.getClinic().getClinicId())
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));
        Veterinary veterinary = veterinaryRepository.findById(appointment.getVeterinary().getVeterinaryId())
                .orElseThrow(() -> new IllegalArgumentException("Veterinary not found"));

        appointment.setClinic(clinic);
        appointment.setVeterinary(veterinary);

        checkWithinWorkingHours(appointment);

        return appointmentRepository.save(appointment);
    }

    @Override
    public Appointment updateAppointment(Long id, Appointment appointment) {
        Appointment existing = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        Clinic fullClinic = clinicRepository.findById(appointment.getClinic().getClinicId())
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));

        existing.setAppointmentDate(appointment.getAppointmentDate());
        existing.setStatus(appointment.getStatus());
        existing.setPet(appointment.getPet());
        existing.setClinic(fullClinic);
        existing.setVeterinary(appointment.getVeterinary());

        checkWithinWorkingHours(existing);
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
        return appointmentRepository.findAllWithDetails();
    }

    private void checkWithinWorkingHours(Appointment appointment) {
        LocalTime appointmentTime = appointment.getAppointmentDate().toLocalTime();
        LocalTime opening = appointment.getClinic().getOpeningHour();
        LocalTime closing = appointment.getClinic().getClosingHour();

        if (opening == null || closing == null) {
            throw new IllegalArgumentException("Clinic working hours are not defined.");
        }

        if (appointmentTime.isBefore(opening) || appointmentTime.isAfter(closing)) {
            throw new IllegalArgumentException("Appointment time is outside clinic working hours.");
        }
    }

    @Override
    public List<LocalDateTime> getAvailableTimeSlots(Long clinicId, Long veterinaryId, LocalDate date) {
        Clinic clinic = clinicRepository.findById(clinicId)
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));
        Veterinary veterinary = veterinaryRepository.findById(veterinaryId)
                .orElseThrow(() -> new IllegalArgumentException("Veterinary not found"));

        LocalTime opening = clinic.getOpeningHour();
        LocalTime closing = clinic.getClosingHour();

        List<Appointment> existingAppointments = appointmentRepository
                .findByVeterinaryVeterinaryIdAndAppointmentDateBetween(
                        veterinaryId,
                        date.atTime(opening),
                        date.atTime(closing)
                );

        Set<LocalTime> takenTimes = existingAppointments.stream()
                .map(a -> a.getAppointmentDate().toLocalTime())
                .collect(Collectors.toSet());

        List<LocalDateTime> availableSlots = new ArrayList<>();
        LocalTime currentTime = opening;

        while (currentTime.plusMinutes(30).compareTo(closing) <= 0) {
            if (!takenTimes.contains(currentTime)) {
                availableSlots.add(date.atTime(currentTime));
            }
            currentTime = currentTime.plusMinutes(30);
        }

        return availableSlots;
    }
}
