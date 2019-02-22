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

        <script src="{$.const.BASE_PATH}/templates/js/jquery-3.3.1.js"></script>
        <script src="{$.const.BASE_PATH}/templates/js/bootstrap/{$.const.BOOTSTRAP_VERSION}/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
        <script src="{$.const.BASE_PATH}/templates/js/help.js"></script>
    </head>
    <body>
        <header>
            <div class="container-fluid breadcrumbs">
                <div class="row">
                    <div class="col">
                        <nav class="navbar navbar-expand-lg navbar-light bg-light">
                        <a class="navbar-brand" href="{$.const.BASE_URL}">{__('ZFI')}</a>
                        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav mr-auto">
                                <li class="nav-item active">
                                    <a class="nav-link" href="{$.const.BASE_URL}">Home <span class="sr-only">(current)</span></a>
                                </li>
                            {if $user->is_superadmin}
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    {__('ADMIN_MENU')}
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="navbarDropdownMenuLink">
                                    <a class="dropdown-item" href="{$.const.BASE_URL}/language/form">{__('LANG_FORM')}</a>
                                    </div>
                                </li>
                            {/if}
                            </ul>
                            <ul class="navbar-nav ml-md-auto d-md-flex">
                                <li class="nav-item">
                                    <a class="nav-link" href="{$.const.BASE_URL}/login" tabindex="-1" aria-disabled="true">{__('PROFILE')} </a>
                                </li>
                                <li class="nav-item form-inline">
                                    <div class="main-language-selector">
                                        <select id="languageSelector" class="custom-select custom-select-md">
                                            {foreach $lang_selector as $ident => $caption}
                                            <option {if $current_language == $ident}selected{/if} value="{$ident}">{$caption}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        </nav>
                    </div>
                </div>
            </div>
        </header>
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
        <div class="container-fluid main-container">
            {$content}
        </div>
        <script src="{$.const.BASE_PATH}/templates/js/if.js"></script>
    </body>
</html>