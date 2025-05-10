<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2>Edit User</h2>
    <form action="/admin/users/update" method="post" class="row g-3">
        <input type="hidden" name="userID" value="${user.userID}"/>

        <div class="col-md-6">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" value="${user.username}" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="${user.email}">
        </div>

        <div class="col-md-6">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" value="${user.phone}">
        </div>

        <div class="col-md-6">
            <label class="form-label">Password</label>
            <input type="password" name="newPassword" class="form-control" placeholder="Leave blank to keep current password">
        </div>

        <div class="col-md-6">
            <label class="form-label">Role</label>
            <select name="roleId" class="form-select">
                <c:forEach var="role" items="${roles}">
                    <option value="${role.roleID}" <c:if test="${role.roleID == user.roleId}">selected</c:if>>${role.roleName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="/admin/users" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
