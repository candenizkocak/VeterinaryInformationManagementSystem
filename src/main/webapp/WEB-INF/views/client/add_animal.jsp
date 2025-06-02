<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Add Animal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>

        body {
            background: #f7faff;
        }
        .add-animal-card {
            max-width: 480px;
            margin: 48px auto 0 auto;
            border-radius: 18px;
            box-shadow: 0 8px 32px 0 #1c4c8c1c;
            background: #fff;
            padding: 38px 38px 24px 38px;
        }
        .add-animal-title {
            font-size: 2.1rem;
            color: #1066ee;
            font-weight: 600;
            text-align: center;
            margin-bottom: 32px;
            letter-spacing: 1px;
        }
        .form-label {
            font-weight: 500;
            color: #27496d;
        }
        .form-control, .form-select {
            border-radius: 12px;
            font-size: 1.09rem;
            padding: 11px 12px;
        }
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
<body>
<jsp:include page="navbar.jsp"/>
<div class="add-animal-card">
    <div class="add-animal-title">
        <i class="bi bi-emoji-paw"></i> Add a New Animal
    </div>

    <c:if test="${success}">
        <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
            <span style="font-size:1.2em;">&#10003;</span> Animal saved successfully!
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
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
