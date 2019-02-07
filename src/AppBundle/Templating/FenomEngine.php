<?php

namespace AppBundle\Templating;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\RouterInterface;
use Symfony\Component\Templating\EngineInterface;
use Symfony\Component\Routing\Generator\UrlGeneratorInterface;

class FenomEngine extends FenomBridge implements EngineInterface
{
    protected $router;
    
    public function __construct(string $source, RouterInterface $router)
    {
        parent::__construct($source);
        $this->router = $router;
    }
    
    public function renderResponse($view, array $parameters = array(), Response $response = null)
    {
        if (is_null($response)) {
            $response = new Response();
        }
        
        $response->setContent($this->render($view, $parameters));
        
        return $response;
    }
    
    public function getFenomTemplate(): \Fenom
    {
        $fenom = parent::getFenomTemplate();
        
        $fenom->addFunction("path", function ($params) {
            return call_user_func_array([$this->router, 'generate'], $params);
        });
        $fenom->addFunction("pathAbsolute", function ($params) {
            $route = array_shift($params);
            return $this->router->generate($route, !empty($params) ? reset($params) : array(), UrlGeneratorInterface::ABSOLUTE_URL);
        });
        
        return $fenom;
    }
}