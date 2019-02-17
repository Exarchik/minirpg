<?php

namespace ZFI;

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
            $error->addMessage("Have no login or password data");
        }

        if ($this->isLoginExist($data['login'])) {
            $error->addMessage("Such login exist!");
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

        return true;
    }
}