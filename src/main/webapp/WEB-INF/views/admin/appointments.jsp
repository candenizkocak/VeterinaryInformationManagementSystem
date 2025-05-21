<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<body id="pageBody">

<jsp:include page="../navbar.jsp"/>

<!-- STYLES -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

<!-- SCRIPTS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<c:choose>
    <c:when test="${empty appointment or empty appointment.appointmentId}">
        <c:set var="formAction" value="add"/>
        <c:set var="submitLabel" value="Add"/>
    </c:when>
    <c:otherwise>
        <c:set var="formAction" value="update"/>
        <c:set var="submitLabel" value="Update"/>
    </c:otherwise>
</c:choose>

<div class="container mt-5">
    <h2 class="mb-4">Appointment Management</h2>

    <form action="/admin/appointments/${formAction}" method="post" class="row g-3 mb-4">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>

        <div class="col-md-3">
            <label class="form-label">Clinic</label>
            <select name="clinicId" id="clinicSelect" class="form-select" required onchange="this.form.submit()">
                <option value="" disabled ${empty selectedClinicId ? 'selected' : ''}>Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}" <c:if test="${selectedClinicId == clinic.clinicId}">selected</c:if>>${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Veterinary</label>
            <select name="veterinaryId" class="form-select" required>
                <option value="" disabled ${empty selectedVetId ? 'selected' : ''}>Select a veterinary</option>
                <c:forEach var="vet" items="${veterinaries}">
                    <option value="${vet.veterinaryId}" <c:if test="${selectedVetId == vet.veterinaryId}">selected</c:if>>${vet.firstName} ${vet.lastName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Date</label>
            <input type="date" name="date" class="form-control" value="${selectedDate}"/>
        </div>

        <div class="col-md-3 d-flex align-items-end">
            <button formaction="/admin/appointments/timeslots" formmethod="post" class="btn btn-outline-primary w-100">
                Show Time Slots
            </button>
        </div>

        <div class="col-md-3">
            <label class="form-label">Pet</label>
            <select name="petId" class="form-select">
                <option value="" disabled selected>Select a pet</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.petID}" <c:if test="${appointment.pet != null and appointment.pet.petID == pet.petID}">selected</c:if>>${pet.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Time Slot</label>
            <c:choose>
                <c:when test="${not empty slots}">
                    <select name="appointmentDate" class="form-select">
                        <option value="">Select a time</option>
                        <c:forEach var="slot" items="${slots}">
                            <option value="${selectedDate}T${slot}"
                                    <c:if test="${appointment.appointmentDate != null and appointment.appointmentDate == selectedDate.concat('T').concat(slot)}">selected</c:if>>
                                    ${slot}
                            </option>
                        </c:forEach>
                    </select>
                </c:when>
                <c:otherwise>
                    <select class="form-select" disabled>
                        <option>Select a clinic, veterinary and date first</option>
                    </select>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="col-md-3">
            <label class="form-label">Status</label>
            <select name="status" class="form-select">
                <option value="Planned" <c:if test="${appointment.status == 'Planned'}">selected</c:if>>Planned</option>
                <option value="Completed" <c:if test="${appointment.status == 'Completed'}">selected</c:if>>Completed</option>
                <option value="Cancelled" <c:if test="${appointment.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
            </select>
        </div>

        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-success w-100">${submitLabel} Appointment</button>
        </div>
    </form>

    <table id="appointmentTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Pet</th>
            <th>Clinic</th>
            <th>Veterinary</th>
            <th>Date</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="appt" items="${appointments}">
            <tr>
                <td>${appt.appointmentId}</td>
                <td>${appt.petName}</td>
                <td>${appt.clinicName}</td>
                <td>${appt.veterinaryName}</td>
                <td>${appt.appointmentDate}</td>
                <td>${appt.status}</td>
                <td>
                    <a href="/admin/appointments/edit/${appt.appointmentId}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/appointments/delete/${appt.appointmentId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function () {
        $('#appointmentTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });
    });

</script>

<script>
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
            themeToggleSwitch.checked = true;

            document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/moon.gif')");
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
            themeToggleSwitch.checked = false;

            document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/sun.gif')");
        }

        localStorage.setItem('theme', theme);
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyTheme(savedTheme);

        themeToggleSwitch?.addEventListener("change", () => {
            const newTheme = themeToggleSwitch.checked ? "dark" : "light";
            applyTheme(newTheme);
        });
    });
</script>
</body>
