<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class GamesController extends ZFIController
{
    public function indexAction($gameType)
    {
        return $this->render('games/' . $gameType . '.tpl', []);
    }
}