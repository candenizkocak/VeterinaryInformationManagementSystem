<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Assign Clinic to ${veterinary.firstName} ${veterinary.lastName}</h2>

    <form action="/admin/veterinaries/${veterinary.veterinaryId}/assign-clinic" method="post">
        <div class="mb-3">
            <label class="form-label">Select Clinic</label>
            <select name="clinicId" class="form-select" required>
                <c:forEach var="clinic" items="${clinics}">
                    <option value="${clinic.clinicId}">${clinic.clinicName}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Assign</button>
        <a href="/admin/veterinaries" class="btn btn-secondary">Back</a>
    </form>
</div>
