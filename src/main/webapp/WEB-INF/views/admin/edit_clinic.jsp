<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Edit Clinic</h2>

    <form action="/admin/clinics/update" method="post" class="row g-3">
        <input type="hidden" name="clinicId" value="${clinic.clinicId}"/>

        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" value="${clinic.clinicName}" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Location</label>
            <input type="text" name="location" class="form-control" value="${clinic.location}" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}" <c:if test="${user.userID == clinic.user.userID}">selected</c:if>>${user.username}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update Clinic</button>
            <a href="/admin/clinics" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
