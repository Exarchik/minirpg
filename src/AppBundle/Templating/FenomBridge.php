<?php

namespace AppBundle\Templating;

use Fenom;
use Fenom\ProviderInterface;

// Нужен для поддержки legacy code, после перехода на Symfony объединится с FenomEngine
class FenomBridge
{
    protected $layout = 'main.tpl';
    
    protected $layoutVars = array();
    
    protected $helpers = array(
        'Helpers:jsError' => 'jsError',
        'Helpers:jsSuccess' => 'jsSuccess',
        'Helpers:jsMessage' => 'jsMessage',
        'Helpers:Notify' => 'Notify',
    );
    
    protected $source;
    
    protected $providers = [];
    
    protected $layoutAliases = [
        'main' => 'main.tpl',
        //'light' => 'light.ihtml',
        //'iframe' => 'iframe.ihtml',
        //'main_report' => 'reports/main_report.ihtml',
    ];
    
    public function __construct(string $source = MAIN_TEMPLATES)
    {
        $this->source = $source;
    }
    
    public function render($name, array $parameters = array())
    {
        if (isset($parameters['layout'])) {
            $this->layoutVars = array_merge($this->layoutVars, $parameters['layout']);
            unset($parameters['layout']);
        }
        $content = $this->fetch($name, $parameters);
        
        return $this->renderLayout($content);
    }
    
    private function fetch($name, array $parameters = array())
    {
        if (empty($name)) {
            return (string)$parameters['content'];
        }
        
        $method = isset($this->helpers[$name]) ? $this->helpers[$name] : null;
        if ($method) {
            return $this->$method($parameters);
        }
        
        return $this->getFenomTemplate()->fetch($name, $parameters);
    }
    
    private function renderLayout(string $content)
    {
        if (!$this->layout) {
            return $content;
        }
        
        return $this->basicDisplay($content);
    }
    
    protected function basicDisplay(string $content)
    {
        return (string)basicDisplay($content, $this->layout, $this->layoutVars);
    }
    
    public function setLayout(string $name, array $vars = array())
    {
        $this->layout = isset($this->layoutAliases[$name]) ? $this->layoutAliases[$name] : $name;
        $this->layoutVars = array_merge($vars, array('return_content' => true));
    }

    public function exists($name)
    {
        return isset($this->helpers[$name]) || $this->getFenomTemplate()->templateExists($name);
    }
    
    public function supports($name)
    {
        return isset($this->helpers[$name]) || in_array(pathinfo($name, PATHINFO_EXTENSION), array('ihtml', 'tpl')) || empty($name);
    }
    
    public function addProvider(string $key, ProviderInterface $provider)
    {
        $this->providers[$key] = $provider;
    }
    
    protected function getFenomTemplate()
    {
        $fenom = Fenom\Extra::factory($this->source, "/tmp/", ['disable_cache' => true]);
        
        foreach ($this->providers as $key => $provider) {
            $fenom->addProvider($key, $provider, '/tmp/');
        }
    
        addFenomModifiersAndFunctions($fenom);
        
        return $fenom;
    }
    
    protected function Notify($parameters)
    {
        $parameters['backLink'] = isset($parameters['backLink']) ? $parameters['backLink'] : $_SERVER['HTTP_REFERER'];
        
        return $this->render('helpers/Notify.tpl', $parameters);
    }
    
    protected function jsError(array $parameters)
    {
        $this->setLayout("");
        
        if (!empty($parameters['needSpecialChars'])) {
            $parameters['message'] = htmlspecialchars($parameters['message']);
        }
        $parameters['message'] = strtr($parameters['message'], array('"' => '\"', "\\" => "\\\\", "\n" => '\n'));
        
        return $this->render('helpers/jsError.tpl', $parameters);
    }
    
    protected function jsSuccess(array $parameters)
    {
        $this->setLayout("");
        
        $parameters['message'] = strtr($parameters['message'], array('"' => '\"', "\\" => "\\\\", "\n" => '\n'));
        
        return $this->render('helpers/jsSuccess.tpl', $parameters);
    }
    
    protected function jsMessage(array $parameters)
    {
        $this->setLayout("");
        
        $replaceToBr = array("\n");
        $parameters['message'] = preg_replace("#(" . join("|", $replaceToBr) . ")#Umis", "<br/>", $parameters['message']);
        $parameters['containerId'] = empty($parameters['containerId']) ? 'messageBox' : $parameters['containerId'];
        
        return $this->render('helpers/jsMessage.tpl', $parameters);
    }
}
