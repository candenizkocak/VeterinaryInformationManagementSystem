<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

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

    <div class="mb-3">
        <input type="text" id="vetSearch" class="form-control" placeholder="Search by name...">
    </div>

    <table class="table table-bordered table-striped" id="vetTable">
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
                <td>${vet.veterinaryID}</td>
                <td>${vet.firstName}</td>
                <td>${vet.lastName}</td>
                <td>${vet.specialization}</td>
                <td>${vet.username}</td>
                <td>
                    <a href="/admin/veterinaries/edit/${vet.veterinaryID}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/veterinaries/delete/${vet.veterinaryID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this vet?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    document.getElementById("vetSearch").addEventListener("keyup", function () {
        const input = this.value.toLowerCase();
        const rows = document.querySelectorAll("#vetTable tbody tr");

        rows.forEach(row => {
            const name = row.cells[1].textContent.toLowerCase();
            const surname = row.cells[2].textContent.toLowerCase();
            row.style.display = (name + " " + surname).includes(input) ? "" : "none";
        });
    });
</script>
