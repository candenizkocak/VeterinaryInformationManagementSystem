<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

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
    <h2 class="mb-4">Edit Pet for Clinic: ${clinicId}</h2>

    <form action="/admin/pets/update-clinic" method="post" class="row g-3">
        <input type="hidden" name="petID" value="${pet.petID}"/>
        <input type="hidden" name="clinic.clinicId" value="${clinicId}"/>

        <div class="col-md-4">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" value="${pet.name}" required>
        </div>

        <div class="col-md-2">
            <label class="form-label">Age</label>
            <input type="number" name="age" class="form-control" min="0" value="${pet.age}" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">Owner</label>
            <select name="client.clientId" class="form-select" required>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.clientId}" <c:if test="${client.clientId == pet.client.clientId}">selected</c:if>>
                            ${client.firstName} ${client.lastName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Species</label>
            <select name="species.speciesID" class="form-select" required>
                <c:forEach var="species" items="${speciesList}">
                    <option value="${species.speciesID}" <c:if test="${species.speciesID == pet.species.speciesID}">selected</c:if>>
                            ${species.speciesName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Breed</label>
            <select name="breed.breedID" class="form-select" required>
                <c:forEach var="breed" items="${breeds}">
                    <option value="${breed.breedID}" <c:if test="${breed.breedID == pet.breed.breedID}">selected</c:if>>
                            ${breed.breedName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Gender</label>
            <select name="gender.genderID" class="form-select" required>
                <c:forEach var="gender" items="${genders}">
                    <option value="${gender.genderID}" <c:if test="${gender.genderID == pet.gender.genderID}">selected</c:if>>
                            ${gender.genderName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="/admin/pets/${clinicId}/pets" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

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
