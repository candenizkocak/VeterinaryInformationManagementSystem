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
    <h2 class="mb-4">Clients and their Pets for ${clinic.clinicName}</h2>

    <c:if test="${empty clients}">
        <div class="alert alert-info text-center">No clients or pets registered to your clinic yet.</div>
    </c:if>
    <c:if test="${not empty clients}">
        <c:forEach var="client" items="${clients}">
            <div class="card mb-4">
                <div class="card-header bg-primary text-white">
                    Client: ${client.firstName} ${client.lastName} (${client.user.username})
                    - Address:
                        ${client.streetAddress}
                    <c:if test="${not empty client.apartmentNumber}">
                        , Daire: ${client.apartmentNumber}
                    </c:if>
                    <c:if test="${not empty client.locality}">
                        , ${client.locality.name}
                    </c:if>
                    <c:if test="${not empty client.locality.district}">
                        / ${client.locality.district.name}
                    </c:if>
                    <c:if test="${not empty client.locality.district.city}">
                        / ${client.locality.district.city.name}
                    </c:if>
                    <c:if test="${not empty client.postalCode}">
                        - ${client.postalCode}
                    </c:if>
                </div>
                <div class="card-body">
                    <h5>Pets:</h5>
                    <c:set var="hasPetsForClinic" value="false" />
                    <ul class="list-group">
                        <c:forEach var="pet" items="${clinicPets}">
                            <c:if test="${pet.client.clientId == client.clientId}">
                                <c:set var="hasPetsForClinic" value="true" />
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                        ${pet.name} (Species: ${pet.species.speciesName}, Breed: ${pet.breed.breedName}, Age: ${pet.age})
                                </li>
                            </c:if>
                        </c:forEach>
                        <c:if test="${not hasPetsForClinic}">
                            <li class="list-group-item text-muted">No pets from this client are registered to your clinic.</li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </c:forEach>
    </c:if>
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