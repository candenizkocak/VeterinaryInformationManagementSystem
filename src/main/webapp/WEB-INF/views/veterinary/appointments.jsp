<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Appointment Management</h2>

    <form action="/admin/appointments/${appointment.appointmentId == null ? 'add' : 'update'}" method="post" class="row g-3 mb-4">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>

        <div class="col-md-3">
            <label class="form-label">Pet</label>
            <select name="pet.petID" class="form-select" required>
                <option disabled>Select a pet</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.petID}" <c:if test="${appointment.pet.petID == pet.petID}">selected</c:if>>${pet.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Clinic</label>
            <select id="clinicSelect" name="clinic.clinicId" class="form-select" required>
                <option value="" disabled selected>Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}" <c:if test="${appointment.clinic.clinicId == clinic.clinicId}">selected</c:if>>${clinic.clinicName}</option>
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
            <button type="submit" class="btn btn-success">${appointment.appointmentId == null ? 'Add' : 'Update'} Appointment</button>
        </div>
    </form>

    <table class="table table-bordered table-striped">
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
                <td>${appt.petName}</td>  <%-- Now using DTO property --%>
                <td>${appt.clientName}</td> <%-- Added client name --%>
                <td>${appt.clinicName}</td> <%-- Now using DTO property --%>
                <td>${appt.veterinaryName}</td> <%-- Now using DTO property --%>
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
    document.getElementById("clinicSelect").addEventListener("change", function () {
        const clinicId = this.value;
        const vetSelect = document.getElementById("veterinarySelect");

        console.log("Selected clinic ID:", clinicId);
        vetSelect.innerHTML = '<option value="">Loading...</option>';

        if (!clinicId || isNaN(Number(clinicId))) {
            vetSelect.innerHTML = '<option disabled selected>Select a valid clinic first</option>';
            return;
        }

        fetch(`/admin/appointments/veterinaries-by-clinic/${clinicId}`)
            .then(res => {
                if (!res.ok) throw new Error("Network response was not ok");
                return res.json();
            })
            .then(data => {
                vetSelect.innerHTML = '';
                if (data.length === 0) {
                    vetSelect.innerHTML = '<option disabled selected>No veterinarians found</option>';
                    return;
                }

                data.forEach(vet => {
                    const option = document.createElement("option");
                    option.value = vet.veterinaryID;
                    option.textContent = `${vet.firstName} ${vet.lastName}`;
                    vetSelect.appendChild(option);
                });
            })
            .catch(err => {
                console.error("FETCH ERROR:", err);
                vetSelect.innerHTML = '<option disabled selected>Error loading veterinarians</option>';
            });
    });
</script>
