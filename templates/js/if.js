jQuery(function(){
    if (invalidFeedback != false) {
        for (var id in invalidFeedback) {
            if (jQuery('#if-'+id).length && invalidFeedback[id] !== true) {
                jQuery('#if-'+id).html(invalidFeedback[id]);
                jQuery('#'+id).addClass('is-invalid');
            }
        }
    }
});