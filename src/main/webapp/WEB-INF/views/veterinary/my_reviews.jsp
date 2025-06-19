<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<head>
    <title>My Reviews</title>
    <jsp:include page="../client/navbar.jsp"/>    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
         /* Dark tema için genel metin rengi ayarı */
                body.bg-dark {
                    color: #e9ecef; /* Ana metin rengi */
                }

                /* Kartların arka planı */
                body.bg-dark .card {
                    background-color: #2c3034; /* Biraz daha açık bir koyu renk */
                    border-color: #454d55;
                }

                /* Kart başlığı metin rengi */
                body.bg-dark .card-title {
                    color: #ffffff;
                }

                /* Kart içindeki ana metin rengi */
                body.bg-dark .card-text {
                    color: #ced4da; /* Biraz daha soluk bir beyaz */
                }

                /* Footer metin rengi */
                body.bg-dark .card-footer {
                    color: #adb5bd !important; /* !important ile Bootstrap'in .text-muted'ını eziyoruz */
                    background-color: #343a40;
                    border-top-color: #454d55;
                }

                /* Yıldız renkleri */
                .rating-stars {
                    color: #ffc107;
                }
                .rating-stars .bi-star {
                    color: #e4e5e9;
                }
                body.bg-dark .rating-stars .bi-star {
                    color: #495057; /* Koyu modda boş yıldız */
                }

                /* Kart hover efekti */
                .review-card {
                    transition: transform 0.2s ease-in-out;
                }
                .review-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15) !important;
                }
                body.bg-dark .review-card:hover {
                    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.4) !important;
                }
    </style>
</head>
<body id="pageBody">

<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>My Reviews</h2>
        <div class="text-end">
            <h5 class="mb-0">Average Rating:
                <span class="badge bg-primary fs-5">
                    <i class="bi bi-star-fill"></i> ${averageRating} / 5.0
                </span>
            </h5>
            <small class="text-muted">Based on ${totalReviews} reviews</small>
        </div>
    </div>

    <c:if test="${empty reviews}">
        <div class="alert alert-info text-center">You have not received any reviews yet.</div>
    </c:if>

    <div class="row row-cols-1 row-cols-md-2 g-4">
        <c:forEach var="review" items="${reviews}">
            <div class="col">
                <div class="card h-100 shadow-sm review-card">
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <h5 class="card-title">
                                Pet: ${review.appointment.pet.name}
                                <small class="text-muted">(Client: ${review.appointment.pet.client.firstName})</small>
                            </h5>
                            <div class="rating-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= review.rating}">
                                            <i class="bi bi-star-fill"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                        <p class="card-text">"${review.comment}"</p>
                    </div>
                    <div class="card-footer text-muted">
                        Reviewed on
                        ${review.reviewDate}
                        (Appointment ID: ${review.appointment.appointmentId})
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Tema script'i
    document.addEventListener("DOMContentLoaded", () => {
        const body = document.getElementById("pageBody");
        const currentTheme = localStorage.getItem("theme") || "light";
        if (currentTheme === "dark") {
            body.classList.add("bg-dark", "text-white");
        } else {
            body.classList.add("bg-light", "text-dark");
        }
    });
</script>

</body>
</html>