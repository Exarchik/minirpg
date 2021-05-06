<?php

namespace ZFI;

use DOMDocument;

class ExusParcer
{
    //protected $url = "https://hotline.ua/sr/?q=3060+ti";
    protected $url = "https://hotline.ua/computer/videokarty/?q=rtx+3060";

    public function execute()
    {
        $db = \App::getPDO();
        $xml = new DOMDocument();

        $currentHourDate = date('Y-m-d H:00:00');

        $internalErrors = libxml_use_internal_errors(true);
        $xml->loadHTMLFile($this->url);
        libxml_use_internal_errors($internalErrors);

        $parsedData = [];
        foreach($xml->getElementsByTagName('li') as $index => $element) {
            $className = $element->getAttribute('class');
            if ($className == 'product-item') {
                foreach ($element->getElementsByTagName('a') as $aElement) {
                    $dataTrackingId = $aElement->getAttribute('data-tracking-id');
                    $aClassName = $aElement->getAttribute('class');
                    $aUrl = $aElement->getAttribute('href');

                    if (mb_strpos($dataTrackingId, 'catalog-') !== false
                        && mb_strpos($aUrl, 'discussion') === false
                        && mb_strpos($aUrl, '#sales') === false
                        && empty($aClassName)) {
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

        if (empty($parsedData)) {
            return "Parsed Data is Empty.";
        }

        $hasDataForDate = $db->getOne("SELECT 1 FROM _hotline_parcer_data WHERE date = ".$db->quote($currentHourDate));
        if (!empty($hasDataForDate)) {
            return $currentHourDate.': There is already data for this date!';
        }

        $sqlValues = [];
        foreach ($parsedData as $position) {
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
                'date' => $currentHourDate,
                'min_price' => $position['minPrice'] ?: $position['midPrice'],
                'max_price' => $position['maxPrice'] ?: $position['midPrice'],
                'mid_price' => $position['midPrice'],
            ];

            $sqlValues[] = join(', ', $db->quoteAll($values));
        }

        $sql = "INSERT INTO _hotline_parcer_data (".join(', ', array_keys($values)).")  VALUES (".join('), (', $sqlValues).")";
        $db->query($sql);

        $sql = "SELECT COALESCE(pd.alias, pd.name) AS caption, MIN(d.min_price) as min_price
                FROM _hotline_parcer_data AS d
                JOIN _hotline_parcer_products AS pd ON d.product_id = pd.id
                WHERE min_price > 0 AND date = ".$db->quote($currentHourDate);
        $resultData = $db->getRow($sql);

        return "Результат аналізу:\n\rДата аналізу: {$currentHourDate}.\n\rДані було успішно проаналізовано! Мінімальна знайдена ціна: {$resultData['caption']} ({$resultData['min_price']} грн.)";
    }
}