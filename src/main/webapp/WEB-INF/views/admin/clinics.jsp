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
    <h2 class="mb-4">Clinic Management</h2>

    <form action="/admin/clinics/create" method="post" class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Location</label>
            <input type="text" name="location" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Opening Hour</label>
            <input type="time" name="openingHour" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Closing Hour</label>
            <input type="time" name="closingHour" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}">${user.username}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Clinic</button>
        </div>
    </form>

    <table id="clinicTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Clinic Name</th>
            <th>Location</th>
            <th>Opening Hour</th>
            <th>Closing Hour</th>
            <th>Owner</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="clinic" items="${clinics}">
            <tr>
                <td>${clinic.clinicId}</td>
                <td>${clinic.clinicName}</td>
                <td>${clinic.location}</td>
                <td>${clinic.openingHour}</td>
                <td>${clinic.closingHour}</td>
                <td>${clinic.user.username}</td>
                <td>
                    <a href="/admin/clinics/edit/${clinic.clinicId}" class="btn btn-warning btn-sm">Edit</a>
                    <a href="/admin/pets/${clinic.clinicId}/pets" class="btn btn-info btn-sm">Pets</a>
                    <a href="/admin/clinics/${clinic.clinicId}/veterinaries" class="btn btn-primary btn-sm">Veterinaries</a>
                    <form action="/admin/clinics/delete/${clinic.clinicId}" method="post" style="display:inline;">
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
        $('#clinicTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });
    });
</script>

<script>
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

    document.addEventListener("DOMContentLoaded", () => {
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
