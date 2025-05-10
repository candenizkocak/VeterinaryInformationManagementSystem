<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../navbar.jsp"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Users</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
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

    <div class="mb-3">
        <input type="text" id="userSearch" class="form-control" placeholder="Search by username...">
    </div>

    <table class="table table-bordered table-striped" id="userTable">
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
        <tbody id="userTableBody">
        <c:forEach var="user" items="${users}">
            <tr>
                <td>${user.userID}</td>
                <td>${user.username}</td>
                <td>${user.email}</td>
                <td>${user.phone}</td>
                <td>${user.role.roleName}</td>
                <td>
                    <a href="/admin/users/edit/${user.userID}" class="btn btn-sm btn-warning">Edit</a>
                    <form action="/admin/users/delete/${user.userID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div id="noResults" class="alert alert-warning d-none">No matching users found.</div>

    <div class="mt-3">
        <button id="prevPage" class="btn btn-secondary btn-sm">Previous</button>
        <button id="nextPage" class="btn btn-secondary btn-sm">Next</button>
    </div>
</div>

<script>
    const searchInput = document.getElementById("userSearch");
    const tableBody = document.getElementById("userTableBody");
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
</body>
</html>
