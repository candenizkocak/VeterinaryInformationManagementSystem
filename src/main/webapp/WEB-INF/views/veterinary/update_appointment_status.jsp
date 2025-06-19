<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
    <title>Update Appointment Status</title>
    <jsp:include page="../client/navbar.jsp"/>    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        body.bg-dark .card {
            background-color: #2b2b2b !important;
        }
    </style>
</head>
<body id="pageBody">

<div class="container mt-5">
    <div class="text shadow-sm mx-auto" style="max-width: 600px;">
        <div class="card-header">
            <h3>Update Appointment Status</h3>
        </div>
        <div class="card-body">
            <p><strong>Pet:</strong> ${appointment.pet.name}</p>
            <p><strong>Client:</strong> ${appointment.pet.client.firstName} ${appointment.pet.client.lastName}</p>
            <p><strong>Date:</strong>
                <fmt:parseDate value="${appointment.appointmentDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
            </p>

            <form action="${pageContext.request.contextPath}/veterinary/appointments/update-status" method="post">
                <input type="hidden" name="appointmentId" value="${appointment.appointmentId}" />

                <div class="mb-3">
                    <label for="status" class="form-label">New Status</label>
                    <select id="status" name="status" class="form-select" required>
                        <c:forEach var="st" items="${statuses}">
                            <option value="${st}" <c:if test="${st == appointment.status}">selected</c:if>>
                                ${st}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">Save Changes</button>
                <a href="${pageContext.request.contextPath}/veterinary/appointments" class="btn btn-secondary">Cancel</a>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const body = document.getElementById("pageBody");
        const currentTheme = localStorage.getItem("theme") || "light";
        if (currentTheme === "dark") {
            body.classList.add("bg-dark", "text-white");
        } else {
            body.classList.add("bg-light", "text-dark");
        }
    });
</script>
</body>
</html>