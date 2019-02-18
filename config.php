<?php

class ZFIConfig
{
    private $dbHost      = 'uchifeek.mysql.tools';
    private $dbName      = 'uchifeek_zfi2';
    private $dbLogin     = 'uchifeek_zfi2';
    private $dbPassword  = 'o5K9LzFhGi60';

    private $langDefault = 'ru'; // en, ua

    public function getDBData() {
        return array($this->dbHost, $this->dbName, $this->dbLogin, $this->dbPassword);
    }

    public function getDefaultLang() {
        return $this->langDefault;
    }
}

$config = new ZFIConfig();
