<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DefaultController extends ZFIController
{
    public function indexAction(Request $request)
    {
        #$db = $this->get('zfi.db');
        $session = $this->get('session');
        $params = array();

        #$users = $this->get('zfi.users');
        #$result = $users->add(['login' => 'empty', 'password' => '34234234']);
        $this->addMessage(__('YOU_ARE_WELCOME').', '.$session->get('login').'!');

        $data = [0,1,2,3,4];

        $params = array_merge($params, array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));

        return $this->render('default.tpl', $params);
    }
}
