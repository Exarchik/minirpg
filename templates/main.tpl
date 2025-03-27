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
        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.2/css/all.css" integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr" crossorigin="anonymous">
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
                        {if $showNavigationBar}
                        <nav class="navbar navbar-expand-lg navbar-light bg-light">
                        {if !$user->is_guest}
                            <a class="navbar-brand" href="{$.const.BASE_URL}">{__('ZFI')}</a>
                        {/if}
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
                                    <a class="nav-link dropdown-toggle" href="#" id="navbarAdminMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    {__('ADMIN_MENU')}
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="navbarAdminMenu">
                                    <a class="dropdown-item" href="{$.const.BASE_URL}/language/form">{__('LANG_FORM')}</a>
                                    </div>
                                </li>
                            {/if}
                            </ul>
                            <ul class="navbar-nav ml-md-auto d-md-flex">
                                {if $user->is_guest}
                                <li class="nav-item">
                                    <a class="nav-link" href="{$.const.BASE_URL}/login" tabindex="-1" aria-disabled="true">{__('LOG_IN')} </a>
                                </li>
                                {else}
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="#" id="profileMenu" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    <i class="far fa-laugh"></i> {$user->data['username']}
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="profileMenu">
                                        <a class="dropdown-item" href="{$.const.BASE_URL}/profile">{__('PROFILE')}</a>
                                        <a class="dropdown-item" href="{$.const.BASE_URL}/logout/quick">{__('LOG_OUT')}</a>
                                    </div>
                                </li>
                                {/if}
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
                        {/if}
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