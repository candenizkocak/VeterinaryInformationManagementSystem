package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.time.LocalDateTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByVeterinary_VeterinaryId(Long veterinaryId);
    List<Appointment> findByClinic_ClinicId(Long clinicId);
    List<Appointment> findByPet_PetID(Long petID);
    boolean existsByPet_PetID(int petID);

    @Query("SELECT a FROM Appointment a " +
            "JOIN FETCH a.pet p " +
            "JOIN FETCH a.veterinary v " +
            "JOIN FETCH a.clinic c")
    List<Appointment> findAllWithDetails();
    List<Appointment> findByVeterinaryVeterinaryIdAndAppointmentDateBetween(
            Long veterinaryId,
            LocalDateTime start,
            LocalDateTime end
    );

}
