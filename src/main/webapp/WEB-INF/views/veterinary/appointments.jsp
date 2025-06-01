<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<!-- STYLES and SCRIPTS (mevcut olanlar) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

<body id="pageBody">
<div class="container mt-5">
    <c:choose>
        <c:when test="${not empty appointment.appointmentId}">
            <h2 class="mb-4">Edit Appointment & Log Visit Details</h2>
        </c:when>
        <c:otherwise>
            <h2 class="mb-4">Add New Appointment</h2>
        </c:otherwise>
    </c:choose>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success">${successMessage}</div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger">${errorMessage}</div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger">Access denied or resource not found.</div>
    </c:if>

    <%-- Formun action'ı dinamik olarak ayarlanacak.
         Eklerken hem tarih hem saat, güncellerken LocalDateTime lazım olacak.
         Controller'da @RequestParam ile tarih ve saat ayrı alınıp birleştirilebilir.
    --%>
    <form id="appointmentForm" action="/veterinary/appointments/${empty appointment.appointmentId ? 'add' : 'update'}" method="post" class="mb-4">
        <c:if test="${not empty appointment.appointmentId}">
            <input type="hidden" name="appointmentId" value="${appointment.appointmentId}"/>
        </c:if>
        <input type="hidden" name="veterinary.veterinaryId" value="${loggedInVeterinary.veterinaryId}" />
        <c:if test="${not empty medicalRecord.medicalRecordId}">
            <input type="hidden" name="existingMedicalRecordId" value="${medicalRecord.medicalRecordId}" />
        </c:if>
        <%-- Bu hidden input AJAX ile doldurulacak tarih ve saati birleştirecek --%>
        <input type="hidden" id="appointmentDateTimeCombined" name="appointmentDate" />


        <fieldset class="border p-3 mb-3">
            <legend class="w-auto px-2 h5">Appointment Details</legend>
            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Pet</label>
                    <select name="pet.petID" class="form-select" required>
                        <option value="" disabled <c:if test="${empty appointment.pet}">selected</c:if>>Select a pet</option>
                        <c:forEach var="pet" items="${pets}">
                            <option value="${pet.petID}" <c:if test="${not empty appointment.pet && appointment.pet.petID == pet.petID}">selected</c:if>>${pet.name} (Owner: ${pet.client.firstName} ${pet.client.lastName})</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Clinic</label>
                    <select id="clinicSelect" name="clinic.clinicId" class="form-select" required>
                        <option value="" disabled <c:if test="${empty appointment.clinic}">selected</c:if>>Select a clinic</option>
                        <c:forEach var="clinic" items="${clinics}">
                            <option value="${clinic.clinicId}" <c:if test="${not empty appointment.clinic && appointment.clinic.clinicId == clinic.clinicId}">selected</c:if>>${clinic.clinicName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label">Veterinary</label>
                    <input type="text" class="form-control" value="${loggedInVeterinary.firstName} ${loggedInVeterinary.lastName}" readonly />
                </div>

                <%-- ESKİ DATETIME-LOCAL INPUT YORUMA ALINDI
                <div class="col-md-6">
                    <label class="form-label">Date & Time</label>
                    <input type="datetime-local" name="appointmentDate" value="${appointment.appointmentDate}" class="form-control" required/>
                </div>
                --%>

                <%-- YENİ TARİH VE SAAT INPUT'LARI --%>
                <div class="col-md-3">
                    <label class="form-label">Date</label>
                    <input type="date" id="appointmentDateInput" class="form-control" required
                           value="${not empty appointment.appointmentDate ? appointment.appointmentDate.toLocalDate().toString() : ''}"/>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Time</label>
                    <select id="appointmentTimeSelect" class="form-select" required>
                        <option value="">Select date and clinic first</option>
                        <c:if test="${not empty appointment.appointmentDate}">
                            <c:set var="selectedTime">
                                <fmt:formatDate value="${appointment.appointmentDate}" type="time" pattern="HH:mm" />
                            </c:set>
                            <option value="${selectedTime}" selected>${selectedTime}</option>
                        </c:if>
                    </select>
                </div>


                <div class="col-md-6">
                    <label class="form-label">Status</label>
                    <select name="status" class="form-select" required>
                        <option value="Planned" <c:if test="${empty appointment.status || appointment.status == 'Planned'}">selected</c:if>>Planned</option>
                        <option value="Completed" <c:if test="${not empty appointment.status && appointment.status == 'Completed'}">selected</c:if>>Completed</option>
                        <option value="Cancelled" <c:if test="${not empty appointment.status && appointment.status == 'Cancelled'}">selected</c:if>>Cancelled</option>
                    </select>
                </div>
            </div>
        </fieldset>

        <%-- ... (Medical Record, Add Vaccination, Add Surgery fieldset'leri eskisi gibi kalabilir) ... --%>
        <c:if test="${not empty appointment.appointmentId}"> <%-- Show clinical fields only when editing --%>
            <%-- Medical Record Fieldset --%>
            <fieldset class="border p-3 mb-3">
                <legend class="w-auto px-2 h5">Medical Record</legend>
                <div class="row g-3">
                    <div class="col-12">
                        <label for="medicalRecordDescription" class="form-label">Description / Diagnosis</label>
                        <textarea id="medicalRecordDescription" name="medicalRecordDescription" class="form-control" rows="3">${medicalRecord.description}</textarea>
                    </div>
                    <div class="col-12">
                        <label for="medicalRecordTreatment" class="form-label">Treatment Plan</label>
                        <textarea id="medicalRecordTreatment" name="medicalRecordTreatment" class="form-control" rows="3">${medicalRecord.treatment}</textarea>
                    </div>
                </div>
            </fieldset>

            <%-- Add Surgery Fieldset (Vaccination'ı kaldırdık, bu kalabilir veya bu da ayrı sayfaya taşınabilir) --%>
            <fieldset class="border p-3 mb-3">
                <legend class="w-auto px-2 h5">Add Surgery (Performed during this visit)</legend>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label for="selectedSurgeryTypeId" class="form-label">Surgery Type (Optional)</label>
                        <select id="selectedSurgeryTypeId" name="selectedSurgeryTypeId" class="form-select">
                            <option value="">-- Select Surgery Type Performed --</option>
                            <c:forEach var="st" items="${allSurgeryTypes}">
                                <option value="${st.surgeryTypeId}">${st.typeName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label for="surgeryNotes" class="form-label">Surgery Notes</label>
                        <textarea id="surgeryNotes" name="surgeryNotes" class="form-control" rows="2"></textarea>
                    </div>
                </div>
            </fieldset>
        </c:if>


        <div class="col-12 mt-3">
            <button type="submit" class="btn btn-success">${empty appointment.appointmentId ? 'Add Appointment' : 'Update Appointment & Records'}</button>
            <a href="/veterinary/appointments" class="btn btn-secondary">Cancel</a>
        </div>
    </form>

    <hr/>
    <h3 class="mb-3">My Scheduled Appointments</h3>
    <table id="appointmentTable" class="table table-bordered table-striped">
        <%-- ... (Tablo içeriği aynı kalabilir, Manage Vaccinations ve Manage Surgeries linkleri doğru olmalı) ... --%>
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Pet</th>
            <th>Client</th>
            <th>Clinic</th>
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
                <td>${appt.appointmentDate}</td>
                <td>${appt.status}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/veterinary/appointments/${appt.appointmentId}/vaccinations" class="btn btn-info btn-sm">
                        Vaccinations
                    </a>

                    <a href="${pageContext.request.contextPath}/veterinary/appointments/${appt.appointmentId}/surgeries" class="btn btn-warning btn-sm"> <%-- YENİ LİNK --%>
                        Surgeries
                    </a>

                    <form action="/veterinary/appointments/delete/${appt.appointmentId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function () {
        $('#appointmentTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [ { orderable: false, targets: -1 } ]
        });

        const clinicSelect = $('#clinicSelect');
        const dateInput = $('#appointmentDateInput');
        const timeSelect = $('#appointmentTimeSelect');
        const combinedDateTimeInput = $('#appointmentDateTimeCombined'); // Hidden input

        function fetchAvailableSlots() {
            const clinicId = clinicSelect.val();
            const selectedDate = dateInput.val();

            if (clinicId && selectedDate) {
                // Veteriner ID'si principal'dan controller'da alınacak, buraya göndermeye gerek yok
                // const veterinaryId = $('input[name="veterinary.veterinaryId"]').val(); // Eğer JSP'de varsa

                timeSelect.empty().append('<option value="">Loading...</option>'); // Clear and show loading

                $.ajax({
                    url: '${pageContext.request.contextPath}/veterinary/appointments/available-slots',
                    type: 'GET',
                    data: {
                        clinicId: clinicId,
                        date: selectedDate
                        // veterinaryId: veterinaryId // Controller principal'dan alacak
                    },
                    success: function(slots) {
                        timeSelect.empty(); // Clear loading/previous options
                        if (slots && slots.length > 0) {
                            slots.forEach(function(slot) {
                                timeSelect.append($('<option>', {
                                    value: slot,
                                    text: slot
                                }));
                            });
                            // Eğer düzenleme modundaysak ve seçili bir saat varsa onu seçili yap
                            const initialTime = "${not empty appointment.appointmentDate ? appointment.appointmentDate.toLocalTime().format(DateTimeFormatter.ofPattern('HH:mm')) : ''}";
                            if (initialTime) {
                                timeSelect.val(initialTime);
                            }

                        } else {
                            timeSelect.append('<option value="">No slots available</option>');
                        }
                        updateCombinedDateTime(); // Saati seçtikten sonra da güncelle
                    },
                    error: function() {
                        timeSelect.empty().append('<option value="">Error loading slots</option>');
                         updateCombinedDateTime();
                    }
                });
            } else {
                timeSelect.empty().append('<option value="">Select date and clinic first</option>');
                 updateCombinedDateTime();
            }
        }

        // Tarih veya Klinik değiştiğinde saatleri getir
        clinicSelect.on('change', fetchAvailableSlots);
        dateInput.on('change', fetchAvailableSlots);

        // Saat seçimi değiştiğinde birleşik değeri güncelle
        timeSelect.on('change', updateCombinedDateTime);

        // Birleşik tarih-saat değerini hidden input'a set et
        function updateCombinedDateTime() {
            const selectedDate = dateInput.val();
            const selectedTime = timeSelect.val();

            if (selectedDate && selectedTime) {
                combinedDateTimeInput.val(selectedDate + 'T' + selectedTime + ':00'); // ISO 8601 formatına yakın (saniye eksik)
                                                                                    // Controller bunu LocalDateTime'a parse edebilmeli
            } else {
                combinedDateTimeInput.val('');
            }
        }

        // Sayfa yüklendiğinde, eğer düzenleme modundaysak ve tarih/klinik seçiliyse saatleri getir
        if (dateInput.val() && clinicSelect.val()) {
            fetchAvailableSlots();
        }


        // Form gönderilmeden önce birleşik değeri güncelle
        $('#appointmentForm').on('submit', function() {
            updateCombinedDateTime();
            // Eğer combinedDateTimeInput boşsa ve tarih/saat zorunluysa formu göndermeyi engelle
            if (!combinedDateTimeInput.val() && dateInput.prop('required') && timeSelect.prop('required')) {
                alert('Please select a date and time.');
                return false; // Formu gönderme
            }
        });
    });
    // Tema script (mevcut olan)
</script>
</body>
</html>