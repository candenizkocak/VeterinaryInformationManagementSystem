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
    <h2 class="mb-4">Inventory for ${clinic.clinicName}</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Add New Inventory Item Form -->
    <h4 class="mb-3">Add New Inventory Item</h4>
    <form action="/clinic/inventory/add" method="post" class="row g-3 mb-4">
        <%-- The 'newItem' object is only used to pre-populate inputs if validation fails and the form is re-shown. --%>
        <%-- No hidden itemId input for ADD form as it's a new item --%>

        <div class="col-md-4">
            <label class="form-label">Item Type</label>
            <select name="itemType.itemTypeId" class="form-select" required>
                <option value="" disabled selected>Select an item type</option>
                <c:forEach var="itemType" items="${itemTypes}">
                    <option value="${itemType.itemTypeId}">${itemType.itemName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-4">
            <label class="form-label">Supplier</label>
            <select name="supplier.supplierId" class="form-select">
                <option value="">None (Optional)</option>
                <c:forEach var="supplier" items="${suppliers}">
                    <option value="${supplier.supplierId}">${supplier.companyName}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <label class="form-label">Quantity</label>
            <input type="number" name="quantity" class="form-control" min="0" required>
        </div>

        <div class="col-12">
            <button type="submit" class="btn btn-success">Add Item</button>
        </div>
    </form>

    <h4>Current Inventory</h4>
    <table id="inventoryTable" class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Item Type</th>
            <th>Supplier</th>
            <th>Quantity</th>
            <th>Last Updated</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:if test="${empty inventoryItems}">
            <tr><td colspan="6" class="text-center">No inventory items found for your clinic.</td></tr>
        </c:if>
        <c:forEach var="item" items="${inventoryItems}">
            <tr>
                <td>${item.itemId}</td>
                <td>${item.itemType.itemName}</td>
                <td>${item.supplier != null ? item.supplier.companyName : 'N/A'}</td>
                <td>${item.quantity}</td>
                <td>${item.lastUpdated}</td>
                <td>
                    <button type="button" class="btn btn-warning btn-sm edit-item-btn"
                            data-bs-toggle="modal" data-bs-target="#editInventoryModal"
                            data-item-id="${item.itemId}"
                            data-item-type-id="${item.itemType.itemTypeId}"
                            data-supplier-id="${item.supplier != null ? item.supplier.supplierId : ''}" <%-- Ensure empty string for null supplier --%>
                            data-quantity="${item.quantity}">
                        Edit
                    </button>
                    <form action="/clinic/inventory/delete/${item.itemId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this inventory item?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- Edit Inventory Item Modal -->
<div class="modal fade" id="editInventoryModal" tabindex="-1" aria-labelledby="editInventoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editInventoryModalLabel">Edit Inventory Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="editInventoryForm" method="post" action="/clinic/inventory/update/">
                    <input type="hidden" name="itemId" id="editItemId">
                    <div class="mb-3">
                        <label for="editItemType" class="form-label">Item Type</label>
                        <select name="itemType.itemTypeId" id="editItemType" class="form-select" required>
                            <c:forEach var="itemType" items="${itemTypes}">
                                <option value="${itemType.itemTypeId}">${itemType.itemName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editSupplier" class="form-label">Supplier</label>
                        <select name="supplier.supplierId" id="editSupplier" class="form-select">
                            <option value="">None (Optional)</option>
                            <c:forEach var="supplier" items="${suppliers}">
                                <option value="${supplier.supplierId}">${supplier.companyName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="editQuantity" class="form-label">Quantity</label>
                        <input type="number" name="quantity" id="editQuantity" class="form-control" min="0" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Update Item</button>
                </form>
            </div>
        </div>
    </div>
</div>


<script>
    $(document).ready(function () {
        $('#inventoryTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [
                { orderable: false, targets: -1 }
            ]
        });

        // Populate modal with item data when edit button is clicked
        $('.edit-item-btn').on('click', function() {
            const itemIdRaw = $(this).data('item-id');
            const itemTypeIdRaw = $(this).data('item-type-id');
            const supplierIdRaw = $(this).data('supplier-id');
            const quantityRaw = $(this).data('quantity');

            // Convert to appropriate types, providing defaults for robustness
            // Use String() for data-* attributes as they are always strings
            const itemId = Number(itemIdRaw); // Convert to number for comparison
            const itemTypeId = Number(itemTypeIdRaw);
            // supplierId can be empty string for 'None', handle 0 as also empty
            const supplierId = (supplierIdRaw === undefined || supplierIdRaw === null || supplierIdRaw === 0) ? '' : String(supplierIdRaw);
            const quantity = Number(quantityRaw);

            console.log("--- Edit Button Click Debug ---");
            console.log("Raw data-item-id:", itemIdRaw, "Type:", typeof itemIdRaw);
            console.log("Parsed itemId:", itemId, "Type:", typeof itemId);
            console.log("Parsed itemTypeId:", itemTypeId, "Type:", typeof itemTypeId);
            console.log("Parsed supplierId:", supplierId, "Type:", typeof supplierId); // Should be string
            console.log("Parsed quantity:", quantity, "Type:", typeof quantity);

            // Set values in the modal form
            $('#editItemId').val(itemId);
            $('#editItemType').val(itemTypeId);
            $('#editSupplier').val(supplierId); // This should now correctly select the 'None' option if supplierId is ''
            $('#editQuantity').val(quantity);

            // Dynamically set the form action URL
            // Ensure itemId is a valid positive number before setting action
            if (!isNaN(itemId) && itemId > 0) {
                const newActionUrl = `/clinic/inventory/update/${itemId}`;
                $('#editInventoryForm').attr('action', newActionUrl);
                console.log("Form action set to:", newActionUrl);
            } else {
                console.error("Error: Invalid itemId for update. Cannot set form action. Item ID:", itemId, "Raw:", itemIdRaw);
                // Optionally set a fallback action or disable the submit button
                $('#editInventoryForm').attr('action', '#'); // Prevent submission to a bad URL
                $('#editInventoryForm button[type="submit"]').prop('disabled', true); // Disable submit button
            }
            console.log("--- End Edit Button Click Debug ---");
        });
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

