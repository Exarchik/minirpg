<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:50%'>
            <form method="post" action="{$.const.BASE_URL}/language/form" id="login-form" class="needs-validation" novalidate>
                <h2>{__('ADD_TERM_TO_DICTIONARY')}</h2>
                <div class="form-group">
                    <label for="zfi_ident">{__('IDENT')}</label>
                    <input required type="login" name="zfi_ident" class="form-control" id="zfi_ident" placeholder="{__('IDENT')}">
                    <div class="invalid-feedback"></div>
                    <small id="emailHelp" class="form-text text-muted">{__('LANGUAGE_FORM_IDENT_HELPER')}</small>
                </div>
                {foreach $language_idents as $ident => $caption}
                <div class="form-group">
                    <label for="term_{$ident}">{__('LANGUAGE')} "{$caption}"</label>
                    <input required type="text" name="term_{$ident}" class="form-control" id="term_{$ident}" placeholder="{$caption}">
                    <div class="invalid-feedback"></div>
                </div>
                {/foreach}
                <button type="submit" class="btn btn-outline-primary">{__('ADD_TERM_TO_DICTIONARY')}</button>
            </form>
        </div>
    </div>
</div>
{ignore}
<script>
    var form = document.querySelector('.needs-validation');
    var jsonUrl = "{/ignore}{$.const.BASE_URL}{ignore}/json/valid/languageForm";

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