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
                'required' => array(__('FORM_REQUIRED_FIELD')),
                'min' => array(5, __('FORM_MIN_FIELD_LONG')),
                'max' => array(20, __('FORM_MAX_FIELD_LONG')),
                'login' => array('Поле может содержать только латиницу, цифры и "-_"')
            ),
            'zfi_password' => array(
                'required' => array(__('FORM_REQUIRED_FIELD')),
                'min' => array(5, __('FORM_MIN_FIELD_LONG')),
                'max' => array(20, __('FORM_MAX_FIELD_LONG')),
                'login' => array('Поле может содержать только латиницу, цифры и "-_"')
            ),
        );

        $params = $request->request->all();
        $validator = new \Validator();

        return $this->json($validator->validateProcess($params, $validationData));
    }
}