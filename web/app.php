<?php

use Symfony\Component\HttpFoundation\Request;
session_start();

require __DIR__.'/../vendor/autoload.php';
require __DIR__.'/../const.php';
require __DIR__.'/../db_config.php';
require __DIR__.'/../config.php';

require MAIN_LIBS.'/data/Error.php';
require MAIN_LIBS.'/data/Users.php';
require MAIN_LIBS.'/data/Session.php';

require MAIN_LIBS.'/functions.php';
require MAIN_LIBS.'/App.php';

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
