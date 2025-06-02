<%-- src/main/webapp/WEB-INF/views/client/book_appointment.jsp --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Book Appointment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        /* ... CSS stilleri ... */
        .appt-card {
            max-width: 550px; margin: 40px auto; border-radius: 18px;
            box-shadow: 0 8px 36px 0 #1c4c8c14; padding: 35px 32px 28px 32px;
            background: #fff;
        }
        .appt-title {
            font-size: 2.0rem; color: #1066ee; font-weight: 600; text-align: center; margin-bottom: 27px;
        }
        .form-label { font-weight: 500; color: #27496d;}
        .form-control, .form-select { border-radius: 12px; font-size: 1.09rem; padding: 11px 12px;}
        .btn-appt { background: #157afe; border: none; font-size: 1.08rem; padding: 13px; border-radius: 10px; font-weight: 500; letter-spacing: 1px; margin-top: 10px; transition: 0.2s;}
        .btn-appt:hover { background: #1066ee;}
        .alert { border-radius: 10px; font-size: 1.08rem; margin-bottom: 23px;}
        /* Dark theme specific adjustments */
        body.bg-dark .appt-card {
            background: #2b2b2b;
            color: #fff;
            box-shadow: 0 8px 36px 0 rgba(0, 0, 0, 0.4);
        }
        body.bg-dark .appt-title {
            color: #6da7f7; /* Lighter blue for dark mode */
        }
        body.bg-dark .form-label {
            color: #ccc;
        }
        body.bg-dark .form-control, body.bg-dark .form-select {
            background-color: #1e1e1e !important;
            color: #fff !important;
            border-color: #555 !important;
        }
        body.bg-dark .form-control::placeholder {
            color: #aaa !important;
        }
        body.bg-dark .form-select option {
            background-color: #1e1e1e;
            color: #fff;
        }
    </style>
</head>
<body id="pageBody">
<jsp:include page="../navbar.jsp"/>

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
                    <option value="${pet.petID}">${pet.name} (${pet.species.speciesName})</option>                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label for="clinicSelect" class="form-label">Select Clinic:</label>
            <select name="clinicId" id="clinicSelect" class="form-select" required>
                <option value="">Select a clinic</option>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}">${clinic.clinicName} (${clinic.location})</option>
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

        <button type="submit" class="btn btn-appt w-100">Book Appointment</button>
        <a href="${pageContext.request.contextPath}/api/clients/appointments" class="btn btn-secondary mt-2 w-100">Back to Appointments</a>
    </form>
</div>

<!-- Bootstrap JS (for modals) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        const petSelect = $('#petSelect'); // Pet select eklendi
        const clinicSelect = $('#clinicSelect');
        const dateInput = $('#dateInput');
        const veterinarySelect = $('#veterinarySelect');
        const timeSelect = $('#timeSelect');

        // Function to fetch and populate veterinarians based on clinic and date
        function fetchVeterinariesAndResetTimes() {
            const clinicId = clinicSelect.val();
            const selectedDate = dateInput.val(); // YYYY-MM-DD formatında string
            console.log('Fetching vets for clinic:', clinicId, 'on date:', selectedDate);

            veterinarySelect.empty().append('<option value="">Loading veterinarians...</option>');
            veterinarySelect.prop('disabled', true); // Yeni istek başladığında disable et

            timeSelect.empty().append('<option value="">Select veterinary first</option>');
            timeSelect.prop('disabled', true); // Veterinerler yüklenirken saati de disable et

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
                                    value: vet.veterinaryId, // HATA BURADAYDI: veterinaryID yerine veterinaryId olmalı
                                    text: vet.firstName + ' ' + vet.lastName + ' (' + vet.specialization + ')'
                                }));
                            });
                            veterinarySelect.prop('disabled', false); // Başarılıysa enable et
                        } else {
                            veterinarySelect.append('<option value="">No veterinarians available for this clinic/date</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error fetching veterinarians:", status, error); // Hata logu
                        veterinarySelect.empty().append('<option value="">Error loading veterinarians</option>');
                    }
                });
            } else {
                veterinarySelect.empty().append('<option value="">Select clinic and date first</option>');
            }
        }

        // Function to fetch and populate available time slots
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

        // Event listeners
        clinicSelect.on('change', fetchVeterinariesAndResetTimes);
        dateInput.on('change', fetchVeterinariesAndResetTimes);

        veterinarySelect.on('change', fetchAvailableSlots);

        // Initial call on page load if clinic/date/vet are pre-selected (not in this case, but good practice)
        // If you were editing an appointment, you'd call fetchVeterinariesAndResetTimes here with initial values
        if (clinicSelect.val() && dateInput.val()) {
            fetchVeterinariesAndResetTimes();
        }
    });
</script>
</body>
</html>