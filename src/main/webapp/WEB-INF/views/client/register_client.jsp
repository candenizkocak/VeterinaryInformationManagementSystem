<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Complete Your Client Profile</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <%-- Genel tema CSS'i (global stiller için) --%>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <%-- Bu sayfaya özel CSS'i ekliyoruz. account_settings.css yerine register_client.css kullanabiliriz. --%>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/register_client.css">

</head>
<body id="pageBody">
<%-- Client modülüne özel navbar'ı dahil eder --%>
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <div class="register-card">
        <div class="register-title">Complete Your Profile</div>
        <p class="register-text">
            To proceed, please provide your personal and address details.
        </p>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success text-center">
                    ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger text-center">
                    ${errorMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/api/clients/register" method="post" autocomplete="off">
            <div class="mb-3">
                <label for="firstName" class="form-label">First Name:</label>
                <input type="text" name="firstName" id="firstName" class="form-control" value="${clientDto.firstName}" required maxlength="40" autofocus />
            </div>
            <div class="mb-3">
                <label for="lastName" class="form-label">Last Name:</label>
                <input type="text" name="lastName" id="lastName" class="form-control" value="${clientDto.lastName}" required maxlength="40" />
            </div>

            <%-- Adres Bilgileri --%>
            <div class="mb-3">
                <label for="citySelect" class="form-label">City</label>
                <select name="cityCode" id="citySelect" class="form-select" required>
                    <option value="">Select City</option>
                    <%-- Şehirler Controller'dan gelecek --%>
                    <c:forEach var="city" items="${cities}">
                        <option value="${city.code}" <c:if test="${clientDto.cityCode == city.code}">selected</c:if>>${city.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label for="districtSelect" class="form-label">District</label>
                <select name="districtCode" id="districtSelect" class="form-select" required disabled>
                    <option value="">Select District</option>
                    <%-- İlçeler JavaScript ile yüklenecek --%>
                </select>
            </div>

            <div class="mb-3">
                <label for="localitySelect" class="form-label">Locality</label>
                <select name="localityCode" id="localitySelect" class="form-select" required disabled>
                    <option value="">Select Locality</option>
                    <%-- Mahalleler JavaScript ile yüklenecek --%>
                </select>
            </div>

            <div class="mb-3">
                <label for="streetAddress" class="form-label">Street Address (Street Name, Building No, etc.)</label>
                <input type="text" name="streetAddress" id="streetAddress" class="form-control" value="${clientDto.streetAddress}" required maxlength="255">
            </div>

            <div class="mb-3">
                <label for="apartmentNumber" class="form-label">Apartment Number (Optional)</label>
                <input type="text" name="apartmentNumber" id="apartmentNumber" class="form-control" value="${clientDto.apartmentNumber}" maxlength="50">
            </div>

            <div class="mb-3">
                <label for="postalCode" class="form-label">Postal Code (Optional)</label>
                <input type="text" name="postalCode" id="postalCode" class="form-control" value="${clientDto.postalCode}" maxlength="10">
            </div>

            <button type="submit" class="btn-create-profile">Create Profile</button>
        </form>

        <a href="/" class="btn btn-home-mini mt-3">Back Home</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        const citySelect = $('#citySelect');
        const districtSelect = $('#districtSelect');
        const localitySelect = $('#localitySelect');

        // Initial values for potential re-submission with errors (Spring will populate clientDto)
        const initialCityCode = '${clientDto.cityCode}' !== '' ? parseInt('${clientDto.cityCode}') : null;
        const initialDistrictCode = '${clientDto.districtCode}' !== '' ? parseInt('${clientDto.districtCode}') : null;
        const initialLocalityCode = '${clientDto.localityCode}' !== '' ? parseInt('${clientDto.localityCode}') : null;

        function loadDistricts(cityCode, selectedDistrictCode, callback) {
            districtSelect.empty().append('<option value="">Loading districts...</option>').prop('disabled', true);
            localitySelect.empty().append('<option value="">Select Locality</option>').prop('disabled', true);

            if (cityCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/districts/' + cityCode,
                    type: 'GET',
                    success: function(data) {
                        districtSelect.empty().append('<option value="">Select District</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(district) {
                                districtSelect.append($('<option>', {
                                    value: district.code,
                                    text: district.name,
                                    selected: (selectedDistrictCode !== null && district.code === selectedDistrictCode)
                                }));
                            });
                            districtSelect.prop('disabled', false);
                        } else {
                            districtSelect.append('<option value="">No districts found</option>');
                        }
                        if (callback) callback();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading districts:", status, error);
                        districtSelect.empty().append('<option value="">Error loading districts</option>');
                        districtSelect.prop('disabled', true);
                    }
                });
            } else {
                districtSelect.empty().append('<option value="">Select City first</option>');
                districtSelect.prop('disabled', true);
            }
        }

        function loadLocalities(districtCode, selectedLocalityCode) {
            localitySelect.empty().append('<option value="">Loading localities...</option>').prop('disabled', true);

            if (districtCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/localities/' + districtCode,
                    type: 'GET',
                    success: function(data) {
                        localitySelect.empty().append('<option value="">Select Locality</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(locality) {
                                localitySelect.append($('<option>', {
                                    value: locality.code,
                                    text: locality.name,
                                    selected: (selectedLocalityCode !== null && locality.code === selectedLocalityCode)
                                }));
                            });
                            localitySelect.prop('disabled', false);
                        } else {
                            localitySelect.append('<option value="">No localities found</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading localities:", status, error);
                        localitySelect.empty().append('<option value="">Error loading localities</option>');
                        localitySelect.prop('disabled', true);
                    }
                });
            } else {
                localitySelect.empty().append('<option value="">Select District first</option>');
                localitySelect.prop('disabled', true);
            }
        }

        citySelect.on('change', function() {
            loadDistricts($(this).val(), null, null);
        });

        districtSelect.on('change', function() {
            loadLocalities($(this).val(), null);
        });

        // Load initial data if a city/district/locality was already selected (e.g., after form submission with errors)
        if (initialCityCode !== null) {
            citySelect.val(initialCityCode); // Set the selected city
            loadDistricts(initialCityCode, initialDistrictCode, function() {
                if (initialDistrictCode !== null) {
                    loadLocalities(initialDistrictCode, initialLocalityCode);
                }
            });
        }
    });
</script>

<%-- Navbar ve Tema JavaScript'i (mevcut olduğu gibi kalsın) --%>
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
</html>