<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login | Veterinary System</title>
</head>
<body>

<jsp:include page="navbar.jsp" />

<h2>Login</h2>

<c:if test="${not empty error}">
    <p style="color: red;">${error}</p>
</c:if>

<form action="/perform_login" method="post">
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <button type="submit">Login</button>
</form>
</body>
</html>
