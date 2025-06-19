<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Welcome to PetPoint Veterinary System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <!-- Theme CSS (Genel Tema ve Navbar Stilleri) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Custom Home Page CSS (Bu sayfaya özel stiller) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/home_custom.css">
</head>
<body id="pageBody"> <%-- Tema scriptinin çalışması için id="pageBody" önemli --%>

<%-- NAVBAR: HER ZAMAN CLIENT NAVBAR'INI KULLAN --%>
<jsp:include page="client/navbar.jsp"/>

<%-- ANA SAYFA İÇERİĞİ --%>
<c:choose>
    <%-- KULLANICI GİRİŞ YAPMAMIŞSA MODERN ANA SAYFAYI GÖSTER --%>
    <c:when test="${empty sessionScope.role}">
        <main>
            <!-- Hero Section -->
            <section class="hero-section text-center text-white">
                <div class="container">
                    <h1 class="hero-title display-4 fw-bold">Your Pet's Health, Our Priority</h1>
                    <p class="hero-subtitle lead mb-4">
                        Comprehensive veterinary care at your fingertips. Book appointments, manage records, and connect with trusted professionals.
                    </p>
                    <a href="${pageContext.request.contextPath}/signup" class="btn btn-lg btn-primary hero-cta-primary me-2">
                        <i class="bi bi-person-plus-fill me-2"></i>Sign Up Now
                    </a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-lg btn-outline-light hero-cta-secondary">
                        <i class="bi bi-box-arrow-in-right me-2"></i>Login
                    </a>
                </div>
            </section>

            <!-- Services Section -->
            <section class="services-section py-5">
                <div class="container">
                    <h2 class="section-title text-center mb-5">Our Services</h2>
                    <div class="row g-4">
                        <div class="col-md-4">
                            <div class="service-card text-center p-4 shadow-sm">
                                <div class="service-icon mb-3">
                                    <i class="bi bi-calendar2-check-fill"></i>
                                </div>
                                <h3 class="service-title h5">Easy Appointment Booking</h3>
                                <p class="service-description">Quickly find available slots and book appointments with your preferred vets.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="service-card text-center p-4 shadow-sm">
                                <div class="service-icon mb-3">
                                    <i class="bi bi-journal-medical"></i>
                                </div>
                                <h3 class="service-title h5">Pet Health Records</h3>
                                <p class="service-description">Access your pet's complete medical history, vaccinations, and treatments anytime.</p>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="service-card text-center p-4 shadow-sm">
                                <div class="service-icon mb-3">
                                    <i class="bi bi-people-fill"></i>
                                </div>
                                <h3 class="service-title h5">Trusted Professionals</h3>
                                <p class="service-description">Connect with experienced veterinarians and well-equipped clinics.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Call to Action Section -->
            <section class="cta-section text-center py-5">
                <div class="container">
                    <h2 class="section-title mb-3">Ready to Get Started?</h2>
                    <p class="lead mb-4">Join PetPoint today and give your furry friends the best care.</p>
                    <a href="${pageContext.request.contextPath}/signup" class="btn btn-lg btn-success cta-button">
                        <i class="bi bi-heart-pulse-fill me-2"></i> Create Your Account
                    </a>
                </div>
            </section>
        </main>
    </c:when>

    <%-- KULLANICI GİRİŞ YAPMIŞSA MEVCUT PANELİ GÖSTER --%>
    <c:otherwise>
        <div class="container mt-5">
            <h1 class="mb-4 text-center">Welcome to Veterinary Information System</h1>

            <c:choose>
                <c:when test="${sessionScope.role == 'ROLE_ADMIN'}">
                    <div class="card bg-secondary text-white mb-3"> <%-- Temaya göre bu class'lar değişebilir --%>
                        <div class="card-header">Admin Panel</div>
                        <div class="card-body">
                            <a href="/admin/users" class="btn btn-light me-2">Manage Users</a>
                            <a href="/admin/clinics" class="btn btn-light me-2">Manage Clinics</a>
                            <a href="/admin/veterinaries" class="btn btn-light me-2">Manage Veterinaries</a>
                            <a href="/admin/pets" class="btn btn-light me-2">Manage Pets</a>
                            <a href="/admin/appointments" class="btn btn-light me-2">Manage Appointments</a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${sessionScope.role == 'ROLE_CLIENT'}">
                    <div class="card shadow-lg rounded-4 border-0 mb-5" style="background: linear-gradient(135deg,#cce7ff 70%,#e6f7ff 100%);">
                        <div class="card-header bg-transparent border-0 pt-4 pb-3">
                            <h3 class="fw-bold text-primary text-center mb-0">
                                <span style="font-size:2em;">👤</span> Client Panel
                            </h3>
                        </div>
                        <div class="card-body text-center py-4">
                            <p class="lead text-dark mb-4">Welcome! Easily manage your pets and appointments.</p>
                            <div class="d-flex flex-wrap justify-content-center gap-3 mb-2">
                                <a href="/api/clients/animals" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">🐾</span>
                                    <span class="fw-semibold mt-2">My Animals</span>
                                </a>
                                <a href="/api/clients/account-settings" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">⚙️</span>
                                    <span class="fw-semibold mt-2">Account Settings</span>
                                </a>
                                <a href="/api/clients/appointments" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">📅</span>
                                    <span class="fw-semibold mt-2">My Appointments</span>
                                </a>
                                <a href="/api/clients/add-animal" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">🐶</span>
                                    <span class="fw-semibold mt-2">Add Animal</span>
                                </a>
                                <a href="/api/clients/our-clinics" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">🏥</span>
                                    <span class="fw-semibold mt-2">Our Clinics</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:when test="${sessionScope.role == 'ROLE_VETERINARY'}">
                    <div class="alert alert-success text-center border-0" style="background-color: #d1e7dd;">
                        <h4 class="mb-4">Welcome to the Veterinary Panel</h4>
                        <div class="d-flex justify-content-center align-items-stretch gap-4">
                            <a href="${pageContext.request.contextPath}/veterinary/appointments"
                               class="btn btn-lg btn-light shadow-sm rounded-4 px-4 py-3 d-flex flex-column align-items-center text-decoration-none"
                               style="min-width: 180px; transition: all 0.2s ease-in-out;">
                                <span style="font-size: 2.5em; line-height: 1;">📅</span>
                                <span class="fw-semibold mt-2">Appointments</span>
                            </a>
                            <a href="${pageContext.request.contextPath}/veterinary/reviews"
                               class="btn btn-lg btn-light shadow-sm rounded-4 px-4 py-3 d-flex flex-column align-items-center text-decoration-none"
                               style="min-width: 180px; transition: all 0.2s ease-in-out;">
                                <span style="font-size: 2.5em; line-height: 1;">⭐</span>
                                <span class="fw-semibold mt-2">Reviews</span>
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${sessionScope.role == 'ROLE_CLINIC'}">
                    <jsp:include page="clinic/dashboard.jsp"/>
                </c:when>
            </c:choose>
        </div>
    </c:otherwise>
</c:choose>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- DataTables (gerekliyse, bazı panellerde kullanılıyor olabilir) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>


</body>
</html>