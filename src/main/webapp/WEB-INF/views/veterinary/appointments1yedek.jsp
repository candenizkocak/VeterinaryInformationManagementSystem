<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

<body id="pageBody">
<div class="container mt-5">
    <h2 class="mb-4">My Appointments</h2>

    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">
            <c:choose>
                <c:when test="${param.error == 'not_found_or_unauthorized'}">Appointment not found or you are not authorized to edit it.</c:when>
                <c:when test="${param.error == 'update_unauthorized'}">You are not authorized to update this appointment.</c:when>
                <c:when test="${param.error == 'delete_unauthorized'}">You are not authorized to delete this appointment.</c:when>
                <c:otherwise>An error occurred.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <form action="/veterinary/appointments/${empty appointment.appointmentId ? 'add' : 'update'}" method="post" class="row g-3 mb-4">
        <c:if test="${not empty appointment.appointmentId}">
            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>
        </c:if>
        <%-- Veterinarian is fixed to the logged-in user --%>
        <input type="hidden" name="veterinary.veterinaryId" value="${loggedInVeterinary.veterinaryId}" />

        <div class="col-md-3">
            <label class="form-label">Pet</label>
            <select name="pet.petID" class="form-select" required>
                <option value="" disabled <c:if test="${empty appointment.pet}">selected</c:if>>Select a pet</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.petID}" <c:if test="${not empty appointment.pet && appointment.pet.petID == pet.petID}">selected</c:if>>${pet.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Clinic</label>
            <select id="clinicSelect" name="clinic.clinicId" class="form-select" required>
                <option value="" disabled <c:if test="${empty appointment.clinic}">selected</c:if>>Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}"> <%-- This 'clinics' attribute is now filtered in controller --%>
                    <option value="${clinic.clinicId}" <c:if test="${not empty appointment.clinic && appointment.clinic.clinicId == clinic.clinicId}">selected</c:if>>${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Veterinary</label>
            <input type="text" class="form-control" value="${loggedInVeterinary.firstName} ${loggedInVeterinary.lastName}" readonly />
        </div>

        <div class="col-md-3">
            <label class="form-label">Date</label>
            <input type="datetime-local" name="appointmentDate" value="${appointment.appointmentDate}" class="form-control" required/>
        </div>

        <div class="col-md-3">
            <label class="form-label">Status</label>
            <select name="status" class="form-select" required>
                <option value="Planned" <c:if test="${empty appointment.status || appointment.status == 'Planned'}">selected</c:if>>Planned</option>
                <option value="Completed" <c:if test="${not empty appointment.status && appointment.status == 'Completed'}">selected</c:if>>Completed</option>
                <option value="Cancelled" <c:if test="${not empty appointment.status && appointment.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-success">${empty appointment.appointmentId ? 'Add' : 'Update'} Appointment</button>
        </div>
    </form>

    <table id="appointmentTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Pet</th>
            <th>Client</th>
            <th>Clinic</th>
            <%-- Veterinary column can be removed if it's always the logged-in one --%>
            <%-- <th>Veterinary</th> --%>
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
                <td>${appt.clientName}</td>
                <td>${appt.clinicName}</td>
                <%-- <td>${appt.veterinaryName}</td> --%>
                <td>${appt.appointmentDate}</td>
                <td>${appt.status}</td>
                <td>
                    <a href="/veterinary/appointments/edit/${appt.appointmentId}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/veterinary/appointments/delete/${appt.appointmentId}" method="post" style="display:inline;">
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
                { orderable: false, targets: -1 } // Assuming 'Actions' is the last column
            ]
        });
    });

    // Theme toggle script from navbar.jsp or your theme.js should handle body class
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    // const body = document.getElementById('pageBody'); // Already in navbar.jsp
    // const navbar = document.getElementById('mainNavbar'); // Already in navbar.jsp

    // Ensure applyTheme function (if defined here or included globally) is called
    // If navbar.jsp handles theme, this might be redundant unless pageBody needs specific handling.
    function applyLocalTheme(theme) { // Renamed to avoid conflict if navbar.jsp has its own
        const localBody = document.getElementById('pageBody');
        if (theme === 'dark') {
            localBody.classList.add('bg-dark', 'text-white');
            localBody.classList.remove('bg-light', 'text-dark');
        } else {
            localBody.classList.add('bg-light', 'text-dark');
            localBody.classList.remove('bg-dark', 'text-white');
        }
        // Navbar theme is handled by navbar.jsp's script
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light"; // Default to light
        applyLocalTheme(savedTheme); // Apply to this page's body

        if (themeToggleSwitch) {
            themeToggleSwitch.checked = (savedTheme === 'dark');
            // Event listener for theme toggle is likely in navbar.jsp,
            // but if you need to re-apply specifically to this body:
            themeToggleSwitch.addEventListener("change", () => {
                const newTheme = themeToggleSwitch.checked ? "dark" : "light";
                applyLocalTheme(newTheme);
            });
        }
    });
</script>
</body>