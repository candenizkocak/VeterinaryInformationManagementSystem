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

<div class="container mt-5">
    <h2 class="mb-4">Edit Appointment</h2>

    <form action="${pageContext.request.contextPath}/admin/appointments/update" method="post" class="row g-3 mb-4">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>

        <div class="col-md-3">
            <label class="form-label">Pet</label>
            <select name="pet.petID" class="form-select" required>
                <option value="" disabled>Select a pet</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.petID}" <c:if test="${appointment.pet.petID == pet.petID}">selected</c:if>>${pet.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Clinic</label>
            <select id="clinicSelect" name="clinic.clinicId" class="form-select" required>
                <option value="" disabled>Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}" <c:if test="${appointment.clinic.clinicId == clinic.clinicId}">selected</c:if>>
                            ${clinic.clinicName} (${clinic.clinicId})
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Veterinary</label>
            <select id="veterinarySelect" name="veterinary.veterinaryId" class="form-select" required>
                <option value="" disabled selected>Select a veterinary</option>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Date</label>
            <input type="datetime-local" name="appointmentDate" value="${appointment.appointmentDate}" class="form-control" required/>
        </div>

        <div class="col-md-3">
            <label class="form-label">Status</label>
            <select name="status" class="form-select" required>
                <option value="Planned" ${appointment.status == 'Planned' ? 'selected' : ''}>Planned</option>
                <option value="Completed" ${appointment.status == 'Completed' ? 'selected' : ''}>Completed</option>
                <option value="Cancelled" ${appointment.status == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update Appointment</button>
            <a href="${pageContext.request.contextPath}/admin/appointments" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<!-- CLINIC → VETERINARY FILL -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const clinicSelect = document.getElementById("clinicSelect");
        const vetSelect = document.getElementById("veterinarySelect");
        const selectedVeterinaryId = "${appointment.veterinary.veterinaryId}";

        function loadVeterinaries(clinicId) {
            if (!clinicId || isNaN(clinicId)) {
                vetSelect.innerHTML = '<option disabled selected>Select a valid clinic first</option>';
                return;
            }

            fetch("/admin/appointments/veterinaries-by-clinic/" + clinicId)
                .then(res => res.json())
                .then(data => {
                    vetSelect.innerHTML = '';
                    if (!data || data.length === 0) {
                        vetSelect.innerHTML = '<option disabled selected>No veterinarians found</option>';
                        return;
                    }

                    data.forEach(vet => {
                        const option = document.createElement("option");
                        option.value = vet.veterinaryID;
                        option.textContent = (vet.firstName || '') + ' ' + (vet.lastName || '');
                        if (vet.veterinaryID == selectedVeterinaryId) {
                            option.selected = true;
                        }
                        vetSelect.appendChild(option);
                    });
                })
                .catch(() => {
                    vetSelect.innerHTML = '<option disabled selected>Error loading veterinarians</option>';
                });
        }

        clinicSelect.addEventListener("change", () => {
            loadVeterinaries(parseInt(clinicSelect.value));
        });

        const preSelectedClinicId = clinicSelect.value;
        if (preSelectedClinicId) {
            loadVeterinaries(parseInt(preSelectedClinicId));
        }
    });
</script>

<!-- THEME TOGGLE -->
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
