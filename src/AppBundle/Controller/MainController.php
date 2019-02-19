<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends ZFIController
{
    public $validationData = array(
        'login' => array(
            'zfi_login' => ['required', 'login', 'min' => 5, 'max' => 20],
            'zfi_password' => ['required', 'login', 'min' => 8, 'max' => 20],
        ),
        'register' => array(
            'zfi_fio' => ['required', 'fio', 'max' => 100],
            'zfi_login' => ['required', 'login', 'min' => 5, 'max' => 20, 'unique' => array('users.login', 'THIS_LOGIN_IS_ALREADY_RESERVED')],
            'zfi_password' => ['required', 'login', 'min' => 8, 'max' => 20],
            'zfi_password_repeat' => ['required', 'identical' => 'zfi_password'],
        ),
    );

    public function loginAction(Request $request)
    {
        $users = $this->get('zfi.users');
        $session = \App::getSession();
        $params = array(
            'isRegisterRefferal' => \App::getConfig()->isRegisterRefferal,
        );

        if (!empty($session['ZFIUD'])) {
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
        $session = \App::getSession();

        if (empty($session['ZFIUD'])) {
            return $this->redirectToRoute('login_page');
        }

        if ($request->isMethod('post')) {
            unset($session['ZFIUD']);
            return $this->redirectToRoute('default_page');
        }
        return $this->render('users/logout.tpl');
    }

    public function registerAction(Request $request)
    {
        $refferalHash = false;
        $errors = array();

        $session = \App::getSession();

        // в конфиге включена регистрация по реферальной ссылке?
        if (\App::getConfig()->isRegisterRefferal) {
            $refferalHash = $request->query->get('ref', null);
            $refferalHash = !is_null($refferalHash) ? $refferalHash : $request->request->get('ref_link', null);

            $errors = \ZFI\RefferalHash::checkHashRegister($refferalHash);

            if (!empty($errors)) {
                $this->addError($errors);
                return $this->render('default.tpl');
            }
        }

        if ($request->isMethod('post')) {
            $users = $this->get('zfi.users');

            $users->add(array(
                'login' => $request->request->get('zfi_login'),
                'password' => md5($request->request->get('zfi_password')),
                'username' => $request->request->get('zfi_fio')
            ));

        }

        $params = array('ref_link' => $refferalHash);

        return $this->render('users/register.tpl', $params);
    }

    public function jsonValidationAction($actionType, Request $request)
    {
        $validator = new \Validator();

        return $this->json($validator->validateProcess(
            $request->request->all(),
            $this->validationData[$actionType]
        ));
    }
}