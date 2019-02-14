<?php

require MAIN_LIBS.'/PDO/PDODecorator.php';

class App
{
    static $db = null;

    static public function getPDO()
    {
        global $config;

        if (is_null(static::$db)) {
            static::$db = new PDODecorator($config->dbHost, $config->dbName, $config->dbLogin, $config->dbPassword);
        }

        return static::$db;
    }
}