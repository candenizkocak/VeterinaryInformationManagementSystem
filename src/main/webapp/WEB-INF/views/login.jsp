<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login | Veterinary System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="bg-dark text-white">

<jsp:include page="navbar.jsp"/>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <h2 class="text-center mb-4">Login</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="/perform_login" method="post">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>

                <button type="submit" class="btn btn-success w-100">Login</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
