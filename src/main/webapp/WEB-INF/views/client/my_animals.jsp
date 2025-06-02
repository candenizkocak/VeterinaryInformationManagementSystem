<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>My Animals</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<jsp:include page="navbar.jsp"/>

<div class="container py-5">

    <div class="mb-3">
        <a href="/" class="btn btn-secondary">&larr; Back to Home</a>
    </div>

    <div class="card shadow p-4">
        <h2 class="mb-4 text-primary text-center">My Animals</h2>
        <c:choose>
            <c:when test="${not empty pets}">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="table-dark">
                        <tr>
                            <th>Name</th>
                            <th>Species</th>
                            <th>Age</th>
                            <th>Breed</th>
                            <th>Gender</th>
                            <th>Clinic</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="pet" items="${pets}">
                            <tr>
                                <td>${pet.name}</td>
                                <td>${pet.species}</td>
                                <td>${pet.age}</td>
                                <td>${pet.breed}</td>
                                <td>${pet.gender}</td>
                                <td>${pet.clinicName}</td>
                                <td>
                                    <!-- Vaccinations Button -->
                                    <button class="btn btn-outline-success btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#vaccinesModal${pet.name}">
                                        View Vaccinations
                                    </button>
                                    <!-- Treatments Button -->
                                    <button class="btn btn-outline-info btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#treatmentsModal${pet.name}">
                                        View Treatments
                                    </button>
                                    <!-- Diagnoses Button -->
                                    <button class="btn btn-outline-warning btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#diagnosesModal${pet.name}">
                                        View Diagnoses
                                    </button>
                                    <!-- Delete Button -->
                                    <form action="${pageContext.request.contextPath}/api/clients/delete-animal/${pet.id}" method="post" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete the pet?');">
                                        <button type="submit" class="btn btn-danger btn-sm ms-1">Delete</button>
                                    </form>
                                </td>
                            </tr>

                            <!-- Vaccinations Modal -->
                            <div class="modal fade" id="vaccinesModal${pet.name}" tabindex="-1" aria-labelledby="vaccinesModalLabel${pet.name}" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="vaccinesModalLabel${pet.name}">Vaccinations of ${pet.name}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <c:choose>
                                                <c:when test="${not empty pet.vaccineNames}">
                                                    <ul>
                                                        <c:forEach var="vaccine" items="${pet.vaccineNames}">
                                                            <li>${vaccine}</li>
                                                        </c:forEach>
                                                    </ul>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-secondary">No vaccination records found.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Treatments Modal -->
                            <div class="modal fade" id="treatmentsModal${pet.name}" tabindex="-1" aria-labelledby="treatmentsModalLabel${pet.name}" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="treatmentsModalLabel${pet.name}">Treatments of ${pet.name}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <c:choose>
                                                <c:when test="${not empty pet.medicalRecords}">
                                                    <ul>
                                                        <c:forEach var="record" items="${pet.medicalRecords}">
                                                            <c:if test="${not empty record.treatment}">
                                                                <li>
                                                                    <strong>Date:</strong> ${record.date} <br/>
                                                                    <strong>Treatment:</strong> ${record.treatment}
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </ul>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-secondary">No treatment records found.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Diagnoses Modal -->
                            <div class="modal fade" id="diagnosesModal${pet.name}" tabindex="-1" aria-labelledby="diagnosesModalLabel${pet.name}" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title" id="diagnosesModalLabel${pet.name}">Diagnoses of ${pet.name}</h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <div class="modal-body">
                                            <c:choose>
                                                <c:when test="${not empty pet.medicalRecords}">
                                                    <ul>
                                                        <c:forEach var="record" items="${pet.medicalRecords}">
                                                            <c:if test="${not empty record.description}">
                                                                <li>
                                                                    <strong>Date:</strong> ${record.date} <br/>
                                                                    <strong>Diagnosis:</strong> ${record.description}
                                                                </li>
                                                            </c:if>
                                                        </c:forEach>
                                                    </ul>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="alert alert-secondary">No diagnosis records found.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning text-center">
                    You do not have any registered animals yet.
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Bootstrap JS (for modals) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
