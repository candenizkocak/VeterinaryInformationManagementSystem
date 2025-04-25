<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Clinic Management</h2>

    <form action="/admin/clinics/create" method="post" class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Location</label>
            <input type="text" name="location" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="user.userID" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}">${user.username}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Clinic</button>
        </div>
    </form>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Clinic Name</th>
            <th>Location</th>
            <th>Owner</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="clinic" items="${clinics}">
            <tr>
                <td>${clinic.clinicID}</td>
                <td>${clinic.clinicName}</td>
                <td>${clinic.location}</td>
                <td>${clinic.user.username}</td>
                <td>
                    <form action="/admin/clinics/delete/${clinic.clinicID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
