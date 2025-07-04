// src/main/java/com/vetapp/veterinarysystem/service/impl/AppointmentServiceImpl.java
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
import org.springframework.transaction.annotation.Transactional; // Import ekleyin
import org.springframework.dao.DataIntegrityViolationException;

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
    public List<Appointment> getAppointmentsByVeterinaryId(Long veterinaryId) {
        return appointmentRepository.findByVeterinary_VeterinaryId(veterinaryId);
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
        if (appointment.getPet() == null || appointment.getPet().getPetID() == null) // Pet'in ID'sinin de kontrolü
            throw new IllegalArgumentException("Pet is missing or Pet ID is null");

        Clinic clinic = clinicRepository.findById(appointment.getClinic().getClinicId())
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));
        Veterinary veterinary = veterinaryRepository.findById(appointment.getVeterinary().getVeterinaryId())
                .orElseThrow(() -> new IllegalArgumentException("Veterinary not found"));

        appointment.setClinic(clinic);
        appointment.setVeterinary(veterinary);

        checkWithinWorkingHours(appointment);


        List<Appointment> existingAppointments = appointmentRepository.findByVeterinaryVeterinaryIdAndAppointmentDateBetween(
                veterinary.getVeterinaryId(),
                appointment.getAppointmentDate().withSecond(0).withNano(0), // Saniye ve nanosaniyeyi sıfırla
                appointment.getAppointmentDate().withSecond(0).withNano(0).plusMinutes(29) // 30 dakikalık slot için 29 dakika ekle
        );

        if (!existingAppointments.isEmpty()) {
            throw new IllegalArgumentException("Selected time slot is already taken by this veterinary.");
        }


        return appointmentRepository.save(appointment);
    }

    @Override
    public Appointment updateAppointment(Long id, Appointment appointment) {
        Appointment existing = appointmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        Clinic fullClinic = clinicRepository.findById(appointment.getClinic().getClinicId())
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));
        Veterinary fullVeterinary = veterinaryRepository.findById(appointment.getVeterinary().getVeterinaryId())
                .orElseThrow(() -> new IllegalArgumentException("Veterinary not found"));


        existing.setAppointmentDate(appointment.getAppointmentDate());
        existing.setStatus(appointment.getStatus());
        existing.setPet(appointment.getPet());
        existing.setClinic(fullClinic);
        existing.setVeterinary(fullVeterinary);

        checkWithinWorkingHours(existing);
        return appointmentRepository.save(existing);
    }

    /*
    @Override
    public void deleteAppointment(Long id) {
        appointmentRepository.deleteById(id);
    }*/

    @Override
    public void deleteAppointment(Long id) {
        try {
            appointmentRepository.deleteById(id);
        } catch (DataIntegrityViolationException e) {
            // Veritabanı bütünlük hatası yakalandı. Bu genellikle bir foreign key kısıtlamasından kaynaklanır.
            // Daha spesifik bir istisna fırlatarak Controller'ın bunu anlamasını sağlıyoruz.
            throw new IllegalStateException("Cannot delete an appointment that has been reviewed or is referenced by other records.");
        }
    }

    @Override
    public Appointment getAppointmentById(Long id) {

        return appointmentRepository.findById(id).orElse(null);
    }

    @Override
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAllWithDetails(); // Detayları ile birlikte getir
    }

    private void checkWithinWorkingHours(Appointment appointment) {
        LocalTime appointmentTime = appointment.getAppointmentDate().toLocalTime();
        LocalTime opening = appointment.getClinic().getOpeningHour();
        LocalTime closing = appointment.getClinic().getClosingHour();

        if (opening == null || closing == null) {
            throw new IllegalArgumentException("Clinic working hours are not defined for clinic ID: " + appointment.getClinic().getClinicId());
        }


        if (appointmentTime.isBefore(opening) || appointmentTime.plusMinutes(29).isAfter(closing)) {
            throw new IllegalArgumentException("Appointment time (" + appointmentTime + ") is outside clinic working hours (" + opening + "-" + closing + ").");
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

        if (opening == null || closing == null) {
            throw new IllegalArgumentException("Clinic working hours are not defined.");
        }

        List<Appointment> existingAppointments = appointmentRepository
                .findByVeterinaryVeterinaryIdAndAppointmentDateBetween(
                        veterinaryId,
                        date.atStartOfDay(), // Günün başlangıcı
                        date.atTime(LocalTime.MAX) // Günün sonu
                );

        Set<LocalTime> takenTimes = existingAppointments.stream()
                .map(a -> a.getAppointmentDate().toLocalTime())
                .collect(Collectors.toSet());

        List<LocalDateTime> availableSlots = new ArrayList<>();
        LocalTime currentTime = opening;

        // 30 dakikalık aralıklarla slotları kontrol et
        while (currentTime.plusMinutes(30).compareTo(closing) <= 0) { // Son randevu bitiş saati kapanış saatini geçmemeli
            if (!takenTimes.contains(currentTime)) {
                availableSlots.add(date.atTime(currentTime));
            }
            currentTime = currentTime.plusMinutes(30);
        }

        return availableSlots;
    }

    @Override
    @Transactional
    public void cancelAppointment(Long appointmentId, Long clientId) throws IllegalArgumentException {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new IllegalArgumentException("Appointment not found with ID: " + appointmentId));

        if (!appointment.getPet().getClient().getClientId().equals(clientId)) {
            throw new IllegalArgumentException("You are not authorized to cancel this appointment.");
        }

        if (!"Planned".equalsIgnoreCase(appointment.getStatus())) {
            throw new IllegalArgumentException("Only 'Planned' appointments can be cancelled. Current status: " + appointment.getStatus());
        }

        appointment.setStatus("Cancelled");
        appointmentRepository.save(appointment);
    }


    // YENİ METOT IMPLEMENTASYONU
    @Override
    public void updateAppointmentStatus(Long appointmentId, String newStatus) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found with ID: " + appointmentId));

        appointment.setStatus(newStatus);
        appointmentRepository.save(appointment);
    }
}