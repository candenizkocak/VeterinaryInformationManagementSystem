<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Book Appointment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .appt-card {
            max-width: 440px; margin: 48px auto 0 auto; border-radius: 18px;
            box-shadow: 0 8px 36px 0 #1c4c8c14; padding: 35px 32px 28px 32px;
            background: #fff;
        }
        .appt-title {
            font-size: 2.0rem; color: #1066ee; font-weight: 600; text-align: center; margin-bottom: 27px;
        }
        .form-label { font-weight: 500; color: #27496d;}
        .form-control, .form-select { border-radius: 12px; font-size: 1.09rem; padding: 11px 12px;}
        .btn-appt { background: #157afe; border: none; font-size: 1.08rem; padding: 13px; border-radius: 10px; font-weight: 500; letter-spacing: 1px; margin-top: 10px; transition: 0.2s;}
        .btn-appt:hover { background: #1066ee;}
        .alert { border-radius: 10px; font-size: 1.08rem; margin-bottom: 23px;}
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="appt-card">
    <div class="appt-title"><i class="bi bi-calendar-plus"></i> Book Appointment</div>

    <c:if test="${success}">
        <div class="alert alert-success text-center">Appointment saved successfully!</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/api/clients/appointments/book" method="post">
        <div class="mb-3">
            <label class="form-label">Select Your Animal:</label>
            <select name="petId" class="form-select" required>
                <option value="">Select</option>
                <c:forEach var="pet" items="${pets}">
                    <option value="${pet.id}">${pet.name} (${pet.species})</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Date:</label>
            <input type="date" name="appointmentDate" class="form-control" required min="${today}"/>
        </div>
        <div class="mb-3">
            <label class="form-label">Time:</label>
            <input type="time" name="appointmentTime" class="form-control" required />
        </div>
        <div class="mb-3">
            <label class="form-label">Veterinary:</label>
            <select name="veterinaryId" class="form-select" required>
                <option value="">Select</option>
                <c:forEach var="vet" items="${veterinaries}">
                    <option value="${vet.id}">${vet.firstName} ${vet.lastName}</option>
                </c:forEach>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Note (optional):</label>
            <textarea name="note" class="form-control" rows="2"></textarea>
        </div>
        <button type="submit" class="btn btn-appt w-100">Book Appointment</button>
    </form>
</div>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
