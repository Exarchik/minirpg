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
            static::$db = new PDODecorator(...$config->getDBData());
        }

        return static::$db;
    }

    static public function getLang()
    {
        global $config;

        if (is_null(static::$lang)) {
            static::$lang = new Language(self::getPDO(), $config->getDefaultLang());
        }

        return static::$lang;
    }
}