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

<form method="post" action="/login">
    <label>Username:</label>
    <input type="text" name="username" required/><br><br>

    <label>Password:</label>
    <input type="password" name="password" required/><br><br>

    <input type="submit" value="Login"/>
</form>

</body>
</html>
