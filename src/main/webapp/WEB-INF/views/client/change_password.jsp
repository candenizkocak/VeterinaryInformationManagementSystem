<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Change Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <!-- Genel tema CSS'i -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/change_password.css">

    <%--
    ÖNEMLİ: Bu JSP'nin orijinalinde bulunan <style> bloğundaki stil kuralları buraya taşındı:
    src/main/resources/static/css/client/change_password.css
    --%>
</head>
<body id="pageBody" class="bg-light">
<jsp:include page="navbar.jsp"/> <%-- Client modülüne özel navbar'ı dahil eder --%>

<div class="pw-card">
    <%-- Burası orijinal JSP'nin ana HTML içeriğiydi --%>
    <div class="pw-title"><i class="bi bi-shield-lock"></i> Change Password</div>
    <c:if test="${success}">
        <div class="alert alert-success text-center">Your password has been changed successfully!</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/api/clients/change-password" method="post" autocomplete="off">
        <div class="mb-3">
            <label class="form-label">Current Password:</label>
            <input type="password" name="oldPassword" class="form-control" required autocomplete="current-password"/>
        </div>
        <div class="mb-3">
            <label class="form-label">New Password:</label>
            <input type="password" name="newPassword" class="form-control" required minlength="6" autocomplete="new-password"/>
        </div>
        <div class="mb-3">
            <label class="form-label">Confirm New Password:</label>
            <input type="password" name="newPasswordConfirm" class="form-control" required minlength="6" autocomplete="new-password"/>
        </div>
        <button type="submit" class="btn btn-change-password">Change Password</button>

        <a href="/" class="btn btn-back-home-card">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </form>
</div>
<!-- Bootstrap iconlar için (isteğe bağlı) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>