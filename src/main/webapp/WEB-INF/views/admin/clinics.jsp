<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<body id="pageBody">

<jsp:include page="../client/navbar.jsp"/>
<!-- STYLES -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">

<!-- SCRIPTS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<div class="container mt-5">
    <h2 class="mb-4">Clinic Management</h2>

    <form action="/admin/clinics/create" method="post" class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" required>
        </div>
        <%-- Eski location alanı yerine yeni adres inputları --%>
        <div class="col-md-4">
            <label class="form-label">City</label>
            <select name="cityCode" id="citySelectCreate" class="form-select" required>
                <option value="">Select City</option>
                <%-- Şehirler JavaScript ile yüklenecek --%>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">District</label>
            <select name="districtCode" id="districtSelectCreate" class="form-select" required disabled>
                <option value="">Select District</option>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">Locality</label>
            <select name="localityCode" id="localitySelectCreate" class="form-select" required disabled>
                <option value="">Select Locality</option>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">Street Address</label>
            <input type="text" name="streetAddress" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Postal Code (Optional)</label>
            <input type="text" name="postalCode" class="form-control">
        </div>
        <%-- Yeni adres inputları sonu --%>

        <div class="col-md-3">
            <label class="form-label">Opening Hour</label>
            <input type="time" name="openingHour" class="form-control" required>
        </div>
        <div class="col-md-3">
            <label class="form-label">Closing Hour</label>
            <input type="time" name="closingHour" class="form-control" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}">${user.username}</option>
                </c:forEach>
            </select>
        </div>
        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Clinic</button>
        </div>
    </form>

    <table id="clinicTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Clinic Name</th>
            <th>Address</th> <%-- Location yerine Address --%>
            <th>Opening Hour</th>
            <th>Closing Hour</th>
            <th>Owner</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="clinic" items="${clinics}">
            <tr>
                <td>${clinic.clinicId}</td>
                <td>${clinic.clinicName}</td>
                    <%-- Adres bilgilerini birleştirerek gösteriyoruz --%>
                <td>
                        ${clinic.streetAddress}
                    <c:if test="${not empty clinic.locality}">
                        , ${clinic.locality.name}
                    </c:if>
                    <c:if test="${not empty clinic.locality.district}">
                        / ${clinic.locality.district.name}
                    </c:if>
                    <c:if test="${not empty clinic.locality.district.city}">
                        / ${clinic.locality.district.city.name}
                    </c:if>
                    <c:if test="${not empty clinic.postalCode}">
                        - ${clinic.postalCode}
                    </c:if>
                </td>
                <td>${clinic.openingHour}</td>
                <td>${clinic.closingHour}</td>
                <td>${clinic.user.username}</td>
                <td>
                    <a href="/admin/clinics/edit/${clinic.clinicId}" class="btn btn-warning btn-sm">Edit</a>
                    <a href="/admin/pets/${clinic.clinicId}/pets" class="btn btn-info btn-sm">Pets</a>
                    <a href="/admin/clinics/${clinic.clinicId}/veterinaries" class="btn btn-primary btn-sm">Veterinaries</a>
                    <form action="/admin/clinics/delete/${clinic.clinicId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function () {
        $('#clinicTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });

        // --- Adres Combo Box'ları İçin JavaScript Mantığı (YENİ) ---
        const citySelectCreate = $('#citySelectCreate');
        const districtSelectCreate = $('#districtSelectCreate');
        const localitySelectCreate = $('#localitySelectCreate');

        // Fonksiyon: Şehirleri Yükle
        function loadCities(callback) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/addresses/cities',
                type: 'GET',
                success: function(data) {
                    citySelectCreate.empty().append('<option value="">Select City</option>');
                    if (data && data.length > 0) {
                        data.forEach(function(city) {
                            citySelectCreate.append($('<option>', {
                                value: city.code,
                                text: city.name
                            }));
                        });
                    } else {
                        citySelectCreate.append('<option value="">No cities found</option>');
                    }
                    if (callback) callback();
                },
                error: function(xhr, status, error) {
                    console.error("Error loading cities:", status, error);
                    citySelectCreate.empty().append('<option value="">Error loading cities</option>');
                }
            });
        }

        // Fonksiyon: İlçeleri Yükle
        function loadDistricts(cityCode, selectedDistrictCode, callback) {
            districtSelectCreate.empty().append('<option value="">Loading districts...</option>').prop('disabled', true);
            localitySelectCreate.empty().append('<option value="">Select Locality</option>').prop('disabled', true);

            if (cityCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/districts/' + cityCode,
                    type: 'GET',
                    success: function(data) {
                        districtSelectCreate.empty().append('<option value="">Select District</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(district) {
                                districtSelectCreate.append($('<option>', {
                                    value: district.code,
                                    text: district.name,
                                    selected: (selectedDistrictCode && district.code == selectedDistrictCode) // Edit için ön seçim
                                }));
                            });
                            districtSelectCreate.prop('disabled', false);
                        } else {
                            districtSelectCreate.append('<option value="">No districts found</option>');
                        }
                        if (callback) callback();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading districts:", status, error);
                        districtSelectCreate.empty().append('<option value="">Error loading districts</option>');
                    }
                });
            } else {
                districtSelectCreate.empty().append('<option value="">Select City first</option>');
            }
        }

        // Fonksiyon: Mahalleleri Yükle
        function loadLocalities(districtCode, selectedLocalityCode) {
            localitySelectCreate.empty().append('<option value="">Loading localities...</option>').prop('disabled', true);

            if (districtCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/localities/' + districtCode,
                    type: 'GET',
                    success: function(data) {
                        localitySelectCreate.empty().append('<option value="">Select Locality</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(locality) {
                                localitySelectCreate.append($('<option>', {
                                    value: locality.code,
                                    text: locality.name,
                                    selected: (selectedLocalityCode && locality.code == selectedLocalityCode) // Edit için ön seçim
                                }));
                            });
                            localitySelectCreate.prop('disabled', false);
                        } else {
                            localitySelectCreate.append('<option value="">No localities found</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading localities:", status, error);
                        localitySelectCreate.empty().append('<option value="">Error loading localities</option>');
                    }
                });
            } else {
                localitySelectCreate.empty().append('<option value="">Select District first</option>');
            }
        }

        // Event Listeners
        citySelectCreate.on('change', function() {
            const selectedCityCode = $(this).val();
            loadDistricts(selectedCityCode);
        });

        districtSelectCreate.on('change', function() {
            const selectedDistrictCode = $(this).val();
            loadLocalities(selectedDistrictCode);
        });

        // Sayfa yüklendiğinde şehirleri otomatik yükle
        loadCities();
    });
</script>

<script>
    const themeToggleSwitch = document.getElementById('themeToggleSwitch');
    const body = document.getElementById('pageBody');
    const navbar = document.getElementById('mainNavbar');

    function applyTheme(theme) {
        if (theme === 'dark') {
            body.classList.add('bg-dark', 'text-white');
            body.classList.remove('bg-light', 'text-dark');
            if (navbar) {
                navbar.classList.add('navbar-dark', 'bg-dark');
                navbar.classList.remove('navbar-light', 'bg-light');
            }
            themeToggleSwitch.checked = true;
            document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/moon.gif')");
        } else {
            body.classList.add('bg-light', 'text-dark');
            body.classList.remove('bg-dark', 'text-white');
            if (navbar) {
                navbar.classList.add('navbar-light', 'bg-light');
                navbar.classList.remove('navbar-dark', 'bg-dark');
            }
            themeToggleSwitch.checked = false;
            document.querySelector('.slider:before')?.style?.setProperty('background-image', "url('<%= request.getContextPath() %>/img/sun.gif')");
        }

        localStorage.setItem('theme', theme);
    }

    document.addEventListener("DOMContentLoaded", () => {
        const savedTheme = localStorage.getItem("theme") || "light";
        applyTheme(savedTheme);

        themeToggleSwitch?.addEventListener("change", () => {
            const newTheme = themeToggleSwitch.checked ? "dark" : "light";
            applyTheme(newTheme);
        });
    });
</script>

</body>