<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Account Settings</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/client/account_settings.css">

</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <div class="settings-card">
        <div class="settings-title">Account Settings</div>

        <c:if test="${not empty success}">
            <div class="alert alert-success text-center">Your account settings have been updated successfully!</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger text-center">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/api/clients/account-settings" method="post" autocomplete="off">
            <div class="mb-3">
                <label class="form-label">First Name:</label>
                <input type="text" name="firstName" value="${accountSettings.firstName}" class="form-control" required maxlength="40" />
            </div>
            <div class="mb-3">
                <label class="form-label">Last Name:</label>
                <input type="text" name="lastName" value="${accountSettings.lastName}" class="form-control" required maxlength="40" />
            </div>
            <div class="mb-3">
                <label class="form-label">Email:</label>
                <input type="email" name="email" value="${accountSettings.email}" class="form-control" required maxlength="60" />
            </div>
            <div class="mb-3">
                <label class="form-label">Phone:</label>
                <input type="text" name="phone" value="${accountSettings.phone}" class="form-control" maxlength="20" />
            </div>

            <div class="mb-3">
                <label for="citySelect" class="form-label">City</label>
                <select name="cityCode" id="citySelect" class="form-select" required>
                    <option value="">Select City</option>
                    <c:forEach var="city" items="${cities}">
                        <option value="${city.code}">${city.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="mb-3">
                <label for="districtSelect" class="form-label">District</label>
                <select name="districtCode" id="districtSelect" class="form-select" required disabled>
                    <option value="">Select District</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="localitySelect" class="form-label">Locality</label>
                <select name="localityCode" id="localitySelect" class="form-select" required disabled>
                    <option value="">Select Locality</option>
                </select>
            </div>

            <div class="mb-3">
                <label for="streetAddress" class="form-label">Street Address (Street Name, Building No, etc.)</label>
                <input type="text" name="streetAddress" id="streetAddress" class="form-control" value="${accountSettings.streetAddress}" required maxlength="255">
            </div>

            <div class="mb-3">
                <label for="apartmentNumber" class="form-label">Apartment Number (Optional)</label>
                <input type="text" name="apartmentNumber" id="apartmentNumber" class="form-control" value="${accountSettings.apartmentNumber}" maxlength="50">
            </div>

            <div class="mb-3">
                <label for="postalCode" class="form-label">Postal Code (Optional)</label>
                <input type="text" name="postalCode" id="postalCode" class="form-control" value="${accountSettings.postalCode}" maxlength="10">
            </div>

            <button type="submit" class="btn-save-modern">Save Changes</button>
        </form>

        <div class="divider"></div>

        <a href="${pageContext.request.contextPath}/api/clients/change-password" class="btn btn-change-password">
            <i class="bi bi-shield-lock"></i> Change Password
        </a>

        <a href="/" class="btn btn-back-home-card">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        const citySelect = $('#citySelect');
        const districtSelect = $('#districtSelect');
        const localitySelect = $('#localitySelect');

        const initialCityCode = ${accountSettings.cityCode != null ? accountSettings.cityCode : 'null'};
        const initialDistrictCode = ${accountSettings.districtCode != null ? accountSettings.districtCode : 'null'};
        const initialLocalityCode = ${accountSettings.localityCode != null ? accountSettings.localityCode : 'null'};


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
                                    selected: (selectedDistrictCode !== null && district.code == selectedDistrictCode)
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
                    }
                });
            } else {
                districtSelect.empty().append('<option value="">Select City first</option>');
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
                                    selected: (selectedLocalityCode !== null && locality.code == selectedLocalityCode)
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
                    }
                });
            } else {
                localitySelect.empty().append('<option value="">Select District first</option>');
            }
        }

        citySelect.on('change', function() {
            loadDistricts($(this).val(), null, null);
        });

        districtSelect.on('change', function() {
            loadLocalities($(this).val(), null);
        });

        if (initialCityCode !== null) {
            citySelect.val(initialCityCode); // Set the selected city
            loadDistricts(initialCityCode, initialDistrictCode, function() {
                if (initialDistrictCode !== null) {
                    loadLocalities(initialDistrictCode, initialLocalityCode);
                }
            });
        } else {

            citySelect.prop('disabled', false);
        }
    });
</script>

</body>
</html>