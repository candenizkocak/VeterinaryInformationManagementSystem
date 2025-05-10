<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Veterinaries in ${clinic.clinicName}</h2>

    <form method="post" action="/admin/clinics/${clinic.clinicId}/veterinaries/assign" class="row g-3 mb-4">
        <div class="col-md-9">
            <label class="form-label">Select Veterinary</label>
            <select name="veterinaryId" class="form-select" required>
                <c:forEach var="vet" items="${allVeterinaries}">
                    <option value="${vet.veterinaryId}">${vet.firstName} ${vet.lastName} (${vet.user.username})</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-md-3 d-flex align-items-end">
            <button type="submit" class="btn btn-primary w-100">Assign</button>
        </div>
    </form>

    <h4>Assigned Veterinaries</h4>
    <table class="table table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Specialization</th>
            <th>Username</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="cv" items="${assignedVeterinaries}">
            <tr>
                <td>${cv.veterinary.veterinaryId}</td>
                <td>${cv.veterinary.firstName} ${cv.veterinary.lastName}</td>
                <td>${cv.veterinary.specialization}</td>
                <td>${cv.veterinary.user.username}</td>
                <td>
                    <form method="post" action="/admin/clinics/${clinic.clinicId}/veterinaries/remove/${cv.veterinary.veterinaryId}" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Remove this veterinary from the clinic?')">Remove</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
