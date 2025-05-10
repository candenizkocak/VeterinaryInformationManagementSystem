<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Edit Veterinary</h2>

    <form action="/admin/veterinaries/update" method="post" class="row g-3">
        <input type="hidden" name="veterinaryID" value="${veterinary.veterinaryId}" />

        <div class="col-md-4">
            <label class="form-label">First Name</label>
            <input type="text" name="firstName" class="form-control" value="${veterinary.firstName}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Last Name</label>
            <input type="text" name="lastName" class="form-control" value="${veterinary.lastName}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">Specialization</label>
            <input type="text" name="specialization" class="form-control" value="${veterinary.specialization}">
        </div>

        <div class="col-md-6">
            <label class="form-label">User</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}" ${user.userID == veterinary.user.userID ? 'selected' : ''}>
                            ${user.username}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="/admin/veterinaries" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
