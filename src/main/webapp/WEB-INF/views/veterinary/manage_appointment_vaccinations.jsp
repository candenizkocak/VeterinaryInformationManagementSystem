<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>


<fmt:setLocale value="tr_TR"/> <%-- Tarih formatı için Türkçe lokalizasyon --%>

<body id="pageBody">
<jsp:include page="../client/navbar.jsp"/>
<!-- STYLES -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

<!-- SCRIPTS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<div class="container mt-5">
    <h2 class="mb-3">Manage Vaccinations for Appointment</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card mb-4">
        <div class="card-header">
            Appointment & Pet Details
        </div>
        <div class="card-body">
            <p><strong>Appointment ID:</strong> ${appointment.appointmentId}</p>
            <p><strong>Pet Name:</strong> ${pet.name} (${pet.species.speciesName} - ${pet.breed.breedName})</p>
            <p><strong>Client:</strong> ${pet.client.firstName} ${pet.client.lastName}</p>
            <p><strong>Appointment Date:</strong> ${formattedAppointmentDate}</p>
        </div>
    </div>

    <hr/>

    <h4 class="mt-4 mb-3">Existing Vaccinations for ${pet.name}</h4>
    <c:choose>
        <c:when test="${not empty existingVaccinations}">
            <table class="table table-striped table-hover" id="existingVaccinationsTable">
                <thead>
                <tr>
                    <th>Vaccine Name</th>
                    <th>Date Administered</th>
                    <th>Next Due Date</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="vacc" items="${existingVaccinations}">
                    <tr>
                        <td>${vacc.vaccineType.vaccineName}</td>
                        <td>${vacc.dateAdministered != null ? vacc.dateAdministered.format(DateTimeFormatter.ofPattern('dd-MM-yyyy')) : 'N/A'}</td>
                        <td>
                            <c:if test="${not empty vacc.nextDueDate}">
                                ${vacc.nextDueDate.format(DateTimeFormatter.ofPattern('dd-MM-yyyy'))}
                            </c:if>
                            <c:if test="${empty vacc.nextDueDate}">N/A</c:if>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/veterinary/appointments/${appointment.appointmentId}/vaccinations/delete/${vacc.vaccinationId}" method="post" style="display:inline;">
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this vaccination record?')">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="alert alert-info">No vaccinations recorded for this pet yet.</div>
        </c:otherwise>
    </c:choose>

    <hr/>

    <h4 class="mt-4 mb-3">Add New Vaccination</h4>
    <form action="${pageContext.request.contextPath}/veterinary/appointments/${appointment.appointmentId}/vaccinations/add" method="post" class="row g-3">
        <div class="col-md-4">
            <label for="vaccineTypeId" class="form-label">Vaccine Type:</label>
            <select id="vaccineTypeId" name="vaccineTypeId" class="form-select" required>
                <option value="">Select Vaccine Type...</option>
                <c:forEach var="vt" items="${allVaccineTypes}">
                    <option value="${vt.vaccineTypeId}">${vt.vaccineName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="dateAdministered" class="form-label">Date Administered:</label>
            <input type="date" id="dateAdministered" name="dateAdministered" class="form-control" required
                               value="<%= java.time.LocalDate.now().toString() %>" >
        </div>
        <div class="col-md-3">
            <label for="nextDueDate" class="form-label">Next Due Date (Optional):</label>
            <input type="date" id="nextDueDate" name="nextDueDate" class="form-control">
        </div>
        <div class="col-md-2 d-flex align-items-end">
            <button type="submit" class="btn btn-success w-100">Add Vaccination</button>
        </div>
    </form>

    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/veterinary/appointments" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Appointments
        </a>
    </div>

</div>

<script>
    $(document).ready(function () {
        $('#existingVaccinationsTable').DataTable({
            "pageLength": 5,
            "lengthMenu": [5, 10, 25],
             "order": [[ 1, "desc" ]] // Tarihe göre tersten sırala
        });
    });

    // Tema script'iniz buraya gelecek (navbar'daki gibi)
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const navbar = document.getElementById('mainNavbar'); // navbar.jsp'deki id

    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            if (navbar) {
                navbar.classList.add('navbar-dark', 'bg-dark');
                navbar.classList.remove('navbar-light', 'bg-light');
            }
            $('#existingVaccinationsTable').removeClass('table-striped').addClass('table-dark'); // DataTables için tema
            if(themeToggleSwitch) themeToggleSwitch.checked = true;
             document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/moon.gif')");
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
            $('#existingVaccinationsTable').addClass('table-striped').removeClass('table-dark'); // DataTables için tema
            if(themeToggleSwitch) themeToggleSwitch.checked = false;
             document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/sun.gif')");
        }
        localStorage.setItem('theme', theme);
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