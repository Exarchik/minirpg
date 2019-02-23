<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class UserController extends ZFIController
{
    public function profileAction()
    {
        $user = \App::getUsers();
        if ($user->is_guest) {
            return $this->json(false);
        }

        return $this->render('users/profile.tpl', array('userData' => $user->data));
    }
}