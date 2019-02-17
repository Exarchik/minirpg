<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

use ZFI\Users;

class MainController extends Controller
{
    public function loginAction(Request $request)
    {
        $params = array();

        $validator = $this->get('validator');

        if ($request->isMethod('post')) {
            $params = $request->request->all();

            $users = new Users();

            #print_r($_REQUEST); die;
        }

        return $this->render('users/login.tpl', $params);
    }
}