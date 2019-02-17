<!doctype html>
<link rel="stylesheet" href="{$.const.BASE_PATH}/templates/css/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="{$.const.BASE_PATH}/templates/js/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<html lang="ua">
    <div class="container-fluid breadcrumbs">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="#">Home</a></li>
                <li class="breadcrumb-item"><a href="#">Library</a></li>
                <li class="breadcrumb-item active" aria-current="page">Data</li>
            </ol>
        </nav>
    </div>
    <div class='container-fluid errors'>
        {foreach $errors as $error}
            <div class="alert alert-danger" role="alert">{$error}</div>
        {/foreach}
    </div>
    <div class='container-fluid success'>
        {foreach $messages as $message}
            <div class="alert alert-success" role="alert">{$message}</div>
        {/foreach}
    </div>

    <div class='container-fluid'>
        Test page
    </div>

    <div class="container-fluid">
        {$content}
    </div>
</html>