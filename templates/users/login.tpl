<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:30%'>
            <form method="post" id="login-form" class="needs-validation" novalidate>
                <h2>{__('AUTHORIZATION')}</h2>
                <div class="form-group">
                    <label for="zfiLogin">{__('LOGIN')}</label>
                    <input required type="login" name="zfi_login" class="form-control" id="zfi_login" placeholder="{__('LOGIN')}">
                    <div class="invalid-feedback">Доступны только латиница, цифры и нижнее подчеркивание</div>
                </div>
                <div class="form-group">
                    <label for="zfiPassword">{__('PASSWORD')}</label>
                    <input required type="password" name="zfi_password" class="form-control is-invalid" id="zfi_password" placeholder="{__('PASSWORD')}">
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" name="zfi_check" class="form-check-input" id="zfiCheck">
                    <label class="form-check-label" for="zfiCheck">Check me out</label>
                </div>
                <button type="submit" class="btn btn-outline-primary">{__('LOG_IN')}</button>
            </form>
        </div>
    </div>
</div>
<script>
    var form = document.querySelector('.needs-validation');

    form.addEventListener('submit', function(event) {
        event.preventDefault();
        event.stopPropagation();
        jQuery.ajax({
            method: "POST",
            url: "/web/login/json",
            data: jQuery(form).serializeArray()
        })
        .done(function(result) {
            console.log(result);
        });

        /*if (form.checkValidity() === false) {
            event.preventDefault();
            event.stopPropagation();
        }*/
        form.classList.add('was-validated');
    })
</script>