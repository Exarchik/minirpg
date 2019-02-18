<?php

require MAIN_LIBS.'/PDO/PDODecorator.php';
require MAIN_LIBS.'/Language.php';

class App
{
    static $db = null;
    static $lang = null;
    static $config = null;

    static public function getConfig()
    {
        global $config;

        if (is_null(static::$config)) {
            static::$config = $config;
        }

        return static::$config;
    }

    static public function getPDO()
    {
        if (is_null(static::$db)) {
            static::$db = new PDODecorator(...self::getConfig()->getDBData());
        }

        return static::$db;
    }

    static public function getLang()
    {
        if (is_null(static::$lang)) {
            static::$lang = new Language(self::getPDO(), self::getConfig()->getDefaultLang());
        }

        return static::$lang;
    }
}