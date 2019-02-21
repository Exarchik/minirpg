<!doctype html>
<html lang="ua">
    <head>
        <title>{$title}</title>
        <script>
            var BASE_URL = '{$.const.BASE_URL}';
            {$invalid_feedback}
        </script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
        <link rel="stylesheet" href="{$.const.BASE_PATH}/templates/css/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
        <link rel="stylesheet" href="{$.const.BASE_PATH}/templates/css/main.css">

        <script src="{$.const.BASE_PATH}/templates/js/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        <script src="{$.const.BASE_PATH}/templates/js/jquery-3.3.1.js"></script>
        <script src="{$.const.BASE_PATH}/templates/js/help.js"></script>
    </head>
    <body>
        <div class="container-fluid breadcrumbs">
            <div class="row">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="{$.const.BASE_URL}">Home</a></li>
                            {if $user->is_superadmin}
                            <li class="breadcrumb-item"><a href="{$.const.BASE_URL}/language/form">Lang Form</a></li>
                            {/if}
                            <li class="breadcrumb-item active" aria-current="page">Data</li>
                        </ol>
                    </nav>
                    <div class="main-language-selector">
                        <select id="languageSelector" class="custom-select custom-select-sm">
                            {foreach $lang_selector as $ident => $caption}
                            <option {if $current_language == $ident}selected{/if} value="{$ident}">{$caption}</option>
                            {/foreach}
                        </select>
                    </div>
                </div>
            </div>
        </div>
        {set $flashes = __flash()}
        <div class='container-fluid errors'>
            {foreach array_merge($errors, $flashes['error']) as $error}
                <div class="alert alert-danger" role="alert">{$error}</div>
            {/foreach}
        </div>
        <div class='container-fluid success'>
            {foreach array_merge($messages, $flashes['notice']) as $message}
                <div class="alert alert-success" role="alert">{$message}</div>
            {/foreach}
        </div>
        <div class="container-fluid">
            {$content}
        </div>
        <script src="{$.const.BASE_PATH}/templates/js/if.js"></script>
    </body>
</html>