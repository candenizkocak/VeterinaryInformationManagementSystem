package com.vetapp.veterinarysystem.repository;

import com.vetapp.veterinarysystem.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByVeterinary_VeterinaryId(Long veterinaryId);
    boolean existsByAppointment_AppointmentId(Long appointmentId);
    List<Review> findByAppointment_Pet_Client_ClientId(Long clientId);
}