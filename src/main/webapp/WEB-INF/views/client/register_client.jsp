<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Client Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <!-- Genel tema CSS'i (global stiller için) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/register_client.css">
</head>
<body id="pageBody" class="bg-light">

<%-- Navbar dahil ediliyor --%>
<jsp:include page="navbar.jsp"/>

<div class="container py-5">
    <div class="register-card">
        <h2 class="register-title">
            <i class="bi bi-person-plus-fill me-2"></i> Client Profile Setup
        </h2>
        <p class="register-text">
            Please provide your personal information to complete your registration.
            This information helps us to provide better services for you and your pets.
        </p>

        <form method="post" action="${pageContext.request.contextPath}/api/clients/register">
            <div class="mb-3">
                <label for="firstName" class="form-label">First Name</label>
                <input type="text" name="firstName" id="firstName" class="form-control" required autofocus>
            </div>

            <div class="mb-3">
                <label for="lastName" class="form-label">Last Name</label>
                <input type="text" name="lastName" id="lastName" class="form-control" required>
            </div>

            <div class="mb-4"> <%-- Boşluk artırıldı --%>
                <label for="address" class="form-label">Address</label>
                <input type="text" name="address" id="address" class="form-control" required>
            </div>

            <div class="text-center">
                <button type="submit" class="btn-create-profile">Create Profile</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>