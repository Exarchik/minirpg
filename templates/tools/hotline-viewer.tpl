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

/*
  google.charts.load('current', {'packages':['corechart']});
  google.charts.setOnLoadCallback(drawChart2);

  function drawChart2() {
    var data = new google.visualization.DataTable();
    data.addColumn('datetime', 'Price Time');
    {/ignore}{foreach $prodNames as $name}{"data.addColumn('number', '{$name}');\n"}{/foreach}{ignore}

    data.addRows([
        {/ignore}{foreach $minChartInfo as $date => $row}{$row}{/foreach}{ignore}
    ]);

    var options = {
      title: 'Company Performance',
      curveType: 'function',
      legend: { position: 'right' }
    };

    var chart = new google.visualization.LineChart(document.getElementById('curve_chart'));

    chart.draw(data, options);
  }
*/
{/ignore}
</script>

<div class="container-fluid">
    <div class="row justify-content-md-center"> 
        {if $type == 'min'}<b>Минимальные цены</b>{else}<a href="{$.const.BASE_URL}/hotline_viewer">Минимальные цены</a>{/if}&nbsp;|&nbsp;
        {if $type == 'mid'}<b>Средние цены</b>{else}<a href="{$.const.BASE_URL}/hotline_viewer?type=mid">Средние цены</a>{/if}&nbsp;|&nbsp;
        {if $type == 'max'}<b>Максимальные цены</b>{else}<a href="{$.const.BASE_URL}/hotline_viewer?type=max">Максимальные цены</a>{/if}
    </div>
    <div class="row justify-content-md-center">
        <div id="hotline-lines" style="width:1400px; height:600px"></div>
    </div>
    <!--<div class="row justify-content-md-center">
        <div id="curve_chart" style="width: 1500px; height: 800px"></div>
    </div>-->
</div>