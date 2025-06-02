<%-- src/main/webapp/WEB-INF/views/navbar.jsp --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<style>
    /* Navbar Modern Style */
    .navbar-modern {
        background: rgba(240,247,255,0.98)!important;
        box-shadow: 0 3px 18px 0 #95d3ff26;
        border-bottom: 1px solid #e3eafc;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        z-index: 2000;
    }
    .navbar-modern .navbar-brand {
        font-weight: 700;
        color: #1a59a6!important;
        font-size: 1.55rem;
        letter-spacing: 1px;
        display: flex;
        align-items: center;
        gap: 0.3em;
    }
    .navbar-modern .navbar-brand i {
        font-size: 1.7em;
        color: #2c8aff;
    }
    .navbar-modern .navbar-nav .nav-link {
        color: #19568c;
        font-size: 1.06rem;
        margin-right: 4px;
        border-radius: 9px;
        padding: 9px 14px!important;
        transition: background .2s, color .18s;
        font-weight: 500;
        position: relative;
    }
    .navbar-modern .navbar-nav .nav-link:hover,
    .navbar-modern .navbar-nav .nav-link.active {
        background: linear-gradient(90deg,#e2edfb 0%,#cbe4fc 100%);
        color: #1a7efa!important;
        text-shadow: 0 1px 8px #e5f4ff7a;
    }
    .navbar-modern .navbar-nav .logout-link {
        background: linear-gradient(90deg, #f94f62 0%, #fa925c 100%);
        color: #fff!important;
        border-radius: 10px;
        margin-left: 10px;
        font-weight: 600;
        padding: 8px 18px;
        font-size: 1.05rem;
        box-shadow: 0 4px 15px 0 #fa925c27;
        border: none;
        transition: background .19s, color .19s;
    }
    .navbar-modern .navbar-nav .logout-link:hover {
        background: #d12d45;
        color: #fff!important;
    }
    .navbar-modern .navbar-toggler {
        border-radius: 10px;
        border: 1px solid #b3d4ff;
    }
    .theme-switch {
        position: relative;
        display: inline-block;
        width: 48px; height: 26px;
        margin-left: 16px; margin-right: 2px;
        vertical-align: middle;
    }
    .theme-switch input { opacity:0; width:0; height:0;}
    .slider {
        position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
        background-color: #cbe4fc; transition: .4s; border-radius: 34px;
    }
    .slider:before {
        position: absolute; content: "";
        height: 22px; width: 22px; left: 2px; bottom: 2px;
        background-color: white;
        background-image: url('<%= request.getContextPath() %>/img/sun.gif');
        background-size: cover; background-repeat: no-repeat;
        border-radius: 50%;
        transition: 0.4s;
        box-shadow: 0 2px 6px #b7dfff2a;
    }
    input:checked + .slider { background-color: #5c636a;}
    input:checked + .slider:before {
        transform: translateX(22px);
        background-image: url('<%= request.getContextPath() %>/img/moon.gif');
    }
    .user-avatar {
        display:inline-flex;
        align-items:center;
        justify-content:center;
        background:linear-gradient(135deg,#99d8fd 0%,#b3cfff 100%);
        color:#225488;
        border-radius:50%;
        font-size:1.2em;
        font-weight:700;
        width:2.2em; height:2.2em;
        margin-right:6px;
        border:2px solid #d0e5fa;
        box-shadow:0 1px 8px 0 #a2cfff25;
    }
    @media (max-width: 600px) {
        .navbar-modern .navbar-brand { font-size:1.1rem;}
        .navbar-modern .navbar-nav .nav-link, .navbar-modern .navbar-nav .logout-link {font-size:0.97rem;}
        .theme-switch {margin-left:6px;}
    }
</style>

<nav id="mainNavbar" class="navbar navbar-expand-lg navbar-modern sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="/">
            <i class="bi bi-hospital"></i> VetApp
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
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
                        <li class="nav-item"><a class="nav-link" href="/api/clients/animals">My Animals</a></li>
                        <li class="nav-item"><a class="nav-link" href="/api/clients/account-settings">Account Settings</a></li>
                        <li class="nav-item"><a class="nav-link" href="/api/clients/appointments">My Appointments</a></li>
                        <li class="nav-item"><a class="nav-link" href="/api/clients/add-animal">Add Animal</a></li>
                        <li class="nav-item"><a class="nav-link" href="/api/clients/appointments/book">Book Appointment</a></li>
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
                        <li class="nav-item"><a class="nav-link" href="/clinic/item-types">Item Types</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/suppliers">Suppliers</a></li>
                        <li class="nav-item"><a class="nav-link" href="/clinic/inventory">Inventory</a></li>
                    </c:when>
                </c:choose>
            </ul>
            <ul class="navbar-nav ms-auto align-items-center mb-2 mb-lg-0">
                <c:if test="${not empty sessionScope.username}">
                    <li class="nav-item me-2 d-flex align-items-center">
                        <span class="user-avatar me-2"><i class="bi bi-person-fill"></i></span>
                        <span id="welcomeUser" class="navbar-text fw-light" style="font-size: 0.97rem;">
                            Welcome, <strong>${sessionScope.username}</strong>
                        </span>
                    </li>
                </c:if>
                <li class="nav-item d-flex align-items-center">
                    <label class="theme-switch mb-0" title="Toggle dark mode">
                        <input type="checkbox" id="themeToggleSwitch">
                        <span class="slider"></span>
                    </label>
                </li>
                <c:if test="${empty sessionScope.role}">
                    <li class="nav-item"><a class="nav-link" href="/login"><i class="bi bi-box-arrow-in-right me-1"></i>Login</a></li>
                    <li class="nav-item"><a class="nav-link" href="/signup"><i class="bi bi-person-plus me-1"></i>Sign Up</a></li>
                </c:if>
                <c:if test="${not empty sessionScope.role}">
                    <li class="nav-item ms-2">
                        <a class="logout-link nav-link px-3" href="/logout"><i class="bi bi-box-arrow-right me-1"></i>Logout</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<script>
    function applyThemeToAll(theme) {
        const body = document.getElementById('pageBody') || document.body;
        const navbar = document.getElementById('mainNavbar');
        const themeToggleSwitch = document.getElementById('themeToggleSwitch');
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            if (navbar) {
                navbar.classList.add('navbar-dark', 'bg-dark');
                navbar.classList.remove('navbar-light', 'bg-light');
            }
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
        }
        if (themeToggleSwitch) themeToggleSwitch.checked = (theme === 'dark');
        localStorage.setItem('theme', theme);
    }
    document.addEventListener('DOMContentLoaded', function() {
        const themeToggleSwitch = document.getElementById('themeToggleSwitch');
        const savedTheme = localStorage.getItem("theme") || "light";
        applyThemeToAll(savedTheme);
        if (themeToggleSwitch) {
            themeToggleSwitch.addEventListener("change", function() {
                const newTheme = themeToggleSwitch.checked ? "dark" : "light";
                applyThemeToAll(newTheme);
            });
        }
    });
</script>
