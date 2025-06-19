<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<body id="pageBody">

<jsp:include page="../client/navbar.jsp"/>
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
    <h2 class="mb-4">Medical Records for Pet: ${pet.name}</h2>

    <!-- Form -->
    <form action="/admin/medical-records/save" method="post" class="row g-3 mb-4">
        <input type="hidden" name="pet.petID" value="${pet.petID}" />

        <div class="col-md-4">
            <label class="form-label">Date</label>
            <input type="date" name="date" class="form-control" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Veterinary</label>
            <select name="veterinary.veterinaryId" class="form-select" required>
                <option value="" disabled selected>Select a veterinary</option>
                <c:forEach var="vet" items="${veterinaries}">
                    <option value="${vet.veterinaryId}">${vet.firstName} ${vet.lastName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-6">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="2" required></textarea>
        </div>

        <div class="col-md-6">
            <label class="form-label">Treatment</label>
            <textarea name="treatment" class="form-control" rows="2" required></textarea>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Medical Record</button>
        </div>
    </form>

    <!-- Medical Record Table -->
    <c:if test="${empty records}">
        <div class="alert alert-info">No medical records found for this pet.</div>
    </c:if>

    <c:if test="${not empty records}">
        <table id="medicalrecordsTable" class="table table-bordered table-striped">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Date</th>
                <th>Veterinary</th>
                <th>Description</th>
                <th>Treatment</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="record" items="${records}">
                <tr>
                    <td>${record.medicalRecordId}</td>
                    <td>${record.date}</td>
                    <td>${record.veterinary.firstName} ${record.veterinary.lastName}</td>
                    <td>${record.description}</td>
                    <td>${record.treatment}</td>
                    <td>
                        <a href="/admin/medical-records/edit/${record.medicalRecordId}" class="btn btn-sm btn-primary">Edit</a>
                        <a href="/admin/medical-records/delete/${record.medicalRecordId}" class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to delete this record?');">Delete</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <a href="/admin/pets" class="btn btn-secondary mt-3">Back to Pet List</a>
</div>

<script>
    $(document).ready(function () {
        $('#medicalrecordsTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });
    });
</script>

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
