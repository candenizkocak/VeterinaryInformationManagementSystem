<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Manage Medical Records</title>
    <jsp:include page="../client/navbar.jsp"/>    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        body.bg-dark .card { background-color: #2b2b2b !important; }
        body.bg-dark .table-striped>tbody>tr:nth-of-type(odd)>* { --bs-table-accent-bg: rgba(255, 255, 255, 0.05) !important; }
        .info-box { border-left: 5px solid #0dcaf0; padding: 15px; background-color: #f8f9fa; }
        body.bg-dark .info-box { background-color: #343a40; }
    </style>
</head>
<body id="pageBody">
<div class="container mt-5">
    <h2 class="mb-4">Manage Medical Records</h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body info-box">
            <h5 class="card-title">Appointment Details</h5>
            <p class="card-text mb-1">
                <strong>Pet:</strong> ${appointment.pet.name} |
                <strong>Client:</strong> ${appointment.pet.client.firstName} ${appointment.pet.client.lastName} |
                <strong>Date:</strong>
                <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
            </p>
        </div>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Add New Record Form -->
    <div class="card shadow-sm mb-4">
        <div class="card-header">
            <h5><i class="bi bi-plus-circle"></i> Add New Record</h5>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/veterinary/appointments/medical-records/add" method="post">
                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label for="date" class="form-label">Record Date</label>
                        <input type="date" class="form-control" id="date" name="date" value="<%= java.time.LocalDate.now() %>" required>
                    </div>
                    <div class="col-md-9">
                        <label for="description" class="form-label">Description (Diagnosis)</label>
                        <textarea class="form-control" id="description" name="description" rows="2" required></textarea>
                    </div>
                    <div class="col-12">
                        <label for="treatment" class="form-label">Treatment</label>
                        <textarea class="form-control" id="treatment" name="treatment" rows="3" required></textarea>
                    </div>
                    <div class="col-12 mt-3">
                        <button type="submit" class="btn btn-primary">Save Record</button>
                        <a href="${pageContext.request.contextPath}/veterinary/appointments" class="btn btn-secondary">Back to Appointments</a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Existing Records Table -->
    <div class="card shadow-sm">
        <div class="card-header">
            <h5><i class="bi bi-list-ul"></i> Existing Records for ${appointment.pet.name}</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-bordered">
                    <thead class="table-dark">
                    <tr>
                        <th>Date</th>
                        <th>Description</th>
                        <th>Treatment</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="record" items="${records}">
                        <tr>
                            <td>${record.date}</td>
                            <td><c:out value="${record.description}"/></td>
                            <td><c:out value="${record.treatment}"/></td>
                            <td>
                                 <form action="${pageContext.request.contextPath}/veterinary/appointments/medical-records/delete/${record.medicalRecordId}" method="post" onsubmit="return confirm('Are you sure you want to delete this record?');">
                                     <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
                                     <button type="submit" class="btn btn-danger btn-sm" title="Delete"><i class="bi bi-trash"></i></button>
                                 </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty records}">
                        <tr>
                            <td colspan="4" class="text-center">No medical records found for this pet.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
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