<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<fmt:setLocale value="tr_TR"/>

<body id="pageBody">
<jsp:include page="../navbar.jsp"/>

<!-- STYLES and SCRIPTS (from manage_appointment_vaccinations.jsp) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
<!-- Font Awesome (for icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">


<div class="container mt-5">
    <h2 class="mb-3">Manage Surgeries for Appointment</h2>

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

    <h4 class="mt-4 mb-3">Existing Surgeries for ${pet.name}</h4>
    <c:choose>
        <c:when test="${not empty existingSurgeries}">
            <table class="table table-striped table-hover" id="existingSurgeriesTable">
                <thead>
                <tr>
                    <th>Surgery Type</th>
                    <th>Veterinary</th>
                    <th>Date</th>
                    <th>Notes</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="surg" items="${existingSurgeries}">
                    <tr>
                        <td>${surg.surgeryType.typeName}</td>
                        <td>${surg.veterinary.firstName} ${surg.veterinary.lastName}</td>
                        <td>${surg.date != null ? surg.date.format(DateTimeFormatter.ofPattern('dd-MM-yyyy')) : 'N/A'}</td>
                        <td><c:out value="${surg.notes}"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/veterinary/appointments/${appointment.appointmentId}/surgeries/delete/${surg.surgeryId}" method="post" style="display:inline;">
                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this surgery record?')">
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
            <div class="alert alert-info">No surgeries recorded for this pet yet.</div>
        </c:otherwise>
    </c:choose>

    <hr/>

    <h4 class="mt-4 mb-3">Add New Surgery</h4>
    <form action="${pageContext.request.contextPath}/veterinary/appointments/${appointment.appointmentId}/surgeries/add" method="post" class="row g-3">
        <%-- Hidden field for the veterinary performing the surgery (logged-in vet) --%>
        <%-- <input type="hidden" name="veterinaryId" value="${loggedInVeterinary.veterinaryId}"/> --%>
        <%-- Not needed if controller sets it from Principal --%>

        <div class="col-md-4">
            <label for="surgeryTypeId" class="form-label">Surgery Type:</label>
            <select id="surgeryTypeId" name="surgeryTypeId" class="form-select" required>
                <option value="">Select Surgery Type...</option>
                <c:forEach var="st" items="${allSurgeryTypes}">
                    <option value="${st.surgeryTypeId}">${st.typeName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3">
            <label for="surgeryDate" class="form-label">Surgery Date:</label>
            <input type="date" id="surgeryDate" name="surgeryDate" class="form-control" required
                   value="<%= java.time.LocalDate.now().toString() %>" >
        </div>
        <div class="col-md-5">
            <label for="notes" class="form-label">Notes (Optional):</label>
            <textarea id="notes" name="notes" class="form-control" rows="2"></textarea>
        </div>
        <div class="col-12 mt-3">
            <button type="submit" class="btn btn-success w-auto">Add Surgery</button>
        </div>
    </form>

    <div class="mt-4">
        <a href="${pageContext.request.contextPath}/veterinary/appointments" class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Back to Appointments
        </a>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function () {
        $('#existingSurgeriesTable').DataTable({
            "pageLength": 5,
            "lengthMenu": [5, 10, 25],
            "order": [[ 2, "desc" ]] // Tarihe göre tersten sırala (2. sütun, index 0'dan başlar)
        });
    });

    // Tema scripti (manage_appointment_vaccinations.jsp'deki gibi)
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const mainNavbar = document.getElementById('mainNavbar');

    function applyTheme(theme) {
        const isDark = theme === 'dark';
        body.classList.toggle('bg-dark', isDark);
        body.classList.toggle('text-white', isDark);
        body.classList.toggle('bg-light', !isDark);
        body.classList.toggle('text-dark', !isDark);

        if (mainNavbar) {
            mainNavbar.classList.toggle('navbar-dark', isDark);
            mainNavbar.classList.toggle('bg-dark', isDark);
            mainNavbar.classList.toggle('navbar-light', !isDark);
            mainNavbar.classList.toggle('bg-light', !isDark);
        }

        $('#existingSurgeriesTable').toggleClass('table-dark', isDark).toggleClass('table-striped', !isDark);

        if (themeToggleSwitch) {
            themeToggleSwitch.checked = isDark;
        }

        const sliderBefore = document.querySelector('.slider:before');
        if (sliderBefore) {
            sliderBefore.style.backgroundImage = isDark ? "url('<%= request.getContextPath() %>/img/moon.gif')" : "url('<%= request.getContextPath() %>/img/sun.gif')";
        }
        localStorage.setItem('theme', theme);
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyTheme(savedTheme);

        if (themeToggleSwitch) {
            themeToggleSwitch.addEventListener("change", () => {
                const newTheme = themeToggleSwitch.checked ? "dark" : "light";
                applyTheme(newTheme);
            });
        }
    });
</script>

</body>
</html>