<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Add Animal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">

<jsp:include page="navbar.jsp"/>

<div class="container py-5">
    <h2 class="mb-4 text-primary">Add a New Animal</h2>

    <!-- Kayıt başarılıysa Bootstrap alert popup göster -->
    <c:if test="${success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            ✔ Animal Savings Successful!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/api/clients/add-animal" method="post">

        <div class="mb-3">
            <label class="form-label">Name:</label>
            <input type="text" name="name" class="form-control" required/>
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

        <button type="submit" class="btn btn-primary">Add Animal</button>
    </form>
    </div>
</body>
</html>
