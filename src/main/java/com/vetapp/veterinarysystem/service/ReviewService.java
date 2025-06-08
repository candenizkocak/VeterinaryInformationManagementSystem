package com.vetapp.veterinarysystem.service;

import com.vetapp.veterinarysystem.model.Review;
import java.util.List;
import java.util.Set;

public interface ReviewService {
    Review createReview(Long appointmentId, Long clientId, int rating, String comment);
    List<Review> getReviewsByVeterinaryId(Long veterinaryId);
    Set<Long> getReviewedAppointmentIdsByClientId(Long clientId);
}