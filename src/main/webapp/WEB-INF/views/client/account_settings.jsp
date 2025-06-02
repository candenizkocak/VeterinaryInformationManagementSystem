<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Account Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <!-- Genel tema CSS'i (global stiller için) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/account_settings.css">

    <%--
    ÖNEMLİ: Bu JSP'nin orijinalinde bulunan <style> bloğu buraya taşındı:
    src/main/resources/static/css/client/account_settings.css
    --%>
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/> <%-- Client modülüne özel navbar'ı dahil eder --%>

<div class="container py-4">
    <%-- Burası orijinal JSP'nin ana HTML içeriğiydi --%>

    <div class="settings-card">
        <div class="settings-title">Account Settings</div>

        <c:if test="${not empty success}">
            <div class="alert alert-success text-center">Your account settings have been updated successfully!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/api/clients/account-settings" method="post" autocomplete="off">
            <div class="mb-3">
                <label class="form-label">First Name:</label>
                <input type="text" name="firstName" value="${accountSettings.firstName}" class="form-control" required maxlength="40" />
            </div>
            <div class="mb-3">
                <label class="form-label">Last Name:</label>
                <input type="text" name="lastName" value="${accountSettings.lastName}" class="form-control" required maxlength="40" />
            </div>
            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" value="${accountSettings.email}" class="form-control" required maxlength="60" />
            </div>
            <div class="mb-3">
                <label class="form-label">Phone:</label>
                <input type="text" name="phone" value="${accountSettings.phone}" class="form-control" maxlength="20" />
            </div>
            <div class="mb-3">
                <label class="form-label">Address:</label>
                <input type="text" name="address" value="${accountSettings.address}" class="form-control" maxlength="120" />
            </div>
            <button type="submit" class="btn-save-modern">Save Changes</button>
        </form>

        <div class="divider"></div>

        <!-- Modern Change Password Button -->
        <a href="${pageContext.request.contextPath}/api/clients/change-password" class="btn btn-change-password">
            <i class="bi bi-shield-lock"></i> Change Password
        </a>

        <%-- Ana Sayfaya Dön Butonu (Kart içine taşındı) --%>
        <a href="/" class="btn btn-back-home-card">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>