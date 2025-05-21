<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Create Client Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="card shadow p-4">
        <h2 class="mb-4 text-primary text-center">Client Profile Setup</h2>
        <p class="text-muted text-center">Please provide your personal information to complete your registration.</p>

        <form method="post" action="/api/clients/register">
            <div class="mb-3">
                <label for="firstName" class="form-label">First Name</label>
                <input type="text" name="firstName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="lastName" class="form-label">Last Name</label>
                <input type="text" name="lastName" class="form-control" required>
            </div>

            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <input type="text" name="address" class="form-control" required>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-primary px-4">Create Profile</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
