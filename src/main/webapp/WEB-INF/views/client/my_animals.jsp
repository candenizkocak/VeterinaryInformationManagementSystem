<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- REMOVED: <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> --%>
<html>
<head>
    <title>My Animals</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body { background: #f6f9fc; }
        .animal-card { border-radius: 1.5rem; box-shadow: 0 8px 32px #044a6033; margin-bottom: 32px; background: #fff; transition:.2s }
        .animal-card:hover { box-shadow: 0 12px 40px #0c748c22; transform: translateY(-2px);}
        .animal-card .paw { font-size:2.8rem; color: #0d6efd; }
        .animal-card .card-title { font-size: 1.25rem; font-weight: 700; letter-spacing:.2px;}
        .animal-attr { font-size: 1.08rem; }
        .btn-paw { font-size:1.1rem; }
        .action-btns { margin-top:18px; display:flex; gap:10px; flex-wrap:wrap;}
        .card-table th, .card-table td { vertical-align: middle; }
        /* Style for upcoming vaccinations */
        .upcoming-vaccine {
            font-weight: bold;
            color: #0d6efd; /* Bootstrap primary blue */
        }
        .past-vaccine {
            color: #6c757d; /* Bootstrap secondary gray */
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <a href="/" class="btn btn-outline-secondary mb-4">← Back to Home</a>

    <h2 class="mb-4 text-primary text-center" style="font-weight:700; letter-spacing:.5px;">
        <i class="bi bi-paw"></i> My Animals
    </h2>

    <c:choose>
        <c:when test="${not empty pets}">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <c:forEach var="pet" items="${pets}">
                    <div class="col">
                        <div class="card animal-card h-100">
                            <div class="card-body pb-3">
                                <div class="d-flex justify-content-center mb-2">
                                    <i class="bi bi-paw paw"></i>
                                </div>
                                <div class="card-title text-center mb-1">${pet.name}</div>
                                <div class="animal-attr mb-1"><b>Species:</b> ${pet.species}</div>
                                <div class="animal-attr mb-1"><b>Breed:</b> ${pet.breed}</div>
                                <div class="animal-attr mb-1"><b>Gender:</b> ${pet.gender}</div>
                                <div class="animal-attr mb-1"><b>Age:</b> ${pet.age}</div>
                                <div class="animal-attr mb-1"><b>Clinic:</b> ${pet.clinicName}</div>

                                <div class="action-btns justify-content-center">
                                    <!-- Vaccinations Button -->
                                    <button class="btn btn-outline-success btn-paw"
                                            data-bs-toggle="modal"
                                            data-bs-target="#vaccinesModal${pet.id}">
                                        <i class="bi bi-shield-plus"></i> Vaccinations
                                    </button>
                                    <!-- Treatments Button -->
                                    <button class="btn btn-outline-info btn-paw"
                                            data-bs-toggle="modal"
                                            data-bs-target="#treatmentsModal${pet.id}">
                                        <i class="bi bi-bandaid"></i> Treatments
                                    </button>
                                    <!-- Diagnoses Button -->
                                    <button class="btn btn-outline-warning btn-paw"
                                            data-bs-toggle="modal"
                                            data-bs-target="#diagnosesModal${pet.id}">
                                        <i class="bi bi-activity"></i> Diagnoses
                                    </button>
                                </div>
                                <form action="${pageContext.request.contextPath}/api/clients/delete-animal/${pet.id}" method="post"
                                      class="d-flex justify-content-center mt-3"
                                      onsubmit="return confirm('Are you sure you want to delete this animal?');">
                                    <button type="submit" class="btn btn-danger btn-sm w-75">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Vaccinations Modal (MODIFIED) -->
                    <div class="modal fade" id="vaccinesModal${pet.id}" tabindex="-1" aria-labelledby="vaccinesModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog modal-lg">
                            <div class="modal-content">
                                <div class="modal-header bg-success-subtle">
                                    <h5 class="modal-title" id="vaccinesModalLabel${pet.id}">
                                        <i class="bi bi-shield-plus text-success"></i> Vaccination History & Upcoming for ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.vaccinations}">
                                            <table class="table table-bordered table-striped">
                                                <thead>
                                                <tr>
                                                    <th>Vaccine Name</th>
                                                    <th>Date Administered</th>
                                                    <th>Next Due Date</th>
                                                </tr>
                                                </thead>
                                                <tbody>
                                                <c:forEach var="vacc" items="${pet.vaccinations}">
                                                    <tr>
                                                        <td>${vacc.vaccineName}</td>
                                                        <td>${vacc.dateAdministered}</td> <%-- Use pre-formatted string --%>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${vacc.upcoming}"> <%-- Use the boolean flag directly --%>
                                                                    <span class="upcoming-vaccine">
                                                                        ${vacc.nextDueDate} (Upcoming)
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <c:if test="${vacc.nextDueDate ne 'N/A'}"> <%-- Check if it's not N/A, 'N/A' means no next due date set or it's not applicable --%>
                                                                        <span class="past-vaccine">
                                                                            ${vacc.nextDueDate} (Past Due / Completed)
                                                                        </span>
                                                                    </c:if>
                                                                    <c:if test="${vacc.nextDueDate eq 'N/A'}">
                                                                        N/A
                                                                    </c:if>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                                </tbody>
                                            </table>
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
                    <div class="modal fade" id="treatmentsModal${pet.id}" tabindex="-1" aria-labelledby="treatmentsModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-info-subtle">
                                    <h5 class="modal-title" id="treatmentsModalLabel${pet.id}">
                                        <i class="bi bi-bandaid text-info"></i> Treatments of ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.medicalRecords}">
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="record" items="${pet.medicalRecords}">
                                                    <c:if test="${not empty record.treatment}">
                                                        <li class="list-group-item">
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
                    <div class="modal fade" id="diagnosesModal${pet.id}" tabindex="-1" aria-labelledby="diagnosesModalLabel${pet.id}" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header bg-warning-subtle">
                                    <h5 class="modal-title" id="diagnosesModalLabel${pet.id}">
                                        <i class="bi bi-activity text-warning"></i> Diagnoses of ${pet.name}
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>
                                <div class="modal-body">
                                    <c:choose>
                                        <c:when test="${not empty pet.medicalRecords}">
                                            <ul class="list-group list-group-flush">
                                                <c:forEach var="record" items="${pet.medicalRecords}">
                                                    <c:if test="${not empty record.description}">
                                                        <li class="list-group-item">
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
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column align-items-center py-5">
                <i class="bi bi-paw text-secondary" style="font-size:5rem;"></i>
                <div class="alert alert-warning text-center mt-4 fs-5" style="max-width:420px;">
                    You do not have any registered animals yet.
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>