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
    <h2 class="mb-4">Veterinary Management</h2>

    <form action="/admin/veterinaries/create" method="post" class="row g-3 mb-4">
        <div class="col-md-3">
            <label class="form-label">First Name</label>
            <input type="text" name="firstName" class="form-control" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Last Name</label>
            <input type="text" name="lastName" class="form-control" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Specialization</label>
            <input type="text" name="specialization" class="form-control">
        </div>

        <div class="col-md-3">
            <label class="form-label">User</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}">${user.username}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Veterinary</button>
        </div>
    </form>

    <table id="vetTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Specialization</th>
            <th>Username</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="vet" items="${veterinaries}">
            <tr>
                <td>${vet.veterinaryId}</td>
                <td>${vet.firstName}</td>
                <td>${vet.lastName}</td>
                <td>${vet.specialization}</td>
                <td>${vet.username}</td>
                <td>
                    <a href="/admin/veterinaries/edit/${vet.veterinaryId}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/veterinaries/delete/${vet.veterinaryId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this vet?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- DATATABLE INIT -->
<script>
    $(document).ready(function () {
        $('#vetTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });
    });
</script>

<!-- THEME SCRIPT -->
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
