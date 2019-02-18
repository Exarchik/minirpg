<?php

namespace ZFI;

use Symfony\Component\HttpFoundation\Session\Session;

class Users
{
    public $id;

    public $data;

    public function getData(int $id)
    {
        $this->data = \App::getPDO()->getAssoc("SELECT id, login, password, username, is_active, role_id FROM users WHERE id = {$id}");
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
            $session->set('login', $login);
            return true;
        }
        return false;
    }
}