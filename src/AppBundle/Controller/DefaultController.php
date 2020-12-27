<?php

namespace AppBundle\Controller;

use DOMDocument;
use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends ZFIController
{
    public function indexAction(Request $request)
    {
        $session = \App::getSession();
        $user = \App::getUsers();
        $params = array();

        #$result = $users->add(['login' => 'empty', 'password' => '34234234']);
        $msg = !is_null($session['ZFIUD']) 
            ? __('YOU_ARE_WELCOME').', '.$user->data['username'].'!'.($user->is_admin ? ' <b>(Админ)</b>':'')
            : "<a href='".BASE_URL."/login'>".__('AUTHORIZATION')."</a>";
        $this->addMessage($msg);

        $params = array_merge($params, array(
            'base_dir' => 'tested information',
            'is_superadmin' => $user->is_superadmin,
        ));

        return $this->render('default.tpl', $params);
    }   

    public function hotlineViewerAction(Request $request)
    {
        $db = \App::getPDO();
        $user = \App::getUsers();

        $allowedPrices = [
            'min' => ['field' => 'min_price', 'caption' => 'Минимальная цена'],
            'mid' => ['field' => 'mid_price', 'caption' => 'Средняя цена'],
            'max' => ['field' => 'max_price', 'caption' => 'Максимальная цена'],
        ];

        $priceIdent = $request->query->get('type', 'min');
        $priceIdent = isset($allowedPrices[$priceIdent]) ? $priceIdent : 'min';
        $priceField = isset($allowedPrices[$priceIdent]) ? $allowedPrices[$priceIdent]['field'] : $allowedPrices['min']['field'];

        $productId = $request->query->get('pid', 'all');

        $productPricesFieldsList = [
            1000 => 'min_price',
            2000 => 'mid_price',
            3000 => 'max_price',
        ];

        if (!$user->is_superadmin) {
            return $this->json(false);
        }

        // кол-во выводимых позиций
        $numberOfData = 17;//500;
        // пропускать нули?
        $skipZeros = false;//true;

        // тянем все даты какие вообще возможны
        $allDates = $db->getCol("SELECT DISTINCT date FROM _hotline_parcer_data ORDER BY date ASC");

        // используем только N самых дешевых товаров по последней дате
        $lowPriceIds = [];
        $sql = "SELECT product_id
                FROM `_hotline_parcer_data`
                WHERE date = (SELECT MAX(date) FROM `_hotline_parcer_data`)
                GROUP BY product_id
                HAVING SUM({$priceField}) != 0
                ORDER BY {$priceField} ASC
                LIMIT {$numberOfData}";
        $lowPriceIds = $db->getCol($sql);

        $sqlWhere = [
            !empty($lowPriceIds) ? "hp.id IN (".join(',', $lowPriceIds).")" : "1",
        ];

        if ($productId == 'all') {
            $sql = "SELECT hp.id AS prodId, hd.date, hd.{$priceField} AS price
                    FROM `_hotline_parcer_data` AS hd
                        JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                    WHERE ".join(" AND ", $sqlWhere)."
                    ORDER BY hp.id ASC, hd.date ASC";
        } else {
            $sqlList = [];

            foreach ($productPricesFieldsList as $index => $priceField) {
                $sqlList[] = "SELECT hp.id + {$index} AS prodId, hd.date, hd.{$priceField} AS price
                                FROM `_hotline_parcer_data` AS hd
                                    JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                                WHERE hp.id = {$productId}
                                ORDER BY hp.id ASC, hd.date ASC";
            }

            $sql = "(" . join(") UNION (", $sqlList) . ")";
        }
        $minPricesData = $db->getAll($sql);

        
        if ($productId == 'all') {
            $sql = "SELECT hp.id AS prodId, CONCAT(hp.id, ') ', COALESCE(hp.alias, hp.name), ' [', last_prices.price, ']') AS name
                    FROM `_hotline_parcer_data` AS hd
                        LEFT JOIN (SELECT product_id, {$priceField} AS price
                                    FROM `_hotline_parcer_data`
                                    WHERE date = (SELECT MAX(date) FROM `_hotline_parcer_data`)) AS last_prices ON hd.product_id = last_prices.product_id
                        JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                    WHERE ".join(" AND ", $sqlWhere)."
                    GROUP BY hp.id
                    ORDER BY hp.id";
        } else {
            $sqlList = [];

            foreach ($productPricesFieldsList as $index => $priceField) {
                $sqlList[] = "SELECT hp.id + {$index}, CONCAT(hp.id, ') min - ', COALESCE(hp.alias, hp.name), ' [', last_prices.price, ']') AS name
                                FROM `_hotline_parcer_products` AS hp
                                    LEFT JOIN (SELECT product_id, {$priceField} AS price
                                                FROM `_hotline_parcer_data`
                                                WHERE date = (SELECT MAX(date) FROM `_hotline_parcer_data`)) AS last_prices ON hp.id = last_prices.product_id
                                WHERE hp.id = {$productId}";
            }

            $sql = "(" . join(") UNION (", $sqlList) . ")";
        }
        $prodNames = $db->getAssoc($sql);

        $pricesChartData = [];
        $minPricesChartData = [];
        $prodIdHasZeroData = [];
        foreach ($allDates as $date) {
            if (!isset($pricesChartData[$date][-1])) {
                // фиксим js идиотизм - месяц 0..11 :(
                $jsMonth = intval(date("m", strtotime($date))) - 1;
                $pricesChartData[$date][-1] = "new Date(".date("Y, {$jsMonth}, d, H, i, s", strtotime($date)).")";
            }
            foreach ($prodNames as $prodId => $name) {
                foreach ($minPricesData as $position) {
                    if ($position['date'] == $date && $position['prodId'] == $prodId) {
                        $pricesChartData[$date][$prodId] = $position['price'];
                    }
                }
                if (!isset($pricesChartData[$date][$prodId]) || $pricesChartData[$date][$prodId] == 0) {
                    $pricesChartData[$date][$prodId] = 'null';
                }
            }
        }

        foreach ($prodNames as $prodId => $name) {
            foreach ($minPricesData as $position) {
                if (!isset($minPricesChartData[$position['date']][-1])) {
                    // фиксим js идиотизм - месяц 0..11 :(
                    $jsMonth = intval(date("m", strtotime($position['date']))) - 1;
                    $minPricesChartData[$position['date']][-1] = "new Date(".date("Y, {$jsMonth}, d, H, i, s", strtotime($position['date'])).")";
                }
                if ($position['price'] == 0) {
                    $prodIdHasZeroData[] = $position['prodId'];
                }
                $minPricesChartData[$position['date']][$position['prodId']] = $position['price'];
            }
        }

        // удаляем записи с "0"
        if ($skipZeros) {
            foreach (array_unique($prodIdHasZeroData) as $deleteProdId) {
                unset($prodNames[$deleteProdId]);
                foreach ($minPricesChartData as $date => $row) {
                    unset($minPricesChartData[$date][$deleteProdId]);
                }
            }
        }
        

        /*echo '<pre>';
        print_r($prodNames);
        print_r($minPricesChartData);
        print_r(array_unique($prodIdHasZeroData));
        echo '</pre>';
        die;*/

        foreach ($minPricesChartData as $date => $row) {
            $minPricesChartData[$date] = "[".join(", ", $row)."],";
        }

        foreach ($pricesChartData as $date => $row) {
            $pricesChartData[$date] = "[".join(", ", $row)."],";
        }

        $params = [
            'type' => $priceIdent,
            'prodNames' => $prodNames,
            //'minChartInfo' => $minPricesChartData,
            'minChartInfo' => $pricesChartData,
            'chartCaption' => $allowedPrices[$priceIdent]['caption'],
        ];
        return $this->render('tools/hotline-viewer.tpl', $params);
    }

    public function hotlineParcerAction(Request $request)
    {
        $db = \App::getPDO();
        $user = \App::getUsers();
        
        if (!$user->is_superadmin) {
            return $this->json(false);
        }

        $currentHourDate = date('Y-m-d H:00:00');

        $testDomParser = $request->get('dom', false);

        $parsedData = [];
        if ($testDomParser) {
            $parseLink = "https://hotline.ua/computer/videokarty/?q=3060+ti";

            $xml = new DOMDocument();
            $xml->loadHTMLFile($parseLink);

            foreach($xml->getElementsByTagName('li') as $index => $element) {
                $className = $element->getAttribute('class');
                if ($className == 'product-item') {
                    foreach ($element->getElementsByTagName('a') as $aElement) {
                        $dataTrackingId = $aElement->getAttribute('data-tracking-id');
                        $aClassName = $aElement->getAttribute('class');
                        $aUrl = $aElement->getAttribute('href');

                        if (mb_strpos($dataTrackingId, 'catalog-') !== false && mb_strpos($aUrl, 'discussion') === false && empty($aClassName)) {
                            $parsedData[$index] = [
                                'name' => trim($aElement->nodeValue),
                                'midPrice' => '0',
                                'minPrice' => '0',
                                'maxPrice' => '0',
                            ];
                        }
                    }

                    foreach ($element->getElementsByTagName('div') as $aElement) {
                        $aClassName = $aElement->getAttribute('class');
                        if ($aClassName == 'price-md') {
                            $parsedData[$index]['midPrice'] = intval(preg_replace('/\s+/u', '', trim($aElement->nodeValue)));
                        }
                        if ($aClassName == 'text-sm') {
                            $aText = preg_replace('/\s+/u', '', trim($aElement->nodeValue));
                            $prices = explode('–', $aText);
                            $parsedData[$index]['minPrice'] = intval($prices[0]);
                            $parsedData[$index]['maxPrice'] = intval($prices[1]);
                        }
                    }
                }
            }
        }

        if ($request->isMethod('post') || !empty($parsedData)) {
            $zfiDate = $request->get('zfi_date', $currentHourDate);
            $zfiJsonData = $request->get('zfi_jsonData', "[]");
            $zfiJsonData = !empty($parsedData) ? $parsedData : json_decode($zfiJsonData, true);

            $hasDataForDate = $db->getOne("SELECT 1 FROM _hotline_parcer_data WHERE date = ".$db->quote($zfiDate));
            if (!empty($hasDataForDate)) {
                $this->addError($zfiDate.': There is already data for this date!');
                return $this->render('tools/hotline-parcer.tpl');
            }

            $sqlValues = [];
            foreach ($zfiJsonData as $position) {
                if (!isset($position['name'])) {
                    continue;
                }

                $productId = $db->getOne("SELECT id FROM _hotline_parcer_products WHERE name = '".$position['name']."'");
                if (empty($productId)) {
                    $sql = "INSERT INTO _hotline_parcer_products (name) VALUES ('".$position['name']."')";
                    $db->query($sql);
                    $productId = $db->lastInsertId();
                }

                $values = [
                    'product_id' => $productId,
                    'date' => $zfiDate,
                    'min_price' => $position['minPrice'] ?: $position['midPrice'],
                    'max_price' => $position['maxPrice'] ?: $position['midPrice'],
                    'mid_price' => $position['midPrice'],
                ];

                $sqlValues[] = join(', ', $db->quoteAll($values));
            }

            $sql = "INSERT INTO _hotline_parcer_data (".join(', ', array_keys($values)).")  VALUES (".join('), (', $sqlValues).")";
            $db->query($sql);
            $this->addFlash('notice', $zfiDate.': Data Parced Succesfully!');
        }

        $params = [
            'currentDate' => $currentHourDate,
        ];
        return $this->render('tools/hotline-parcer.tpl', $params);
/*
// заходишь по ссылке и в консоли выполняешь скрипт ниже
// https://hotline.ua/sr/?q=3060+ti
// получаешь json - его вставляешь в форму и сохраняешь, данные по каждой позиции будут в таблицах

// primitive jquery hotline.ua prices parcer 
var prices = [];
jQuery('.product-item').each(function(index){
    var element = {'id': index, name: '', 'midPrice': 0, 'minPrice': 0, 'maxPrice': 0};
    
    var name = jQuery(this).find('.item-info p.h4 a').html().trim();
    var minMaxPrices = jQuery(this).find('.text-sm').html();
    var midPrice = jQuery(this).find('.value').not('.getmdl').html();

    if (name != undefined) {
        element.name = name;
    }
    if (midPrice != undefined) {
        midPrice = midPrice.replaceAll('&nbsp;', '');
        if (midPrice > 0) {
            element.midPrice = midPrice;
        }
    }
    if (minMaxPrices != undefined) {
        minMaxPrices = minMaxPrices.replaceAll('&nbsp;', '').replace('грн', '').split('–');
        element.minPrice = minMaxPrices[0] != undefined ? minMaxPrices[0] : 0;
        element.maxPrice = minMaxPrices[1] != undefined ? minMaxPrices[1] : 0;
    }
    if ((element.minPrice == 0 || element.maxPrice == 0) && midPrice > 0) {
        element.minPrice = midPrice;
        element.maxPrice = midPrice;
    }
    prices.push(element);
});
console.log(prices);
console.log(JSON.stringify(prices));
*/
    }
}
