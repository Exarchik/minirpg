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
        #$session = $this->get('session');

        $session = \App::getSession();
        $user = \App::getUsers();
        $params = array();

        #$result = $users->add(['login' => 'empty', 'password' => '34234234']);
        $msg = !is_null($session['ZFIUD']) 
            ? __('YOU_ARE_WELCOME').', '.$user->data['username'].'!'.($user->is_admin ? ' <b>(Админ)</b>':'')
            : "<a href='".BASE_URL."/login'>".__('AUTHORIZATION')."</a>";
        $this->addMessage($msg);

        $data = [0,1,2,3,4];

        $params = array_merge($params, array(
            'base_dir' => 'tested information',
            'data' => $data,
        ));

        return $this->render('default.tpl', $params);
    }
}
