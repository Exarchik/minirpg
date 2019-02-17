<?php

require MAIN_LIBS.'/PDO/PDODecorator.php';
require MAIN_LIBS.'/Language.php';

class App
{
    static $db = null;
    static $lang = null;

    static public function getPDO()
    {
        global $config;

        if (is_null(static::$db)) {
            static::$db = new PDODecorator($config->dbHost, $config->dbName, $config->dbLogin, $config->dbPassword);
        }

        return static::$db;
    }

    static public function getLang()
    {
        global $config;

        if (is_null(static::$lang)) {
            static::$lang = new Language(self::getPDO(), $config->langDefault);
        }

        return static::$lang;
    }
}