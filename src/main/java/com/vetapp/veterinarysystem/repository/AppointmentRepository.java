package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long> {
    List<Appointment> findByVeterinary_VeterinaryId(Long veterinaryId);
    List<Appointment> findByClinic_ClinicId(Long clinicId);
    List<Appointment> findByPet_PetID(Long petID);

    @Query("SELECT a FROM Appointment a " +
            "JOIN FETCH a.pet p " +
            "JOIN FETCH a.veterinary v " +
            "JOIN FETCH a.clinic c")
    List<Appointment> findAllWithDetails();
}
