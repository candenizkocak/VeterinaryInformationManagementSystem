<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
    .theme-switch {
        position: relative;
        display: inline-block;
        width: 60px;
        height: 30px;
        margin-left: 10px;
        margin-right: 4px;
    }

    .theme-switch input {
        opacity: 0;
        width: 0;
        height: 0;
    }

    .slider {
        position: absolute;
        cursor: pointer;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: #ccc;
        transition: 0.4s;
        border-radius: 34px;
    }

    .slider:before {
        position: absolute;
        content: "";
        height: 26px;
        width: 26px;
        left: 2px;
        bottom: 2px;
        background-color: white;
        background-image: url('<%= request.getContextPath() %>/img/sun.gif');
        background-size: cover;
        background-repeat: no-repeat;
        border-radius: 50%;
        transition: 0.4s;
    }

    input:checked + .slider {
        background-color: #444;
    }

    input:checked + .slider:before {
        transform: translateX(30px);
        background-image: url('<%= request.getContextPath() %>/img/moon.gif');
    }

    .navbar .nav-link {
        transition: 0.3s;
        padding: 6px 12px;
        border-radius: 8px;
    }

    /* Theme: Light */
    body.bg-light .navbar .nav-link {
        color: black !important;
        border: 1px solid rgba(0, 0, 0, 0.06);
        margin-right: 4px;
    }

    body.bg-light .navbar .nav-link:hover {
        background-color: rgba(0, 0, 0, 0.05);
    }

    body.bg-light #welcomeUser {
        color: black;
    }

    /* Theme: Dark */
    body.bg-dark .navbar .nav-link {
        color: white !important;
        border: 1px solid rgba(255, 255, 255, 0.1);
        margin-right: 4px;
    }

    body.bg-dark .navbar .nav-link:hover {
        background-color: rgba(255, 255, 255, 0.15);
    }

    body.bg-dark #welcomeUser {
        color: white;
    }

    /* Logout */
    .navbar .logout-link {
        background-color: #dc3545;
        padding: 6px 12px;
        border-radius: 6px;
        font-size: 0.85rem;
        transition: 0.3s;
        text-align: center;
    }

    .navbar .logout-link:hover {
        background-color: #bb2d3b;
        text-decoration: none;
        color: white !important;
    }
</style>

<body id="pageBody">

<nav id="mainNavbar" class="navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">VetApp</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                    <c:if test="${empty sessionScope.role}">
                        <li class="nav-item"><a class="nav-link" href="#pets">Pets</a></li>
                        <li class="nav-item"><a class="nav-link" href="#clinics">Clinics</a></li>
                    </c:if>
                <c:choose>
                    <c:when test="${sessionScope.role == 'ROLE_ADMIN'}">
                        <li class="nav-item"><a class="nav-link" href="/admin/users">Users</a></li>
                        <li class="nav-item"><a class="nav-link" href="/admin/clinics">Clinics</a></li>
                        <li class="nav-item"><a class="nav-link" href="/admin/veterinaries">Veterinaries</a></li>
                        <li class="nav-item"><a class="nav-link" href="/admin/pets">Pets</a></li>
                        <li class="nav-item"><a class="nav-link" href="/admin/appointments">Appointments</a></li>
                    </c:when>
                    <c:when test="${sessionScope.role == 'ROLE_CLIENT'}">
                        <li class="nav-item"><a class="nav-link" href="/client/something">Client Panel</a></li>
                    </c:when>
                    <c:when test="${sessionScope.role == 'ROLE_VETERINARY'}">
                        <li class="nav-item"><a class="nav-link" href="/veterinary/appointments">My Appointments</a></li>
                    </c:when>
                    <c:when test="${sessionScope.role == 'ROLE_CLINIC'}">
                        <li class="nav-item"><a class="nav-link" href="/clinic/veterinaries">Veterinaries</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/appointments">Appointments</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/clients-and-pets">Clients & Pets</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/vaccine-types">Vaccine Types</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/surgery-types">Surgery Types</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/item-types">Item Types</a></li>    <%-- NEW LINE --%>
                        <li class="nav-item"><a class="nav-link" href="/clinic/suppliers">Suppliers</a></li>     <%-- NEW LINE --%>
                        <li class="nav-item"><a class="nav-link" href="/clinic/inventory">Inventory</a></li>
                    </c:when>
                </c:choose>
            </ul>

            <ul class="navbar-nav ms-auto align-items-center">
                <c:if test="${not empty sessionScope.username}">
                    <li class="nav-item me-2">
                        <span id="welcomeUser" class="navbar-text fw-light" style="font-size: 0.9rem;">
                            Welcome, <strong>${sessionScope.username}</strong>
                        </span>
                    </li>
                </c:if>
                <li class="nav-item d-flex align-items-center">
                    <label class="theme-switch mb-0">
                        <input type="checkbox" id="themeToggleSwitch">
                        <span class="slider"></span>
                    </label>
                </li>
                <c:if test="${empty sessionScope.role}">
                    <li class="nav-item"><a class="nav-link" href="/login">Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="/signup">Sign Up</a></li>
                </c:if>
                <c:if test="${not empty sessionScope.role}">
                    <li class="nav-item ms-2">
                        <a class="nav-link logout-link" href="/logout">Logout</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<script>
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const navbar = document.getElementById('mainNavbar');

    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            navbar.classList.add('navbar-dark', 'bg-dark');
            navbar.classList.remove('navbar-light', 'bg-light');
            themeToggleSwitch.checked = true;
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            navbar.classList.add('navbar-light', 'bg-light');
            navbar.classList.remove('navbar-dark', 'bg-dark');
            themeToggleSwitch.checked = false;
        }
        localStorage.setItem('theme', theme);
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyTheme(savedTheme);

        themeToggleSwitch.addEventListener("change", () => {
            const newTheme = themeToggleSwitch.checked ? "dark" : "light";
            applyTheme(newTheme);
        });
    });
</script>
