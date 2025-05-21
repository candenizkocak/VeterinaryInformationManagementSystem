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
    <h2 class="mb-4">Assign Clinic to ${veterinary.firstName} ${veterinary.lastName}</h2>

    <form action="/admin/veterinaries/${veterinary.veterinaryId}/assign-clinic" method="post">
        <div class="mb-3">
            <label class="form-label">Select Clinic</label>
            <select name="clinicId" class="form-select" required>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}">${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Assign</button>
        <a href="/admin/veterinaries" class="btn btn-secondary">Back</a>
    </form>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const body = document.getElementById("pageBody");

        function applyTheme(theme) {
            if (theme === "dark") {
                body.classList.add("bg-dark", "text-white");
                body.classList.remove("bg-light", "text-dark");
            } else {
                body.classList.add("bg-light", "text-dark");
                body.classList.remove("bg-dark", "text-white");
            }
        }

        const currentTheme = localStorage.getItem("theme") || "light";
        applyTheme(currentTheme);

        const toggleBtn = document.getElementById("themeToggle");
        if (toggleBtn) {
            toggleBtn.addEventListener("click", () => {
                const newTheme = localStorage.getItem("theme") === "dark" ? "light" : "dark";
                localStorage.setItem("theme", newTheme);
                applyTheme(newTheme);
            });
        }
    });
</script>

</body>
