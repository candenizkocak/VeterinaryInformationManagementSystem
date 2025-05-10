<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2>Edit Pet for Clinic: ${clinicId}</h2>

    <form action="/admin/pets/update-clinic" method="post" class="row g-3">
        <input type="hidden" name="petID" value="${pet.petID}"/>
        <input type="hidden" name="clinic.clinicId" value="${clinicId}"/>

        <div class="col-md-4">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" value="${pet.name}" required>
        </div>

        <div class="col-md-2">
            <label class="form-label">Age</label>
            <input type="number" name="age" class="form-control" min="0" value="${pet.age}" required>
        </div>

        <div class="col-md-6">
            <label class="form-label">Owner</label>
            <select name="client.clientId" class="form-select" required>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.clientId}" <c:if test="${client.clientId == pet.client.clientId}">selected</c:if>>
                            ${client.firstName} ${client.lastName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Species</label>
            <select name="species.speciesID" class="form-select" required>
                <c:forEach var="species" items="${speciesList}">
                    <option value="${species.speciesID}" <c:if test="${species.speciesID == pet.species.speciesID}">selected</c:if>>
                            ${species.speciesName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Breed</label>
            <select name="breed.breedID" class="form-select" required>
                <c:forEach var="breed" items="${breeds}">
                    <option value="${breed.breedID}" <c:if test="${breed.breedID == pet.breed.breedID}">selected</c:if>>
                            ${breed.breedName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Gender</label>
            <select name="gender.genderID" class="form-select" required>
                <c:forEach var="gender" items="${genders}">
                    <option value="${gender.genderID}" <c:if test="${gender.genderID == pet.gender.genderID}">selected</c:if>>
                            ${gender.genderName}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="/admin/pets/${clinicId}/pets" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
