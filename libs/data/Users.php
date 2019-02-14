<?php

class Users
{
    public $id;

    public $data;

    public function getData(int $id)
    {
        $this->data = App::getPDO()->getAssoc("SELECT id, login, password, username, is_active, role_id FROM users WHERE id = {$id}");
        return !empty($this->data) ? $this->data : false;
    }

    public function isLoginExist(string $login)
    {
        $sql = "SELECT id FROM users WHERE login = ".App::getPDO()->quote($login);
        if (App::getPDO()->getOne($sql)) {
            return true;
        }
        return false;
    }

    public function add($data)
    {
        if (empty($data['login']) || empty($data['password'])) {
            throw new Exception("Have no login or password data");
        }

        if ($this->isLoginExist($data['login'])) {
            throw new Exception("Such login exist!");
        }
        return true;
    }
}