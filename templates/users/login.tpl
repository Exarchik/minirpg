<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:50%'>
            <form method="post" action="{$.const.BASE_URL}/login" id="login-form" class="needs-validation" novalidate>
                <h2>{__('AUTHORIZATION')}</h2>
                <div class="form-group">
                    <label for="zfi_login">{__('LOGIN')}</label>
                    <input required type="login" name="zfi_login" class="form-control" id="zfi_login" placeholder="{__('LOGIN')}">
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-group">
                    <label for="zfi_password">{__('PASSWORD')}</label>
                    <input required type="password" name="zfi_password" class="form-control" id="zfi_password" placeholder="{__('PASSWORD')}">
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" name="zfi_check" class="form-check-input" id="zfi_check">
                    <label class="form-check-label" for="zfi_check">{__('FORM_REMEMBER_ME')}</label>
                </div>
                {if !$isRegisterRefferal}
                <div class="form-group">
                    <a href="{$.const.BASE_URL}/register">{__('REGISTRATION')}</a>
                </div>
                {/if}
                <button type="submit" class="btn btn-outline-primary">{__('LOG_IN')}</button>
            </form>
        </div>
    </div>
</div>
{ignore}
<script>
    var form = document.querySelector('.needs-validation');
    var jsonUrl = "{/ignore}{$.const.BASE_URL}{ignore}/json-valid/login"; 

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();
        jQuery.ajax({
            method: "POST",
            url: jsonUrl,
            data: jQuery(form).serializeArray()
        })
        .done(function(result) {
            var resultSuccess = true;
            for (var key in result) {
                if (result[key] != true) {
                    resultSuccess = false;
                    setInvalid('#'+key);
                    jQuery('#'+key).parent().find('.invalid-feedback').html(result[key][0]);
                } else {
                    setValid('#'+key);
                }
            }
            if (resultSuccess) {
                jQuery(form).submit();
            }
        });
    })
</script>
{/ignore}