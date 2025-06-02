<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Change Password</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f7faff;
        }
        .pw-card {
            max-width: 430px;
            margin: 48px auto 0 auto;
            border-radius: 18px;
            box-shadow: 0 8px 36px 0 #1c4c8c14;
            padding: 32px 36px 28px 36px;
            background: #fff;
        }
        .pw-title {
            font-size: 2rem;
            color: #1066ee;
            font-weight: 600;
            text-align: center;
            margin-bottom: 35px;
            letter-spacing: 1px;
        }
        .form-label {
            font-weight: 500;
            color: #27496d;
        }
        .form-control {
            border-radius: 12px;
            font-size: 1.08rem;
            padding: 12px;
        }
        .btn-pw {
            background: #157afe;
            border: none;
            font-size: 1.1rem;
            padding: 13px;
            border-radius: 10px;
            font-weight: 500;
            letter-spacing: 1px;
            margin-top: 10px;
            transition: 0.2s;
        }
        .btn-pw:hover {
            background: #1066ee;
        }
        .alert {
            border-radius: 10px;
            font-size: 1.07rem;
            margin-bottom: 22px;
        }
        @media (max-width: 700px) {
            .pw-card { padding: 18px 8px 18px 8px; }
            .pw-title { font-size: 1.3rem; }
        }
    </style>
</head>
<body id="pageBody" class="bg-light">
<jsp:include page="navbar.jsp"/>
<div class="pw-card">
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
        <button type="submit" class="btn btn-pw w-100">Change Password</button>
    </form>
</div>
<!-- Bootstrap iconlar için (isteğe bağlı) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
