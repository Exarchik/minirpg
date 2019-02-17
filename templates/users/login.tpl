<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:30%'>
            <form method="post">
                <h2>{__('AUTHORIZATION')}</h2>
                <div class="form-group">
                    <label for="zfiLogin">{__('LOGIN')}</label>
                    <input type="login" name="zfi_login" class="form-control" id="zfiLogin" placeholder="{__('LOGIN')}">
                </div>
                <div class="form-group">
                    <label for="zfiPassword">{__('PASSWORD')}</label>
                    <input type="password" name="zfi_password" class="form-control" id="zfiPassword" placeholder="{__('PASSWORD')}">
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" name="zfi_check" class="form-check-input" id="zfiCheck">
                    <label class="form-check-label" for="zfiCheck">Check me out</label>
                </div>
                <button type="submit" class="btn btn-primary">{__('LOG_IN')}</button>
            </form>
        </div>
    </div>
</div>