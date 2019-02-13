<?php

use Symfony\Component\HttpFoundation\Request;

require __DIR__.'/../vendor/autoload.php';
require __DIR__.'/../const.php';
require __DIR__.'/../config.php';

require MAIN_LIBS.'/functions.php';
require MAIN_LIBS.'/PDO/PDODecorator.php';

$GLOBALS['db'] = new PDODecorator($config->dbHost, $config->dbName, $config->dbLogin, $config->dbPassword);

if (PHP_VERSION_ID < 70000) {
    include_once __DIR__.'/../var/bootstrap.php.cache';
}

$kernel = new AppKernel('prod', false);
if (PHP_VERSION_ID < 70000) {
    $kernel->loadClassCache();
}
//$kernel = new AppCache($kernel);

// When using the HttpCache, you need to call the method in your front controller instead of relying on the configuration parameter
//Request::enableHttpMethodParameterOverride();
$request = Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);
