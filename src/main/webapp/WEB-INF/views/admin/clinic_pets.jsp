<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<jsp:include page="../navbar.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">Pets of Clinic: ${clinic.clinicName}</h2>

    <!-- Pet Ekleme Formu -->
    <form action="/admin/pets/${clinic.clinicId}/pets/create" method="post" class="row g-3 mb-4">
        <div class="col-md-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
        </div>

        <div class="col-md-2">
            <label class="form-label">Age</label>
            <input type="number" name="age" class="form-control" min="0" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Owner</label>
            <select name="client.clientID" class="form-select" required>
                <c:forEach var="client" items="${clients}">
                    <option value="${client.clientId}">${client.firstName} ${client.lastName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Species</label>
            <select name="species.speciesID" class="form-select" required>
                <c:forEach var="species" items="${speciesList}">
                    <option value="${species.speciesID}">${species.speciesName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Breed</label>
            <select name="breed.breedID" class="form-select" required>
                <c:forEach var="breed" items="${breeds}">
                    <option value="${breed.breedID}">${breed.breedName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Gender</label>
            <select name="gender.genderID" class="form-select" required>
                <c:forEach var="gender" items="${genders}">
                    <option value="${gender.genderID}">${gender.genderName}</option>
                </c:forEach>
            </select>
        </div>

        <!-- Clinic ID Gizli -->
        <input type="hidden" name="clinic.clinicId" value="${clinic.clinicId}"/>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Pet</button>
        </div>
    </form>

    <!-- Klinik Pet Listesi -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>Species</th>
            <th>Breed</th>
            <th>Gender</th>
            <th>Client</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="pet" items="${pets}">
            <tr>
                <td>${pet.petID}</td>
                <td>${pet.name}</td>
                <td>${pet.age}</td>
                <td>${pet.species.speciesName}</td>
                <td>${pet.breed.breedName}</td>
                <td>${pet.gender.genderName}</td>
                <td>${pet.client.firstName} ${pet.client.lastName}</td>
                <td>
                    <a href="/admin/pets/${clinic.clinicId}/pets/edit/${pet.petID}" class="btn btn-warning btn-sm">Edit</a>
                    <form action="/admin/pets/delete/${pet.petID}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this pet?')">Delete</button>
                    </form>
                </td>

            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
