<?php

namespace ZFI;

use Symfony\Component\HttpFoundation\Session\Session;

class Users
{
    public $id;

    public $data;

    public $is_admin = false;
    public $is_superadmin = false;

    public function getData(int $id)
    {
        $sql = "SELECT u.login, u.username, u.is_active, u.role_id, ur.code
                FROM users AS u
                JOIN users_roles AS ur ON u.role_id = ur.id
                WHERE u.id = {$id}";
        $this->data = \App::getPDO()->getRow($sql);
        if (!empty($this->data)) {
            $this->id = $id;
            $this->is_admin = in_array($this->data['code'], ['ZFI_ADMIN', 'ZFI_SUPERADMIN']) ? true : false;
            $this->is_superadmin = in_array($this->data['code'], ['ZFI_SUPERADMIN']) ? true : false;
        }
        return !empty($this->data) ? $this->data : false;
    }

    public function isLoginExist(string $login)
    {
        $sql = "SELECT id FROM users WHERE login = ".\App::getPDO()->quote($login);
        if (\App::getPDO()->getOne($sql)) {
            return true;
        }
        return false;
    }

    public function checkData($data = array())
    {
        $error = new Error();
        if (empty($data['login']) || empty($data['password'])) {
            $error->addMessage(__('NO_PASSWORD_OR_LOGIN_SPECIFIED'));
        }

        if ($this->isLoginExist($data['login'])) {
            $error->addMessage(__('THIS_LOGIN_IS_ALREADY_RESERVED'));
        }

        if ($error->hasErrors()) {
            return $error;
        }
        return false;
    }

    public function add($data)
    {
        $errors = $this->checkData($data);
        if ($errors !== false) {
            return $errors;
        }

        $fields = array_keys($data);
        $sql = "INSERT INTO `users` (".join(', ', $fields).")
                VALUES (".join(', ', \App::getPDO()->quoteAll($data)).")";
        print_r([$sql]);
        return true;
    }

    public function auth($login, $pass)
    {
        $session = new Session();
        $userData = \App::getPDO()->getAssoc("SELECT login, id, password FROM users WHERE login = ".\App::getPDO()->quote($login));
        if (md5($pass) === $userData[$login]['password']) {
            $session->set('ZFIUD', base64_encode($login.":".$userData[$login]['id']));
            return true;
        }
        return false;
    }
}