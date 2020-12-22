<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
{ignore}
    google.charts.load('current', {'packages':['line']});
    google.charts.setOnLoadCallback(drawChart);

function drawChart() {
    var data = new google.visualization.DataTable();
    data.addColumn('datetime', 'Price Time');
    /*data.addColumn('number', 'ASUS ROG-STRIX-RTX3060TI-8G-GAMING');*/
    {/ignore}{foreach $prodNames as $name}{"data.addColumn('number', '{$name}');\n"}{/foreach}{ignore}

    data.addRows([
        /*[new Date(2020, 12, 19, 20, 00, 00),  22146, 24499, 26499],*/
        {/ignore}{foreach $minChartInfo as $date => $row}{$row}{/foreach}{ignore}
    ]);

    var options = {
        chart: {
            title: 'Hotline 3060-ti GPU Prices',
            subtitle: {/ignore}{"'{$chartCaption} в грн.'"}{ignore}
        },
        width: '100%',
        height: '100%',
        curveType: 'function',
        axes: {
            x: {
                0: {side: 'top'}
            }
        },
        showRowNumber: false,
    };

    var chart = new google.charts.Line(document.getElementById('hotline-lines'));

    chart.draw(data, google.charts.Line.convertOptions(options));
}
{/ignore}
</script>

<div class='container'>
    <div class='row justify-content-md-center'>
        <div>
            <a href="{$.const.BASE_URL}/hotline_viewer">Минимальные цены</a> | 
            <a href="{$.const.BASE_URL}/hotline_viewer?type=mid">Средние цены</a> | 
            <a href="{$.const.BASE_URL}/hotline_viewer?type=max">Максимальные цены</a>
        </div>
        <div id="hotline-lines" style="width:1000px; height:600px"></div>
    </div>
</div>