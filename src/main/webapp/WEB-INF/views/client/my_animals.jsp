<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>My Animals</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>

    <!-- Genel tema CSS'i (global stiller için) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/my_animals.css">

</head>
<body id="pageBody" class="bg-light">
<jsp:include page="navbar.jsp"/> <%-- Navbar include'u body içine taşındı --%>

<div class="container py-4">
    <%-- Üst Başlık ve Butonlar --%>
    <div class="d-flex align-items-center mb-4">
        <a href="/" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2 rounded-pill px-3 py-2 me-auto">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
        <h2 class="fw-bold text-primary mb-0 text-center flex-grow-1"><span style="font-size:1.4em;">🐾</span> My Animals</h2>
        <a href="${pageContext.request.contextPath}/api/clients/add-animal" class="btn btn-primary btn-sm d-flex align-items-center gap-2 rounded-pill px-3 py-2 ms-auto">
            <i class="bi bi-plus-circle"></i> Add New Animal
        </a>
    </div>

    <c:choose>
        <c:when test="${not empty pets}">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <c:forEach var="pet" items="${pets}" varStatus="status">
                    <div class="col stagger-in-item" style="opacity: 0; transform: translateY(20px);">
                        <div class="card animal-card h-100 shadow-sm">
                            <div class="card-body pb-3 d-flex flex-column">
                                <div class="d-flex justify-content-center mb-3">
                                    <i class="bi bi-paw paw"></i>
                                </div>
                                <h5 class="card-title text-center mb-3">${pet.name}</h5>
                                <ul class="list-group list-group-flush flex-grow-1">
                                    <li class="list-group-item animal-attr"><b>Species:</b> ${pet.species}</li>
                                    <li class="list-group-item animal-attr"><b>Breed:</b> ${pet.breed}</li>
                                    <li class="list-group-item animal-attr"><b>Gender:</b> ${pet.gender}</li>
                                    <li class="list-group-item animal-attr"><b>Age:</b> ${pet.age}</li>
                                    <li class="list-group-item animal-attr"><b>Clinic:</b> ${pet.clinicName}</li>
                                </ul>

                                <div class="action-btns mt-4 d-flex flex-column align-items-center gap-3">
                                    <!-- Vaccinations Button -->
                                    <button class="btn btn-outline-success btn-paw w-100"
                                            data-bs-toggle="modal"
                                            data-bs-target="#vaccinesModal${pet.id}">
                                        <i class="bi bi-shield-plus me-2"></i> Vaccinations
                                    </button>
                                    <!-- Treatments Button -->
                                    <button class="btn btn-outline-info btn-paw w-100"
                                            data-bs-toggle="modal"
                                            data-bs-target="#treatmentsModal${pet.id}">
                                        <i class="bi bi-bandaid me-2"></i> Treatments
                                    </button>
                                    <!-- Diagnoses Button -->
                                    <button class="btn btn-outline-warning btn-paw w-100"
                                            data-bs-toggle="modal"
                                            data-bs-target="#diagnosesModal${pet.id}">
                                        <i class="bi bi-activity me-2"></i> Diagnoses
                                    </button>
                                    <form action="${pageContext.request.contextPath}/api/clients/delete-animal/${pet.id}" method="post"
                                          class="w-100"
                                          onsubmit="return confirm('Are you sure you want to delete this animal?');">
                                        <button type="submit" class="btn btn-danger btn-paw w-100">
                                            <i class="bi bi-trash me-2"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modals (Updated for theme.css changes) -->
                    <!-- Vaccinations Modal -->
                    <div class="modal fade" id="vaccinesModal${pet.id}" tabindex="-1" aria-labelledby="vaccinesModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-success-subtle">
                                    <h5 class="modal-title text-success" id="vaccinesModalLabel${pet.id}">
                                        <i class="bi bi-shield-plus me-2"></i> Vaccination History & Upcoming for ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.vaccinations}">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                <tr>
                                                    <th>Vaccine Name</th>
                                                    <th>Date Administered</th>
                                                    <th>Next Due Date</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="vacc" items="${pet.vaccinations}">
                                                    <tr>
                                                        <td>${vacc.vaccineName}</td>
                                                        <td>${vacc.dateAdministered}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${vacc.upcoming}">
                                                                    <span class="upcoming-vaccine">
                                                                        ${vacc.nextDueDate} (Upcoming)
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:if test="${vacc.nextDueDate ne 'N/A'}">
                                                                        <span class="past-vaccine">
                                                                            ${vacc.nextDueDate} (Past Due / Completed)
                                                                        </span>
                                                                    </c:if>
                                                                    <c:if test="${vacc.nextDueDate eq 'N/A'}">
                                                                        N/A
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-secondary">No vaccination records found.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Treatments Modal -->
                    <div class="modal fade" id="treatmentsModal${pet.id}" tabindex="-1" aria-labelledby="treatmentsModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info-subtle">
                                    <h5 class="modal-title text-info" id="treatmentsModalLabel${pet.id}">
                                        <i class="bi bi-bandaid me-2"></i> Treatments of ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.medicalRecords}">
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="record" items="${pet.medicalRecords}">
                                                    <c:if test="${not empty record.treatment}">
                                                        <li class="list-group-item">
                                                            <strong>Date:</strong> ${record.date} <br/>
                                                            <strong>Treatment:</strong> ${record.treatment}
                                                        </li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-secondary">No treatment records found.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Diagnoses Modal -->
                    <div class="modal fade" id="diagnosesModal${pet.id}" tabindex="-1" aria-labelledby="diagnosesModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-warning-subtle">
                                    <h5 class="modal-title text-warning" id="diagnosesModalLabel${pet.id}">
                                        <i class="bi bi-activity me-2"></i> Diagnoses of ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.medicalRecords}">
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="record" items="${pet.medicalRecords}">
                                                    <c:if test="${not empty record.description}">
                                                        <li class="list-group-item">
                                                            <strong>Date:</strong> ${record.date} <br/>
                                                            <strong>Diagnosis:</strong> ${record.description}
                                                        </li>
                                                    </c:if>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="alert alert-secondary">No diagnosis records found.</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column align-items-center py-5 no-animals-found">
                <i class="bi bi-paw text-secondary" style="font-size:5rem;"></i>
                <div class="alert alert-warning text-center mt-4 fs-5" style="max-width:420px;">
                    You do not have any registered animals yet.
                    <br><br>
                    <a href="${pageContext.request.contextPath}/api/clients/add-animal" class="btn btn-primary btn-lg mt-3">
                        <i class="bi bi-plus-circle me-2"></i> Add Your First Animal
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Card Entrance Animation (Staggered Fade-in)
    document.addEventListener("DOMContentLoaded", () => {
        const cards = document.querySelectorAll('.stagger-in-item');
        cards.forEach((card, index) => {
            setTimeout(() => {
                card.style.transition = 'opacity 0.6s ease-out, transform 0.6s ease-out';
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, index * 100);
        });
    });

    // Theme script (from navbar.jsp, ensure consistency across Client module)
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const navbar = document.getElementById('mainNavbar');

    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            if (navbar) {
                navbar.classList.add('navbar-dark', 'bg-dark');
                navbar.classList.remove('navbar-light', 'bg-light');
            }
            if(themeToggleSwitch) themeToggleSwitch.checked = true;
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
            if(themeToggleSwitch) themeToggleSwitch.checked = false;
        }
        localStorage.setItem('theme', theme);

        const sliderBefore = document.querySelector('.slider:before');
        if (sliderBefore) {
            sliderBefore.style.backgroundImage = theme === 'dark' ? "url('<%= request.getContextPath() %>/img/moon.gif')" : "url('<%= request.getContextPath() %>/img/sun.gif')";
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyTheme(savedTheme);

        if(themeToggleSwitch) {
            themeToggleSwitch.addEventListener("change", () => {
                const newTheme = themeToggleSwitch.checked ? "dark" : "light";
                applyTheme(newTheme);
            });
        }
    });
</script>

</body>
</html>