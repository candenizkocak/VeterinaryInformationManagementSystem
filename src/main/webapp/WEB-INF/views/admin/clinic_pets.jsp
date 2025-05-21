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
    <h2 class="mb-4">Pets of Clinic: ${clinic.clinicName}</h2>

    <form action="/admin/pets/${clinic.clinicId}/pets/create" method="post" class="row g-3 mb-4">
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
            <select name="client.clientID" class="form-select" required>
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

        <input type="hidden" name="clinic.clinicId" value="${clinic.clinicId}"/>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Pet</button>
        </div>
    </form>

    <table id="petTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Species</th>
            <th>Breed</th>
            <th>Gender</th>
            <th>Client</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="pet" items="${pets}">
            <tr>
                <td>${pet.petID}</td>
                <td>${pet.name}</td>
                <td>${pet.age}</td>
                <td>${pet.species.speciesName}</td>
                <td>${pet.breed.breedName}</td>
                <td>${pet.gender.genderName}</td>
                <td>${pet.client.firstName} ${pet.client.lastName}</td>
                <td>
                    <a href="/admin/pets/${clinic.clinicId}/pets/edit/${pet.petID}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/pets/delete/${pet.petID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this pet?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function () {
        $('#petTable').DataTable({
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
