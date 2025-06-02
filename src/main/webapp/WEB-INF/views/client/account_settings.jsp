<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Account Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: #f7faff;
        }
        .settings-card {
            max-width: 500px;
            margin: 40px auto;
            border-radius: 18px;
            box-shadow: 0 8px 40px 0 #1c4c8c15;
            padding: 32px 36px 28px 36px;
            background: #fff;
        }
        .settings-title {
            font-size: 2.2rem;
            color: #1066ee;
            font-weight: 600;
            letter-spacing: 1px;
            text-align: center;
            margin-bottom: 35px;
        }
        .form-label {
            font-weight: 500;
            color: #27496d;
        }
        .form-control {
            border-radius: 12px;
            font-size: 1.1rem;
            padding: 12px;
        }
        .btn-save {
            background: #157afe;
            border: none;
            font-size: 1.12rem;
            padding: 13px;
            border-radius: 10px;
            font-weight: 500;
            letter-spacing: 1px;
            transition: 0.2s;
        }
        .btn-save:hover {
            background: #1066ee;
        }
        .btn-change-password {
            width: 100%;
            background: #fff;
            color: #1066ee;
            border: 2px solid #1066ee;
            border-radius: 10px;
            font-weight: 500;
            font-size: 1.08rem;
            padding: 12px 0;
            margin-top: 32px;
            transition: 0.2s;
        }
        .btn-change-password:hover {
            background: #1066ee;
            color: #fff;
            border-color: #1066ee;
        }
        .divider {
            border-top: 1px solid #e0e6ef;
            margin: 32px 0 20px 0;
        }
        @media (max-width: 700px) {
            .settings-card { padding: 18px 8px 18px 8px; }
            .settings-title { font-size: 1.5rem; }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="settings-card">
    <div class="settings-title">Account Settings</div>

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
        <button type="submit" class="btn btn-save w-100 mb-1">Save Changes</button>
    </form>

    <div class="divider"></div>

    <!-- Modern Change Password Button -->
    <a href="${pageContext.request.contextPath}/api/clients/change-password" class="btn btn-change-password">
        <i class="bi bi-shield-lock"></i> Change Password
    </a>
</div>

<!-- Bootstrap ve icon desteği -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
