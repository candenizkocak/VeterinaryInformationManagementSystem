<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Appointment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <!-- Genel tema CSS'i (global stiller için) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/book_appointment.css">
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/>

<div class="appt-card">
    <div class="appt-title"><i class="bi bi-calendar-plus"></i> Book New Appointment</div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success text-center">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger text-center">${errorMessage}</div>
    </c:if>

    <form id="bookAppointmentForm" action="${pageContext.request.contextPath}/api/clients/appointments/book" method="post">
        <div class="mb-3">
            <label for="petSelect" class="form-label">Select Your Animal:</label>
            <select name="petId" id="petSelect" class="form-select" required>
                <option value="">Select a pet</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.petID}">${pet.name} (${pet.species.speciesName})</option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label for="clinicSelect" class="form-label">Select Clinic:</label>
            <select name="clinicId" id="clinicSelect" class="form-select" required>
                <option value="">Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}">${clinic.clinicName} (${clinic.formattedAddress})</option> <%-- formattedAddress kullanıldı --%>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label for="dateInput" class="form-label">Select Date:</label>
            <input type="date" name="appointmentDate" id="dateInput" class="form-control" required min="${today}"/>
        </div>

        <div class="mb-3">
            <label for="veterinarySelect" class="form-label">Select Veterinary:</label>
            <select name="veterinaryId" id="veterinarySelect" class="form-select" required>
                <option value="">Select clinic and date first</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="timeSelect" class="form-label">Select Time:</label>
            <select name="appointmentTime" id="timeSelect" class="form-select" required>
                <option value="">Select clinic, date, and veterinary first</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="notes" class="form-label">Reason for visit (optional):</label>
            <textarea name="notes" id="notes" class="form-control" rows="2"></textarea>
        </div>

        <div class="d-flex flex-column align-items-center justify-content-center">
            <button type="submit" class="btn-main-appt">
                <span style="font-size:1.3em; margin-right: 7px;">📅</span> Book Appointment
            </button>
            <a href="${pageContext.request.contextPath}/api/clients/appointments" class="btn-secondary-appt">
                Back to Appointments
            </a>
        </div>
    </form>
</div>

<!-- Bootstrap JS (for modals) -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        const petSelect = $('#petSelect');
        const clinicSelect = $('#clinicSelect');
        const dateInput = $('#dateInput');
        const veterinarySelect = $('#veterinarySelect');
        const timeSelect = $('#timeSelect');

        const preselectedClinicId = ${not empty preselectedClinicId ? preselectedClinicId : 'null'};
        const preselectedVeterinaryId = ${not empty preselectedVeterinaryId ? preselectedVeterinaryId : 'null'};
        const initialAppointmentDate = '${param.appointmentDate}';

        function fetchVeterinariesAndResetTimes() {
            const clinicId = clinicSelect.val();
            const selectedDate = dateInput.val();
            console.log('Fetching vets for clinic:', clinicId, 'on date:', selectedDate);

            veterinarySelect.empty().append('<option value="">Loading veterinarians...</option>');
            veterinarySelect.prop('disabled', true);

            timeSelect.empty().append('<option value="">Select veterinary first</option>');
            timeSelect.prop('disabled', true);

            if (clinicId && selectedDate) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/clients/veterinaries-by-clinic-and-date',
                    type: 'GET',
                    data: { clinicId: clinicId, date: selectedDate },
                    success: function(vets) {
                        veterinarySelect.empty().append('<option value="">Select a veterinary</option>');
                        if (vets && vets.length > 0) {
                            vets.forEach(function(vet) {
                                veterinarySelect.append($('<option>', {
                                    value: vet.veterinaryId,
                                    text: vet.firstName + ' ' + vet.lastName + ' (' + vet.specialization + ')'
                                }));
                            });
                            veterinarySelect.prop('disabled', false);


                            if (preselectedVeterinaryId !== null) {
                                veterinarySelect.val(preselectedVeterinaryId);
                                fetchAvailableSlots();
                            }
                        } else {
                            veterinarySelect.append('<option value="">No veterinarians available for this clinic/date</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error fetching veterinarians:", status, error);
                        veterinarySelect.empty().append('<option value="">Error loading veterinarians</option>');
                    }
                });
            } else {
                veterinarySelect.empty().append('<option value="">Select clinic and date first</option>');
            }
        }

        function fetchAvailableSlots() {
            const clinicId = clinicSelect.val();
            const veterinaryId = veterinarySelect.val();
            const selectedDate = dateInput.val();

            timeSelect.empty().append('<option value="">Loading time slots...</option>');
            timeSelect.prop('disabled', true);

            if (clinicId && veterinaryId && selectedDate) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/clients/appointments/available-slots',
                    type: 'GET',
                    data: { clinicId: clinicId, veterinaryId: veterinaryId, date: selectedDate },
                    success: function(slots) {
                        timeSelect.empty().append('<option value="">Select a time</option>');
                        if (slots && slots.length > 0) {
                            slots.forEach(function(slot) {
                                timeSelect.append($('<option>', {
                                    value: slot,
                                    text: slot
                                }));
                            });
                            timeSelect.prop('disabled', false);
                        } else {
                            timeSelect.append('<option value="">No slots available for this time/vet</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error fetching available slots:", status, error);
                        timeSelect.empty().append('<option value="">Error loading time slots</option>');
                    }
                });
            } else {
                timeSelect.empty().append('<option value="">Select clinic, date, and veterinary first</option>');
            }
        }


        clinicSelect.on('change', fetchVeterinariesAndResetTimes);
        dateInput.on('change', fetchVeterinariesAndResetTimes);
        veterinarySelect.on('change', fetchAvailableSlots);


        if (preselectedClinicId !== null) {
            clinicSelect.val(preselectedClinicId);

            if (initialAppointmentDate) {
                dateInput.val(initialAppointmentDate);
            }

            fetchVeterinariesAndResetTimes();
        }
    });
</script>
</body>
</html>