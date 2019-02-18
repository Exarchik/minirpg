<!doctype html>
<html lang="ua">
    <head>
        <title>{$title}</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <link rel="stylesheet" href="{$.const.BASE_PATH}/templates/css/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <script src="{$.const.BASE_PATH}/templates/js/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        <script src="{$.const.BASE_PATH}/templates/js/jquery-3.3.1.js"></script>
        <script src="{$.const.BASE_PATH}/templates/js/help.js"></script>
    </head>
    <body>
        <div class="container-fluid breadcrumbs">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="{$.const.BASE_URL}">Home</a></li>
                    <li class="breadcrumb-item"><a href="{$.const.BASE_URL}">Library</a></li>
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
        <div class="container-fluid">
            {$content}
        </div>
    </body>
</html>