<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<body id="pageBody">

<jsp:include page="../navbar.jsp"/>

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
    <h2 class="mb-4">Edit Clinic</h2>

    <form action="/admin/clinics/update" method="post" class="row g-3">
        <input type="hidden" name="clinicId" value="${clinic.clinicId}"/>

        <div class="col-md-4">
            <label class="form-label">Clinic Name</label>
            <input type="text" name="clinicName" class="form-control" value="${clinic.clinicName}" required>
        </div>

        <div class="col-md-4">
            <label class="form-label">City</label>
            <select name="cityCode" id="citySelectEdit" class="form-select" required>
                <option value="">Select City</option>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">District</label>
            <select name="districtCode" id="districtSelectEdit" class="form-select" required disabled>
                <option value="">Select District</option>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">Locality</label>
            <select name="localityCode" id="localitySelectEdit" class="form-select" required disabled>
                <option value="">Select Locality</option>
            </select>
        </div>
        <div class="col-md-4">
            <label class="form-label">Street Address</label>
            <input type="text" name="streetAddress" class="form-control" value="${clinic.streetAddress}" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Postal Code (Optional)</label>
            <input type="text" name="postalCode" class="form-control" value="${clinic.postalCode}">
        </div>


        <div class="col-md-4">
            <label class="form-label">User (Clinic Owner)</label>
            <select name="userId" class="form-select" required>
                <c:forEach var="user" items="${users}">
                    <option value="${user.userID}" <c:if test="${user.userID == clinic.user.userID}">selected</c:if>>
                            ${user.username}
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-3">
            <label class="form-label">Opening Hour</label>
            <input type="time" name="openingHour" class="form-control" value="${clinic.openingHour}" required>
        </div>

        <div class="col-md-3">
            <label class="form-label">Closing Hour</label>
            <input type="time" name="closingHour" class="form-control" value="${clinic.closingHour}" required>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-primary">Update Clinic</button>
            <a href="/admin/clinics" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>

<script>
    $(document).ready(function () {
        const citySelectEdit = $('#citySelectEdit');
        const districtSelectEdit = $('#districtSelectEdit');
        const localitySelectEdit = $('#localitySelectEdit');


        const initialCityCode = ${not empty clinic.locality && not empty clinic.locality.district.city ? clinic.locality.district.city.code : 'null'};
        const initialDistrictCode = ${not empty clinic.locality && not empty clinic.locality.district ? clinic.locality.district.code : 'null'};
        const initialLocalityCode = ${not empty clinic.locality ? clinic.locality.code : 'null'};


        function loadCitiesEdit(callback) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/addresses/cities',
                type: 'GET',
                success: function(data) {
                    citySelectEdit.empty().append('<option value="">Select City</option>');
                    if (data && data.length > 0) {
                        data.forEach(function(city) {
                            citySelectEdit.append($('<option>', {
                                value: city.code,
                                text: city.name,
                                selected: (initialCityCode && city.code == initialCityCode)
                            }));
                        });
                    } else {
                        citySelectEdit.append('<option value="">No cities found</option>');
                    }
                    if (callback) callback();
                },
                error: function(xhr, status, error) {
                    console.error("Error loading cities:", status, error);
                    citySelectEdit.empty().append('<option value="">Error loading cities</option>');
                }
            });
        }


        function loadDistrictsEdit(cityCode, selectedDistrictCode, callback) {
            districtSelectEdit.empty().append('<option value="">Loading districts...</option>').prop('disabled', true);
            localitySelectEdit.empty().append('<option value="">Select Locality</option>').prop('disabled', true);

            if (cityCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/districts/' + cityCode,
                    type: 'GET',
                    success: function(data) {
                        districtSelectEdit.empty().append('<option value="">Select District</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(district) {
                                districtSelectEdit.append($('<option>', {
                                    value: district.code,
                                    text: district.name,
                                    selected: (selectedDistrictCode && district.code == selectedDistrictCode) // Edit için ön seçim
                                }));
                            });
                            districtSelectEdit.prop('disabled', false);
                        } else {
                            districtSelectEdit.append('<option value="">No districts found</option>');
                        }
                        if (callback) callback();
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading districts:", status, error);
                        districtSelectEdit.empty().append('<option value="">Error loading districts</option>');
                    }
                });
            } else {
                districtSelectEdit.empty().append('<option value="">Select City first</option>');
            }
        }

        function loadLocalitiesEdit(districtCode, selectedLocalityCode) {
            localitySelectEdit.empty().append('<option value="">Loading localities...</option>').prop('disabled', true);

            if (districtCode) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/addresses/localities/' + districtCode,
                    type: 'GET',
                    success: function(data) {
                        localitySelectEdit.empty().append('<option value="">Select Locality</option>');
                        if (data && data.length > 0) {
                            data.forEach(function(locality) {
                                localitySelectEdit.append($('<option>', {
                                    value: locality.code,
                                    text: locality.name,
                                    selected: (selectedLocalityCode && locality.code == selectedLocalityCode)
                                }));
                            });
                            localitySelectEdit.prop('disabled', false);
                        } else {
                            localitySelectEdit.append('<option value="">No localities found</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading localities:", status, error);
                        localitySelectEdit.empty().append('<option value="">Error loading localities</option>');
                    }
                });
            } else {
                localitySelectEdit.empty().append('<option value="">Select District first</option>');
            }
        }

        citySelectEdit.on('change', function() {
            const selectedCityCode = $(this).val();
            loadDistrictsEdit(selectedCityCode, null, null);
        });

        districtSelectEdit.on('change', function() {
            const selectedDistrictCode = $(this).val();
            loadLocalitiesEdit(selectedDistrictCode, null);
        });

        loadCitiesEdit(function() {
            if (initialCityCode) {

                loadDistrictsEdit(initialCityCode, initialDistrictCode, function() {
                    if (initialDistrictCode) {

                        loadLocalitiesEdit(initialDistrictCode, initialLocalityCode);
                    }
                });
            }
        });
    });
</script>

<!-- THEME TOGGLE -->
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