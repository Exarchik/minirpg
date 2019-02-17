<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends ZFIController
{
    public function loginAction(Request $request)
    {
        $params = array();

        if ($request->isMethod('post')) {
            $users = $this->get('zfi.users');

            $this->addMessage("Введены след. данные: Логин: {$_REQUEST['zfi_login']} и пароль: {$_REQUEST['zfi_password']} ");
        }

        return $this->render('users/login.tpl', $params);
    }

    public function jsonAction(Request $request)
    {
        $validationData = array(
            'zfi_login' => array(
                'min' => array(5, 'Логин должен быть длинее %s символов'),
                'max' => array(20, 'Логин не должен превышать %s символов'),
                'login' => array('Логин может содержать только латиницу, цифры и "-_')
            ),
            'zfi_password' => array(
                'required' => array('Поле обязательно к заполнению'),
                'min' => array(5, 'Пароль должен быть длинее %s символов'),
                'max' => array(20, 'Пароль не должен превышать %s символов'),
            ),
        );

        $params = $request->request->all();
        $validator = new \Validator();

        return $this->json($validator->validateProcess($params, $validationData));
    }
}