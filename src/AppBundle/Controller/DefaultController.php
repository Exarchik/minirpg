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
        /*
         * Зарезервированные переменные _GET
         * pid = ИД товара в int, 0 - если нужен весь список товаров | PRODUCT_ID
         * type = тип поля для графика по всем товарам (min/mid/max) | PRICE_IDENT
         * points = кол-во точек для разбития графика 0 - все точки  | AMOUNT_OF_POINTS
         */

        $allowedPrices = [
            'min' => ['field' => 'min_price', 'caption' => 'Минимальная цена'],
            'mid' => ['field' => 'mid_price', 'caption' => 'Средняя цена'],
            'max' => ['field' => 'max_price', 'caption' => 'Максимальная цена'],
        ];
        // спец таблица с доп ИД и полями цен для случая с одним товаром
        $productPricesFieldsList = [
            1000 => ['field' => 'min_price', 'caption' => 'Мин. цена'],
            2000 => ['field' => 'mid_price', 'caption' => 'Сред. цена'],
            3000 => ['field' => 'max_price', 'caption' => 'Макс. цена'],
        ];

        // тип цены (мин, сред, макс)
        $PRICE_IDENT = $request->query->get('type', 'min');
        $PRICE_IDENT = isset($allowedPrices[$PRICE_IDENT]) ? $PRICE_IDENT : 'min';
        // название поля для указанной цены
        $priceField = isset($allowedPrices[$PRICE_IDENT]) ? $allowedPrices[$PRICE_IDENT]['field'] : $allowedPrices['min']['field'];

        // кол-во точек на которое будет разбиваться график для каждого товара (+1 последняя точка)
        $AMOUNT_OF_POINTS = (int)$request->query->get('points', '0');

        // продукт ИД - all если нужны все товары
        $PRODUCT_ID = (int)$request->query->get('pid', '0');

        // минимальная сущестующая в БД цена
        $minDataTime = $db->getOne("SELECT MIN(date) FROM _hotline_parcer_data") ?: '1970-01-01 00:00:00';
        // цена от
        $dateFrom = $request->query->get('from', $minDataTime);
        // цена до
        $dateTo = $request->query->get('to', date('Y-m-d H:i:s'));
        // цена от в Юниксдате
        $uDateFrom = strtotime($dateFrom);
        // цена до в Юниксдате
        $uDateTo = strtotime($dateTo);

        // список дат расчитыанных с помощью указанного кол-ва точек
        $datesList = [];
        if ($AMOUNT_OF_POINTS > 0) {
            // кол-во секунд которое будет потрачено на каждый шаг
            $stepBySeconds = $AMOUNT_OF_POINTS > 0 ? (int)(($uDateTo - $uDateFrom) / $AMOUNT_OF_POINTS) : 0;

            for ($i = 0; $i <= $AMOUNT_OF_POINTS; $i++) {
                $datesList[] = date('Y-m-d H:i:s', strtotime($dateFrom." + ".($i * $stepBySeconds)." seconds"));
            }
        }

        $dateFrom = date('Y-m-d H:i:s', $uDateFrom);
        $dateTo = date('Y-m-d H:i:s', $uDateTo);

        if (!$user->is_superadmin) {
            return $this->json(false);
        }

        // кол-во выводимых позиций
        $numberOfData = 17;//500;
        // пропускать нули?
        $skipZeros = false;//true;

        $fromUnixTime = strtotime($dateFrom);
        $toUnixTime = strtotime($dateTo);

        // тянем все даты какие вообще возможны
        $allDates = [];
        $_allDates = $db->getCol("SELECT DISTINCT date FROM _hotline_parcer_data WHERE date BETWEEN ".$db->quote($dateFrom)." AND ".$db->quote($dateTo)." ORDER BY date ASC");
        if ($AMOUNT_OF_POINTS > 0) {
            foreach ($datesList as $dateINeed) {
                $minTmpUDate = 100000;
                $minTmpDate = date('Y-m-d H:i:s');
                foreach ($_allDates as $dateIHave) {
                    $absDate = abs(strtotime($dateIHave) - strtotime($dateINeed));
                    if ($absDate < $minTmpUDate) {
                        $minTmpUDate = $absDate;
                        $minTmpDate = $dateIHave;
                    }
                }
                $allDates[] = $minTmpDate;
            }
            array_unique($allDates);
        } else {
            $allDates = $_allDates;
        }

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

        if ($PRODUCT_ID == 0) {
            $sqlPrices = "SELECT hp.id AS prodId, hd.date, hd.{$priceField} AS price
                    FROM `_hotline_parcer_data` AS hd
                        JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                    WHERE ".join(" AND ", $sqlWhere)."
                    ORDER BY hp.id ASC, hd.date ASC";

            $sqlNames = "SELECT hp.id AS prodId, CONCAT(hp.id, ') ', COALESCE(hp.alias, hp.name), ' [', last_prices.price, ']') AS name
                    FROM `_hotline_parcer_data` AS hd
                        LEFT JOIN (SELECT product_id, {$priceField} AS price
                                    FROM `_hotline_parcer_data`
                                    WHERE date = (SELECT MAX(date) FROM `_hotline_parcer_data`)) AS last_prices ON hd.product_id = last_prices.product_id
                        JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                    WHERE ".join(" AND ", $sqlWhere)."
                    GROUP BY hp.id
                    ORDER BY hp.id";
        } else {
            $sqlPricesList = [];
            $sqlNamesList = [];

            foreach ($productPricesFieldsList as $index => $priceFieldData) {
                $sqlPricesList[] = "SELECT hp.id + {$index} AS prodId, hd.date, hd.{$priceFieldData['field']} AS price
                                FROM `_hotline_parcer_data` AS hd
                                    JOIN `_hotline_parcer_products` AS hp ON hp.id = hd.product_id
                                WHERE hp.id = {$PRODUCT_ID}
                                ORDER BY hp.id ASC, hd.date ASC";

                $sqlNamesList[] = "SELECT hp.id + {$index}, CONCAT(hp.id, ') {$priceFieldData['caption']} - ', COALESCE(hp.alias, hp.name), ' [', last_prices.price, ']') AS name
                                    FROM `_hotline_parcer_products` AS hp
                                        LEFT JOIN (SELECT product_id, {$priceFieldData['field']} AS price
                                                    FROM `_hotline_parcer_data`
                                                    WHERE date = (SELECT MAX(date) FROM `_hotline_parcer_data`)) AS last_prices ON hp.id = last_prices.product_id
                                    WHERE hp.id = {$PRODUCT_ID}";
            }

            $sqlPrices = "(" . join(") UNION (", $sqlPricesList) . ")";
            $sqlNames = "(" . join(") UNION (", $sqlNamesList) . ")";
        }

        $minPricesData = $db->getAll($sqlPrices);
        $prodNames = $db->getAssoc($sqlNames);

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
        /*if ($skipZeros) {
            foreach (array_unique($prodIdHasZeroData) as $deleteProdId) {
                unset($prodNames[$deleteProdId]);
                foreach ($minPricesChartData as $date => $row) {
                    unset($minPricesChartData[$date][$deleteProdId]);
                }
            }
        }*/

        foreach ($minPricesChartData as $date => $row) {
            $minPricesChartData[$date] = "[".join(", ", $row)."],";
        }

        foreach ($pricesChartData as $date => $row) {
            $pricesChartData[$date] = "[".join(", ", $row)."],";
        }

        $params = [
            'type' => $PRICE_IDENT,
            'prodNames' => $prodNames,
            //'minChartInfo' => $minPricesChartData,
            'minChartInfo' => $pricesChartData,
            'chartCaption' => $allowedPrices[$PRICE_IDENT]['caption'],
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

                $productParcerId = $db->getOne("SELECT id FROM _hotline_parcer_products WHERE name = '".$position['name']."'");
                if (empty($productParcerId)) {
                    $sql = "INSERT INTO _hotline_parcer_products (name) VALUES ('".$position['name']."')";
                    $db->query($sql);
                    $productParcerId = $db->lastInsertId();
                }

                $values = [
                    'product_id' => $productParcerId,
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
