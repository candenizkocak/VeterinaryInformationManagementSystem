<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

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

    <div class="mb-3">
        <input type="text" id="clinicSearch" class="form-control" placeholder="Search by clinic name...">
    </div>

    <table class="table table-bordered table-striped" id="clinicTable">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Clinic Name</th>
            <th>Location</th>
            <th>Owner</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="clinicTableBody">
        <c:forEach var="clinic" items="${clinics}">
            <tr>
                <td>${clinic.clinicId}</td>
                <td>${clinic.clinicName}</td>
                <td>${clinic.location}</td>
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

    <div id="noResults" class="alert alert-warning d-none">No matching clinics found.</div>

    <div class="mt-3">
        <button id="prevPage" class="btn btn-secondary btn-sm">Previous</button>
        <button id="nextPage" class="btn btn-secondary btn-sm">Next</button>
    </div>
</div>

<script>
    const searchInput = document.getElementById("clinicSearch");
    const tableBody = document.getElementById("clinicTableBody");
    const rows = Array.from(tableBody.querySelectorAll("tr"));
    const rowsPerPage = 100;
    const noResults = document.getElementById("noResults");
    let currentPage = 1;

    function renderTable(filtered) {
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const paginated = filtered.slice(start, end);

        tableBody.innerHTML = "";
        paginated.forEach(row => tableBody.appendChild(row));
        noResults.classList.toggle("d-none", filtered.length > 0);
    }

    function updateTable() {
        const query = searchInput.value.toLowerCase();
        const filtered = rows.filter(row =>
            row.cells[1].textContent.toLowerCase().includes(query)
        );
        currentPage = 1;
        renderTable(filtered);
    }

    document.getElementById("prevPage").addEventListener("click", () => {
        if (currentPage > 1) {
            currentPage--;
            updateTable();
        }
    });

    document.getElementById("nextPage").addEventListener("click", () => {
        const query = searchInput.value.toLowerCase();
        const filtered = rows.filter(row =>
            row.cells[1].textContent.toLowerCase().includes(query)
        );
        const maxPage = Math.ceil(filtered.length / rowsPerPage);
        if (currentPage < maxPage) {
            currentPage++;
            renderTable(filtered);
        }
    });

    searchInput.addEventListener("keyup", updateTable);
    renderTable(rows);
</script>
