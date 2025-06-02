<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>My Appointments</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

    <!-- Genel tema CSS'i -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/appointments.css">

</head>
<body id="pageBody" class="bg-light">
<jsp:include page="navbar.jsp"/> <%-- Client modülüne özel navbar'ı dahil eder --%>

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold text-primary mb-0"><span style="font-size:1.6em;">🐾</span> My Appointments</h2>
        <a href="${pageContext.request.contextPath}/api/clients/appointments/book" class="btn btn-success btn-lg shadow-sm">
            <i class="fas fa-calendar-plus me-2"></i>Book New Appointment
        </a>
    </div>

    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card shadow rounded-4">
        <div class="card-body">
            <div class="table-responsive">
                <table id="clientAppointmentsTable" class="table table-hover align-middle mb-0">
                    <thead class="table-primary">
                    <tr>
                        <th class="text-center">ID</th>
                        <th class="text-center">Pet</th>
                        <th class="text-center">Clinic</th>
                        <th class="text-center">Veterinary</th>
                        <th class="text-center">Date & Time</th>
                        <th class="text-center">Status</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty appointments}">
                            <tr><td colspan="7" class="text-center py-5"><span class="display-6 text-muted">No appointments found</span></td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="appt" items="${appointments}">
                                <tr>
                                    <td class="text-center">${appt.appointmentId}</td>
                                    <td class="text-center">${appt.petName}</td>
                                    <td class="text-center">${appt.clinicName}</td>
                                    <td class="text-center">${appt.veterinaryName}</td>
                                    <td class="text-center">
                                        <span class="badge bg-light text-dark fs-6 shadow-sm px-3 py-2 rounded-pill">${appt.appointmentDate}</span>
                                    </td>
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${appt.status == 'Planned'}">
                                                <span class="badge bg-warning px-3 py-2 rounded-pill">Planned</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Completed'}">
                                                <span class="badge bg-success px-3 py-2 rounded-pill">Completed</span>
                                            </c:when>
                                            <c:when test="${appt.status == 'Cancelled'}">
                                                <span class="badge bg-danger px-3 py-2 rounded-pill">Cancelled</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary px-3 py-2 rounded-pill">${appt.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-center">
                                        <c:if test="${appt.status == 'Planned'}">
                                            <form action="${pageContext.request.contextPath}/api/clients/appointments/cancel/${appt.appointmentId}" method="post" style="display:inline;">
                                                <button type="submit"
                                                        class="btn btn-outline-danger shadow-sm btn-cancel-sm"
                                                        title="Cancel Appointment"
                                                        onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${appt.status != 'Planned'}">
                                            <span class="badge bg-light text-secondary rounded-pill fs-6">No Action</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#clientAppointmentsTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100], // Sayfada gösterilecek öğe sayısı seçenekleri
            searching: false, // Arama çubuğunu gizle
            info: true, // Bilgi metnini (Showing X to Y of Z entries) göster
            paging: true, // Sayfalama tuşlarını göster
            order: [], // Varsayılan sıralamayı kaldır (veya isteğe göre belirle)
            columnDefs: [
                { orderable: false, targets: -1 } // Son sütunu sıralanamaz yap
            ],
            language: { // Dil özelleştirmeleri
                lengthMenu: "Show _MENU_ entries", // "Show 10 entries"
                info: "Showing _START_ to _END_ of _TOTAL_ entries",
                infoEmpty: "Showing 0 to 0 of 0 entries",
                infoFiltered: "(filtered from _MAX_ total entries)",
                paginate: {
                    first: "First",
                    last: "Last",
                    next: "Next",
                    previous: "Previous"
                }
            },
            // DOM yapısını özelleştirerek arama kutusunu gizleyip sayfa uzunluğu ve sayfalama tuşlarını göster
            "dom": '<"top"l<"clear">><"table-responsive"t><"bottom"ip<"clear">>'

        });

        // Tema DataTables elementlerine otomatik olarak uygulanır
        applyThemeToDataTables(localStorage.getItem('theme') || 'light');
    });

    // Bu fonksiyon DataTables'ın tema adaptasyonunu yapar ve burada kalmalı.
    function applyThemeToDataTables(theme) {
        const isDark = theme === 'dark';
        const table = $('#clientAppointmentsTable');
        const wrapper = table.closest('.dataTables_wrapper');

        // DataTables wrapper ve tablo elementlerine tema sınıflarını uygula
        wrapper.toggleClass('bg-dark', isDark);
        table.toggleClass('table-dark', isDark);
        table.find('thead').toggleClass('table-dark', isDark);

        // Input ve select elementlerine tema sınıflarını uygula
        wrapper.find('.dataTables_filter input, .dataTables_length select').each(function() {
            $(this).toggleClass('bg-dark text-white', isDark)
                .toggleClass('bg-light text-dark', !isDark)
                .css('border-color', isDark ? '#555' : '#ced4da');
        });

        // Pagination butonlarına tema sınıflarını uygula
        wrapper.find('.dataTables_paginate .paginate_button').each(function() {
            $(this).toggleClass('bg-dark text-white', isDark)
                .toggleClass('bg-light text-dark', !isDark)
                .css('border-color', isDark ? '#444' : '#dee2e6');
        });
        wrapper.find('.dataTables_paginate .paginate_button.current').each(function() {
            $(this).toggleClass('bg-primary text-white', isDark)
                .css('border-color', isDark ? '#0d6efd' : '#0d6efd'); // Aktif butona özel stil
        });

        // Bilgi metnine tema sınıflarını uygula
        wrapper.find('.dataTables_info').toggleClass('text-white', isDark).toggleClass('text-muted', !isDark);

        $('.table-responsive').removeClass('rounded shadow');
        // Tablo background'unu da temaya göre ayarla
        table.toggleClass('bg-dark', isDark).toggleClass('bg-light', !isDark);
    }

    // Sayfa yüklendiğinde DataTables temasını ayarlar.
    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyThemeToDataTables(savedTheme);
    });
</script>

</body>
</html>