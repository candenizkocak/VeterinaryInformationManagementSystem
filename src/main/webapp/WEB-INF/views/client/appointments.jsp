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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css"> <%-- Tema CSS'i buradan yükleniyor --%>
</head>
<body id="pageBody" class="bg-light">
<jsp:include page="navbar.jsp"/> <%-- Navbar include'u body içine taşındı --%>

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
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [{ orderable: false, targets: -1 }],
            language: {
                searchPlaceholder: "Search appointments...",
                search: "",
            },
            // --- Search bar kaldırıldı ---
            "dom": '<"row"<"col-sm-12 col-md-6"l><"col-sm-12 col-md-6">>' + /* İkinci col-md-6 boş bırakıldı */
                '<"row"<"col-sm-12"tr>>' +
                '<"row"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>'
        });

        // Tema DataTables elementlerine otomatik olarak uygulanır
        applyThemeToDataTables(localStorage.getItem('theme') || 'light');
    });

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
            if(themeToggleSwitch) themeToggleSwitch.checked = true;
            applyThemeToDataTables('dark');
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
            if(themeToggleSwitch) themeToggleSwitch.checked = false;
            applyThemeToDataTables('light');
        }
        localStorage.setItem('theme', theme);

        const sliderBefore = document.querySelector('.slider:before');
        if (sliderBefore) {
            // İkonları navbar.jsp'deki script yönetecek, burada tekrar tanımlamak yerine
            // sadece tema değişimini tetikleyen ana fonksiyonun bir parçası olarak kalabilir.
        }
    }

    function applyThemeToDataTables(theme) {
        const isDark = theme === 'dark';
        const table = $('#clientAppointmentsTable');
        const wrapper = table.closest('.dataTables_wrapper');

        // Genel tablo ve wrapper için tema sınıfları
        wrapper.toggleClass('bg-dark', isDark);
        table.toggleClass('table-dark', isDark);
        table.find('thead').toggleClass('table-dark', isDark);

        wrapper.find('.dataTables_filter input, .dataTables_length select').each(function() {
            $(this).toggleClass('bg-dark text-white', isDark)
                .toggleClass('bg-light text-dark', !isDark)
                .css('border-color', isDark ? '#555' : '#ced4da');
        });

        wrapper.find('.dataTables_paginate .paginate_button').each(function() {
            $(this).toggleClass('bg-dark text-white', isDark)
                .toggleClass('bg-light text-dark', !isDark)
                .css('border-color', isDark ? '#444' : '#dee2e6');
        });
        wrapper.find('.dataTables_paginate .paginate_button.current').each(function() {
            $(this).toggleClass('bg-primary text-white', isDark)
                .css('border-color', isDark ? '#0d6efd' : '#0d6efd');
        });

        wrapper.find('.dataTables_info').toggleClass('text-white', isDark).toggleClass('text-muted', !isDark);

        // Tablo responsive container'ının kendi border-radius'u olmamalı, köşeleri card-body ve thead yönetiyor.
        $('.table-responsive').removeClass('rounded shadow');
        table.toggleClass('bg-dark', isDark).toggleClass('bg-light', !isDark);
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