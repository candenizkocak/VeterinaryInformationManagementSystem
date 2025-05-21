<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

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
    <h2 class="mb-4">${record.medicalRecordId == null ? 'Add' : 'Edit'} Medical Record</h2>

    <form action="/admin/medical-records/save" method="post" class="row g-3">
        <c:if test="${record.medicalRecordId != null}">
            <input type="hidden" name="medicalRecordId" value="${record.medicalRecordId}" />
        </c:if>

        <div class="col-md-4">
            <label class="form-label">Date</label>
            <input type="date" name="date" class="form-control" value="${record.date}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Pet</label>
            <select name="pet.petID" class="form-select" required>
                <option value="" disabled ${record.pet == null ? 'selected' : ''}>Select a pet</option>
                <c:forEach var="p" items="${pets}">
                    <option value="${p.petID}" <c:if test="${record.pet != null && record.pet.petID == p.petID}">selected</c:if>>${p.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Veterinary</label>
            <select name="veterinary.veterinaryId" class="form-select" required>
                <option value="" disabled ${record.veterinary == null ? 'selected' : ''}>Select a veterinary</option>
                <c:forEach var="v" items="${veterinaries}">
                    <option value="${v.veterinaryId}" <c:if test="${record.veterinary != null && record.veterinary.veterinaryId == v.veterinaryId}">selected</c:if>>${v.firstName} ${v.lastName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-6">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="2" required>${record.description}</textarea>
        </div>

        <div class="col-md-6">
            <label class="form-label">Treatment</label>
            <textarea name="treatment" class="form-control" rows="2" required>${record.treatment}</textarea>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">${record.medicalRecordId == null ? 'Add' : 'Update'}</button>
            <a href="/admin/medical-records/pet/${record.pet.petID}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

</body>
