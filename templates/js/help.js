function setValid(id){
    jQuery(id).removeClass('is-invalid');
    jQuery(id).addClass('is-valid');
}

function setInvalid(id){
    jQuery(id).removeClass('is-valid');
    jQuery(id).addClass('is-invalid');
}