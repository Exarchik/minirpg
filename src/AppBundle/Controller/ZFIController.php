<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

// специальный файл контроллер - прокладка
class ZFIController extends Controller
{
    protected $params = array(
        'errors' => array(),
        'messages' => array(),
    );
    
    // добавляет ошибку в layout
    public function addError($msgs)
    {
        $msgs = is_array($msgs) ? $msgs : array($msgs);
        $this->params['errors'] = array_merge($this->params['errors'], $msgs);
    }

    // добавляет сообщение в layout
    public function addMessage($msgs)
    {
        $msgs = is_array($msgs) ? $msgs : array($msgs);
        $this->params['messages'] = array_merge($this->params['messages'], $msgs);
    }

    // измененный рендер
    public function render($template, $params = array())
    {
        $params = array_merge($params, array('layout' => $this->params));

        return parent::render($template, $params);
    }  
}