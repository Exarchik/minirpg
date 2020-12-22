<div class='container'>
    <div class='row justify-content-md-center'>
        <div class='col-md-auto' style='min-width:50%'>
            <a href="{$.const.BASE_URL}/hotline_parcer?dom=1"><i class="fas fa-exclamation-triangle"></i> Use Automatic Parcer</a>
            <form method="post" action="{$.const.BASE_URL}/hotline_parcer" id="hotline_parcer-form" class="needs-validation" novalidate>
                <h2>Hotline Parcer Form</h2>
                <div class="form-group">
                    <label for="zfi_date">DATE</label>
                    <input required type="text" name="zfi_date" class="form-control" id="zfi_date" placeholder="DATE" value="{$currentDate}">
                    <div class="invalid-feedback" id="if-zfi_date"></div>
                </div>
                <div class="form-group">
                    <label for="zfi_jsonData">JSON DATA</label>
                    <input required type="text" name="zfi_jsonData" class="form-control" id="zfi_jsonData" placeholder="JSON DATA" autocomplete="off">
                    <div class="invalid-feedback" id="if-zfi_jsonData"></div>
                </div>
                <button type="submit" class="btn btn-outline-primary">SAVE JSON</button>
            </form>
        </div>
    </div>
</div>
{ignore}
<script>
    /*var form = document.querySelector('.needs-validation');
    var jsonUrl = "{/ignore}{$.const.BASE_URL}{ignore}/hotline_parcer";

    formAjaxValidatione(form, jsonUrl);*/
</script>
{/ignore}