<?php

class ZFIConfig
{
    private $dbHost      = 'uchifeek.mysql.tools';
    private $dbName      = 'uchifeek_zfi2';
    private $dbLogin     = 'uchifeek_zfi2';
    private $dbPassword  = 'o5K9LzFhGi60';

    private $langDefault = 'ru'; // en, ua

    // авторизация доступна только по реферальным ссылкам
    public $isRegisterRefferal = true;

    public function getDBData()
    {
        return array($this->dbHost, $this->dbName, $this->dbLogin, $this->dbPassword);
    }

    public function getCurrentLang()
    {
        $session = \App::getSession();
        return !empty($session['language']) ? $session['language'] : $this->langDefault;
    }

    public function __debugInfo()
    {
        return array(
            'langDefault' => $this->langDefault,
            'isRegisterRefferal' => $this->isRegisterRefferal,
        );
    }
}

$config = new ZFIConfig();
