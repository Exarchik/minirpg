<?php

namespace AppBundle\Controller;

use AppBundle\Controller\ZFIController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class MainController extends ZFIController
{
    public $validationData = array(
        'app.main.login' => array(
            'zfi_login' => ['required', 'login', 'min' => 5, 'max' => 20],
            'zfi_password' => ['required', 'login', 'min' => 8, 'max' => 20],
        ),
        'app.main.register' => array(
            'zfi_fio' => ['required', 'fio', 'max' => 100],
            'zfi_login' => ['required', 'login', 'min' => 5, 'max' => 20, 'unique' => array('users.login', 'THIS_LOGIN_IS_ALREADY_RESERVED')],
            'zfi_password' => ['required', 'login', 'min' => 8, 'max' => 20],
            'zfi_password_repeat' => ['required', 'identical' => 'zfi_password'],
        ),
        // lang_% в addSpecificValidData
        'app.main.languageform' => array(
            'zfi_ident' => ['required', 'ident', 'unique' => 'lang_data.ident'],
        )
    );

    public function loginAction(Request $request)
    {
        $valiData = $this->validate($request);
        if ($this->isJsonResponse($valiData)) {
            return $valiData;
        }

        $users = $this->get('zfi.users');
        $session = \App::getSession();
        $params = array(
            'isRegisterRefferal' => \App::getConfig()->isRegisterRefferal,
        );

        if (!empty($session['ZFIUD'])) {
            return $this->redirectToRoute('logout_page');
        }

        if ($request->isMethod('post') && $valiData === true) {
            $users = $this->get('zfi.users');
            $login = $request->get('zfi_login', null);
            $pass = $request->get('zfi_password', null);

            if (!$users->auth($login, $pass)) {
                $this->addInvalidFeedback(array('zfi_login' => __('FORM_ERROR_ACCOUNT_DOES_NOT_EXIST').'!'));
            } else {
                return $this->redirectToRoute('default_page');
            }
        }

        return $this->render('users/login.tpl', $params);
    }

    public function logoutAction($type, Request $request)
    {
        $session = \App::getSession();

        if (empty($session['ZFIUD'])) {
            return $this->redirectToRoute('login_page');
        }

        if ($request->isMethod('post') || $type == 'quick') {
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
        $isRegisterRefferal = \App::getConfig()->isRegisterRefferal;

        $valiData = $this->validate($request);
        if ($this->isJsonResponse($valiData)) {
            return $valiData;
        }

        // в конфиге включена регистрация по реферальной ссылке?
        if ($isRegisterRefferal) {
            $refferalHash = $request->query->get('ref', null);
            $refferalHash = !is_null($refferalHash) ? $refferalHash : $request->request->get('ref_link', null);

            $errors = \ZFI\RefferalHash::checkHashRegister($refferalHash);

            if (!empty($errors)) {
                $this->addError($errors);
                return $this->render('default.tpl');
            }
        }

        if ($request->isMethod('post') && $valiData === true) {
            $users = $this->get('zfi.users');

            $users->add(array(
                'login' => $request->request->get('zfi_login'),
                'password' => md5($request->request->get('zfi_password')),
                'username' => $request->request->get('zfi_fio')
            ));
            // в конфиге включена регистрация по реферальной ссылке? "убиваем" ссылку
            if ($isRegisterRefferal) {
                \ZFI\RefferalHash::killHash($refferalHash, $users->lastInsertUserId);
            }

            $this->addFlash('notice', __('NOW_YOU_CAN_LOG_IN_WITH_YOUR_ACCOUNT'));
            return $this->redirectToRoute('login_page');
        }

        $params = array('ref_link' => $refferalHash);

        return $this->render('users/register.tpl', $params);
    }

    public function languageFormAction(Request $request)
    {
        if (!\App::getUsers()->is_superadmin) {
            return $this->json(false);
        }

        $valiData = $this->validate($request);
        if ($this->isJsonResponse($valiData)) {
            return $valiData;
        }

        $langList = \App::getLang()->getLanguageList();

        $params = array(
           'language_idents' => $langList,
        );

        if ($request->isMethod('post') && $valiData === true) {
            $validator = new \Validator();
            $realIdent = textToIdent($request->get('zfi_ident'));

            $errors = $validator->validate($realIdent, array('unique' => 'lang_data.ident'));

            if ($errors !== true) {
                $this->addError($errors);
                return $this->render('superadmin/language.form.tpl', $params);
            }

            $values = array(
                "ident" => \App::getPDO()->quote($realIdent),
            );
            $langData = array();
            foreach (array_keys($langList) as $ident) {
                $langData[$ident] = $request->get('term_'.$ident, '');
            }
            $values["value"] = \App::getPDO()->quote(json_encode($langData));

            $sql = "INSERT INTO `lang_data` (".join(', ', array_keys($values)).") VALUES (".join(', ', $values).")";
            \App::getPDO()->query($sql);

            $this->addMessage(__('LANGUAGE_IDENT_SUCCESSFULLY_INSERTED'));
        }

        return $this->render('superadmin/language.form.tpl', $params);
    }

    public function jsonValidationAction($actionType, Request $request)
    {
        $this->addSpecificValidData($actionType);

        if (!$request->isXmlHttpRequest()) {
            return $this->json(false);
        }
        $validator = new \Validator();

        return $this->json($validator->validateProcess(
            $request->request->all(),
            $this->validationData[$actionType]
        ));
    }

    // переключение языков
    public function jsonLanguageAction($language, Request $request)
    {
        if (!$request->isXmlHttpRequest() || strlen($language) != 2) {
            return $this->json(false);
        }
        return $this->json(array('result' => \App::getLang()->setDefaultLang($language)));
    }

    protected function addSpecificValidData($formAlias)
    {
        switch ($formAlias) {
            case 'app.main.languageform':
                $langIdents = \App::getLang()->getLanguageListIdents();
                foreach($langIdents as $ident) {
                    $this->validationData[$formAlias]['term_'.$ident] = ['required', 'text', 'max' => 250];
                }
            break;
            default:
            break;
        }
    }
}