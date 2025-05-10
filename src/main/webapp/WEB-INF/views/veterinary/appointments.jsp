<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Appointments</title>
</head>
<body>
<h2>Appointment List</h2>
<table border="1">
    <thead>
        <tr>
            <th>ID</th>
            <th>Pet Name</th>
            <th>Veterinary Name</th>
            <th>Clinic</th>
            <th>Date</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="appointment" items="${appointments}">
            <tr>
                <td>${appointment.appointmentId}</td>
                <td>${appointment.pet.name}</td>
                <td>${appointment.veterinary.firstName} ${appointment.veterinary.lastName}</td>
                <td>${appointment.clinic.clinicName}</td>
                <td>${appointment.appointmentDate}</td>
                <td>${appointment.status}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</body>
</html>
