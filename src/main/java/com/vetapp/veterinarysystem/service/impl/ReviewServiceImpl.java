package com.vetapp.veterinarysystem.service.impl;

import com.vetapp.veterinarysystem.model.Appointment;
import com.vetapp.veterinarysystem.model.Review;
import com.vetapp.veterinarysystem.repository.AppointmentRepository;
import com.vetapp.veterinarysystem.repository.ReviewRepository;
import com.vetapp.veterinarysystem.service.ReviewService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final AppointmentRepository appointmentRepository;

    @Override
    public Review createReview(Long appointmentId, Long clientId, int rating, String comment) {
        Appointment appointment = appointmentRepository.findById(appointmentId)
                .orElseThrow(() -> new RuntimeException("Appointment not found."));

        if (!appointment.getPet().getClient().getClientId().equals(clientId)) {
            throw new SecurityException("You are not authorized to review this appointment.");
        }
        if (!"Completed".equalsIgnoreCase(appointment.getStatus())) {
            throw new IllegalStateException("You can only review completed appointments.");
        }
        if (reviewRepository.existsByAppointment_AppointmentId(appointmentId)) {
            throw new IllegalStateException("This appointment has already been reviewed.");
        }

        Review review = Review.builder()
                .appointment(appointment)
                .client(appointment.getPet().getClient())
                .veterinary(appointment.getVeterinary())
                .rating(rating)
                .comment(comment)
                .reviewDate(LocalDate.now())
                .build();

        return reviewRepository.save(review);
    }

    @Override
    public List<Review> getReviewsByVeterinaryId(Long veterinaryId) {
        return reviewRepository.findByVeterinary_VeterinaryId(veterinaryId);
    }

    @Override
    public Set<Long> getReviewedAppointmentIdsByClientId(Long clientId) {
        return reviewRepository.findByAppointment_Pet_Client_ClientId(clientId).stream()
                .map(review -> review.getAppointment().getAppointmentId())
                .collect(Collectors.toSet());
    }
}