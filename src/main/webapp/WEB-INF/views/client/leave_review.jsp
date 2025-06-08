<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<html>
<head>
    <title>Leave a Review</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/leave_review.css">


    <style>
        .rating-stars {
            cursor: pointer;
        }
        .star-icon {
            font-size: 2.5rem;
            color: #d3d3d3;
            transition: color 0.2s, transform 0.15s;
        }
        .star-icon:hover {
            transform: scale(1.15);
        }
        .star-icon.selected {
            color: #ffc107;
        }
        body.bg-dark .star-icon {
            color: #495057;
        }
        body.bg-dark .star-icon.selected {
            color: #ffc107;
        }
    </style>
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/>
<div class="container mt-5">
    <div class="card mx-auto shadow-lg review-card">
        <div class="card-header">
            <h3 class="mb-0"><i class="bi bi-pencil-square"></i> Review Your Appointment</h3>
        </div>
        <div class="card-body p-4">
            <div class="mb-3">
                <p class="mb-1"><strong>Appointment Date:</strong>
                    ${appointment.appointmentDate.format(DateTimeFormatter.ofPattern("dd/MM/yyyy 'at' HH:mm"))}
                </p>
                <p class="mb-1"><strong>Veterinarian:</strong> ${appointment.veterinary.firstName} ${appointment.veterinary.lastName}</p>
                <p><strong>Clinic:</strong> ${appointment.clinic.clinicName}</p>
            </div>
            <hr>
            <form id="reviewForm" action="${pageContext.request.contextPath}/api/clients/appointments/review/submit" method="post">
                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

                <%-- YENİ: Değerlendirme için gizli input --%>
                <input type="hidden" name="rating" id="rating-value" value="0" required>

                <div class="mb-3 text-center">
                    <label class="form-label d-block fs-5">Your Rating:</label>

                    <%-- YENİ HTML YAPISI: Basit ikonlar --%>
                    <div class="rating-stars" id="star-rating">
                        <i class="bi bi-star-fill star-icon" data-value="1" title="Bad"></i>
                        <i class="bi bi-star-fill star-icon" data-value="2" title="Poor"></i>
                        <i class="bi bi-star-fill star-icon" data-value="3" title="Average"></i>
                        <i class="bi bi-star-fill star-icon" data-value="4" title="Good"></i>
                        <i class="bi bi-star-fill star-icon" data-value="5" title="Excellent"></i>
                    </div>
                </div>

                <div class="mb-4">
                    <label for="comment" class="form-label">Your Comment (optional):</label>
                    <textarea class="form-control" id="comment" name="comment" rows="4" placeholder="Share your experience..."></textarea>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                    <a href="${pageContext.request.contextPath}/api/clients/appointments" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary"><i class="bi bi-send-fill"></i> Submit Review</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const stars = document.querySelectorAll('.rating-stars .star-icon');
        const ratingInput = document.getElementById('rating-value');
        const ratingContainer = document.getElementById('star-rating');

        const setRating = (value) => {
            stars.forEach(star => {
                if (star.dataset.value <= value) {
                    star.classList.add('selected');
                } else {
                    star.classList.remove('selected');
                }
            });
        };

        stars.forEach(star => {
            star.addEventListener('click', () => {
                const value = star.dataset.value;
                ratingInput.value = value;
                setRating(value);
            });

            star.addEventListener('mouseover', () => {
                setRating(star.dataset.value);
            });
        });


        ratingContainer.addEventListener('mouseleave', () => {
            setRating(ratingInput.value);
        });


        document.getElementById('reviewForm').addEventListener('submit', function(event) {
            if (ratingInput.value === '0') {
                alert('Please select a rating by clicking on a star.');
                event.preventDefault();
            }
        });


        if (typeof applyThemeToAll === 'function') {
            const savedTheme = localStorage.getItem("theme") || "light";
            applyThemeToAll(savedTheme);
        }
    });
</script>
</body>
</html>