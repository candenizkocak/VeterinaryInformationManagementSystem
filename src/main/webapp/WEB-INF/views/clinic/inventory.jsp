<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Inventory Management</title>

    <!-- STYLES -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/theme.css">
</head>
<body id="pageBody">

<jsp:include page="../client/navbar.jsp"/>
<div class="container mt-5">
    <h2 class="mb-4">Inventory for ${clinic.clinicName}</h2>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- ADD FORM -->
    <h4 class="mb-3">Add New Inventory Item</h4>
    <form action="/clinic/inventory/add" method="post" class="row g-3 mb-4">
        <div class="col-md-4">
            <label class="form-label">Item Type</label>
            <select name="itemTypeId.itemTypeId" class="form-select" required>
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

    <!-- INVENTORY TABLE -->
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
            <tr><td colspan="6" class="text-center">No inventory items found.</td></tr>
        </c:if>
        <c:forEach var="item" items="${inventoryItems}">
            <tr>
                <td>${item.itemId}</td>
                <td>${item.itemTypeId.itemName}</td>
                <td>
                    <c:choose>
                        <c:when test="${item.supplier != null}">
                            ${item.supplier.companyName}
                        </c:when>
                        <c:otherwise>N/A</c:otherwise>
                    </c:choose>
                </td>
                <td>${item.quantity}</td>
                <td>${item.lastUpdated}</td>
                <td>
                    <button type="button" class="btn btn-warning btn-sm edit-item-btn"
                            data-bs-toggle="modal" data-bs-target="#editInventoryModal"
                            data-item-id="${item.itemId}"
                            data-item-type-id="${item.itemTypeId.itemTypeId}"
                            data-supplier-id="${item.supplier != null ? item.supplier.supplierId : ''}"
                            data-quantity="${item.quantity}">
                        Edit
                    </button>
                    <form action="/clinic/inventory/delete/${item.itemId}" method="post" style="display:inline;">
                        <button type="submit" class="btn btn-danger btn-sm"
                                onclick="return confirm('Are you sure you want to delete this inventory item?')">
                            Delete
                        </button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editInventoryModal" tabindex="-1" aria-labelledby="editInventoryModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form id="editInventoryForm" method="post" action="/clinic/inventory/update">
                <div class="modal-header">
                    <h5 class="modal-title" id="editInventoryModalLabel">Edit Inventory Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="itemId" id="editItemId">

                    <div class="mb-3">
                        <label for="editItemType" class="form-label">Item Type</label>
                        <select name="itemTypeId.itemTypeId" id="editItemType" class="form-select" required>
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
                </div>
                <div class="modal-footer">
                    <button type="submit" class="btn btn-primary">Update Item</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- SCRIPTS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        $('#inventoryTable').DataTable({
            pageLength: 10,
            lengthMenu: [5, 10, 25, 50, 100],
            columnDefs: [{ orderable: false, targets: -1 }]
        });

        $('.edit-item-btn').on('click', function () {
            const itemId = $(this).data('item-id');
            const itemTypeId = $(this).data('item-type-id');
            const supplierId = $(this).data('supplier-id') || '';
            const quantity = $(this).data('quantity');

            $('#editItemId').val(itemId);
            $('#editItemType').val(itemTypeId);
            $('#editSupplier').val(supplierId);
            $('#editQuantity').val(quantity);
        });
    });
</script>

</body>
</html>
