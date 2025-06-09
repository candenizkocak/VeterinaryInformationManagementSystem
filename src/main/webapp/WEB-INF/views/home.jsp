<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Veterinary System</title>

    <!-- STYLES -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

    <!-- SCRIPTS -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
</head>
<body class="bg-dark text-white">

<c:choose>
    <c:when test="${sessionScope.role == 'ROLE_CLIENT'}">
        <%-- Client rolündeki kullanıcılar için client klasöründeki navbar'ı dahil et --%>
        <jsp:include page="client/navbar.jsp"/>
    </c:when>
    <c:otherwise>
        <%-- Diğer roller (Admin, Veterinary, Clinic) ve giriş yapmamış kullanıcılar için varsayılan navbar'ı dahil et --%>
        <jsp:include page="navbar.jsp"/>
    </c:otherwise>
</c:choose>
<%-- SON: DEĞİŞTİRİLMİŞ KOD --%>

<div class="container mt-5">

    <c:choose>
        <c:when test="${not empty sessionScope.role}">
            <h1 class="mb-4 text-center">Welcome to Veterinary Information System</h1>

            <c:choose>
                <c:when test="${sessionScope.role == 'ROLE_ADMIN'}">
                    <div class="card bg-secondary text-white mb-3">
                        <div class="card-header">Admin Panel</div>
                        <div class="card-body">
                            <a href="/admin/users" class="btn btn-light me-2">Manage Users</a>
                            <a href="/admin/clinics" class="btn btn-light me-2">Manage Clinics</a>
                            <a href="/admin/veterinaries" class="btn btn-light me-2">Manage Veterinaries</a>
                            <a href="/admin/pets" class="btn btn-light me-2">Manage Pets</a>
                            <a href="/admin/appointments" class="btn btn-light me-2">Manage Appointments</a>
                        </div>
                    </div>
                </c:when>
                <c:when test="${sessionScope.role == 'ROLE_CLIENT'}">
                    <div class="card shadow-lg rounded-4 border-0 mb-5" style="background: linear-gradient(135deg,#cce7ff 70%,#e6f7ff 100%);">
                        <div class="card-header bg-transparent border-0 pt-4 pb-3">
                            <h3 class="fw-bold text-primary text-center mb-0">
                                <span style="font-size:2em;">👤</span> Client Panel
                            </h3>
                        </div>
                        <div class="card-body text-center py-4">
                            <p class="lead text-dark mb-4">Welcome! Easily manage your pets and appointments.</p>
                            <div class="d-flex flex-wrap justify-content-center gap-3 mb-2">
                                <a href="/api/clients/animals" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">🐾</span>
                                    <span class="fw-semibold mt-2">My Animals</span>
                                </a>
                                <a href="/api/clients/account-settings" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">⚙️</span>
                                    <span class="fw-semibold mt-2">Account Settings</span>
                                </a>
                                <a href="/api/clients/appointments" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">📅</span>
                                    <span class="fw-semibold mt-2">My Appointments</span>
                                </a>
                                <a href="/api/clients/add-animal" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;">
                                    <span style="font-size:2.2em;">🐶</span>
                                    <span class="fw-semibold mt-2">Add Animal</span>
                                </a>
                                <a href="/api/clients/our-clinics" class="btn btn-lg btn-light shadow rounded-4 px-4 py-3 d-flex flex-column align-items-center" style="min-width:150px;"> <%-- <--- YENİ EKLENEN BAĞLANTI --%>
                                    <span style="font-size:2.2em;">🏥</span>
                                    <span class="fw-semibold mt-2">Our Clinics</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:when>


                <c:when test="${sessionScope.role == 'ROLE_VETERINARY'}">
                    <div class="alert alert-success text-center">
                        <h4>Welcome to Veterinary Panel</h4>
                        <a href="/veterinary/appointments" class="btn btn-light mt-2">My Appointments</a>
                    </div>
                </c:when>

                <c:when test="${sessionScope.role == 'ROLE_CLINIC'}">
                    <jsp:include page="clinic/dashboard.jsp"/>
                </c:when>
            </c:choose>
        </c:when>

        <c:otherwise>
            <section class="text-center">
                <h1 class="mb-4">Welcome to Our Veterinary System</h1>
                <p class="mb-4">Explore information about pets and clinics below.</p>
                <a href="#pets" class="btn btn-primary me-2">Explore Pets</a>
                <a href="#clinics" class="btn btn-success">Find Clinics</a>
            </section>

            <section id="pets" class="text-white py-5">
                <h2 class="text-center mb-4">Pet Types</h2>

                <div id="petSelectArea" class="position-relative mx-auto">
                    <div id="petTypeContainer" class="transition mb-3">
                        <label for="petType" class="form-label">Select Pet Type</label>
                        <select id="petType" class="form-select">
                            <option value="">-- Choose --</option>
                            <option value="dog">Dog</option>
                            <option value="cat">Cat</option>
                        </select>
                    </div>

                    <div id="petBreedContainer" class="transition">
                        <label for="petBreed" class="form-label">Select Breed</label>
                        <select id="petBreed" class="form-select" disabled>
                            <option value="">-- Choose a type first --</option>
                        </select>
                    </div>
                </div>

                <div class="mt-5 text-center" id="breedInfo" style="display: none;">
                    <h4 class="mb-3">Breed Information</h4>
                    <p id="breedDescription"></p>
                </div>
            </section>

            <section id="clinics" class="bg-secondary text-white py-5">
                <div class="container">
                    <h2 class="text-center mb-4">Clinics</h2>
                    <p class="text-center">Klinik bilgileri ve harita burada olacak 📍</p>
                </div>
            </section>
        </c:otherwise>
    </c:choose>

</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const petType = document.getElementById('petType');
        const petBreed = document.getElementById('petBreed');
        const breedInfo = document.getElementById('breedInfo');
        const breedDescription = document.getElementById('breedDescription');
        const wrapper = document.getElementById('petSelectArea');

        const breedsData = {
            dog: {
                "Golden Retriever": "Friendly, intelligent, and devoted. Avg weight: 30–34 kg.",
                "German Shepherd": "Confident, courageous, and smart. Avg weight: 30–40 kg."
            },
            cat: {
                "British Shorthair": "Easygoing, affectionate. Avg weight: 5–7 kg.",
                "Siamese": "Vocal, social, and playful. Avg weight: 4–6 kg."
            }
        };

        petType.addEventListener('change', () => {
            const selectedType = petType.value;
            petBreed.innerHTML = '<option value="">-- Choose --</option>';
            breedInfo.style.display = "none";
            wrapper.classList.remove('pets-active');

            if (selectedType && breedsData[selectedType]) {
                wrapper.classList.add('pets-active');
                petBreed.disabled = false;

                Object.keys(breedsData[selectedType]).forEach(breed => {
                    const option = document.createElement('option');
                    option.value = breed;
                    option.textContent = breed;
                    petBreed.appendChild(option);
                });
            } else {
                petBreed.disabled = true;
            }
        });

        petBreed.addEventListener('change', () => {
            const type = petType.value;
            const breed = petBreed.value;

            if (type && breed && breedsData[type][breed]) {
                breedInfo.style.display = "block";
                breedDescription.textContent = breedsData[type][breed];
            } else {
                breedInfo.style.display = "none";
            }
        });
    });
</script>
</body>
</html>
