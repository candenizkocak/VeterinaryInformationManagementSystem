<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Add Animal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" /> <%-- Biicons linkini head'e taşıdım --%>
    <style>

        body {
            background: #f7faff;
        }
        /* --- Karanlık Mod için Eklenecek CSS BAŞLANGICI --- */
        body.bg-dark {
            background: #1a1a1a !important; /* Koyu tema için genel arka plan */
            color: #e0e0e0; /* Varsayılan metin rengi */
        }
        /* Kartın kendisi */
        .add-animal-card {
            max-width: 480px;
            margin: 48px auto 0 auto;
            border-radius: 18px;
            box-shadow: 0 8px 32px 0 #1c4c8c1c;
            background: #fff; /* Açık mod varsayılanı */
            padding: 38px 38px 24px 38px;
        }
        body.bg-dark .add-animal-card {
            background: #2b2b2b !important; /* Koyu temada kart arka planı */
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.4); /* Koyu temada gölge */
            color: #fff; /* Koyu temada metin rengi */
        }

        /* Başlık rengi */
        .add-animal-title {
            font-size: 2.1rem;
            color: #1066ee; /* Açık mod varsayılanı */
            font-weight: 600;
            text-align: center;
            margin-bottom: 32px;
            letter-spacing: 1px;
        }
        body.bg-dark .add-animal-title {
            color: #6da7f7; /* Koyu temada başlık rengi */
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
        .form-control, .form-select {
            border-radius: 12px;
            font-size: 1.09rem;
            padding: 11px 12px;
            background-color: #fff; /* Açık mod varsayılanı */
            color: #212529; /* Açık mod varsayılan metin rengi */
            border: 1px solid #ced4da;
        }
        body.bg-dark .form-control,
        body.bg-dark .form-select {
            background-color: #1e1e1e !important; /* Koyu temada input arka planı */
            color: #fff !important; /* Koyu temada input metin rengi */
            border-color: #555 !important; /* Koyu temada input kenarlığı */
        }
        body.bg-dark .form-control::placeholder {
            color: #aaa !important; /* Koyu temada placeholder rengi */
        }
        body.bg-dark .form-select option {
            background-color: #1e1e1e; /* Koyu temada select option arka planı */
            color: #fff; /* Koyu temada select option metin rengi */
        }

        /* Alert stilini temaya uygun hale getirme (isteğe bağlı) */
        body.bg-dark .alert-success {
            background-color: #28a745;
            color: #fff;
        }
        body.bg-dark .alert-info {
            background-color: #17a2b8;
            color: #fff;
        }
        body.bg-dark .alert-warning {
            background-color: #ffc107;
            color: #212529; /* Uyarı metnini okunur tutmak için */
        }
        body.bg-dark .alert-danger {
            background-color: #dc3545;
            color: #fff;
        }
        /* --- Karanlık Mod için Eklenecek CSS SONU --- */

        .alert {
            border-radius: 10px;
            font-size: 1.09rem;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px 0 #00996612;
            animation: slideIn 0.45s;
        }
        @keyframes slideIn {
            0% { opacity: 0; transform: translateY(-30px);}
            100% { opacity: 1; transform: translateY(0);}
        }
        @media (max-width: 700px) {
            .add-animal-card { padding: 18px 8px 18px 8px; }
            .add-animal-title { font-size: 1.3rem; }
        }

        .btn-animal {
            background: linear-gradient(90deg, #2196f3 0%, #1976d2 100%);
            color: #fff;
            font-weight: 600;
            font-size: 1.13rem;
            border: none;
            border-radius: 14px;
            padding: 0.78rem 0;
            width: 70%;
            max-width: 340px;
            margin: 32px auto 0 auto;
            letter-spacing: 0.3px;
            box-shadow: 0 3px 18px 0 #1565c029;
            display: block;
            transition: all 0.17s cubic-bezier(.4,0,.2,1);
        }

        .btn-animal:hover, .btn-animal:focus {
            background: linear-gradient(90deg, #1565c0 0%, #1976d2 100%);
            color: #fff;
            box-shadow: 0 8px 28px 0 #1976d240;
            transform: translateY(-1px) scale(1.025);
            outline: none;
        }
    </style>
</head>
<body id="pageBody"> <%-- body id'si buraya taşındı --%>
<jsp:include page="navbar.jsp"/> <%-- Navbar include'u body içine taşındı --%>

<div class="add-animal-card">
    <div class="add-animal-title">
        <i class="bi bi-emoji-paw"></i> Add a New Animal
    </div>

    <c:if test="${success}">
        <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
            <span style="font-size:1.2em;">✓</span> Animal saved successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/api/clients/add-animal" method="post" autocomplete="off">

        <div class="mb-3">
            <label class="form-label">Name:</label>
            <input type="text" name="name" class="form-control" required autofocus/>
        </div>

        <div class="mb-3">
            <label class="form-label">Age:</label>
            <input type="number" name="age" class="form-control" required min="0"/>
        </div>

        <div class="mb-3">
            <label class="form-label">Species:</label>
            <select name="species.speciesID" class="form-select" required>
                <option value="">Select Species</option>
                <c:forEach var="sp" items="${speciesList}">
                    <option value="${sp.speciesID}">${sp.speciesName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Breed:</label>
            <select name="breed.breedID" class="form-select" required>
                <option value="">Select Breed</option>
                <c:forEach var="br" items="${breedList}">
                    <option value="${br.breedID}">${br.breedName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label">Gender:</label>
            <select name="gender.genderID" class="form-select" required>
                <option value="">Select Gender</option>
                <c:forEach var="g" items="${genderList}">
                    <option value="${g.genderID}">${g.genderName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="d-flex justify-content-center">
            <button type="submit" class="btn-animal">Add Animal</button>
        </div>
    </form>
</div>
<%-- Bootstrap JS'i ve ikon kütüphanesi buraya taşındı --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>