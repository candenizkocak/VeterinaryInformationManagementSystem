<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Login | PetPoint</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        body {
            background: #e4e9ed;
            margin: 0;
        }
        .login-main {
            min-height: 100vh;
            display: flex;
        }
        .login-image {
            flex-basis: 45%;
            min-width: 330px;
            background: #b6d3ce;
            min-height: 100vh;
            position: relative;
            display: flex;
            align-items: stretch;
            justify-content: stretch;
            box-shadow: 6px 0 22px 0 #0001;
        }
        .login-image img {
            width: 100%;
            height: 100vh;
            object-fit: cover;
            object-position: top center;
            display: block;
        }
        .login-side {
            flex-basis: 55%;
            background: #f8fafb;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-width: 420px;
        }
        .petpoint-logo {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 8px;
            margin-top: 10px;
        }
        .petpoint-logo .icon {
            font-size: 2.2rem;
            color: #2581a7;
        }
        .petpoint-logo .text {
            font-size: 2.2rem;
            font-weight: bold;
            color: #2581a7;
            letter-spacing: .7px;
        }
        .login-card {
            width: 100%;
            max-width: 390px;
            background: #fff;
            border-radius: 22px;
            box-shadow: 0 3px 16px #0001;
            padding: 38px 32px 34px 32px;
            margin-top: 10px;
        }
        .login-card h2 {
            text-align: center;
            color: #227497;
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 28px;
            letter-spacing: .5px;
        }
        .form-label {
            color: #227497;
            font-weight: 500;
        }
        .form-control {
            border-radius: 14px;
            padding: 10px 14px;
            border: 1.5px solid #b1c7d3;
            margin-bottom: 18px;
            background: #f3f7fa;
        }
        .btn-login {
            width: 100%;
            background: #2581a7;
            color: #fff;
            font-weight: 600;
            border-radius: 14px;
            padding: 12px 0;
            font-size: 1.09rem;
            margin-top: 10px;
            transition: background .18s;
        }
        .btn-login:hover {
            background: #16627e;
        }
        .btn-register {
            width: 100%;
            background: #f5f6fa;
            color: #227497;
            border-radius: 14px;
            border: 1.5px solid #b1c7d3;
            font-weight: 600;
            font-size: 1.02rem;
            padding: 10px 0;
            transition: background .15s, color .15s, border .15s;
        }
        .btn-register:hover {
            background: #e6f7f7;
            color: #2581a7;
            border: 1.5px solid #2581a7;
        }
        .alert-danger {
            border-radius: 12px;
            font-size: .96rem;
            margin-bottom: 16px;
        }
        @media (max-width: 1050px) {
            .login-main { flex-direction: column; }
            .login-image { min-height: 220px; height: 220px; flex-basis:unset; width:100vw;}
            .login-image img { height: 220px; }
            .login-side { flex-basis: unset; min-width: unset; }
            .petpoint-logo { margin: 12px 0 8px 0;}
            .login-card {margin-top: 10px;}
        }
    </style>
</head>
<body>
<div class="login-main">
    <div class="login-image">
        <img src="/img/Login1.jpg" alt="Veteriner login görseli"/>
    </div>
    <div class="login-side">
        <div class="petpoint-logo">
            <span class="icon">🏥</span>
            <span class="text">PetPoint</span>
       </div>
        <div class="login-card">
            <h2>Login</h2>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <form action="/perform_login" method="post">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" required />
                </div>
                <div class="mb-2">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <button type="submit" class="btn btn-login">Login</button>
            </form>
            <a href="/signup" class="btn btn-register mt-2">Sign Up</a>
        </div>
    </div>
</div>
</body>
</html>
