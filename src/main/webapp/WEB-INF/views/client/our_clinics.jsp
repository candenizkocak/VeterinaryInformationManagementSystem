<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Our Clinics</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
    <style>
        .filter-row {
            margin-bottom: 22px;
            margin-top: -12px;
        }
        .filter-group {
            display: flex;
            gap: 16px;
            align-items: center;
        }
        .custom-select {
            min-width: 170px;
            background: #f3f7fa;
            border-radius: 10px;
            border: 1px solid #dde4ee;
            font-weight: 500;
            font-size: 1rem;
            color: #34436c;
            box-shadow: 0 1px 4px 0 rgba(31, 52, 95, 0.03);
            padding: 9px 14px;
            transition: border .2s;
        }
        .custom-select:focus {
            border-color: #246bda;
            outline: none;
            box-shadow: 0 0 0 0.15rem #e6eeff;
        }
        @media (max-width: 768px) {
            .filter-group {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
        }
    </style>
</head>
<body id="pageBody">
<jsp:include page="navbar.jsp"/>

<div class="container py-4">
    <h2 class="fw-bold text-primary mb-3 text-center">
        <i class="bi bi-hospital me-2"></i>Our Clinics
    </h2>
    <div class="row filter-row">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="filter-group">
                <select id="citySelect" class="custom-select">
                    <option value="">Select City</option>
                </select>
                <select id="districtSelect" class="custom-select" disabled>
                    <option value="">Select District</option>
                </select>
            </div>
        </div>
    </div>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4" id="clinicsArea"></div>
</div>

<div class="modal fade" id="veterinariansModal" tabindex="-1" aria-labelledby="veterinariansModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="veterinariansModalLabel">
                    Veterinarians at <span id="modalClinicName"></span>
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="veterinariansList">
                    <p class="text-center text-muted" id="loadingVetsMessage">Loading veterinarians...</p>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function formatArrayHour(arr) {
        if (!Array.isArray(arr) || arr.length < 2) return '?';
        let h = arr[0].toString().padStart(2, '0');
        let m = arr[1].toString().padStart(2, '0');
        return h + ':' + m;
    }
    $(document).ready(function() {
        let allClinics = [];
        $.ajax({
            url: '/api/addresses/cities',
            method: 'GET',
            dataType: 'json',
            success: function(cities) {
                cities.forEach(function(city) {
                    $('#citySelect').append('<option value="' + city.code + '">' + city.name + '</option>');
                });
            }
        });
        function fetchAndRenderAllClinics() {
            $.ajax({
                url: '/api/clients/clinics/all',
                method: 'GET',
                dataType: 'json',
                success: function(clinics) {
                    allClinics = clinics;
                    renderClinics(allClinics);
                }
            });
        }
        fetchAndRenderAllClinics();
        $('#citySelect').on('change', function() {
            var cityCode = $(this).val();
            $('#districtSelect').empty().append('<option value="">Select District</option>').prop('disabled', true);
            if (cityCode) {
                $.ajax({
                    url: '/api/addresses/districts/' + cityCode,
                    method: 'GET',
                    dataType: 'json',
                    success: function(districts) {
                        $('#districtSelect').prop('disabled', false);
                        districts.forEach(function(district) {
                            $('#districtSelect').append('<option value="' + district.code + '">' + district.name + '</option>');
                        });
                    }
                });
            } else {
                $('#districtSelect').prop('disabled', true);
            }
            filterAndRenderClinics();
        });
        $('#districtSelect').on('change', function() {
            filterAndRenderClinics();
        });
        function filterAndRenderClinics() {
            var cityCode = $('#citySelect').val();
            var districtCode = $('#districtSelect').val();
            let filtered = allClinics;
            if (cityCode) {
                filtered = filtered.filter(function(clinic) {
                    return clinic.cityCode && clinic.cityCode == cityCode;
                });
            }
            if (districtCode) {
                filtered = filtered.filter(function(clinic) {
                    return clinic.districtCode && clinic.districtCode == districtCode;
                });
            }
            renderClinics(filtered);
        }
        function renderClinics(clinics) {
            $('#clinicsArea').empty();
            if (clinics.length > 0) {
                clinics.forEach(function(clinic) {
                    var openHour = formatArrayHour(clinic.openingHour);
                    var closeHour = formatArrayHour(clinic.closingHour);
                    var timeInfo = openHour + ' - ' + closeHour;
                    var clinicCard = ''
                        + '<div class="col">'
                        +   '<div class="card h-100 shadow-sm">'
                        +     '<div class="card-body d-flex flex-column">'
                        +       '<h5 class="card-title text-primary fw-bold">' + clinic.clinicName + '</h5>'
                        +       '<p class="card-text text-muted mb-1"><i class="bi bi-geo-alt-fill me-1"></i> ' + (clinic.formattedAddress || '') + '</p>'
                        +       '<p class="card-text text-muted mb-3"><i class="bi bi-clock-fill me-1"></i> ' + timeInfo + '</p>'
                        +       '<div class="mt-auto d-flex justify-content-center">'
                        +         '<button class="btn btn-outline-primary view-vets-btn w-100" '
                        +                 'data-bs-toggle="modal" '
                        +                 'data-bs-target="#veterinariansModal" '
                        +                 'data-clinic-id="' + clinic.clinicId + '" '
                        +                 'data-clinic-name="' + clinic.clinicName + '">'
                        +           '<i class="bi bi-people-fill me-2"></i> View Veterinarians'
                        +         '</button>'
                        +       '</div>'
                        +     '</div>'
                        +   '</div>'
                        + '</div>';
                    $('#clinicsArea').append(clinicCard);
                });
            } else {
                $('#clinicsArea').append('<div class="alert alert-info text-center">No clinics found.</div>');
            }
            bindVeterinarianButtons();
        }
        function bindVeterinarianButtons() {
            $('.view-vets-btn').off('click').on('click', function() {
                const clinicId = $(this).data('clinic-id');
                const clinicName = $(this).data('clinic-name');
                const veterinariansList = $('#veterinariansList');
                const loadingVetsMessage = $('#loadingVetsMessage');
                $('#modalClinicName').text(clinicName);
                veterinariansList.empty();
                loadingVetsMessage.show();
                $.ajax({
                    url: '/api/clients/clinics/' + clinicId + '/veterinaries',
                    type: 'GET',
                    dataType: 'json',
                    success: function(vets) {
                        loadingVetsMessage.hide();
                        if (vets && vets.length > 0) {
                            vets.forEach(function(vet) {
                                var vetCard = ''
                                    + '<div class="card mb-3 shadow-sm">'
                                    +   '<div class="card-body">'
                                    +     '<p class="mb-1"><strong>Name:</strong> ' + vet.firstName + ' ' + vet.lastName + '</p>'
                                    +     '<p class="mb-3 text-muted">Specialization: <strong>' + vet.specialization + '</strong></p>'
                                    +     '<a href="/api/clients/appointments/book?clinicId=' + clinicId + '&veterinaryId=' + vet.veterinaryId + '"'
                                    +        ' class="btn btn-success btn-sm w-100">'
                                    +        'Book Appointment'
                                    +     '</a>'
                                    +   '</div>'
                                    + '</div>';
                                veterinariansList.append(vetCard);
                            });
                        } else {
                            veterinariansList.append('<div class="alert alert-warning text-center">No veterinarians found for this clinic.</div>');
                        }
                    },
                    error: function() {
                        loadingVetsMessage.hide();
                        veterinariansList.append('<div class="alert alert-danger text-center">Error loading veterinarians!</div>');
                    }
                });
            });
        }
        $('#veterinariansModal').on('hidden.bs.modal', function () {
            $('#veterinariansList').empty();
            $('#loadingVetsMessage').show();
        });
        $('#veterinariansModal').on('shown.bs.modal', function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        });
    });
</script>
</body>
</html>
