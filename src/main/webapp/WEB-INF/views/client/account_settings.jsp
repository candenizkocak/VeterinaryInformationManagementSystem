<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Account Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <style>
        /* Genel Arka Plan ve Metin Renkleri */
        body {
            background: #f7faff; /* Açık mod varsayılan arka plan */
            color: #212529; /* Açık mod varsayılan metin rengi */
        }
        body.bg-dark {
            background: #1a1a1a !important; /* Koyu mod arka plan */
            color: #e0e0e0 !important; /* Koyu mod metin rengi */
        }

        /* Ayarlar Kartı */
        .settings-card {
            max-width: 500px;
            margin: 40px auto;
            border-radius: 18px;
            box-shadow: 0 8px 40px 0 #1c4c8c15;
            padding: 32px 36px 28px 36px;
            background: #fff; /* Açık mod varsayılanı */
            border: none; /* Kenarlık kaldırıldı */
        }
        body.bg-dark .settings-card {
            background: #2b2b2b !important; /* Koyu mod kart arka planı */
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.4) !important;
            color: #e0e0e0; /* Koyu mod kart metin rengi */
        }

        /* Başlık rengi */
        .settings-title {
            font-size: 2.2rem;
            color: #1066ee; /* Açık mod varsayılanı */
            font-weight: 600;
            letter-spacing: 1px;
            text-align: center;
            margin-bottom: 35px;
        }
        body.bg-dark .settings-title {
            color: #6da7f7; /* Koyu mod başlık rengi */
        }

        /* Form etiketleri */
        .form-label {
            font-weight: 500;
            color: #27496d; /* Açık mod varsayılanı */
        }
        body.bg-dark .form-label {
            color: #ccc; /* Koyu temada etiket rengi */
        }

        /* Form kontrolleri (input, select, textarea) */
        .form-control {
            border-radius: 12px;
            font-size: 1.1rem;
            padding: 12px;
            background-color: #fff; /* Açık mod varsayılanı */
            color: #212529; /* Açık mod varsayılan metin rengi */
            border: 1px solid #ced4da;
        }
        body.bg-dark .form-control {
            background-color: #1e1e1e !important; /* Koyu temada input arka planı */
            color: #fff !important; /* Koyu temada input metin rengi */
            border-color: #555 !important; /* Koyu temada input kenarlığı */
        }
        body.bg-dark .form-control::placeholder {
            color: #aaa !important; /* Koyu temada placeholder rengi */
        }

        /* Kaydet Butonu (btn-save-modern) */
        .btn-save-modern {
            background: linear-gradient(90deg, #64b5f6 0%, #1976d2 100%);
            color: #fff;
            font-weight: 600;
            font-size: 1.08rem;
            letter-spacing: 0.3px;
            border: none;
            border-radius: 15px;
            padding: 0.7rem 0;
            margin-top: 30px;
            box-shadow: 0 4px 18px 0 #1565c022;
            transition: all 0.18s cubic-bezier(.4,0,.2,1);
            width: 60%;
            display: block;
            margin-left: auto;
            margin-right: auto;
            cursor: pointer;
        }
        .btn-save-modern:hover, .btn-save-modern:focus {
            background: linear-gradient(90deg, #1976d2 0%, #64b5f6 100%);
            color: #e3f2fd;
            box-shadow: 0 6px 28px 0 #1976d23d;
            transform: translateY(-2px) scale(1.025);
            outline: none;
        }
        body.bg-dark .btn-save-modern {
            background: linear-gradient(90deg, #a7d9ff 0%, #4a8ee0 100%) !important;
            color: #212529;
            box-shadow: 0 4px 18px 0 rgba(0,0,0,0.3);
        }
        body.bg-dark .btn-save-modern:hover, body.bg-dark .btn-save-modern:focus {
            background: linear-gradient(90deg, #4a8ee0 0%, #a7d9ff 100%) !important;
            box-shadow: 0 6px 28px 0 rgba(0,0,0,0.5);
        }

        /* Şifre Değiştir Butonu */
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
        body.bg-dark .btn-change-password {
            background: #343a40 !important;
            color: #a7d9ff !important;
            border-color: #a7d9ff !important;
        }
        body.bg-dark .btn-change-password:hover {
            background: #a7d9ff !important;
            color: #212529 !important;
            border-color: #a7d9ff !important;
        }

        /* Divider */
        .divider {
            border-top: 1px solid #e0e6ef;
            margin: 32px 0 20px 0;
        }
        body.bg-dark .divider {
            border-color: #495057 !important;
        }

        /* Alert Stilini temaya uygun hale getirme */
        .alert {
            border-radius: 10px;
            font-size: 1.09rem;
            margin-bottom: 22px;
            box-shadow: 0 2px 8px 0 #00996612;
        }
        body.bg-dark .alert-success {
            background-color: #28a745;
            color: #fff;
        }
        body.bg-dark .alert-danger {
            background-color: #dc3545;
            color: #fff;
        }

        /* --- Ana Sayfaya Dön Butonu (Güncellenmiş & Kart İçi) --- */
        .btn-back-home-card { /* Yeni sınıf adı */
            background: #fff;
            color: #1170e6;
            font-weight: 600;
            border: 2px solid #36b0ff;
            border-radius: 14px;
            font-size: 1rem;
            padding: 0.78rem 0; /* İçerik ortalanacağı için yatay padding sıfırlandı */
            width: 100%; /* Kart içinde tam genişlik alması için */
            display: block; /* Tam genişlik ve yeni satıra geçiş için */
            text-align: center; /* İçerik ortalanması için */
            text-decoration: none;
            transition: all 0.17s cubic-bezier(.4,0,.2,1);
            box-shadow: 0 2px 8px 0 #1170e612;
            outline: none;
            margin-top: 20px; /* Üstteki öğeden boşluk */
        }
        .btn-back-home-card:hover, .btn-back-home-card:focus {
            background: #e3f2fd !important;
            color: #1976d2 !important;
            border-color: #1976d2 !important;
            box-shadow: 0 6px 18px 0 #36b0ff2c;
            transform: translateY(-1px) scale(1.005);
            text-decoration: none;
        }
        .btn-back-home-card i { /* Buton içindeki ikon için stil */
            margin-right: 8px; /* İkon ile metin arasına boşluk */
            vertical-align: middle; /* Dikey hizalama */
        }
        body.bg-dark .btn-back-home-card {
            background: #343a40 !important;
            color: #a7d9ff !important;
            border-color: #a7d9ff !important;
            box-shadow: 0 2px 8px 0 rgba(0,0,0,0.3);
        }
        body.bg-dark .btn-back-home-card:hover, body.bg-dark .btn-back-home-card:focus {
            background: #495057 !important;
            color: #fff !important;
            border-color: #495057 !important;
            box-shadow: 0 6px 18px 0 rgba(0,0,0,0.5);
        }


        @media (max-width: 700px) {
            .settings-card { padding: 18px 8px 18px 8px; }
            .settings-title { font-size: 1.5rem; }
            .btn-save-modern { width: 80%; }
        }
    </style>
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <%-- Ana Sayfaya Dön Butonu kaldırıldı ve kart içine taşındı --%>

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