function setValid(id) {
    jQuery(id).removeClass('is-invalid');
    jQuery(id).addClass('is-valid');
}

function setInvalid(id) {
    jQuery(id).removeClass('is-valid');
    jQuery(id).addClass('is-invalid');
}

function formAjaxValidatione(form, jsonUrl)
{
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
                    jQuery('#'+key).parent().find('.invalid-feedback').html(result[key]);
                } else {
                    setValid('#'+key);
                }
            }
            if (resultSuccess) {
                jQuery(form).submit();
            }
        });
    });
}


jQuery(function() {
    // language selector
    jQuery('#languageSelector').on('change', function() {
       jQuery.ajax({
            method: "POST",
            url: BASE_URL + '/json/lang/' + jQuery(this).val(),
        })
        .done(function(response) {
            if (response.result == true) {
                location.reload();
            }
        });
    });
});

