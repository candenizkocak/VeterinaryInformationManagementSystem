<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav style="background-color: #f1f1f1; padding: 10px;">
    <a href="/" style="margin-right: 15px;">Home</a>

    <c:if test="${not empty sessionScope.user}">
        <a href="/dashboard" style="margin-right: 15px;">Dashboard</a>
        <a href="/logout">Logout</a>
    </c:if>

    <c:if test="${empty sessionScope.user}">
        <a href="/login" style="margin-right: 15px;">Login</a>
        <a href="/signup">Sign Up</a>
    </c:if>
</nav>
<hr/>
