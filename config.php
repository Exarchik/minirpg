<?php

function parseDsn($dsn)
{   
    $parsedDsn = parse_url($dsn);
    $parsedDsn['database'] = str_replace('/', '', $parsedDsn['path']);
    unset($parsedDsn['path']);
    
    return $parsedDsn;
}

class ZFIConfig
{
    private $dbHost;
    private $dbName;
    private $dbLogin;
    private $dbPassword;

    private $dsn = null;

    private $langDefault = 'ru'; // en, ua

    // авторизация доступна только по реферальным ссылкам
    public $isRegisterRefferal = true;

    public function __construct($dsn = null)
    {
        $this->dsn = !is_null($dsn) ? $dsn : DSN;
        $dbConfigData = parseDsn($this->dsn);
        
        if (is_array($dbConfigData) && !empty($dbConfigData)) {
            $this->dbHost = $dbConfigData['host'];
            $this->dbName = $dbConfigData['database'];
            $this->dbLogin = $dbConfigData['user'];
            $this->dbPassword = $dbConfigData['pass'];
        }
    }

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

$config = new ZFIConfig(DSN);
