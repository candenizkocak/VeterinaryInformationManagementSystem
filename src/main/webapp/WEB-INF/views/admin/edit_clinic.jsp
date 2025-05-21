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
    <h2 class="mb-4">Edit Clinic</h2>

    <form action="/admin/clinics/update" method="post" class="row g-3">
        <input type="hidden" name="clinicId" value="${clinic.clinicId}"/>

        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" value="${clinic.clinicName}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Location</label>
            <input type="text" name="location" class="form-control" value="${clinic.location}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}" <c:if test="${user.userID == clinic.user.userID}">selected</c:if>>
                            ${user.username}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Opening Hour</label>
            <input type="time" name="openingHour" class="form-control" value="${clinic.openingHour}" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Closing Hour</label>
            <input type="time" name="closingHour" class="form-control" value="${clinic.closingHour}" required>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update Clinic</button>
            <a href="/admin/clinics" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

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
