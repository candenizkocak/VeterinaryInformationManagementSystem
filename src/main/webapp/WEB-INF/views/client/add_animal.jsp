<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Add Animal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <!-- Genel tema CSS'i -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <!-- Bu sayfaya özel CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/add_animal.css">

    <%--
    ÖNEMLİ: Bu JSP'nin orijinalinde bulunan <style> bloğundaki stil kuralları buraya taşındı:
    src/main/resources/static/css/client/add_animal.css
    --%>
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/> <%-- Client modülüne özel navbar'ı dahil eder --%>

<div class="add-animal-card">
    <%-- Burası orijinal JSP'nin ana HTML içeriğiydi --%>
    <div class="add-animal-title">
        <i class="bi bi-emoji-paw"></i> Add a New Animal
    </div>

    <c:if test="${success}">
        <div class="alert alert-success alert-dismissible fade show text-center" role="alert">
            <span style="font-size:1.2em;"></span> Animal saved successfully!
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
        <div class="d-flex justify-content-center mt-3">
            <a href="${pageContext.request.contextPath}/api/clients/animals" class="btn btn-back-home-card">
                <i class="bi bi-arrow-left"></i> Back to My Animals
            </a>

    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>