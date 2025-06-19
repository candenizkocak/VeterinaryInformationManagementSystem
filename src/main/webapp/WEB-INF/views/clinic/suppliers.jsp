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
    <h2 class="mb-4">Supplier Management</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form action="/clinic/suppliers/add" method="post" class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label">Company Name</label>
            <input type="text" name="companyName" class="form-control" value="${newSupplier.companyName}" required>
        </div>
        <div class="col-md-4">
            <label class="form-label">Contact Name</label>
            <input type="text" name="contactName" class="form-control" value="${newSupplier.contactName}">
        </div>
        <div class="col-md-4">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" value="${newSupplier.phone}">
        </div>
        <div class="col-md-6">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="${newSupplier.email}">
        </div>

        <%-- ADRES BİLGİLERİ BAŞLANGICI --%>
        <div class="col-md-4">
            <label for="citySelect" class="form-label">City</label>
            <select name="cityCode" id="citySelect" class="form-select" required>
                <option value="">Select City</option>
                <c:forEach var="city" items="${cities}">
                    <option value="${city.code}">${city.name}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label for="districtSelect" class="form-label">District</label>
            <select name="districtCode" id="districtSelect" class="form-select" required>
                <option value="">Select District</option>
            </select>
        </div>

        <div class="col-md-4">
            <label for="localitySelect" class="form-label">Locality</label>
            <select name="localityCode" id="localitySelect" class="form-select" required>
                <option value="">Select Locality</option>
            </select>
        </div>

        <div class="col-md-6">
            <label for="streetAddress" class="form-label">Street Address (Street Name, Building No, etc.)</label>
            <input type="text" name="streetAddress" id="streetAddress" class="form-control" value="${newSupplier.streetAddress}" required maxlength="255">
        </div>

        <div class="col-md-6">
            <label for="postalCode" class="form-label">Postal Code (Optional)</label>
            <input type="text" name="postalCode" id="postalCode" class="form-control" value="${newSupplier.postalCode}" maxlength="10">
        </div>
        <%-- ADRES BİLGİLERİ SONU --%>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Supplier</button>
        </div>
    </form>

    <h4>Existing Suppliers</h4>
    <table id="supplierTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Company Name</th>
            <th>Contact Name</th>
            <th>Phone</th>
            <th>Email</th>
            <th>Address</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="supplier" items="${suppliers}">
            <tr>
                <td><c:out value="${supplier.supplierId}"/></td>
                <td><c:out value="${supplier.companyName}"/></td>
                <td><c:out value="${supplier.contactName}"/></td>
                <td><c:out value="${supplier.phone}"/></td>
                <td><c:out value="${supplier.email}"/></td>
                    <%-- Formatlanmış adresi kullanıyoruz --%>
                <td><c:out value="${supplier.formattedAddress}"/></td>
                <td>
                    <form action="/clinic/suppliers/delete/${supplier.supplierId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this supplier?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function () {
        // DataTables başlatma
        $('#supplierTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });

        // Adres Combo Box'ları için elementleri seç
        const citySelect = $('#citySelect');
        const districtSelect = $('#districtSelect');
        const localitySelect = $('#localitySelect');

        // Form yeniden yüklendiğinde (örn. hata sonrası) adres bilgilerini tutmak için
        // JSTL'den gelen değerler, JavaScript'te null veya 'null' stringi olabilir.
        const initialCityCode = ${newSupplier.cityCode != null ? newSupplier.cityCode : 'null'};
        const initialDistrictCode = ${newSupplier.districtCode != null ? newSupplier.districtCode : 'null'};
        const initialLocalityCode = ${newSupplier.localityCode != null ? newSupplier.localityCode : 'null'};

        // Fonksiyon: İlçeleri Yükle
        // Parametreler: cityCode (seçilen şehir kodu), selectedDistrictCode (önceden seçili ilçe kodu), callback (ilçeler yüklendikten sonra çalışacak fonksiyon)
        function loadDistricts(cityCode, selectedDistrictCode, callback) {
            districtSelect.empty().append('<option value="">Loading districts...</option>');
            localitySelect.empty().append('<option value="">Select Locality</option>');
            districtSelect.prop('disabled', true); // Yükleme başlarken ilçe ve mahalleleri devre dışı bırak
            localitySelect.prop('disabled', true);

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
                                    selected: (selectedDistrictCode !== null && district.code == selectedDistrictCode) // Ön seçim
                                }));
                            });
                            districtSelect.prop('disabled', false); // Başarılı yüklemede etkinleştir
                        } else {
                            districtSelect.append('<option value="">No districts found</option>');
                        }
                        if (callback) callback(); // Callback'i çağır
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading districts:", status, error);
                        districtSelect.empty().append('<option value="">Error loading districts</option>');
                        districtSelect.prop('disabled', true); // Hata durumunda devre dışı bırak
                    }
                });
            } else {
                districtSelect.empty().append('<option value="">Select City first</option>');
                districtSelect.prop('disabled', true);
            }
        }

        // Fonksiyon: Mahalleleri Yükle
        // Parametreler: districtCode (seçilen ilçe kodu), selectedLocalityCode (önceden seçili mahalle kodu)
        function loadLocalities(districtCode, selectedLocalityCode) {
            localitySelect.empty().append('<option value="">Loading localities...</option>');
            localitySelect.prop('disabled', true); // Yükleme başlarken devre dışı bırak

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
                                    selected: (selectedLocalityCode !== null && locality.code == selectedLocalityCode) // Ön seçim
                                }));
                            });
                            localitySelect.prop('disabled', false); // Başarılı yüklemede etkinleştir
                        } else {
                            localitySelect.append('<option value="">No localities found</option>');
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("Error loading localities:", status, error);
                        localitySelect.empty().append('<option value="">Error loading localities</option>');
                        localitySelect.prop('disabled', true); // Hata durumunda devre dışı bırak
                    }
                });
            } else {
                localitySelect.empty().append('<option value="">Select District first</option>');
                localitySelect.prop('disabled', true);
            }
        }

        // Event Listeners: Combo Box değişimlerini dinle
        citySelect.on('change', function() {
            const selectedCityCode = $(this).val();
            // Şehir değişince ilçe ve mahalle seçimlerini sıfırla, yeni ilçeleri yükle
            loadDistricts(selectedCityCode, null, null);
        });

        districtSelect.on('change', function() {
            const selectedDistrictCode = $(this).val();
            // İlçe değişince mahalle seçimini sıfırla, yeni mahalleleri yükle
            loadLocalities(selectedDistrictCode, null);
        });

        // Sayfa yüklendiğinde başlangıç durumunu ayarla ve ön seçimleri yap
        // Eğer form hata sonrası yeniden yüklendiyse (newSupplier objesi doluysa), bu kısım adresleri önceden seçecektir.
        // JSTL'den gelen 'null' stringini de kontrol etmek önemlidir.
        if (initialCityCode !== null && initialCityCode !== 'null') {
            citySelect.val(initialCityCode); // Şehri seç
            // İlçeleri yükle ve ilçe seçildikten sonra mahalleleri yükle
            loadDistricts(initialCityCode, initialDistrictCode, function() {
                if (initialDistrictCode !== null && initialDistrictCode !== 'null') {
                    loadLocalities(initialDistrictCode, initialLocalityCode);
                }
            });
        } else {
            // Eğer başlangıçta seçili bir şehir yoksa (yeni form durumu), ilçe ve mahalle combo box'larını devre dışı bırak
            districtSelect.prop('disabled', true);
            localitySelect.prop('disabled', true);
            districtSelect.empty().append('<option value="">Select City first</option>');
            localitySelect.empty().append('<option value="">Select District first</option>');
        }
    });
</script>
</body>