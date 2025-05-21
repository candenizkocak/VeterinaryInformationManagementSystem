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
    <h2 class="mb-4">Users Page</h2>

    <form action="/admin/users/create" method="post" class="row g-3 mb-4">
        <div class="col-md-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Role</label>
            <select name="roleId" class="form-select" required>
                <c:forEach var="role" items="${roles}">
                    <option value="${role.roleID}">${role.roleName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-success">Add User</button>
        </div>
    </form>

    <table id="userTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Role</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.userID}</td>
                <td>${user.username}</td>
                <td>${user.email}</td>
                <td>${user.phone}</td>
                <td>${user.role.roleName}</td>
                <td>
                    <a href="/admin/users/edit/${user.userID}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/users/delete/${user.userID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function () {
        $('#userTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });
    });
</script>

<script>
    const body = document.getElementById("pageBody");

    function applyTheme(theme) {
        if (theme === "dark") {
            body.classList.add("bg-dark", "text-white");
            body.classList.remove("bg-light", "text-dark");
        } else {
            body.classList.add("bg-light", "text-dark");
            body.classList.remove("bg-dark", "text-white");
        }
    }

    document.addEventListener("DOMContentLoaded", () => {
        const currentTheme = localStorage.getItem("theme") || "light";
        applyTheme(currentTheme);

        const toggleBtn = document.getElementById("themeToggle");
        if (toggleBtn) {
            toggleBtn.addEventListener("click", () => {
                const newTheme = localStorage.getItem("theme") === "dark" ? "light" : "dark";
                localStorage.setItem("theme", newTheme);
                applyTheme(newTheme);
            });
        }
    });
</script>

</body>
