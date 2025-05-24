<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<body id="pageBody">
<jsp:include page="../navbar.jsp"/>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

<div class="container mt-5">
    <h2 class="mb-4">Welcome to Clinic Dashboard, ${clinic.clinicName}!</h2>

    <div class="alert alert-info">
        <p>This is your clinic's main management area. From here you can:</p>
        <ul>
            <li>Manage your **Veterinarians** (add/remove staff).</li>
            <li>View and **Approve Appointments**.</li>
            <li>See your **Clients** and their **Animals**.</li>
            <li>Manage **Vaccine Types** available in the system.</li>
            <li>Oversee your **Inventory** of medical supplies.</li>
        </ul>
        <p>Use the navigation bar above to access specific sections.</p>
    </div>

    <!-- Quick Links (Optional, can be expanded) -->
    <div class="row mt-4">
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body">
                    <h5 class="card-title">Veterinarian Management</h5>
                    <p class="card-text">Add or remove veterinarians from your clinic.</p>
                    <a href="/clinic/veterinaries" class="btn btn-primary">Go to Veterinaries</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body">
                    <h5 class="card-title">Appointment Approvals</h5>
                    <p class="card-text">View pending appointments and approve them.</p>
                    <a href="/clinic/appointments" class="btn btn-primary">Go to Appointments</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body">
                    <h5 class="card-title">Client & Pet Overview</h5>
                    <p class="card-text">See all clients and their pets registered to your clinic.</p>
                    <a href="/clinic/clients-and-pets" class="btn btn-primary">Go to Clients & Pets</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body">
                    <h5 class="card-title">Vaccine Type Management</h5>
                    <p class="card-text">Manage the types of vaccines offered at your clinic.</p>
                    <a href="/clinic/vaccine-types" class="btn btn-primary">Go to Vaccine Types</a>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card text-center h-100">
                <div class="card-body">
                    <h5 class="card-title">Inventory Management</h5>
                    <p class="card-text">Track and manage your clinic's medical inventory.</p>
                    <a href="/clinic/inventory" class="btn btn-primary">Go to Inventory</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
<script>
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const navbar = document.getElementById('mainNavbar');

    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            navbar?.classList.add('navbar-dark', 'bg-dark');
            navbar?.classList.remove('navbar-light', 'bg-light');
            themeToggleSwitch.checked = true;
            document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/moon.gif')");
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            navbar?.classList.add('navbar-light', 'bg-light');
            navbar?.classList.remove('navbar-dark', 'bg-dark');
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