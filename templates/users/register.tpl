<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:50%'>
            <form method="post" action="{$.const.BASE_URL}/register" id="login-form" class="needs-validation" novalidate>
                <h2>{__('REGISTRATION')}</h2>
                <div class="form-group">
                    <label for="zfi_login">{__('LOGIN')}</label>
                    <input required type="login" name="zfi_login" class="form-control" id="zfi_login" placeholder="{__('LOGIN')}">
                    <div class="invalid-feedback" id="if-zfi_login"></div>
                </div>
                <div class="form-group">
                    <label for="zfi_password">{__('PASSWORD')}</label>
                    <input required type="password" name="zfi_password" class="form-control" id="zfi_password" placeholder="{__('PASSWORD')}">
                    <div class="invalid-feedback" id="if-zfi_password"></div>
                </div>
                <div class="form-group">
                    <label for="zfi_password_repeat">{__('PASSWORD_REPEAT')}</label>
                    <input required type="password" name="zfi_password_repeat" class="form-control" id="zfi_password_repeat" placeholder="{__('PASSWORD_REPEAT')}">
                    <div class="invalid-feedback" id="if-zfi_password_repeat"></div>
                </div>
                <div class="form-group">
                    <label for="zfi_fio">{__('YOUR_NAME')}</label>
                    <input required type="name" name="zfi_fio" class="form-control" id="zfi_fio" placeholder="{__('YOUR_NAME')}">
                    <div class="invalid-feedback" id="if-zfi_fio"></div>
                </div>
                {if $ref_link}
                <input type="hidden" id="ref_link" name="ref_link" value="{$ref_link}" />
                {/if}
                <button type="submit" class="btn btn-outline-primary">{__('SIGN_UP')}</button>
            </form>
        </div>
    </div>
</div>
{ignore}
<script>
    var form = document.querySelector('.needs-validation');
    var jsonUrl = "{/ignore}{$.const.BASE_URL}{ignore}/register";

    formAjaxValidatione(form, jsonUrl);
</script>
{/ignore}