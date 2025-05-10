<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="navbar.jsp" />

<div class="container mt-5">
    <h1 class="mb-4 text-center">Welcome to Veterinary Information System</h1>

    <c:choose>
        <c:when test="${sessionScope.role == 'ROLE_ADMIN'}">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    Admin Panel
                </div>
                <div class="card-body">
                    <p class="card-text">Manage system users and clinics.</p>
                    <a href="/admin/users" class="btn btn-primary me-2">Manage Users</a>
                    <a href="/admin/clinics" class="btn btn-secondary">Manage Clinics</a>
                </div>
            </div>
        </c:when>

        <c:when test="${sessionScope.role == 'ROLE_CLIENT'}">
            <div class="alert alert-info">
                <h4 class="alert-heading">Client Panel</h4>
                <p>View your pets, make appointments and more.</p>
            </div>
        </c:when>

        <c:when test="${sessionScope.role == 'ROLE_VETERINARY'}">
            <div class="alert alert-success">
                <h4 class="alert-heading">Veterinary Panel</h4>
                <a href="https://google.com" class="btn btn-primary me-2">Google Linki</a>
                <a href="/veterinary/appointments" class="btn btn-primary me-2">Appointment Page</a>
                <p>Manage medical records, view appointments.</p>
            </div>
        </c:when>

        <c:when test="${sessionScope.role == 'ROLE_CLINIC'}">
            <div class="alert alert-warning">
                <h4 class="alert-heading">Clinic Panel</h4>
                <p>Manage veterinarians, inventory and appointments.</p>
            </div>
        </c:when>

        <c:otherwise>
            <div class="text-center">
                <p>This is the homepage for anonymous users.</p>
                <a href="/login" class="btn btn-outline-primary me-2">Login</a>
                <a href="/signup" class="btn btn-outline-success">Sign up</a>
            </div>
        </c:otherwise>
    </c:choose>
</div>
