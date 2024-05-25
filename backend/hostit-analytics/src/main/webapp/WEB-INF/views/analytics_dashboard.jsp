<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Analytics Dashboard</title>
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="//ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>
<body>
<div class="container mt-5">
    <h1>HostIT Analytics Dashboard</h1>
    <div class="row">
        <div class="col-lg-12">
            <h2>File Metadata</h2>
            <table class="table table-bordered" id="fileMetadataTable">
                <thead class="thead-dark">
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>File Type</th>
                    <th>File Size</th>
                    <th>Upload Date</th>
                    <th>Directory ID</th>
                </tr>
                </thead>
                <tbody>
                <!-- Data will be populated here by jQuery AJAX -->
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        $.ajax({
            url: '/api/files',
            type: 'GET',
            dataType: 'json',
            success: function(data) {
                var tableBody = '';
                $.each(data, function(index, element) {
                    tableBody += '<tr>' +
                        '<td>' + element.id + '</td>' +
                        '<td>' + element.userId + '</td>' +
                        '<td>' + element.fileType + '</td>' +
                        '<td>' + element.fileSize + '</td>' +
                        '<td>' + new Date(element.uploadDate).toLocaleDateString("en-US") + '</td>' +
                        '<td>' + element.directoryId + '</td>' +
                        '</tr>';
                });
                $('#fileMetadataTable tbody').html(tableBody);
            }
        });
    });
</script>
</body>
</html>
