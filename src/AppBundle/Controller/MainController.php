<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends ZFIController
{
    public $validationData = array(
        'login' => array(
            'zfi_login' => ['required', 'min' => 5, 'max' => 20, 'login'],
            'zfi_password' => ['required', 'min' => 8, 'max' => 20, 'login'],
        ),
        'register' => array(
            'zfi_login' => ['required', 'min' => 5, 'max' => 20, 'login'],
            'zfi_password' => ['required', 'min' => 8, 'max' => 20, 'login'],
        ),
    );

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
                $this->addError(__('FORM_ERROR_ACCOUNT_DOES_NOT_EXIST').'!');
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

    public function registerAction(Request $request)
    {
        if (\App::getConfig()->isRegisterRefferal) {
            $refferalHash = $request->query->get('ref', null);
            if (is_null($refferalHash)) {
                $this->addError('Регистрация доступна только по реферальной ссылке');
                return $this->render('default.tpl');
            }
        } else {
            $refferalHash = true;
        }
        return $this->render('users/register.tpl');
    }

    public function jsonValidationAction($actionType, Request $request)
    {
        $validator = new \Validator();

        return $this->json($validator->validateProcess($request->request->all(), $this->validationData[$actionType]));
    }
}