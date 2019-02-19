function setValid(id) {
    jQuery(id).removeClass('is-invalid');
    jQuery(id).addClass('is-valid');
}

function setInvalid(id) {
    jQuery(id).removeClass('is-valid');
    jQuery(id).addClass('is-invalid');
}

jQuery(function() {
    // language selector
    jQuery('#languageSelector').on('change', function() {
       jQuery.ajax({
            method: "POST",
            url: BASE_URL + '/json/lang/' + jQuery(this).val(),
            data: jQuery(form).serializeArray()
        })
        .done(function(response) {
            if (response.result == true) {
                location.reload();
            }
        });
    });
});