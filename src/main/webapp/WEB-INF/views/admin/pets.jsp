<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Pet Management</h2>

    <!-- Pet Adding Form -->
    <form action="/admin/pets/create" method="post" class="row g-3 mb-4">
        <div class="col-md-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="col-md-2">
            <label class="form-label">Age</label>
            <input type="number" name="age" class="form-control" min="0" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Owner</label>
            <select name="client.clientId" class="form-select" required>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.clientId}">${client.firstName} ${client.lastName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Species</label>
            <select name="species.speciesID" class="form-select" required>
                <c:forEach var="species" items="${speciesList}">
                    <option value="${species.speciesID}">${species.speciesName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Breed</label>
            <select name="breed.breedID" class="form-select" required>
                <c:forEach var="breed" items="${breeds}">
                    <option value="${breed.breedID}">${breed.breedName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Gender</label>
            <select name="gender.genderID" class="form-select" required>
                <c:forEach var="gender" items="${genders}">
                    <option value="${gender.genderID}">${gender.genderName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Clinic</label>
            <select name="clinic.clinicId" class="form-select" required>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}">${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Pet</button>
        </div>
    </form>

    <!-- Search Input -->
    <div class="mb-3">
        <input type="text" id="petSearch" class="form-control" placeholder="Search by name...">
    </div>

    <!-- Table -->
    <table class="table table-bordered table-striped" id="petTable">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Species</th>
            <th>Breed</th>
            <th>Gender</th>
            <th>Client</th>
            <th>Clinic</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="petTableBody">
        <c:forEach var="pet" items="${pets}">
            <tr>
                <td>${pet.petID}</td>
                <td>${pet.name}</td>
                <td>${pet.age}</td>
                <td>${pet.species.speciesName}</td>
                <td>${pet.breed.breedName}</td>
                <td>${pet.gender.genderName}</td>
                <td>${pet.client.firstName} ${pet.client.lastName}</td>
                <td>${pet.clinic.clinicName}</td>
                <td>
                    <a href="/admin/pets/edit/${pet.petID}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/pets/delete/${pet.petID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this pet?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div id="noResults" class="alert alert-warning d-none">No matching pets found.</div>
    <div class="mt-3">
        <button id="prevPage" class="btn btn-secondary btn-sm">Previous</button>
        <button id="nextPage" class="btn btn-secondary btn-sm">Next</button>
    </div>
</div>

<script>
    const searchInput = document.getElementById("petSearch");
    const tableBody = document.getElementById("petTableBody");
    const noResultsDiv = document.getElementById("noResults");
    const rows = Array.from(tableBody.querySelectorAll("tr"));
    const rowsPerPage = 100;
    let currentPage = 1;

    function renderTable(filteredRows) {
        const start = (currentPage - 1) * rowsPerPage;
        const end = start + rowsPerPage;
        const paginated = filteredRows.slice(start, end);

        tableBody.innerHTML = "";
        paginated.forEach(row => tableBody.appendChild(row));
        noResultsDiv.classList.toggle("d-none", filteredRows.length > 0);
    }

    function updateTable() {
        const query = searchInput.value.toLowerCase();
        const filtered = rows.filter(row => row.cells[1].textContent.toLowerCase().includes(query));
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
        const filtered = rows.filter(row => row.cells[1].textContent.toLowerCase().includes(query));
        const maxPage = Math.ceil(filtered.length / rowsPerPage);
        if (currentPage < maxPage) {
            currentPage++;
            renderTable(filtered);
        }
    });

    searchInput.addEventListener("keyup", updateTable);
    renderTable(rows);
</script>
