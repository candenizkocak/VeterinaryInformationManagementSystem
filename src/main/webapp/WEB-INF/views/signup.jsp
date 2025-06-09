<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Sign Up | PetPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: #e7f5ef;
            margin: 0;
            min-height: 100vh;
        }
        .signup-main {
            min-height: 100vh;
            display: flex;
        }
        .signup-side {
            flex-basis: 50%;
            min-width: 340px;
            background: #f9faf8;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        .petpoint-logo {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 2rem;
            font-weight: bold;
            color: #278080;
            margin-bottom: 8px;
            margin-top: 8px;
            letter-spacing: .6px;
            text-decoration: none;
        }
        .signup-card {
            width: 100%;
            max-width: 380px;
            background: #f3faf7;
            border-radius: 22px;
            box-shadow: 0 6px 22px #0001;
            padding: 34px 30px 38px 30px;
            border: 1.2px solid #bfe2d6;
            position: relative;
        }
        .signup-card h2 {
            text-align: center;
            color: #278080;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 22px;
            letter-spacing: .5px;
        }
        .form-label {
            color: #288880;
            font-weight: 500;
            margin-bottom: 2px;
        }
        .form-control {
            border-radius: 13px;
            border: 1.3px solid #b9dbcc;
            background: #eaf6f2;
            margin-bottom: 12px;
            color: #347062;
        }
        .form-control:focus {
            border-color: #278080;
            box-shadow: 0 0 0 0.09rem #b7ece3;
        }
        .btn-signup {
            width: 100%;
            background: #5da690;
            color: #fff;
            font-weight: 700;
            border-radius: 13px;
            padding: 12px 0;
            font-size: 1.09rem;
            margin-top: 10px;
            margin-bottom: 6px;
            border: none;
            box-shadow: 0 2px 6px #0001;
            transition: background .18s, color .13s;
        }
        .btn-signup:hover {
            background: #1b8e6a;
            color: #fff;
        }
        .bottom-links-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 0;
            margin-top: 0;
            margin-bottom: 0;
            width: 100%;
            position: relative;
        }
        .login-link {
            color: #ff9050;
            text-decoration: underline;
            font-weight: 500;
            font-size: 1.02rem;
            padding: 2px 0;
            background: none;
            border: none;
            transition: color 0.13s;
        }
        .login-link:hover { color: #e56c0b; }
        .btn-home-mini {
            position: absolute;
            right: 20px;
            bottom: 15px;
            font-size: 0.92rem;
            padding: 4.5px 16px;
            border-radius: 8px;
            background: #f1f9f7;
            color: #288880;
            border: 1.1px solid #bfe2d6;
            font-weight: 500;
            transition: background .15s, color .15s, border .15s;
            text-decoration: none;
        }
        .btn-home-mini:hover {
            background: #d4f7ee;
            color: #11916e;
            border: 1.1px solid #26b98a;
        }
        .alert-danger {
            border-radius: 12px;
            font-size: .97rem;
            margin-bottom: 14px;
        }
        .signup-img {
            flex-basis: 50%;
            min-width: 320px;
            background: #dae8e0;
            min-height: 100vh;
            display: flex;
            align-items: stretch;
            justify-content: stretch;
            box-shadow: -6px 0 22px 0 #0001;
            position: relative;
        }
        .signup-img img {
            width: 100%;
            height: 100vh;
            object-fit: cover;
            object-position: center center;
            display: block;
            border-top-left-radius: 30px;
            border-bottom-left-radius: 30px;
        }
        @media (max-width: 1050px) {
            .signup-main { flex-direction: column-reverse;}
            .signup-img { min-height: 200px; height: 200px; flex-basis:unset; width:100vw; box-shadow: none;}
            .signup-img img { height: 200px; border-radius: 0; }
            .signup-side { flex-basis: unset; min-width: unset;}
            .signup-card { margin-top: 0;}
            .petpoint-logo { margin: 14px 0 6px 0;}
            .bottom-links-row { flex-direction: column; gap: 0; align-items: stretch;}
            .btn-home-mini { position: static; margin: 8px 0 0 0; width: 100%; }
        }
    </style>
</head>
<body>
<div class="signup-main">
    <div class="signup-side">
        <a href="/" class="petpoint-logo">PetPoint</a>
        <div class="signup-card">
            <h2>Sign Up</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <form method="post" action="/signup">
                <label class="form-label">Username</label>
                <input type="text" name="username" class="form-control" required />

                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" required />

                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" />

                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" />

                <button type="submit" class="btn btn-signup">Sign Up</button>
            </form>
            <div class="bottom-links-row">
                <a href="/login" class="login-link">Already have an account?</a>
            </div>
            <a href="/" class="btn-home-mini">Back Home</a>
        </div>
    </div>
    <div class="signup-img">
        <img src="/img/signup-vet.jpg" alt="Veteriner kayıt görseli"/>
    </div>
</div>
</body>
</html>
