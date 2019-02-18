<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends ZFIController
{
    public function loginAction(Request $request)
    {
        $users = $this->get('zfi.users');
        $session = $this->get('session');
        $params = array();

        if (!is_null($session->get('login'))) {
            return $this->redirectToRoute('logout_page');
        }

        if ($request->isMethod('post')) {
            $users = $this->get('zfi.users');
            $login = $request->get('zfi_login', null);
            $pass = $request->get('zfi_password', null);

            if (!$users->auth($login, $pass)) {
                $this->addError("Логин или пароль введены не верно!");
            } else {
                return $this->redirectToRoute('default_page');
            }
        }

        return $this->render('users/login.tpl', $params);
    }

    public function logoutAction(Request $request)
    {
        $users = $this->get('zfi.users');
        $session = $this->get('session');

        if (is_null($session->get('login'))) {
            return $this->redirectToRoute('login_page');
        }

        if ($request->isMethod('post')) {
            $session->remove('login');
            return $this->redirectToRoute('default_page');
        }
        return $this->render('users/logout.tpl');
    }

    public function jsonAction(Request $request)
    {
        $validationData = array(
            'zfi_login' => array(
                'required' => array(__('FORM_REQUIRED_FIELD')),
                'min' => array(5, __('FORM_MIN_FIELD_LONG')),
                'max' => array(20, __('FORM_MAX_FIELD_LONG')),
                'login' => array(__('FORM_LOGIN_TYPE_VALIDATION_TEXT'))
            ),
            'zfi_password' => array(
                'required' => array(__('FORM_REQUIRED_FIELD')),
                'min' => array(5, __('FORM_MIN_FIELD_LONG')),
                'max' => array(20, __('FORM_MAX_FIELD_LONG')),
                'login' => array(__('FORM_LOGIN_TYPE_VALIDATION_TEXT'))
            ),
        );

        $params = $request->request->all();
        $validator = new \Validator();

        return $this->json($validator->validateProcess($params, $validationData));
    }
}